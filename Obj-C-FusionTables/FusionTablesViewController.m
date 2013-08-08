//
//  FusionTablesViewController.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 4/8/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "FusionTablesViewController.h"
#import "SampleViewController.h"
#import "AppGeneralServicesController.h"
#import "AppIconsController.h"

// FTables processing states
typedef NS_ENUM (NSUInteger, FTProcessingStates) {
    kFTStateIdle = 0,
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
                       customEditBarButtonItemsForTarget:self WithAction:@selector(setEditingMode)];
    }
    return _editButton;
}
- (NSArray *)doneButton {
    if (!_doneButton) {
        _doneButton = [[AppGeneralServicesController sharedAppTheme]
                       customDoneBarButtonItemsForTarget:self WithAction:@selector(setEditingMode)];
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
    ftProcessingStates = kFTStateIdle;
    self.navigationItem.rightBarButtonItems = [[AppGeneralServicesController sharedAppTheme]
                                                        customAddBarButtonItemsForTarget:self
                                                        WithAction:@selector(insertNewFusionTable)];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshFusionTablesList:)
                                               forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    // Load Fusion Tables list
    [self loadFusionTables];
}
- (void)refreshFusionTablesList:(UIRefreshControl *)refreshControl {
    [self loadFusionTables];
    [refreshControl endRefreshing];
}

#pragma mark - FT Action Handlers
// loads list of Fusion Tables for authenticated user
- (void)loadFusionTables {
    if (ftProcessingStates == kFTStateIdle) {
        ftProcessingStates = kFTStateRetrieving;
        self.ftTableObjects = nil;
        [self.tableView reloadData];
        
        [[SimpleGoogleServiceHelpers sharedInstance] incrementNetworkActivityIndicator];
        [self.ftTable listFusionTablesWithCompletionHandler:^(NSData *data, NSError *error) {
            [[SimpleGoogleServiceHelpers sharedInstance] decrementNetworkActivityIndicator];
            if (error) {
                NSData *data = [[error userInfo] valueForKey:@"data"];
                NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [[SimpleGoogleServiceHelpers sharedInstance]
                        showAlertViewWithTitle:@"Fusion Tables Error"
                        AndText: [NSString stringWithFormat:@"Error Creating Fusion Table: %@", errorStr]];
            } else {
                NSDictionary *lines = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions error:nil];
                NSLog(@"Fusion Tables: %@", lines);
                _ftTableObjects = [NSMutableArray arrayWithArray:lines[@"items"]];
                if ([_ftTableObjects count] > 0) self.navigationItem.leftBarButtonItems = self.editButton;
            }
            ftProcessingStates = kFTStateIdle;
            [self.tableView reloadData];
        }];
    }
}

// inserts a new Fusion Tables
- (void)insertNewFusionTable {
    if (ftProcessingStates == kFTStateIdle) {
        ftProcessingStates = kFTStateInserting;
        [self.tableView reloadData];

        [[SimpleGoogleServiceHelpers sharedInstance] incrementNetworkActivityIndicator];
        [self.ftTable insertFusionTableWithCompletionHandler:^(NSData *data, NSError *error) {
            [[SimpleGoogleServiceHelpers sharedInstance] decrementNetworkActivityIndicator];
            if (error) {
                NSData *data = [[error userInfo] valueForKey:@"data"];
                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                [[SimpleGoogleServiceHelpers sharedInstance]
                        showAlertViewWithTitle:@"Fusion Tables Error"
                        AndText: [NSString stringWithFormat:@"Error Creating Fusion Table: %@", str]];
            } else {
                NSDictionary *contentDict = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:kNilOptions error:nil];
                if (contentDict) {
                    NSLog(@"Created a new Fusion Table: %@", contentDict);
                    
                    [_ftTableObjects insertObject:contentDict atIndex:0];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationAutomatic];
                    if (!self.navigationItem.leftBarButtonItem)
                                self.navigationItem.leftBarButtonItem = self.editButtonItem;
                } else {
                    // the FT Create Table did not return tableid
                    [[SimpleGoogleServiceHelpers sharedInstance]
                            showAlertViewWithTitle:@"Fusion Tables Error"
                            AndText:  @"Error Fetching the Fusion Table ID"];
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
        
        [[SimpleGoogleServiceHelpers sharedInstance] incrementNetworkActivityIndicator];
        [self.ftTable deleteFusionTableWithCompletionHandler:^(NSData *data, NSError *error) {
            [[SimpleGoogleServiceHelpers sharedInstance] decrementNetworkActivityIndicator];
            if (error) {
                NSData *data = [[error userInfo] valueForKey:@"data"];
                NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [[SimpleGoogleServiceHelpers sharedInstance]
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
- (NSString *)ftTitle {
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
    // +1 for the info row
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
    NSString *tableName = self.ftTableObjects[rowIndex][@"name"];
    if ([tableName rangeOfString:SAMPLE_FUSION_TABLE_PREFIX].location != NSNotFound) {
        NSString *titleString = [NSString stringWithFormat:
                                 @"About to delete Fusion Table %@\n This operation can not be undone",
                                 self.ftTableObjects[rowIndex][@"name"]];
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
        self.selectedFusionTableID = self.ftTableObjects[rowIndex][@"tableId"];
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
        self.selectedFusionTableID = self.ftTableObjects[indexPath.row - 1][@"tableId"];
        SampleViewController *ftDetailViewController = [[SampleViewController alloc]
                                                        initWithNibName:@"GroupedTableViewController" bundle:nil];
        ftDetailViewController.fusionTableID = self.selectedFusionTableID;
        ftDetailViewController.fusionTableName = self.ftTableObjects[indexPath.row - 1][@"name"];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                                 style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:ftDetailViewController animated:YES];
    }
}

#pragma mark - Info Cell Helpers
- (NSString *)stringForProcessingState {
    NSString *processingStateString = nil;
    NSString *userID = [[GoogleAuthorizationController sharedInstance] authenticatedUserID];
    switch (ftProcessingStates) {
        case kFTStateIdle:
            processingStateString = [NSString stringWithFormat:@"Fusion Tables for userID: %@", userID];
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
    // a quick way to center text within UITableViewCellStyleSubtitle cell without adding custom lables
    return [[@"" stringByPaddingToLength:(46 - [processingStateString length])
                              withString:@" " startingAtIndex:0] stringByAppendingString:processingStateString];
}
@end
