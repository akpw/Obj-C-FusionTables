//
//  FusionTablesViewController.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 4/8/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

/****
    Shows usage of Obj-C-FusionTables, 
    retrieving & displaying a list of Fusion Tables (requiring & setting a Google auth).
    For the sake data safety, allows editing only Fusion Tables created in this app.
****/

#import <UIKit/UIKit.h>
#import "FTTable.h"

@interface FusionTablesViewController : UITableViewController <FTDelegate, UIActionSheetDelegate>

@end
