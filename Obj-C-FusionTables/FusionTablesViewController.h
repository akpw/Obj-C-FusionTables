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
    Shows usage of Obj-C-FusionTables for retrieving & displaing 
    a list of Fusion Tables for a given google auth.
    allows editing only for Fusion Tables created within this app
****/

@interface FusionTablesViewController : UITableViewController <FTDelegate, UIActionSheetDelegate>

@end
