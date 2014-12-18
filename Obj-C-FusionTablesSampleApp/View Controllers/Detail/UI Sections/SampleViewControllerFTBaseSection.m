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

//  SampleViewControllerFTBaseSection.m
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    Base class for SampleViewController UITableView section controllers
****/

#import "SampleViewControllerFTBaseSection.h"
#import "AppIconsController.h"
#import "SampleViewController.h"

@implementation SampleViewControllerFTBaseSection

#pragma mark - Obj-C-FusionTables Sample Table check
// a simple Fusion Table name prefix check,
// used to recognise tables created with this app
- (BOOL)isSampleAppFusionTable {
    return [(SampleViewController *)self.parentVC isSampleAppFusionTable];
}

#pragma mark - FTDelegate Methods
// default impl
- (NSString *)ftTableID {
    return [(SampleViewController *)self.parentVC fusionTableID];
}

#pragma mark - Default Action Button for Section Rows Action Handlers
- (UIButton *)ftActionButton {
    UIImage *buttonImage = [AppIconsController cellAccessoryActionBtnImage][IconsControllerIconTypeNormal];
    UIImage *selectedButtonImage = [AppIconsController cellAccessoryActionBtnImage][IconsControllerIconTypeHighlighted];
    
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    actionButton.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    
    [actionButton setImage:buttonImage forState:UIControlStateNormal];
    [actionButton setImage:selectedButtonImage forState:UIControlStateHighlighted];
    [actionButton addTarget:self action:@selector(executeFTAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return actionButton;
}
// default action target
- (void)executeFTAction:(id)sender {
}


#pragma mark - GroupedTableSectionsController Table View Delegate
- (CGFloat)heightForHeaderInSection {
    return 40.0f;
}
- (CGFloat)heightForFooterInSection {
    CGFloat multilineHeight = ([[[UIDevice currentDevice] systemVersion] doubleValue] < 7) ? 58.0f : 40.0f;
    return ([self isSampleAppFusionTable]) ? 32.0f : multilineHeight;
}
- (CGFloat)heightForRow:(NSInteger)row {
    return ([self isSampleAppFusionTable]) ? 38.0f : 28.0f;
}

@end

