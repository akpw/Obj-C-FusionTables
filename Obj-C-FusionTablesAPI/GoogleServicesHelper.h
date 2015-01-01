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

//  GoogleServicesHelper.h
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    A simple Google Services Helper class
****/

#import <Foundation/Foundation.h>

typedef void(^ServiceAPIHandler)(NSData *data, NSError *error);
typedef void (^void_completion_handler_block)(void);
typedef void (^ErrorHandler)(NSError *error);

@interface GoogleServicesHelper : NSObject

#pragma mark - Singleton instance
+ (GoogleServicesHelper *)sharedInstance;

#pragma mark - Network connectivity helpers
- (void)incrementNetworkActivityIndicator;
- (void)decrementNetworkActivityIndicator;
- (void)hideNetworkActivityIndicator;

#pragma mark - Google Drive permissions helper
- (void)listSharingPermissionsForFileWithID:(NSString *)fileID 
                      WithCompletionHandler:(ServiceAPIHandler)completionHandler;

- (void)setPublicSharingForFileWithID:(NSString *)fileID
                WithCompletionHandler:(ServiceAPIHandler)completionHandler;

/*  a temporary workaround for the Drive API bug, see http://stackoverflow.com/questions/26761199/google-drive-api-call-to-insert-public-share-permissions-on-fusiontables-causes/27674201#27674201
*/ 
- (void)gdataSetPublicSharingForFileWithID:(NSString *)fileID
                     WithCompletionHandler:(ServiceAPIHandler)completionHandler;

#pragma mark - Google GTMHTTPFetcher error processing
+ (NSString *)remoteErrorDataString:(NSError *)error;

#pragma mark - Google URL Shortener helper
- (void)shortenURL:(NSString *)longURL
                WithCompletionHandler:(ServiceAPIHandler)completionHandler;

#pragma mark - Presentation Helper
- (void)showAlertViewWithTitle:(NSString *)title AndText:(NSString *)text;
- (void)presentController:(UIViewController *)controller
            animated:(BOOL)animated
            completionHandler:(void_completion_handler_block)completionHandler;
- (void)dismissViewControllerAnimated:(BOOL)animated 
            completion:(void_completion_handler_block)completionHandler;

#pragma mark - Random Number Helpers
- (NSString *)random4DigitNumberStringFrom:(NSUInteger)from To:(NSUInteger)to;
- (NSString *)random4DigitNumberString;


@end
