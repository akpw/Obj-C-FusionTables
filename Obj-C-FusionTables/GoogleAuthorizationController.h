//
//  GoogleAuthorizationController.h
//  Obj-C-FusionTables
//
//  Created by Arseniy Kuznetsov on 28/9/11.
//  Copyright 2011 Arseniy Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleGoogleServiceHelpers.h"
#import "GTMHTTPFetcher.h"

@interface GoogleAuthorizationController : NSObject

@property (nonatomic, readonly) NSString *authenticatedUserID;

#pragma mark - Singleton instance
+ (GoogleAuthorizationController *)sharedInstance;

#pragma mark - Google Authorization Methods
- (BOOL)isAuthorised;
- (void)signInToGoogleWithCompletionHandler:(void_completion_handler_block)completionHandler
                              CancelHandler:(void_completion_handler_block)cancelHandler;
- (void)signOutFromGoogle;

- (void)authorizedRequestWithCompletionHandler:(void_completion_handler_block)completionHandler
                                 CancelHandler:(void_completion_handler_block)cancelHandler;
- (void)authorizeHTTPFetcher:(GTMHTTPFetcher *)fetcher
                WithCompletionHandler:(void_completion_handler_block)completionHandler;

@end

