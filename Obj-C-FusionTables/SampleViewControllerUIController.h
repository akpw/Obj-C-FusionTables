//
//  SampleViewControllerUIController.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 19/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "GroupedTableUIController.h"

/****
    A specific SampleViewController dispatcher class.
    
    SampleViewController is using GroupedUITableViews (https://github.com/akpw/GroupedUITableViews),
    to isolate sample logic of Fusion Table ops in small dedicated UITableView sections controller classes.
****/

@interface SampleViewControllerUIController : GroupedTableUIController

@end
