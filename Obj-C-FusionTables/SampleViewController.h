//
//  SampleViewController.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 23/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupedTableViewController.h"

/****
    Allows setting Fusion Table Map Styles and Templates, as well as base rows ops
    only for Fusion Tables created within this app.
 
    SampleViewController is using GroupedUITableViews (https://github.com/akpw/GroupedUITableViews),
    to isolate sample logic of Fusion Table ops in small dedicated UITableView sections controller classes.
****/

#define SAMPLE_FUSION_TABLE_PREFIX (@"ObjC-API_Sample_FT_")

@interface SampleViewController : GroupedTableViewController

@property (nonatomic, strong) NSString *fusionTableID;
@property (nonatomic, strong) NSString *fusionTableName;

@end
