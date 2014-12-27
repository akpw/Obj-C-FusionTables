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

//  GroupedTableSectionController.h
//  GroupedUITableViews
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    Represents a section in a grouped UITableView.
    Allows encasulating section-related controller logic in a small dedicated class.
    
    Descendant section controllers implement specific Table View Data Source / Delegate methods
    and add their section-related controller logic.
****/

#import <Foundation/Foundation.h>

@class GroupedTableViewController;

@interface GroupedTableSectionController : NSObject

@property (nonatomic, assign) NSUInteger sectionID;
@property (nonatomic, strong) NSString *defaultCellIdentifier;
@property (nonatomic, weak) GroupedTableViewController *parentVC;

- (void)didReceiveMemoryWarning;

- (GroupedTableSectionController *)initWithParentViewController:(GroupedTableViewController *)theParentVC
                                                   SectionID:(NSUInteger)sectionID
                                                   DefaultCellID:(NSString *) defaultCellID;
- (void)initSpecifics;
- (void)reloadSection;
- (void)reloadSectionWithRowAnimation:(UITableViewRowAnimation)rowAnimation;
- (void)reloadRow:(NSUInteger)row;
- (void)reloadRow:(NSUInteger)row WithRowAnimation:(UITableViewRowAnimation)rowAnimation;

- (NSUInteger)numberOfRows;
- (UITableViewCell *)tableView:(UITableView *)tableView CellForRow:(NSUInteger)row;
- (void)configureCell:(UITableViewCell *)cell ForRow:(NSUInteger)row;

- (void)tableView:(UITableView *)tableView DidSelectRow:(NSInteger)row;
- (void)deselectRow;
- (void)tableView:(UITableView *)tableView WillDisplayCell:(UITableViewCell *)cell forRow:(NSInteger)row;
- (UITableViewCellEditingStyle)editingStyleForRow:(NSUInteger)row;
- (NSString *)titleForHeaderInSection;
- (NSString *)titleForFooterInSection;
- (UIView *)viewForHeaderInSection;
- (UIView *)viewForFooterInSection;


@end
