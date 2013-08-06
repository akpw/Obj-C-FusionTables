//
//  AppIconsController.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 17/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IconsControllerIconTypeNormal (@"IconsControllerIconTypeNormal")
#define IconsControllerIconTypeHighlighted (@"IconsControllerIconTypeHighlighted")

@interface AppIconsController : NSObject

+ (NSDictionary *)navBarCustomBackButtonImage;
+ (NSDictionary *)navBaAddBarButtonImage;
+ (NSDictionary *)navBarItemEditButtonImage;
+ (NSDictionary *)navBarItemDoneButtonImage;
+ (NSDictionary *)cellAccessoryActionBtnImage;

+ (UIImage *)fusionTablesImage;

@end
