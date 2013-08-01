//
//  AppGeneralServicesController.h
//  Obj-C-FusionTables
//
//  Created by Arseniy Kuznetsov on 9/7/11.
//  Copyright 2011 Arseniy Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>


@interface AppGeneralServicesController : NSObject
                        <MFMailComposeViewControllerDelegate>

+ (AppGeneralServicesController *)sharedInstance;

- (void)incrementNetworkActivityIndicator;
- (void)decrementNetworkActivityIndicator;
- (void)hideNetworkActivityIndicator;

- (void)showActivityIndicatorViewInView:(UIView *)view;
- (void)hideActivityIndicatorViewInView;

- (void)showAlertViewWithTitle:(NSString *)title AndText:(NSString *)text;

+ (void)CGContext:(CGContextRef)context SetStrokeColorFromRGB:(NSInteger)rgbValue;
+ (void)CGContext:(CGContextRef)context SetStrokeColorFromRGB:(NSInteger)rgbValue AndAlpha:(float)theAlpha;

- (NSString *)random4DigitNumberString;


@end
