//
//  FusionTablesViewController.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 4/8/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTTable.h"

/****
    Shows usage of Obj-C-FusionTables, retrieving & displaying 
    a list of Fusion Tables for a given google auth.
    for data safety, allows editing only Fusion Tables created in this app
****/

@interface FusionTablesViewController : UITableViewController <FTDelegate, UIActionSheetDelegate>

@end
