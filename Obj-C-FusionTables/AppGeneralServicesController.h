//
//  AppGeneralServicesController.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 6/8/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

/****
    General-level Sample App Services Helper
****/

#import <Foundation/Foundation.h>

@protocol AppTheme;

@interface AppGeneralServicesController : NSObject

+ (id <AppTheme>)sharedAppTheme;

#pragma mark - Theme-based appearance customization
+ (void)customizeAppearance;

#pragma mark - UIColor Helpers
+ (UIColor *)UIColorFromRGB:(NSInteger)rgbValue;
+ (UIColor *)UIColorFromRGB:(NSInteger)rgbValue AndAlpha:(float)theAlpha;

#pragma mark - UIImage Helpers
+ (UIImage *)colorizeImage:(UIImage *)baseImage color:(UIColor *)theColor;

@end

#pragma mark - the App Theme protocol
@protocol AppTheme <NSObject>
- (UIColor *)baseTintColor;
- (NSArray *)customBarButtonItemsBackForTarget:(id)target WithAction:(SEL)actionSelector;
- (NSArray *)customAddBarButtonItemsForTarget:(id)target WithAction:(SEL)actionSelector;
- (NSArray *)customEditBarButtonItemsForTarget:(id)target WithAction:(SEL)actionSelector;
- (NSArray *)customDoneBarButtonItemsForTarget:(id)target WithAction:(SEL)actionSelector;

@end