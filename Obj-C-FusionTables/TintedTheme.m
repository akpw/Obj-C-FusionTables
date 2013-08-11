//
//  TintedTheme.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 6/8/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

/****
    Sample App Appearance customization, tinted theme
****/

#import "TintedTheme.h"

@implementation TintedTheme

#define APP_FRAME_BRAND_COLOR 0x677494

#pragma mark - App tint color customization
- (UIColor *)baseTintColor {
    return [AppGeneralServicesController UIColorFromRGB:(APP_FRAME_BRAND_COLOR)];
}


@end
