//
//  SampleViewControllerFTBaseSection.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 26/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupedTableSectionController.h"

#define FUSION_TABLE_CREATION_STARTED_NOTIFICATION (@"FusionTableCreationStartedNotification")
#define FUSION_TABLE_CREATION_SUCCEDED_NOTIFICATION (@"FusionTableCreationSuccededNotification")
#define FUSION_TABLE_CREATION_FAILED_NOTIFICATION (@"FusionTableCreationFailedNotification")
#define FT_TABLE_ID_KEY (@"FTTableIDKey")

@interface SampleViewControllerFTBaseSection : GroupedTableSectionController

@property (nonatomic, strong) NSString *fusionTableID;

- (UIButton *)ftActionButton;
- (void)executeFTAction:(id)sender;
- (void)resetFusionTableID;

@end
