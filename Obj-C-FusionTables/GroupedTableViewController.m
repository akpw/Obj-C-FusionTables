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

//  GroupedTableViewController.m
//  GroupedUITableViews

#import "GroupedTableViewController.h"


#pragma mark - 
@implementation GroupedTableViewController

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    // passing over to the UI controller, which in turn notify all of its Section Controllers
    [self.uiController didReceiveMemoryWarning];

    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.uiController numberOfSections];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GroupedTableSectionController *sectionController = [self.uiController
                                                         sectionControllerForSection:section];
    return [sectionController numberOfRows];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupedTableSectionController *sectionController = [self.uiController 
                                                            sectionControllerForSection:indexPath.section];
    UITableViewCell *cell = [sectionController tableView:tableView CellForRow:indexPath.row];
    [sectionController configureCell:cell ForRow:indexPath.row];    
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupedTableSectionController *sectionController = [self.uiController
                                                         sectionControllerForSection:indexPath.section];
    return [sectionController heightForRow:indexPath.row];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupedTableSectionController *sectionController = [self.uiController 
                                                         sectionControllerForSection:indexPath.section];
    [sectionController tableView:tableView DidSelectRow:indexPath.row];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
                                                    forRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupedTableSectionController *sectionController = [self.uiController 
                                                         sectionControllerForSection:indexPath.section];
    [sectionController tableView:tableView WillDisplayCell:(UITableViewCell *)cell forRow:indexPath.row];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    GroupedTableSectionController *sectionController = [self.uiController 
                                                         sectionControllerForSection:section];
    return [sectionController heightForFooterInSection];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    GroupedTableSectionController *sectionController = [self.uiController 
                                                         sectionControllerForSection:section];
    return [sectionController heightForHeaderInSection];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    GroupedTableSectionController *sectionController = [self.uiController 
                                                         sectionControllerForSection:section];
    return [sectionController titleForHeaderInSection];
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    GroupedTableSectionController *sectionController = [self.uiController 
                                                         sectionControllerForSection:section];
    return [sectionController titleForFooterInSection];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GroupedTableSectionController *sectionController = [self.uiController 
                                                         sectionControllerForSection:section];
    return [sectionController viewForHeaderInSection];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    GroupedTableSectionController *sectionController = [self.uiController 
                                                         sectionControllerForSection:section];
    return [sectionController viewForFooterInSection];
}

@end
