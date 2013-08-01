//
//  SharingController.m
//  Obj-C-FusionTables
//
//  Created by Arseniy Kuznetsov on 9/7/11.
//  Copyright 2011 Arseniy Kuznetsov. All rights reserved.
//

#import "AppGeneralServicesController.h"
#import "AppDelegate.h"

@interface AppGeneralServicesController ()
    @property (nonatomic, strong) UIActivityIndicatorView *spinner;
@end

@implementation AppGeneralServicesController {
    NSUInteger networkActivityIndicatorCounter;
}

#pragma mark - Singleton instance
+ (AppGeneralServicesController *)sharedInstance {
    static AppGeneralServicesController *sharedAppGeneralServicesControllerInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedAppGeneralServicesControllerInstance = [[[self class] alloc] init];
    });
    return sharedAppGeneralServicesControllerInstance;
}

#pragma mark Initialization
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
#pragma mark - Network Activity
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

#pragma mark - Visual Indicators methods
- (void)hideActivityIndicatorViewInView {
    [self.spinner stopAnimating];
    if ([self.spinner superview]) {
        [self.spinner removeFromSuperview];
    }
}
- (void)showActivityIndicatorViewInView:(UIView *)view {
    [self hideActivityIndicatorViewInView];
    if (view) {
        [self.spinner setCenter:view.center];
        [view addSubview:self.spinner];
        [self.spinner startAnimating];
    }
}
- (void)showAlertViewWithTitle:(NSString *)title AndText:(NSString *)text {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title 
                                                        message:text delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
	[alertView show];
}

#pragma mark - MFMailComposeViewController
- (void)mailComposeController:(MFMailComposeViewController*)controller 
                                didFinishWithResult:(MFMailComposeResult)result 
                                error:(NSError*)error {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Colors
+ (UIColor *)UIColorFromRGB:(NSInteger)rgbValue {
    return [self UIColorFromRGB:rgbValue AndAlpha:1.0];
}
+ (UIColor *)UIColorFromRGB:(NSInteger)rgbValue AndAlpha:(float)theAlpha {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0
                           alpha:theAlpha];
}

#pragma mark - CGContext Colors
+ (void)CGContext:(CGContextRef)context SetStrokeColorFromRGB:(NSInteger)rgbValue {
    [self CGContext:context SetStrokeColorFromRGB:rgbValue AndAlpha:1.0];
}
+ (void)CGContext:(CGContextRef)context SetStrokeColorFromRGB:(NSInteger)rgbValue AndAlpha:(float)theAlpha {
    CGContextSetRGBStrokeColor(context, 
                               ((float)((rgbValue & 0xFF0000) >> 16))/255.0, 
                               ((float)((rgbValue & 0xFF00) >> 8))/255.0, 
                               ((float)(rgbValue & 0xFF))/255.0, 
                               theAlpha);
}

#pragma mark - a Random Number
- (NSString *)random4DigitNumberString {
    int from = 1000, to = 9999;
    NSString *randomString = [NSString stringWithFormat:@"%i", (arc4random()%(to-from)) + from];
    return randomString;
}


@end










