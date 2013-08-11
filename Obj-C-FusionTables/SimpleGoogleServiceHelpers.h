//
//  SimpleGoogleServiceHelpers.h
//  Obj-C-FusionTables
//
//  Created by Arseniy Kuznetsov on 9/7/11.
//  Copyright 2011 Arseniy Kuznetsov. All rights reserved.
//

/****
    A simple Google Services Helper class
****/

#import <Foundation/Foundation.h>

typedef void(^ServiceAPIHandler)(NSData *data, NSError *error);
typedef void (^void_completion_handler_block)(void);

@interface SimpleGoogleServiceHelpers : NSObject

#pragma mark - Singleton instance
+ (SimpleGoogleServiceHelpers *)sharedInstance;

#pragma mark - Network connectivity helpers
- (void)incrementNetworkActivityIndicator;
- (void)decrementNetworkActivityIndicator;
- (void)hideNetworkActivityIndicator;

#pragma mark - Alert View Helper
- (void)showAlertViewWithTitle:(NSString *)title AndText:(NSString *)text;

#pragma mark - Google Drive permissions helper
- (void)setPublicSharingForFileWithID:(NSString *)fileID
                WithCompletionHandler:(ServiceAPIHandler)completionHandler;

#pragma mark - Google URL Shortener helper
- (void)shortenURL:(NSString *)longURL
                WithCompletionHandler:(ServiceAPIHandler)completionHandler;

#pragma mark - Random Number Helpers
- (NSString *)random4DigitNumberStringFrom:(NSUInteger)from To:(NSUInteger)to;
- (NSString *)random4DigitNumberString;


@end
