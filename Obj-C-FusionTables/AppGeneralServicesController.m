//
//  AppGeneralServicesController.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 6/8/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

/****
    General-level Sample App Services Helper
****/

#import "AppGeneralServicesController.h"
#import "TintedTheme.h"

@implementation AppGeneralServicesController

#pragma mark - Shared Theme (Singleton)
+ (id <AppTheme>)sharedAppTheme {
    static id <AppTheme> sharedAppTheme = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAppTheme = [[TintedTheme alloc] init];
    });
    return sharedAppTheme;
}

#pragma mark - Theme-based appearance customization
+ (void)customizeAppearance {
    id <AppTheme> theme = [self sharedAppTheme];
    
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
   
    UIColor *baseTintColor = [theme baseTintColor];
    if (baseTintColor) {
        [navigationBarAppearance setTintColor:baseTintColor];
    }
}

#pragma mark - UIColor Helpers
+ (UIColor *)UIColorFromRGB:(NSInteger)rgbValue {
    return [self UIColorFromRGB:rgbValue AndAlpha:1.0f];
}
+ (UIColor *)UIColorFromRGB:(NSInteger)rgbValue AndAlpha:(float)theAlpha {
    float f16 = (float)((rgbValue & 0xFF0000) >> 16);
    float f8 = (float)((rgbValue & 0xFF00) >> 8);
    float f = (float)((rgbValue & 0xFF));
    
    return [UIColor colorWithRed:f16/255.0f
                           green:f8/255.0f
                            blue:f/255.0f
                           alpha:theAlpha];
}

#pragma mark - UIImage Helpers
+ (UIImage *)colorizeImage:(UIImage *)baseImage color:(UIColor *)theColor {
    UIGraphicsBeginImageContext(baseImage.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, baseImage.CGImage);
    
    [theColor set];
    CGContextFillRect(ctx, area);
    
    CGContextRestoreGState(ctx);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextDrawImage(ctx, area, baseImage.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
