//
//  AppIconsController.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 17/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "AppIconsController.h"
#import "AppGeneralServicesController.h"

@implementation AppIconsController

+ (NSDictionary *)navBarCustomBackButtonImage {
    UIImage *controlStateNormalImage = [UIImage imageNamed:@"custom-back-btn.png"];
    UIImage *controlStateHighlightedImage = [AppGeneralServicesController
                                                 colorizeImage:controlStateNormalImage
                                                 color:[UIColor grayColor]];
    
    NSDictionary *customBackButtonImageDictionary = @{
                                    IconsControllerIconTypeNormal : controlStateNormalImage,
                                    IconsControllerIconTypeHighlighted : controlStateHighlightedImage
                                        };
    return customBackButtonImageDictionary;
}
+ (NSDictionary *)navBaAddBarButtonImage {
    UIImage *controlStateNormalImage = [UIImage imageNamed:@"add-icon.png"];
    UIImage *controlStateHighlightedImage = [AppGeneralServicesController
                                                colorizeImage:controlStateNormalImage
                                                color:[UIColor grayColor]];    
    NSDictionary *customBackButtonImageDictionary = @{
                                    IconsControllerIconTypeNormal : controlStateNormalImage,
                                    IconsControllerIconTypeHighlighted : controlStateHighlightedImage
                                                      };
    return customBackButtonImageDictionary;    
}
+ (NSDictionary *)navBarItemEditButtonImage {
    UIImage *controlStateNormalImage = [UIImage imageNamed:@"start-editing.png"];
    UIImage *controlStateHighlightedImage = [AppGeneralServicesController
                                                colorizeImage:controlStateNormalImage
                                                color:[UIColor grayColor]];    
    NSDictionary *customBackButtonImageDictionary = @{
                                    IconsControllerIconTypeNormal : controlStateNormalImage,
                                    IconsControllerIconTypeHighlighted : controlStateHighlightedImage
                                                      };
    return customBackButtonImageDictionary;
}
+ (NSDictionary *)navBarItemDoneButtonImage {
    UIImage *controlStateNormalImage = [UIImage imageNamed:@"done-editing.png"];
    UIImage *controlStateHighlightedImage = [AppGeneralServicesController
                                                colorizeImage:controlStateNormalImage
                                                color:[UIColor grayColor]];
    NSDictionary *customBackButtonImageDictionary = @{
                                     IconsControllerIconTypeNormal : controlStateNormalImage,
                                     IconsControllerIconTypeHighlighted : controlStateHighlightedImage
                                                      };
    return customBackButtonImageDictionary;
}


+ (NSDictionary *)cellAccessoryActionBtnImage {
    UIImage *controlStateNormalImage = [UIImage imageNamed:@"CellAccessoryActionBtn.png"];
    UIImage *controlStateHighlightedImage = [UIImage imageNamed:@"CellAccessoryActionBtnPressed.png"];
    NSDictionary *cellAccessoryActionBtnImage = @{
                                      IconsControllerIconTypeNormal : controlStateNormalImage,
                                      IconsControllerIconTypeHighlighted : controlStateHighlightedImage
                                                      };
    return cellAccessoryActionBtnImage;
}

+ (UIImage *)fusionTablesImage {
    return [UIImage imageNamed:@"fusion_tables_img.png"];
}

@end











