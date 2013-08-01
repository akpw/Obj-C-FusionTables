//
//  GoogleAuthorizationController.m
//  Obj-C-FusionTables
//
//  Created by Arseniy Kuznetsov on 28/9/11.
//  Copyright 2011 Arseniy Kuznetsov. All rights reserved.
//


#import "GoogleAuthorizationController.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTMOAuth2SignIn.h"
#import "AppDelegate.h"

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

#define GOOGLE_FUSION_TABLES_API_SCOPE (@"https://www.googleapis.com/auth/fusiontables")
#define GOOGLE_FUSION_TABLES_SCOPE_READONLY (@"https://www.googleapis.com/auth/fusiontables.readonly")
#define GOOGLE_URLSHORTENER_SCOPE (@"https://www.googleapis.com/auth/urlshortener")
#pragma mark - Initialization
- (id)init {
    self = [super init];
    if (self) {
        [self signOutFromGoogle];
        self.theScope = [GTMOAuth2Authentication scopeWithStrings:
                                     GOOGLE_FUSION_TABLES_API_SCOPE,
                                     GOOGLE_FUSION_TABLES_SCOPE_READONLY,
                                     GOOGLE_URLSHORTENER_SCOPE,
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

#pragma mark - Google API Keys need to be initialised in "GoogleAPIKeys.plist"
// initialise "GoogleAPIKeys.plist" with your API Keys
// you can get the API keys from: https://developers.google.com/fusiontables/docs/v1/using#APIKey
- (NSDictionary *)googleAPIKeys {
    if (!_googleAPIKeys) {
        _googleAPIKeys = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]
                                     pathForResource:@"GoogleAPIKeys" ofType:@"plist"]];
    }
    return _googleAPIKeys;
}
// initialise "GoogleAPIKeys.plist" with your API Keys
// you can get the API keys from: https://developers.google.com/fusiontables/docs/v1/using#APIKey
#pragma mark - Google API Keys need to be initialised in "GoogleAPIKeys.plist"

#pragma mark - Google API Keys Helpers
#define GOOGLE_CLIENT_ID_KEY (@"GOOGLE_CLIENT_ID_KEY")
- (NSString *)googleClientID {
    return self.googleAPIKeys[GOOGLE_CLIENT_ID_KEY];
}
#undef GOOGLE_CLIENT_ID_KEY
#define GOOGLE_CLIENT_SECRET_KEY (@"GOOGLE_CLIENT_SECRET_KEY")
- (NSString *)googleClientSecret {
    return self.googleAPIKeys[GOOGLE_CLIENT_SECRET_KEY];
}
#undef GOOGLE_CLIENT_SECRET_KEY

#pragma mark - Network connectivity states
- (void)incrementNetworkActivity:(NSNotification *)notify {
    [[AppGeneralServicesController sharedInstance] incrementNetworkActivityIndicator];
}
- (void)decrementNetworkActivity:(NSNotification *)notify {
    [[AppGeneralServicesController sharedInstance] decrementNetworkActivityIndicator];
}
- (void)signInNetworkLostOrFound:(NSNotification *)notification {
    if ([[notification name] isEqual:kGTMOAuth2NetworkLost]) {
        [[AppGeneralServicesController sharedInstance] showAlertViewWithTitle:@"Network Connection Lost"
                                            AndText:@"Network connection was lost while connecting to Google"];         
        [[[notification object] delegate] cancelSigningIn];
    } else {
        // network connection was found again
    }
}

#pragma mark - Google Authorization Methods
#define GOOGLE_KEYCHAIN_ID (@"Obj-C FT Google KeyChain ID")
- (void)restoreFromKeyChain {
    self.theAuth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:GOOGLE_KEYCHAIN_ID
                                                                         clientID:[self googleClientID]
                                                                     clientSecret:[self googleClientSecret]];
}
- (void)authorizationFailureHandlerForError:(NSError *)error {
    NSData *responseData = [error userInfo][kGTMHTTPFetcherStatusDataKey]; // kGTMHTTPFetcherStatusDataKey
    NSString *responseBody = nil;
    if ([responseData length] > 0) {
        // show the body of the server's authentication failure response
        responseBody = [[NSString alloc] initWithData:responseData
                                              encoding:NSUTF8StringEncoding];
    }
    NSLog(@"Authentication error: %@ Failure response body: %@", error, responseBody);
    [[AppGeneralServicesController sharedInstance] showAlertViewWithTitle:@"Authentication error" AndText:
                                     [NSString stringWithFormat:@"Error while signing-in in to Google: %@", 
                                     [error localizedDescription]]];
}

#pragma mark - Authorization Methods
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
- (void)authorizeHTTPFetcher:(GTMHTTPFetcher *)fetcher
                WithCompletionHandler:(void_completion_handler_block)completionHandler {
    
    void_completion_handler_block authFetcherBlock = ^ {
        [fetcher setAuthorizer:self.theAuth];
        if (completionHandler) {
            completionHandler();
        }
    };
    [self authorizedRequestWithCompletionHandler:authFetcherBlock CancelHandler:nil];
}

#pragma mark - Google SignIn
- (void)signInToGoogleWithCompletionHandler:(void_completion_handler_block)completionHandler 
                                        CancelHandler:(void_completion_handler_block)cancelHandler {
    GTMOAuth2ViewControllerTouch *viewController = [GTMOAuth2ViewControllerTouch controllerWithScope:self.theScope
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
                 [[AppGeneralServicesController sharedInstance]
                                showAlertViewWithTitle:@"Authentication error" AndText:
                                [NSString stringWithFormat:@"Error while signing-in in to Google: %@",
                                [error localizedDescription]]];
                 
                 // cancel handler
                 if (cancelHandler) {
                     cancelHandler();
                 }
             } else {
                 // Authentication succeeded
                 self.theAuth = auth;
                 
                 // Execute the request
                 completionHandler();
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
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.navigationController pushViewController:viewController animated:YES];
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



