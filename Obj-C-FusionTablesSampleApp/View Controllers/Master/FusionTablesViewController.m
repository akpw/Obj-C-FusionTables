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

//  FusionTablesViewController.m
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    Shows usage of Obj-C-FusionTables, 
    retrieving & displaying a list of Fusion Tables (requiring & setting a Google auth).
    For the sake data safety, allows editing only Fusion Tables created in this app.
****/

#import "FusionTablesViewController.h"
#import "AppGeneralServicesController.h"
#import "AppIconsController.h"
#import "SampleViewController.h"
#import "FTInfoCellTableViewCell.h"
#import "FTCellTableViewCell.h"
#import "SampleFTTableDelegate.h"

@interface FusionTablesViewController () {
    BOOL isInEditingMode;
}

@property (nonatomic, strong) SampleFTTableDelegate *ftTableDelegate;
@property (nonatomic, strong) NSArray *editButton;
@property (nonatomic, strong) NSArray *doneButton;
@end

NSString *const FTTableViewControllerInfoCellIdentifier = @"FusionTableInfoCell";
NSString *const FTTableViewControllerCellIdentifier = @"FusionTableCell";

@implementation FusionTablesViewController
#pragma mark - Initialization
- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = @"FT API Example";
    }
    return self;
}
- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [self init];
    return self;
}

- (SampleFTTableDelegate *)ftTableDelegate {
    if (!_ftTableDelegate) {
        _ftTableDelegate = [[SampleFTTableDelegate alloc] init];
    }
    return _ftTableDelegate;
}
- (NSArray *)editButton {
    if (!_editButton) {
        _editButton = [[AppGeneralServicesController sharedAppTheme]
                                        customEditBarButtonItemsForTarget:self 
                                        WithAction:@selector(setEditingMode)];
    }
    return _editButton;
}
- (NSArray *)doneButton {
    if (!_doneButton) {
        _doneButton = [[AppGeneralServicesController sharedAppTheme]
                                        customDoneBarButtonItemsForTarget:self 
                                        WithAction:@selector(setEditingMode)];
    }
    return _doneButton;
}

#pragma mark - View lifecycle
- (void)setEditingMode {
    self.navigationItem.leftBarButtonItems = (isInEditingMode) ? self.editButton : self.doneButton;
    isInEditingMode = !isInEditingMode;
    [self.tableView setEditing:isInEditingMode animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[FTInfoCellTableViewCell class] 
                        forCellReuseIdentifier:FTTableViewControllerInfoCellIdentifier];
    [self.tableView registerClass:[FTCellTableViewCell class] 
                        forCellReuseIdentifier:FTTableViewControllerCellIdentifier];
    
    isInEditingMode = NO;
    self.navigationItem.rightBarButtonItems = [[AppGeneralServicesController sharedAppTheme]
                                                        customAddBarButtonItemsForTarget:self
                                                        WithAction:@selector(insertNewFusionTable)];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshFusionTablesList:)
                                               forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    // Authenticate & Load Fusion Tables list
    [self performSelector:@selector(loadFusionTables) withObject:self afterDelay:1.0f];
}
- (void)refreshFusionTablesList:(UIRefreshControl *)refreshControl {
    [self loadFusionTables];
    [refreshControl endRefreshing];
}

#pragma mark - FT Action Handlers
// loads list of Fusion Tables for authenticated user
- (void)loadFusionTables {
    __weak typeof (self) weakSelf = self;
    [self.ftTableDelegate 
            loadFusionTablesWithPreprocessingBlock: ^{
                [weakSelf.tableView reloadData];
            }
            FailedCompletionHandler: ^{                 
                [weakSelf reloadInfoRow];
            }
            CompletionHandler: ^{
               if ([weakSelf.ftTableDelegate.ftTableObjects count] > 0) 
                   weakSelf.navigationItem.leftBarButtonItems = weakSelf.editButton;                
                [weakSelf.tableView reloadData];
            }];
}

// inserts a new Fusion Tables
- (void)insertNewFusionTable {
    __weak typeof (self) weakSelf = self;
    [self.ftTableDelegate 
            insertNewFusionTableWithPreprocessingBlock: ^{
                [weakSelf reloadInfoRow];
            } 
            FailedCompletionHandler: ^{                 
                [weakSelf reloadInfoRow];
            }
            CompletionHandler:^{
                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                 [weakSelf.tableView insertRowsAtIndexPaths:@[indexPath]
                                           withRowAnimation:UITableViewRowAnimationAutomatic];
                 if (!weakSelf.navigationItem.leftBarButtonItem)
                     weakSelf.navigationItem.leftBarButtonItem = weakSelf.editButtonItem;  
                [weakSelf.tableView selectRowAtIndexPath:indexPath 
                                            animated:YES scrollPosition:UITableViewScrollPositionNone];
                [weakSelf tableView:weakSelf.tableView didSelectRowAtIndexPath:indexPath];
                [weakSelf reloadInfoRow];                
            }];
}

// delete existing Fusion Tables
- (void)deleteFusionTableObjectWithIndex:(NSUInteger)rowIndex {
    NSString *tableName = self.ftTableDelegate.ftTableObjects[rowIndex][@"name"];
    NSString *titleString = nil;
    UIAlertController *deleteAlertVC = [UIAlertController 
                                            alertControllerWithTitle:nil
                                            message:nil 
                                            preferredStyle:UIAlertControllerStyleActionSheet];    
    if ([tableName rangeOfString:SAMPLE_FUSION_TABLE_PREFIX].location != NSNotFound) {        
        titleString = [NSString stringWithFormat:
                   @"About to delete Fusion Table:\n%@\nThis operation can not be undone",
                                    self.ftTableDelegate.ftTableObjects[rowIndex][@"name"]];        
        // configure delete action
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete Table" 
             style:UIAlertActionStyleDefault 
             handler:^(UIAlertAction *action) {                                                                     
                 self.ftTableDelegate.selectedFusionTableID = 
                 self.ftTableDelegate.ftTableObjects[rowIndex][@"tableId"];            
                 __weak typeof (self) weakSelf = self;
                 [self.ftTableDelegate deleteFusionTableWithPreprocessingBlock:^{
                     [weakSelf reloadInfoRow];
                 }
                 FailedCompletionHandler: ^{                 
                     [weakSelf reloadInfoRow];
                 }         
                 CompletionHandler:^{
                     [weakSelf.ftTableDelegate.ftTableObjects removeObjectAtIndex:rowIndex];
                     if ([weakSelf.ftTableDelegate.ftTableObjects count] == 0) {
                         weakSelf.navigationItem.leftBarButtonItem = nil;
                     }
                     [weakSelf.tableView deleteRowsAtIndexPaths:
                      @[[NSIndexPath indexPathForRow:rowIndex inSection:0]]
                                               withRowAnimation:UITableViewRowAnimationFade];
                     [weakSelf reloadInfoRow];
                 }];                                                                
             }];        
        [deleteAlertVC addAction:deleteAction];
        
        // cancel action
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" 
                                                   style:UIAlertActionStyleDefault handler: nil];        
        [deleteAlertVC addAction:cancelAction];
        
    } else {
        titleString = @"To protect your existing Fusion Tables,\n"
                        "delete is enabled only for tables\n created with this App";  
        // OK action
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" 
                                                   style:UIAlertActionStyleDefault handler:nil];        
        [deleteAlertVC addAction:actionOK];        
    }    
    deleteAlertVC.title = titleString;

    // configure popover
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:
                             [NSIndexPath indexPathForRow:rowIndex inSection:0]];   
    UIPopoverPresentationController *popover = deleteAlertVC.popoverPresentationController;
    if (popover) {
        popover.sourceView = cell.contentView;
        popover.sourceRect = cell.contentView.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }            
    [self presentViewController:deleteAlertVC animated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // +1 for the info row
    return [self.ftTableDelegate.ftTableObjects count] + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if ([self.ftTableDelegate.ftTableObjects count] > 0 && indexPath.row > 0) {
        // regular cell
        cell = [tableView dequeueReusableCellWithIdentifier:FTTableViewControllerCellIdentifier];
        NSDictionary *ftObject = self.ftTableDelegate.ftTableObjects[indexPath.row - 1];
        cell.textLabel.text = ftObject[@"name"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"TableID: %@", ftObject[@"tableId"]];
    } else {
        // info cell
        cell = [tableView dequeueReusableCellWithIdentifier:FTTableViewControllerInfoCellIdentifier];
        cell.detailTextLabel.text = [self.ftTableDelegate currentActionInfoString];
    }
    return cell;
}
- (void)reloadInfoRow {
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] 
                              withRowAnimation:UITableViewRowAnimationAutomatic];    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 0) {
        self.ftTableDelegate.selectedFusionTableID = 
        self.ftTableDelegate.ftTableObjects[indexPath.row - 1][@"tableId"];
        
        SampleViewController *ftDetailViewController = [[SampleViewController alloc] init];
        ftDetailViewController.fusionTableID = self.ftTableDelegate.selectedFusionTableID;
        ftDetailViewController.fusionTableName = 
        self.ftTableDelegate.ftTableObjects[indexPath.row - 1][@"name"];
        
        [self.navigationController showDetailViewController:ftDetailViewController sender:self];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row > 0) ? YES : NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete & indexPath.row > 0) {
        [self deleteFusionTableObjectWithIndex:(indexPath.row - 1)];
    }
}




@end


