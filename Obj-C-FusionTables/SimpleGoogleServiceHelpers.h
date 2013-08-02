//
//  SimpleGoogleServiceHelpers.h
//  Obj-C-FusionTables
//
//  Created by Arseniy Kuznetsov on 9/7/11.
//  Copyright 2011 Arseniy Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ServiceAPIHandler)(NSData *data, NSError *error);
typedef void (^void_completion_handler_block)(void);

@interface SimpleGoogleServiceHelpers : NSObject

+ (SimpleGoogleServiceHelpers *)sharedInstance;

- (void)incrementNetworkActivityIndicator;
- (void)decrementNetworkActivityIndicator;
- (void)hideNetworkActivityIndicator;

- (void)showAlertViewWithTitle:(NSString *)title AndText:(NSString *)text;

- (NSString *)random4DigitNumberString;

- (void)setPublicSharingForFileWithID:(NSString *)fileID
                WithCompletionHandler:(ServiceAPIHandler)completionHandler;
- (void)shortenURL:(NSString *)longURL
                WithCompletionHandler:(ServiceAPIHandler)completionHandler;


@end
