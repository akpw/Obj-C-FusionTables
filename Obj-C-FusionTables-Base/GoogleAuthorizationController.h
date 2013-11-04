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

//  GoogleAuthorizationController.h
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    Google Authorization wrapper class
****/

#import <Foundation/Foundation.h>
#import "GoogleServicesHelper.h"
#import "GTMHTTPFetcher.h"

@interface GoogleAuthorizationController : NSObject

@property (nonatomic, readonly) NSString *authenticatedUserID;

#pragma mark - Singleton instance
+ (GoogleAuthorizationController *)sharedInstance;

#pragma mark - General Authorization Methods
- (BOOL)isAuthorised;
- (void)signInToGoogleWithCompletionHandler:(void_completion_handler_block)completionHandler
                              CancelHandler:(void_completion_handler_block)cancelHandler;
- (void)signOutFromGoogle;

- (void)authorizedRequestWithCompletionHandler:(void_completion_handler_block)completionHandler
                                 CancelHandler:(void_completion_handler_block)cancelHandler;

#pragma mark Fetcher Authorization Methods
- (void)authorizeHTTPFetcher:(GTMHTTPFetcher *)fetcher
                WithCompletionHandler:(void_completion_handler_block)completionHandler
               CancelHandler:(void_completion_handler_block)cancelHandler;
- (void)authorizeHTTPFetcher:(GTMHTTPFetcher *)fetcher
                WithCompletionHandler:(void_completion_handler_block)completionHandler;

@end

