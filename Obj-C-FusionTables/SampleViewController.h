//
//  SampleViewController.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 23/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

/****
    Shows usage of Obj-C-FusionTables for 
    setting Fusion Table Map Styles and Templates, as well as for base Fusion Tables rows ops.
    For the sake data safety, changes are allowed only for Fusion Tables created in this app.
 
    SampleViewController is using GroupedUITableViews (https://github.com/akpw/GroupedUITableViews),
    isolating the logic of Fusion Table ops in small dedicated UITableView sections controller classes.
****/

#import <UIKit/UIKit.h>
#import "GroupedTableViewController.h"

#define SAMPLE_FUSION_TABLE_PREFIX (@"ObjC-API_Sample_FT_")

@interface SampleViewController : GroupedTableViewController

@property (nonatomic, strong) NSString *fusionTableID;
@property (nonatomic, strong) NSString *fusionTableName;

@end
