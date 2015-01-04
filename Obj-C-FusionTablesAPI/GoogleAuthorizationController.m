/* Copyright (c) 2013 Arseniy Kuznetsov
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//  GoogleAuthorizationController.m
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    Google Authorization wrapper class
****/

#import "GoogleAuthorizationController.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTMOAuth2SignIn.h"

@interface GoogleAuthorizationController ()
    @property (nonatomic, strong) NSDictionary *googleAPIKeys;
    @property (nonatomic, strong) GTMOAuth2Authentication *theAuth;
    @property (nonatomic, strong) NSString *theScope;
@end

@implementation GoogleAuthorizationController

#pragma mark Memory management
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Singleton instance
+ (GoogleAuthorizationController *)sharedInstance {
    static GoogleAuthorizationController *sharedGoogleAuthorizationControllerInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedGoogleAuthorizationControllerInstance = [[[self class] alloc] init];
    });
    return sharedGoogleAuthorizationControllerInstance;
}

#pragma mark - Initialization
#define GOOGLE_FUSION_TABLES_API_SCOPE (@"https://www.googleapis.com/auth/fusiontables")
#define GOOGLE_FUSION_TABLES_SCOPE_READONLY (@"https://www.googleapis.com/auth/fusiontables.readonly")
#define GOOGLE_URLSHORTENER_SCOPE (@"https://www.googleapis.com/auth/urlshortener")
#define GOOGLE_DRIVE_SCOPE (@"https://www.googleapis.com/auth/drive")
#define GOOGLE_DRIVE_FILE_SCOPE (@"https://www.googleapis.com/auth/drive.file")
#define GOOGLE_DOCS_FILE_SCOPE (@"https://docs.google.com/feeds/") 
/* GOOGLE_DOCS_FILE_SCOPE: 
    a temporary workaround for the Drive API bug, see http://stackoverflow.com/questions/26761199/google-drive-api-call-to-insert-public-share-permissions-on-fusiontables-causes/27674201#27674201
*/ 
- (id)init {
    self = [super init];
    if (self) {
        self.theScope = [GTMOAuth2Authentication scopeWithStrings:
                                     GOOGLE_FUSION_TABLES_API_SCOPE,
                                     GOOGLE_FUSION_TABLES_SCOPE_READONLY,
                                     GOOGLE_URLSHORTENER_SCOPE,
                                     GOOGLE_DRIVE_SCOPE, 
                                     GOOGLE_DRIVE_FILE_SCOPE, GOOGLE_DOCS_FILE_SCOPE,
                                     nil];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(incrementNetworkActivity:)
                                                name:kGTMOAuth2FetchStarted object:nil];
        [nc addObserver:self selector:@selector(decrementNetworkActivity:)
                                                name:kGTMOAuth2FetchStopped object:nil];
        [nc addObserver:self selector:@selector(signInNetworkLostOrFound:)
                                                name:kGTMOAuth2NetworkLost  object:nil];
        [nc addObserver:self selector:@selector(signInNetworkLostOrFound:)
                                                name:kGTMOAuth2NetworkFound object:nil];
    }
    return self;
}
#undef GOOGLE_FUSION_TABLES_SCOPE_READONLY
#undef GOOGLE_FUSION_TABLES_API_SCOPE
#undef GOOGLE_URLSHORTENER_SCOPE
#undef GOOGLE_DRIVE_SCOPE

#pragma mark - Google API Keys need to be initialised in "GoogleAPIKeys.plist"
// initialize "GoogleAPIKeys.plist" with your API Keys
// you can get the API keys from: https://developers.google.com/fusiontables/docs/v2/using#APIKey
- (NSDictionary *)googleAPIKeys {
    if (!_googleAPIKeys) {
        _googleAPIKeys = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]
                                     pathForResource:@"GoogleAPIKeys" ofType:@"plist"]];
    }
    return _googleAPIKeys;
}
// initialize "GoogleAPIKeys.plist" with your API Keys
// you can get the API keys from: https://developers.google.com/fusiontables/docs/v2/using#APIKey
#pragma mark - Google API Keys need to be initialised in "GoogleAPIKeys.plist"

#pragma mark - Google API Keys Helpers
#define GOOGLE_CLIENT_ID_KEY (@"GOOGLE_CLIENT_ID_KEY")
#define GOOGLE_CLIENT_SECRET_KEY (@"GOOGLE_CLIENT_SECRET_KEY")
#define GOOGLE_NON_VALID_ID_KEY (@"GET Your Google Client ID")
- (BOOL)isDefaultNonValidGoogleClientID {
    NSString *theAPIKey = [self googleClientID];    
    return ([theAPIKey rangeOfString:GOOGLE_NON_VALID_ID_KEY 
                    options:NSCaseInsensitiveSearch].location == NSNotFound) ? NO : YES;
}
- (NSString *)googleClientID {
    return self.googleAPIKeys[GOOGLE_CLIENT_ID_KEY];
}
- (NSString *)googleClientSecret {
    return self.googleAPIKeys[GOOGLE_CLIENT_SECRET_KEY];
}
#undef GOOGLE_NON_VALID_ID_KEY
#undef GOOGLE_CLIENT_ID_KEY
#undef GOOGLE_CLIENT_SECRET_KEY

#pragma mark - Network connectivity indication
- (void)incrementNetworkActivity:(NSNotification *)notify {
    [[GoogleServicesHelper sharedInstance] incrementNetworkActivityIndicator];
}
- (void)decrementNetworkActivity:(NSNotification *)notify {
    [[GoogleServicesHelper sharedInstance] decrementNetworkActivityIndicator];
}
- (void)signInNetworkLostOrFound:(NSNotification *)notification {
    if ([[notification name] isEqual:kGTMOAuth2NetworkLost]) {
        [[GoogleServicesHelper sharedInstance] 
                            showAlertViewWithTitle:@"Network Connection Lost"
                            AndText:@"Network connection was lost while connecting to Google"];         
        [(GTMOAuth2SignIn *)[notification object] cancelSigningIn];
    } else {
        // network connection was found again
    }
}

#pragma mark General Authorization Methods
- (NSString *)authenticatedUserID {
    return [self.theAuth userEmail];
}
- (BOOL)isAuthorised {
    if (![self.theAuth canAuthorize]) {
        [self restoreFromKeyChain];
    }
    return [self.theAuth canAuthorize];
}
- (void)authorizedRequestWithCompletionHandler:(void_completion_handler_block)completionHandler 
                                 CancelHandler:(void_completion_handler_block)cancelHandler {
    if ([self isAuthorised]) {
        completionHandler();
    } else {
        [self signInToGoogleWithCompletionHandler:completionHandler CancelHandler:cancelHandler];
    }
}

#pragma mark Fetcher Authorization Methods
- (void)authorizeHTTPFetcher:(GTMHTTPFetcher *)fetcher
                WithCompletionHandler:(void_completion_handler_block)completionHandler
                                CancelHandler:(void_completion_handler_block)cancelHandler {
    void_completion_handler_block authFetcherBlock = ^ {
        [fetcher setAuthorizer:self.theAuth];
        if (completionHandler) completionHandler();
    };
    [self authorizedRequestWithCompletionHandler:authFetcherBlock CancelHandler:cancelHandler];
}

- (void)authorizeHTTPFetcher:(GTMHTTPFetcher *)fetcher
       WithCompletionHandler:(void_completion_handler_block)completionHandler {        
    [self authorizeHTTPFetcher:fetcher WithCompletionHandler:completionHandler CancelHandler:nil];
}

#define GOOGLE_KEYCHAIN_ID (@"Obj-C FT Google KeyChain ID")
- (void)restoreFromKeyChain {
    if ([self isDefaultNonValidGoogleClientID]) {
        [[GoogleServicesHelper sharedInstance]
             showAlertViewWithTitle:@"Google API Key Not Set"
             AndText:[NSString stringWithFormat:
                      @"Before using Obj-C-FusionTables, "
                      "you need to set your Google API Key in GoogleAPIKeys.plist\n\n"
                      "Please follow the instructions at: "
                      "https://github.com/akpw/Obj-C-FusionTables#setting-up-you-google-project"]];        
    }
    else {
        self.theAuth = [GTMOAuth2ViewControllerTouch 
                                authForGoogleFromKeychainForName:GOOGLE_KEYCHAIN_ID
                                clientID:[self googleClientID]
                                clientSecret:[self googleClientSecret]];        
    }
}

#pragma mark - Google SignIn
- (void)signInToGoogleWithCompletionHandler:(void_completion_handler_block)completionHandler
                                        CancelHandler:(void_completion_handler_block)cancelHandler {
    
    GTMOAuth2ViewControllerTouch *viewController = [GTMOAuth2ViewControllerTouch
                                                            controllerWithScope:self.theScope
                                                            clientID:[self googleClientID]
                                                            clientSecret:[self googleClientSecret]
                                                            keychainItemName:GOOGLE_KEYCHAIN_ID
         completionHandler:^(GTMOAuth2ViewControllerTouch *viewController, 
                                    GTMOAuth2Authentication *auth, NSError *error) {
             if (error) {
                 self.theAuth = nil;
                 
                 // error processing, look at what's up there
                 NSData *responseData = [error userInfo][kGTMHTTPFetcherStatusDataKey];
                 NSString *responseBody = nil;
                 if ([responseData length] > 0) {
                     // the body of the server's authentication failure response
                     responseBody = [[NSString alloc] initWithData:responseData
                                                          encoding:NSUTF8StringEncoding];
                 }
                 NSLog(@"Authentication error: %@ Failure response body: %@", error, responseBody);
                 [[GoogleServicesHelper sharedInstance]
                                showAlertViewWithTitle:@"Authentication error" AndText:
                                [NSString stringWithFormat:@"Error while signing-in in to Google: %@",
                                [error localizedDescription]]];                                  
                 [[GoogleServicesHelper sharedInstance] 
                                dismissViewControllerAnimated:YES completion:nil];                  
                 // cancel handler
                 if (cancelHandler) cancelHandler();
             } else {
                 // Authentication succeeded
                 self.theAuth = auth;
                 [[GoogleServicesHelper sharedInstance] 
                                dismissViewControllerAnimated:YES completion:nil];                  
                 // Execute the request
                 if (completionHandler) completionHandler();
             }     
        }];
    
    NSDictionary *params = @{@"hl": @"en"};
    viewController.signIn.additionalAuthorizationParameters = params;
    viewController.signIn.shouldFetchGoogleUserProfile = YES;
    
    NSString *html =
            @"<html><body bgcolor=silver>"
            "<div align=center>Loading Google Secure Sign-In Page...</div>"
            "</body></html>";
    viewController.initialHTMLString = html;  
    
    viewController.modalPresentationStyle = UIModalPresentationPageSheet;
    [[GoogleServicesHelper sharedInstance] 
        presentController:viewController animated:YES completionHandler:nil];
}

#pragma mark - Google SignOut
- (void)signOutFromGoogle {
    if ([self isAuthorised]) {
        if ([self.theAuth.serviceProvider isEqual:kGTMOAuth2ServiceProviderGoogle]) {
            // remove the token from Google's servers
            [GTMOAuth2ViewControllerTouch revokeTokenForGoogleAuthentication:self.theAuth];
        }        
        // remove the stored Google authentication from the keychain, if any
        [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:GOOGLE_KEYCHAIN_ID];
    }
    self.theAuth = nil;
}
#undef GOOGLE_KEYCHAIN_ID


@end
