//
//  SampleViewControllerFTBaseSection.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 26/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

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
    NSString *tableName = [(SampleViewController *)self.parentVC fusionTableName];
    return ([tableName rangeOfString:SAMPLE_FUSION_TABLE_PREFIX].location != NSNotFound);
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
    
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
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
    return 2.0f;
}


@end
