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

//  GoogleServicesHelper.m
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    A simple Google Services Helper class
****/

#import "GoogleServicesHelper.h"
#import "GoogleAuthorizationController.h"

@interface GoogleServicesHelper ()
@end

@implementation GoogleServicesHelper {
    NSUInteger networkActivityIndicatorCounter;
}

#pragma mark - Singleton instance
+ (GoogleServicesHelper *)sharedInstance {
    static GoogleServicesHelper *sharedSimpleGoogleServiceHelperInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedSimpleGoogleServiceHelperInstance = [[[self class] alloc] init];
    });
    return sharedSimpleGoogleServiceHelperInstance;
}

#pragma mark - Initialization
- (id)init {
    self = [super init];
    if (self) {
        networkActivityIndicatorCounter = 0;
    }
    return self;
}

#pragma mark Public Methods
#pragma mark - Network connectivity helpers
- (void)incrementNetworkActivityIndicator {
    ++networkActivityIndicatorCounter;
    if (networkActivityIndicatorCounter == 1) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}
- (void)decrementNetworkActivityIndicator {
    --networkActivityIndicatorCounter;
    if (networkActivityIndicatorCounter == 0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}
- (void)hideNetworkActivityIndicator {
    networkActivityIndicatorCounter = 0;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - Google Drive permissions helper
#define GOOGLE_GDRIVE_API_URL @("https://www.googleapis.com/drive/v2/files")
- (void)listSharingPermissionsForFileWithID:(NSString *)fileID 
                  WithCompletionHandler:(ServiceAPIHandler)completionHandler {

    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", GOOGLE_GDRIVE_API_URL, fileID, @"permissions"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [[GoogleAuthorizationController sharedInstance] authorizeHTTPFetcher:fetcher WithCompletionHandler:^{
        [fetcher beginFetchWithCompletionHandler:completionHandler];
    }];
}

#define GOOGLE_ERROR_DOMAIN_CODE_INTERNAL_ERROR 500
// checks current sharing permissions and sets public sharing if needed
- (void)setPublicSharingForFileWithID:(NSString *)fileID
                WithCompletionHandler:(ServiceAPIHandler)completionHandler {
    
    // public sharing block, to be executed if public sharing has not yet been set
    ServiceAPIHandler setPublicSharingBlock = ^(NSData *data, NSError *error) {
        /* a temporary workaround for the Drive API bug, see 
         http://stackoverflow.com/questions/26761199/google-drive-api-call-to-insert-public-share-permissions-on-fusiontables-causes/27674201#27674201
        */
        ServiceAPIHandler theDriveAPiBugHandler = ^(NSData *data, NSError *error) {
            if (error && [error code] == GOOGLE_ERROR_DOMAIN_CODE_INTERNAL_ERROR) {
                // let's try to share via old, XML-Based Google Docs API
                [self gdataSetPublicSharingForFileWithID:fileID 
                                   WithCompletionHandler:completionHandler];
            }
            else {
                completionHandler(data, error);
            }
        };          
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@", GOOGLE_GDRIVE_API_URL, fileID, @"permissions"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
        [[GoogleAuthorizationController sharedInstance] authorizeHTTPFetcher:fetcher WithCompletionHandler:^{
            
            NSMutableDictionary *permissionsDict = [NSMutableDictionary dictionary];
            permissionsDict[@"role"] = @"reader";
            permissionsDict[@"type"] = @"anyone";
            //permissionsDict[@"value"] = @"";
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:permissionsDict
                                                               options:NSJSONWritingPrettyPrinted error:nil];
            [fetcher setPostData:jsonData];
            [fetcher beginFetchWithCompletionHandler:theDriveAPiBugHandler];
        }];
    };

    // check the current permissions and execute the public sharing block if needed
    ServiceAPIHandler checkSharingPermissionsBlock = ^(NSData *data, NSError *error) {
        if (error) {
            NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
            [[GoogleServicesHelper sharedInstance]
                 showAlertViewWithTitle:@"Google Drive Sharing Error"
                 AndText:[NSString stringWithFormat:
                          @"An error while listing Fusion Table permissions: %@", errorStr]];      
            completionHandler(data, error);
        } else {
            NSDictionary *lines = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions error:nil];
            NSLog(@"Fusion Tables permissions: %@", lines);
            NSArray *permissions = [NSMutableArray arrayWithArray:lines[@"items"]];
            NSIndexSet *matchIdxs = 
            [permissions indexesOfObjectsPassingTest:
             ^BOOL(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
                 return 
                    [dict[@"role"] isEqualToString:@"reader"] && 
                    [dict[@"type"] isEqualToString:@"anyone"];
             }]; 
            if ([matchIdxs count] != 0) {
                // public permissions are already set
                completionHandler(data, error);
            } else {
                // public permissions need setting, run the public sharing block from above
                setPublicSharingBlock(data, error);
            }
        }        
    };         
    // list the current permission with the checkSharingPermissionsBlock from above
    [self listSharingPermissionsForFileWithID:fileID WithCompletionHandler:checkSharingPermissionsBlock];
}
#undef GOOGLE_GDRIVE_API_URL
#undef GOOGLE_ERROR_DOMAIN_CODE_INTERNAL_ERROR

/*  a temporary workaround for the Drive API bug, see http://stackoverflow.com/questions/26761199/google-drive-api-call-to-insert-public-share-permissions-on-fusiontables-causes/27674201#27674201
*/ 
#define GOOGLE_GDATA_API_URL @("https://docs.google.com/feeds/default/private/full/table%3A")
- (void)gdataSetPublicSharingForFileWithID:(NSString *)fileID
                WithCompletionHandler:(ServiceAPIHandler)completionHandler {
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@", GOOGLE_GDATA_API_URL, fileID, @"acl"];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *requestUserAgent = @"Obj-C-FusionTables";
    [request setValue:requestUserAgent forHTTPHeaderField:@"User-Agent"];

    NSString *serviceVersion = @"3.0";
    [request setValue:serviceVersion forHTTPHeaderField:@"GData-Version"];

    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/atom+xml, text/xml" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/atom+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];

    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    NSString *message = 
                @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                "<entry  xmlns=\"http://www.w3.org/2005/Atom\" "
                        "xmlns:gd=\"http://schemas.google.com/g/2005\" "
                        "xmlns:gAcl=\"http://schemas.google.com/acl/2007\" "
                        "xmlns:app=\"http://www.w3.org/2007/app\">"
                    "<gAcl:scope type=\"default\"/>"
                    "<gAcl:role value=\"reader\"/>"
                    "<category scheme=\"http://schemas.google.com/g/2005#kind\" "
                    "term=\"http://schemas.google.com/acl/2007#accessRule\"/>"
                "</entry>";
    [fetcher setPostData:[message dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[GoogleAuthorizationController sharedInstance] 
                        authorizeHTTPFetcher:fetcher WithCompletionHandler:^{
        [fetcher beginFetchWithCompletionHandler:completionHandler];
    }];
}
#undef GOOGLE_GDATA_API_URL

#pragma mark - Google GTMHTTPFetcher error processing
+ (NSString *)remoteErrorDataString:(NSError *)error {
    NSData *data = [[error userInfo] valueForKey:kGTMHTTPFetcherStatusDataKey];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];                    
}

#pragma mark - Google URL Shortener helper
#define GOOGLE_URL_SHORTENER_API_URL (@"https://www.googleapis.com/urlshortener/v1/url")
- (void)shortenURL:(NSString *)longURL
                        WithCompletionHandler:(ServiceAPIHandler)completionHandler {
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:GOOGLE_URL_SHORTENER_API_URL]];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    
    [[GoogleAuthorizationController sharedInstance] authorizeHTTPFetcher:fetcher WithCompletionHandler:^{            
        NSMutableDictionary* jsonObject = [NSMutableDictionary dictionary];
        jsonObject[@"longUrl"] = longURL;
        
        // convert object to data
        NSData *postData = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                           options:NSJSONWritingPrettyPrinted error:nil];
        [fetcher setPostData:postData];
        
        GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
        [[GoogleAuthorizationController sharedInstance] authorizeHTTPFetcher:fetcher WithCompletionHandler:^{
            [fetcher setPostData:postData];
            [fetcher beginFetchWithCompletionHandler:completionHandler];
        }];
    }];
}

#pragma mark - Random Number Helpers
- (NSString *)random4DigitNumberStringFrom:(NSUInteger)from To:(NSUInteger)to {
    return [NSString stringWithFormat:@"%lu", (arc4random()%(to-from)) + from];
}
- (NSString *)random4DigitNumberString {
    return [self random4DigitNumberStringFrom:1000 To:9999];
}

#pragma mark - Presentation Helper
- (void)presentController:(UIViewController *)controller
                animated:(BOOL)animated
                completionHandler:(void_completion_handler_block)completionHandler {    

    UIViewController *presentingViewController = 
                [[UIApplication sharedApplication] delegate].window.rootViewController;
    
    // get to top controller on the presentation stack
    while (presentingViewController.presentedViewController) {
        presentingViewController = presentingViewController.presentedViewController;
    }    
    [presentingViewController presentViewController:controller animated:animated completion:completionHandler];    
}
- (void)dismissViewControllerAnimated:(BOOL)animated 
                           completion:(void_completion_handler_block)completionHandler {
    [[[UIApplication sharedApplication] delegate].window.rootViewController
                        dismissViewControllerAnimated:animated completion:completionHandler];
}
- (void)showAlertViewWithTitle:(NSString *)title AndText:(NSString *)text {
    UIAlertController *alertVC = [UIAlertController 
                                      alertControllerWithTitle:title
                                      message:text 
                                      preferredStyle:UIAlertControllerStyleAlert];    
    // OK action
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" 
                                                       style:UIAlertActionStyleDefault handler:nil];        
    [alertVC addAction:actionOK];           
    [self presentController:alertVC animated:YES completionHandler:nil];
}

@end


