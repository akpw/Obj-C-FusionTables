/* Copyright (c) 2013 Arseniy Kuznetsov
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//  GroupedTableUIController.h
//  GroupedUITableViews
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

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
