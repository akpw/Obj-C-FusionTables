//
//  GroupedTableViewController.h
//  GroupedUITableViews
//
//  Created by Arseniy Kuznetsov on 11/10/11.
//  Copyright 2011 Arseniy Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupedTableUIController.h"

/****
    A grouped UITableView controller that dispatches its 
    Data Source / Delegate methods to dedicated section controllers
    via the UI Controller. 
****/


@interface GroupedTableViewController : UITableViewController

@property (nonatomic, strong) GroupedTableUIController *uiController;

@end
