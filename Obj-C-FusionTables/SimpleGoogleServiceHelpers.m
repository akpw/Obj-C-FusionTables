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

//  SimpleGoogleServiceHelpers.m
//  Obj-C-FusionTables

/****
    A simple Google Services Helper class
****/

#import "SimpleGoogleServiceHelpers.h"
#import "GoogleAuthorizationController.h"

@interface SimpleGoogleServiceHelpers ()
    @property (nonatomic, strong) UIActivityIndicatorView *spinner;
@end

@implementation SimpleGoogleServiceHelpers {
    NSUInteger networkActivityIndicatorCounter;
}

#pragma mark - Singleton instance
+ (SimpleGoogleServiceHelpers *)sharedInstance {
    static SimpleGoogleServiceHelpers *sharedSimpleGoogleServiceHelperInstance = nil;
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
- (UIActivityIndicatorView *)spinner {
    if (!_spinner) {
        _spinner = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _spinner;
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

#pragma mark - Alert View Helper
- (void)showAlertViewWithTitle:(NSString *)title AndText:(NSString *)text {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title 
                                                        message:text delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
	[alertView show];
}

#pragma mark - Google Drive permissions helper
#define GOOGLE_GDRIVE_API_URL @("https://www.googleapis.com/drive/v2/files")
- (void)setPublicSharingForFileWithID:(NSString *)fileID
                WithCompletionHandler:(ServiceAPIHandler)completionHandler {
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", GOOGLE_GDRIVE_API_URL, fileID, @"permissions"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [[GoogleAuthorizationController sharedInstance] authorizeHTTPFetcher:fetcher WithCompletionHandler:^{
        
        NSMutableDictionary *permissionsDict = [NSMutableDictionary dictionary];
        permissionsDict[@"role"] = @"reader";
        permissionsDict[@"type"] = @"anyone";
        permissionsDict[@"value"] = @"";
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:permissionsDict
                                                           options:NSJSONWritingPrettyPrinted error:nil];
        [fetcher setPostData:jsonData];
        [fetcher beginFetchWithCompletionHandler:completionHandler];
    }];
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
    return [NSString stringWithFormat:@"%i", (arc4random()%(to-from)) + from];
}
- (NSString *)random4DigitNumberString {
    return [self random4DigitNumberStringFrom:1000 To:9999];
}


@end







