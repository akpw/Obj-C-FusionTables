//
//  GroupedTableUIController.h
//  GroupedUITableViews
//
//  Created by Arseniy Kuznetsov on 4/8/11.
//  Copyright 2011 Arseniy Kuznetsov. All rights reserved.
//

/****
    Dispatches TableView Data Source / Delegate methods to sections controllers.
    Dispatches memory warning  to sections controllers.
 
    Concrete UI Contollers build their dispatch tables, thus defining
    their specific grouped UTableViews' sections
****/

#import <Foundation/Foundation.h>
#import "GroupedTableSectionController.h"

@class GroupedTableViewController;

@interface GroupedTableUIController : NSObject

@property (nonatomic, weak) GroupedTableViewController *parentVC;
@property (nonatomic, strong) NSDictionary *grandDispatchTable;

- (void)didReceiveMemoryWarning;
- (GroupedTableUIController *)initWithParentViewController:(GroupedTableViewController *)theParentVC;

- (void)buildSectionsDispatchTable;
- (NSInteger)numberOfSections;
- (GroupedTableSectionController *)sectionControllerForSection:(NSUInteger)theSection;

@end
