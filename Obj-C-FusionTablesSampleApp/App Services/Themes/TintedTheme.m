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

//  TintedTheme.m
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

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
