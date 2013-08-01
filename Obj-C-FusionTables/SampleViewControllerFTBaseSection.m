//
//  SampleViewControllerFTBaseSection.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 26/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "SampleViewControllerFTBaseSection.h"

@implementation SampleViewControllerFTBaseSection

#pragma mark - Memory management
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Initialisation
- (void)initSpecifics {
    [[NSNotificationCenter defaultCenter]
                addObserverForName:FUSION_TABLE_CREATION_SUCCEDED_NOTIFICATION
                object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *tableID = (NSString *)[[note userInfo] valueForKey:FT_TABLE_ID_KEY];
        if (tableID) {
            self.fusionTableID = tableID;
            [self reloadSection];
        }
    }];
    [[NSNotificationCenter defaultCenter]
                addObserver:self selector:@selector(resetFusionTableID)
                name:FUSION_TABLE_CREATION_FAILED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]
                addObserver:self selector:@selector(resetFusionTableID)
                name:FUSION_TABLE_CREATION_STARTED_NOTIFICATION object:nil];
}
- (void)resetFusionTableID {
    self.fusionTableID = nil;
    [self reloadSection];
}

#pragma mark - Default Action Button for Section Rows Action Handlers
- (UIButton *)ftActionButton {
    UIImage *buttonImage = [UIImage imageNamed:@"CellAccessoryViewButtonHighlighted.png"];
    UIImage *selectedButtonImage = [UIImage imageNamed:@"CellAccessoryViewButton.png"];
    
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
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
