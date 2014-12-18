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

//  AppIconsController.h
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/*****
    Simple organization of sample app images
*****/

#import <Foundation/Foundation.h>

#define IconsControllerIconTypeNormal (@"IconsControllerIconTypeNormal")
#define IconsControllerIconTypeHighlighted (@"IconsControllerIconTypeHighlighted")

@interface AppIconsController : NSObject

+ (NSDictionary *)navBarCustomBackButtonImage;
+ (NSDictionary *)navBaAddBarButtonImage;
+ (NSDictionary *)navBarItemEditButtonImage;
+ (NSDictionary *)navBarItemDoneButtonImage;
+ (NSDictionary *)navBarItemShareButtonImage;
+ (NSDictionary *)cellAccessoryActionBtnImage;
+ (NSDictionary *)cellGenericBtnImage;

+ (UIImage *)fusionTablesImage;

@end
