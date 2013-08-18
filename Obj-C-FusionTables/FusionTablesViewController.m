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

// FTables processing states
typedef NS_ENUM (NSUInteger, FTProcessingStates) {
    kFTStateIdle = 0,
    kFTStateAuthenticating,
    kFTStateRetrieving,
    kFTStateInserting,
    kFTStateDeleting
};
@interface FusionTablesViewController () {
    FTProcessingStates ftProcessingStates;
    BOOL isInEditingMode;
}
@property (nonatomic, strong) NSMutableArray *ftTableObjects;
@property (nonatomic, strong) FTTable *ftTable;
@property (nonatomic, strong) NSString *selectedFusionTableID;
@property (nonatomic, strong) NSArray *editButton;
@property (nonatomic, strong) NSArray *doneButton;
@end

@implementation FusionTablesViewController
#pragma mark - Initialization
- (FTTable *)ftTable {
    if (!_ftTable) {
        _ftTable = [[FTTable alloc] init];
        _ftTable.ftTableDelegate = self;
    }
    return _ftTable;
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
    
    self.title = @"FT API Example";

    isInEditingMode = NO;
    self.navigationItem.rightBarButtonItems = [[AppGeneralServicesController sharedAppTheme]
                                                        customAddBarButtonItemsForTarget:self
                                                        WithAction:@selector(insertNewFusionTable)];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshFusionTablesList:)
                                               forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    // Authenticate & Load Fusion Tables list
    ftProcessingStates = kFTStateAuthenticating;
    [self performSelector:@selector(loadFusionTables) withObject:self afterDelay:1.0f];
}
- (void)refreshFusionTablesList:(UIRefreshControl *)refreshControl {
    [self loadFusionTables];
    [refreshControl endRefreshing];
}

#pragma mark - FT Action Handlers
// loads list of Fusion Tables for authenticated user
- (void)loadFusionTables {
    if (ftProcessingStates == kFTStateIdle || ftProcessingStates == kFTStateAuthenticating) {
        self.ftTableObjects = nil;
        ftProcessingStates =  kFTStateRetrieving;
        [self.tableView reloadData];

        void_completion_handler_block finishProcessingBlock = ^ {
            [[GoogleServicesHelper sharedInstance] decrementNetworkActivityIndicator];
            ftProcessingStates = kFTStateIdle;
            [self.tableView reloadData];
        };
        [[GoogleServicesHelper sharedInstance] incrementNetworkActivityIndicator];
        [[GoogleAuthorizationController sharedInstance] authorizedRequestWithCompletionHandler:^{
            [self.ftTable listFusionTablesWithCompletionHandler:^(NSData *data, NSError *error) {
                if (error) {
                    NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
                    [[GoogleServicesHelper sharedInstance]
                            showAlertViewWithTitle:@"Fusion Tables Error"
                            AndText: [NSString stringWithFormat:@"Error Fetching Fusion Tables: %@", errorStr]];
                } else {
                    NSDictionary *lines = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:kNilOptions error:nil];
                    NSLog(@"Fusion Tables: %@", lines);
                    self.ftTableObjects = [NSMutableArray arrayWithArray:lines[@"items"]];
                    if ([_ftTableObjects count] > 0) self.navigationItem.leftBarButtonItems = self.editButton;
                }
                finishProcessingBlock ();
            }];
        } CancelHandler:^{
                finishProcessingBlock ();
        }];
    }
}

// inserts a new Fusion Tables
- (void)insertNewFusionTable {
    if (ftProcessingStates == kFTStateIdle) {
        ftProcessingStates = kFTStateInserting;
        [self.tableView reloadData];

        [[GoogleServicesHelper sharedInstance] incrementNetworkActivityIndicator];
        [self.ftTable insertFusionTableWithCompletionHandler:^(NSData *data, NSError *error) {
            [[GoogleServicesHelper sharedInstance] decrementNetworkActivityIndicator];
            if (error) {
                NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];                
                [[GoogleServicesHelper sharedInstance]
                        showAlertViewWithTitle:@"Fusion Tables Error"
                        AndText: [NSString stringWithFormat:@"Error Inserting Fusion Table: %@", errorStr]];
            } else {
                NSDictionary *ftTableDict = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:kNilOptions error:nil];
                if (ftTableDict) {
                    NSLog(@"Inserted a new Fusion Table: %@", ftTableDict);
                    
                    [_ftTableObjects insertObject:ftTableDict atIndex:0];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationAutomatic];
                    if (!self.navigationItem.leftBarButtonItem)
                                self.navigationItem.leftBarButtonItem = self.editButtonItem;
                } else {
                    // the FT Create Insert did not return sound info
                    [[GoogleServicesHelper sharedInstance]
                            showAlertViewWithTitle:@"Fusion Tables Error"
                            AndText:  @"Error processsing inserted Fusion Table data"];
                }
            }
            ftProcessingStates = kFTStateIdle;
            [self.tableView reloadData];
        }];
    }
}

// deletes a Fusion Tables with specified ID
- (void)deleteFusionTableWithCompletionHandler:(void_completion_handler_block)completionHandler {
    if (ftProcessingStates == kFTStateIdle) {
        ftProcessingStates = kFTStateDeleting;
        [self.tableView reloadData];
        
        [[GoogleServicesHelper sharedInstance] incrementNetworkActivityIndicator];
        [self.ftTable deleteFusionTableWithCompletionHandler:^(NSData *data, NSError *error) {
            [[GoogleServicesHelper sharedInstance] decrementNetworkActivityIndicator];
            if (error) {
                NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
                [[GoogleServicesHelper sharedInstance]
                        showAlertViewWithTitle:@"Fusion Tables Error"
                        AndText: [NSString stringWithFormat:@"Error deleting Fusion Table: %@", errorStr]];
            } else {
                // Table deleted, run the handler
                completionHandler();
            }
            ftProcessingStates = kFTStateIdle;
            [self.tableView reloadData];
        }];
    }
}

#pragma mark - FTDelegate methods
- (NSString *)ftTableID {
    return self.selectedFusionTableID;
}
- (NSString *)ftName {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd-hhmmss"];
    return [NSString stringWithFormat:@"%@%@",
            SAMPLE_FUSION_TABLE_PREFIX, [formatter stringFromDate:[NSDate date]]];
}
// Sample Fusion Table Columns Definition
- (NSArray *)ftColumns {
    return @[
             @{@"name": @"entryDate",
               @"type": @"STRING"
               },
             @{@"name": @"entryName",
               @"type": @"STRING"
               },
             @{@"name": @"entryThumbImageURL",
               @"type": @"STRING"
               },
             @{@"name": @"entryURL",
               @"type": @"STRING"
               },
             @{@"name": @"entryURLDescription",
               @"type": @"STRING"
               },
             @{@"name": @"entryNote",
               @"type": @"STRING"
               },
             @{@"name": @"entryImageURL",
               @"type": @"STRING"
               },
             @{@"name": @"markerIcon",
               @"type": @"STRING"
               },
             @{@"name": @"lineColor",
               @"type": @"STRING"
               },
             @{@"name": @"geometry",
               @"type": @"LOCATION"
               }
             ];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // adding +1 for the info row
    return [_ftTableObjects count] + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TheCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    if ([_ftTableObjects count] > 0) {
        [self configureCell:cell ForRow:indexPath.row];
    } else {
        [self configureInfoCell:cell];
    }
    return cell;
}
- (void)configureInfoCell:(UITableViewCell *)cell {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = [self stringForProcessingState];
    cell.contentView.backgroundColor = [UIColor lightGrayColor];
    cell.detailTextLabel.backgroundColor = [UIColor lightGrayColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.imageView.image = nil;
}
- (void)configureCell:(UITableViewCell *)cell ForRow:(NSUInteger)row {
    if (row == 0) {
        [self configureInfoCell:cell];
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSDictionary *ftObject = _ftTableObjects[row - 1];
        cell.textLabel.text = ftObject[@"name"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"TableID: %@", ftObject[@"tableId"]];
        cell.imageView.image = [AppIconsController fusionTablesImage];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.detailTextLabel.backgroundColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
}

#pragma mark - Table view delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row > 0) ? YES : NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete & indexPath.row > 0) {
        [self deleteFusionTableObjectWithIndex:(indexPath.row - 1)];
    }
}
#define DELETE_BUTTON_TITLE (@"Delete Table")
- (void)deleteFusionTableObjectWithIndex:(NSUInteger)rowIndex {
    UIActionSheet *deleteActionSheet;
    NSString *tableName = _ftTableObjects[rowIndex][@"name"];
    if ([tableName rangeOfString:SAMPLE_FUSION_TABLE_PREFIX].location != NSNotFound) {
        NSString *titleString = [NSString stringWithFormat:
                                 @"About to delete Fusion Table %@\n This operation can not be undone",
                                 _ftTableObjects[rowIndex][@"name"]];
        deleteActionSheet = [[UIActionSheet alloc] initWithTitle:titleString
                                                                       delegate:self
                                                              cancelButtonTitle:@"Cancel"
                                                         destructiveButtonTitle:DELETE_BUTTON_TITLE
                                                              otherButtonTitles:nil];
        deleteActionSheet.tag = rowIndex;
    } else {
        NSString *titleString = @"To protect your existing Fusion Tables,\n"
                                 "delete is enabled only for tables\n created with this App";
        deleteActionSheet = [[UIActionSheet alloc] initWithTitle:titleString
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:nil];
        deleteActionSheet.tag = rowIndex;
    }
    [deleteActionSheet showInView:self.navigationController.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:DELETE_BUTTON_TITLE]) {
        NSUInteger rowIndex = actionSheet.tag;
        self.selectedFusionTableID = _ftTableObjects[rowIndex][@"tableId"];
        [self deleteFusionTableWithCompletionHandler:^{
            [_ftTableObjects removeObjectAtIndex:rowIndex];
            if ([_ftTableObjects count] == 0) self.navigationItem.leftBarButtonItem = nil;
            [self.tableView deleteRowsAtIndexPaths:
                                    @[[NSIndexPath indexPathForRow:rowIndex inSection:0]]
                                    withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}
#undef DELETE_BUTTON_TITLE

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 0) {
        self.selectedFusionTableID = _ftTableObjects[indexPath.row - 1][@"tableId"];
        SampleViewController *ftDetailViewController = [[SampleViewController alloc]
                                                        initWithNibName:@"GroupedTableViewController" bundle:nil];
        ftDetailViewController.fusionTableID = _selectedFusionTableID;
        ftDetailViewController.fusionTableName = _ftTableObjects[indexPath.row - 1][@"name"];
        [self.navigationController pushViewController:ftDetailViewController animated:YES];
    }
}

#pragma mark - Info Cell Helpers
- (NSString *)stringForProcessingState {
    NSString *processingStateString = @"";
    switch (ftProcessingStates) {
        case kFTStateIdle:
        {
            NSString *userID = [[GoogleAuthorizationController sharedInstance] authenticatedUserID];
            if (userID) {
                processingStateString = [NSString stringWithFormat:@"Fusion Tables for userID: %@", userID];
            } else {
                processingStateString = [NSString stringWithFormat:@"Pull down to retrieve your Fusion Tables"];
            }
            break;
        }
        case kFTStateAuthenticating:
            processingStateString = @"... authenticating for a Google Account";
            break;
        case kFTStateRetrieving:
            processingStateString = @"... retrieving list of Fusion Tables";
            break;
        case kFTStateInserting:
            processingStateString = @"... creating a new Fusion Table";
            break;
        case kFTStateDeleting:
            processingStateString = @"... deleting Fusion Table";
            break;
        default:
            break;
    }
    // a quick way to center text within UITableViewCellStyleSubtitle cell without adding a custom lable
    NSUInteger pStringLength = [processingStateString length];
    NSUInteger padding = (pStringLength < 46) ? (46 - pStringLength) : 0;
    return [[@"" stringByPaddingToLength:padding
                              withString:@" " startingAtIndex:0] stringByAppendingString:processingStateString];
}


@end


