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

//  AppGeneralServicesController.h
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

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
- (UIColor *)tableViewCellButtonTextLabelColor;
- (UIColor *)tableViewCellButtonBackgroundColor;

- (NSArray *)customBarButtonItemsBackForTarget:(id)target WithAction:(SEL)actionSelector;
- (NSArray *)customAddBarButtonItemsForTarget:(id)target WithAction:(SEL)actionSelector;
- (NSArray *)customEditBarButtonItemsForTarget:(id)target WithAction:(SEL)actionSelector;
- (NSArray *)customDoneBarButtonItemsForTarget:(id)target WithAction:(SEL)actionSelector;
- (NSArray *)customShareBarButtonItemsForTarget:(id)target WithAction:(SEL)actionSelector;

@end