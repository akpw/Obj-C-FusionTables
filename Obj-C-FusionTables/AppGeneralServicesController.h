//
//  AppGeneralServicesController.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 6/8/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 General-level App Services Helper
*/


@protocol AppTheme;

@interface AppGeneralServicesController : NSObject

+ (id <AppTheme>)sharedAppTheme;
+ (void)customizeAppearance;

+ (UIColor *)UIColorFromRGB:(NSInteger)rgbValue;
+ (UIColor *)UIColorFromRGB:(NSInteger)rgbValue AndAlpha:(float)theAlpha;
+ (UIImage *)colorizeImage:(UIImage *)baseImage color:(UIColor *)theColor;

@end


@protocol AppTheme <NSObject>
- (UIColor *)baseTintColor;
- (NSArray *)customBarButtonItemsBackForTarget:(id)target WithAction:(SEL)actionSelector;
- (NSArray *)customAddBarButtonItemsForTarget:(id)target WithAction:(SEL)actionSelector;
- (NSArray *)customEditBarButtonItemsForTarget:(id)target WithAction:(SEL)actionSelector;
- (NSArray *)customDoneBarButtonItemsForTarget:(id)target WithAction:(SEL)actionSelector;

@end