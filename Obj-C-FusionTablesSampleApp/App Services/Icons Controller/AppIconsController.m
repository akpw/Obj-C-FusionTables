/* Copyright (c) 2013 Arseniy Kuznetsov
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//  AppIconsController.m
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/*****
    Simple organization of sample app images
*****/

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
+ (NSDictionary *)navBarItemShareButtonImage {
    UIImage *controlStateNormalImage = [UIImage imageNamed:@"ft_share.png"];
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











