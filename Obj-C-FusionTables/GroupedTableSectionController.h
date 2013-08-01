//
//  GroupedTableSectionController.h
//  iCasualTours
//
//  Created by Arseniy Kuznetsov on 4/8/11.
//  Copyright 2011 Arseniy Kuznetsov. All rights reserved.
//

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
- (CGFloat)heightForRow:(NSInteger)row;
- (CGFloat)heightForHeaderInSection;
- (CGFloat)heightForFooterInSection;
- (NSString *)titleForHeaderInSection;
- (NSString *)titleForFooterInSection;
- (UIView *)viewForHeaderInSection;
- (UIView *)viewForFooterInSection;

// Search Bar methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString;
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption;
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar;
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller;
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller;

@end
