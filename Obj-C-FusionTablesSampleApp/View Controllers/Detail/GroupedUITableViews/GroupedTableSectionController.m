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

//  GroupedTableSectionController.m
//  GroupedUITableViews
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

#import "GroupedTableSectionController.h"
#import "GroupedTableViewController.h"

#pragma mark -
@implementation GroupedTableSectionController

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    // descendants' specifics
}

#pragma mark - Initialization
- (GroupedTableSectionController *)initWithParentViewController:(GroupedTableViewController *)theParentVC
                                                SectionID:(NSUInteger)sectionID
                                                DefaultCellID:(NSString *) defaultCellID {
    self = [super init];
    if (self) {
        self.parentVC = theParentVC;
        self.defaultCellIdentifier = defaultCellID;
        self.sectionID = sectionID;
        
        [self.parentVC.tableView registerClass:[UITableViewCell class] 
                                               forCellReuseIdentifier:self.defaultCellIdentifier];
        
        // simple descendants' inits
        [self initSpecifics];
    }
    return self;
}
- (void)initSpecifics {
    // descendants' specifics
}

#pragma mark - Section reload methods
- (void)reloadSectionWithRowAnimation:(UITableViewRowAnimation)rowAnimation {
    [self.parentVC.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.sectionID]
                           withRowAnimation:rowAnimation];
}
- (void)reloadSection {
    [self reloadSectionWithRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)reloadRow:(NSUInteger)row WithRowAnimation:(UITableViewRowAnimation)rowAnimation {
    NSArray *rowsArray = @[[NSIndexPath indexPathForRow:row inSection:_sectionID]];
    [self.parentVC.tableView reloadRowsAtIndexPaths:rowsArray withRowAnimation:rowAnimation];
}
- (void)reloadRow:(NSUInteger)row {
    [self reloadRow:row WithRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View Data Source methods, defaults impls
- (NSUInteger)numberOfRows {
    // descendants' specifics    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView CellForRow:(NSUInteger)row {
    // default impl
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.defaultCellIdentifier];
    return cell;
}
- (void)configureCell:(UITableViewCell *)cell ForRow:(NSUInteger)row {
    // descendants' specifics
}

#pragma mark - Table View Delegate method,s defaults impls
- (UITableViewCellEditingStyle)editingStyleForRow:(NSUInteger)row {
    // descendants' specifics
    return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView DidSelectRow:(NSInteger)row {
    // descendants' specifics
}
- (void)tableView:(UITableView *)tableView WillDisplayCell:(UITableViewCell *)cell forRow:(NSInteger)row {
    // descendants' specifics
}
- (NSString *)titleForHeaderInSection {
    // descendants' specifics
    return nil;
}
- (NSString *)titleForFooterInSection {
    // descendants' specifics
    return nil;
}
- (UIView *)viewForHeaderInSection {
    return nil;    
}
- (UIView *)viewForFooterInSection {
    return nil;
}
- (void)deselectRow {
    [self.parentVC.tableView 
            deselectRowAtIndexPath:[self.parentVC.tableView indexPathForSelectedRow] animated:YES];
}

@end
