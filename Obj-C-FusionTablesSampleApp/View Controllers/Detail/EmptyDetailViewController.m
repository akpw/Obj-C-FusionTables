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

//  FusionTablesViewController.h
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
 Shows usage of Obj-C-FusionTables, 
 retrieving & displaying a list of Fusion Tables (requiring & setting a Google auth).
 For the sake data safety, allows editing only Fusion Tables created in this app.
 ****/

#import "EmptyDetailViewController.h"

@implementation EmptyDetailViewController

- (void)loadView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = @"No Fusion Table Selected";
    label.textColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    [view addSubview:label];
    
    NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    NSLayoutConstraint *yConstraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    [NSLayoutConstraint activateConstraints:@[xConstraint, yConstraint]];
    
    self.view = view;
}

@end
