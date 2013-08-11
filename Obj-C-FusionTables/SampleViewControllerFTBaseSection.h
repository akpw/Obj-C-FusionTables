//
//  SampleViewControllerFTBaseSection.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 26/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupedTableSectionController.h"
#import "FTTable.h"

/****
    Base class for SampleViewController UITableView section controllers
****/

@interface SampleViewControllerFTBaseSection : GroupedTableSectionController <FTDelegate>

- (UIButton *)ftActionButton;
- (void)executeFTAction:(id)sender;
- (BOOL)isSampleAppFusionTable;

@end
