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

//  SampleViewControllerFTSharingSection.m
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    Shows usage of Obj-C-FusionTables for Fusion Tables rows operations
****/

#import "SampleViewControllerInsertFTRowsSection.h"
#import "FTSQLQueryBuilder.h"

// Defines rows in section
enum SampleViewControllerFTInsertSectionRows {
    kSampleViewControllerFTInsertRowSection = 0,
    kSampleViewControllerFTUpdateRowSection,
    kSampleViewControllerFTDeleteRowSection,
    SampleViewControllerFTInsertSectionNumRows
};

// FTable SQL query states
typedef NS_ENUM (NSUInteger, FTSQLQueryStates) {
    kFTStateIdle = 0,
    kFTStateInsertingRows,
    kFTStateUpdatingRows,
    kFTStateDeletingRows
};

@interface SampleViewControllerInsertFTRowsSection ()
    @property (nonatomic, strong) FTSQLQuery *ftSQLQuery;
@end

@implementation SampleViewControllerInsertFTRowsSection {
    FTSQLQueryStates ftInsertRowState;
    NSInteger ftPhotoEntryRowID;
    NSUInteger ftPhotoEntrySampleDataRotatingIdx;
}

#pragma mark - Initialisation
- (void)initSpecifics {
    ftInsertRowState = kFTStateIdle;
    ftPhotoEntryRowID = -1; // uknown at that point
    ftPhotoEntrySampleDataRotatingIdx = 0;
}
- (FTSQLQuery *)ftSQLQuery {
    if (!_ftSQLQuery) {
        _ftSQLQuery = [[FTSQLQuery alloc] init];
        _ftSQLQuery.ftSQLQueryDelegate = self;
    }
    return _ftSQLQuery;
}

#pragma mark - GroupedTableSectionsController Table View Data Source
enum FTActionTypes {
    kFTActionInsert = 0,
    kFTActionUpdate,
    kFTActionDelete
};
- (NSUInteger)numberOfRows {
    return SampleViewControllerFTInsertSectionNumRows;
}
- (void)configureCell:(UITableViewCell *)cell ForRow:(NSUInteger)row {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.userInteractionEnabled = YES;
    cell.backgroundColor = [UIColor whiteColor];
    switch (row) {
        case kSampleViewControllerFTInsertRowSection:
            if (ftPhotoEntryRowID < 0) {
                cell.textLabel.text = @"Resolving sample rows";
                cell.accessoryView = [self spinnerView];
                [self selectSampleRows];
            } else if (ftPhotoEntryRowID == 0) {
                cell.textLabel.text = @"Insert sample rows";
                cell.accessoryView = [self ftActionButtonWithTag:kFTActionInsert];
            } else {
                cell.textLabel.text = @"Sample rows inserted";
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        case kSampleViewControllerFTUpdateRowSection:
            cell.textLabel.text = @"Update the photo entry";
            if (ftPhotoEntryRowID <= 0) {
                cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
                cell.userInteractionEnabled = NO;
            } else {
                cell.accessoryView = [self ftActionButtonWithTag:kFTActionUpdate];
            }
            break;
        case kSampleViewControllerFTDeleteRowSection:
            cell.textLabel.text = @"Delete sample rows";
            if (ftPhotoEntryRowID <= 0) {
                cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
                cell.userInteractionEnabled = NO;
            } else {
                cell.accessoryView = [self ftActionButtonWithTag:kFTActionDelete];
            }
            break;
        default:
            break;
    }
}
- (void)executeFTAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case kFTActionInsert:
            [self insertSampleRows];
            break;
        case kFTActionUpdate:
            [self updateLastInsertedRow];
            break;
        case kFTActionDelete:
            [self deleteInsertedRows];
            break;
    }
}

#pragma mark - GroupedTableSectionsController Table View Delegate
- (NSString *)titleForFooterInSection {
    NSString *footerString = nil;
    switch (ftInsertRowState) {
        case kFTStateIdle:
            footerString = @"Fusion Tables SQL operations";
            break;
        case kFTStateInsertingRows:
            footerString = @"Inserting Fusion Tables Rows...";
            break;
        case kFTStateUpdatingRows:
            footerString = @"Updating Fusion Tables Rows...";
            break;
        case kFTStateDeletingRows:
            footerString = @"Deleting Fusion Tables Rows...";
            break;
        default:
            break;
    }
    return footerString;
}
- (NSString *)titleForHeaderInSection {
    return @"Fusion Table Rows Operations";
}

#pragma mark - FT Action Handlers
#pragma mark - Columns Names for Insert / Update
- (NSArray *)columnNames {
    return @[@"entryDate",
             @"entryName",
             @"entryThumbImageURL",
             @"entryURL",
             @"entryURLDescription",
             @"entryNote",
             @"entryImageURL",
             @"markerIcon",
             @"lineColor",
             @"geometry"
             ];
}

#pragma mark - FTSQLQueryDelegate Methods
- (NSString *)ftSQLSelectStatement {
    return [NSString stringWithFormat:@"SELECT ROWID FROM %@ WHERE  markerIcon CONTAINS %@", 
                                [self ftTableID], 
                                [FTSQLQueryBuilder buildFTStringValueString:@"cross_hairs_highlight"]];
}
- (NSString *)ftSQLInsertStatement {
    NSString *ftSQLInsertStatementString = nil;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"sampleInsertData" ofType:@"plist"];
    NSArray *insertArray = [NSArray arrayWithContentsOfFile:plistPath];

    for (NSDictionary *insertEntry in insertArray) {
        NSString *lineColor = [FTSQLQueryBuilder buildFTStringValueString:insertEntry[@"lineColor"]];
        NSString *insertEntryString = [FTSQLQueryBuilder
                                        builSQLInsertStringForColumnNames:[self columnNames]
                                        FTTableID:[self ftTableID],
               [FTSQLQueryBuilder buildFTStringValueString:insertEntry[@"entryDate"]],
               [FTSQLQueryBuilder buildFTStringValueString:insertEntry[@"entryName"]],
               [FTSQLQueryBuilder buildFTStringValueString:insertEntry[@"entryThumbImageURL"]],
               [FTSQLQueryBuilder buildFTStringValueString:insertEntry[@"entryURL"]],
               [FTSQLQueryBuilder buildFTStringValueString:insertEntry[@"entryURLDescription"]],
               [FTSQLQueryBuilder buildFTStringValueString:insertEntry[@"entryNote"]],
               [FTSQLQueryBuilder buildFTStringValueString:insertEntry[@"entryImageURL"]],
               [FTSQLQueryBuilder buildFTStringValueString:insertEntry[@"markerIcon"]],
               lineColor,
               ([lineColor length] > 2) ?  // a quick & dirty way to insert different KML item types
                   [FTSQLQueryBuilder buildKMLLineString:insertEntry[@"geometry"]] :
                   [FTSQLQueryBuilder buildKMLPointString:insertEntry[@"geometry"]]
               ];
        ftSQLInsertStatementString = (ftSQLInsertStatementString) ?
                [NSString stringWithFormat:@"%@;%@", 
                        ftSQLInsertStatementString, insertEntryString] :
                insertEntryString;
    }
    return ftSQLInsertStatementString;
}
- (NSString *)ftSQLUpdateStatement {
    NSDictionary *updateEntry = [self rotatingSampleDataPhotoEntry];
    NSString *ftSQLUpdateStatementString = [FTSQLQueryBuilder 
                                        builSQLUpdateStringForRowID:ftPhotoEntryRowID
                                        ColumnNames:[self columnNames]
                                        FTTableID:[self ftTableID],
                 [FTSQLQueryBuilder buildFTStringValueString:updateEntry[@"entryDate"]],
                 [FTSQLQueryBuilder buildFTStringValueString:updateEntry[@"entryName"]],
                 [FTSQLQueryBuilder buildFTStringValueString:updateEntry[@"entryThumbImageURL"]],
                 [FTSQLQueryBuilder buildFTStringValueString:updateEntry[@"entryURL"]],
                 [FTSQLQueryBuilder buildFTStringValueString:updateEntry[@"entryURLDescription"]],
                 [FTSQLQueryBuilder buildFTStringValueString:updateEntry[@"entryNote"]],
                 [FTSQLQueryBuilder buildFTStringValueString:updateEntry[@"entryImageURL"]],
                 [FTSQLQueryBuilder buildFTStringValueString:updateEntry[@"markerIcon"]],
                 [FTSQLQueryBuilder buildFTStringValueString:updateEntry[@"lineColor"]],
                 [FTSQLQueryBuilder buildKMLPointString:updateEntry[@"geometry"]]
                 ];    
    return ftSQLUpdateStatementString;
}
- (NSString *)ftSQLDeleteStatement {
    return [FTSQLQueryBuilder buildDeleteAllRowStringForFusionTableID:[self ftTableID]];
}

#pragma mark - Sample Rows Handlers
- (void)selectSampleRows {
    [[GoogleServicesHelper sharedInstance] incrementNetworkActivityIndicator];
    [self.ftSQLQuery sqlSelectWithCompletionHandler:^(NSData *data, NSError *error) {
        [[GoogleServicesHelper sharedInstance] decrementNetworkActivityIndicator];
        ftPhotoEntryRowID = 0;
        if (error) {
            NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
            [[GoogleServicesHelper sharedInstance]
             showAlertViewWithTitle:@"Fusion Tables Error"
             AndText: [NSString stringWithFormat:
                       @"Error listing Fusion Table Styles: %@", errorStr]];
        } else {
            NSDictionary *lines = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions error:nil];
            NSLog(@"Fusion Tables styles: %@", lines);
            NSArray *rows = [NSMutableArray arrayWithArray:lines[@"rows"]];
            if ([rows count] != 0) {
                ftPhotoEntryRowID = [[rows lastObject][0] intValue];
            }
        }
        [self reloadSection];
    }];
}
- (void)insertSampleRows {   
    ftInsertRowState = kFTStateInsertingRows;
    ftPhotoEntryRowID = 0;
    [self reloadSection];
    
    [[GoogleServicesHelper sharedInstance] incrementNetworkActivityIndicator];
    [self.ftSQLQuery sqlInsertWithCompletionHandler:^(NSData *data, NSError *error) {
        [[GoogleServicesHelper sharedInstance] decrementNetworkActivityIndicator];
        ftInsertRowState = kFTStateIdle;
        if (error) {
            NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
            [[GoogleServicesHelper sharedInstance]
                    showAlertViewWithTitle:@"Fusion Tables Error"
                    AndText: [NSString stringWithFormat:@"Error inserting Rows: %@", errorStr]];
        } else {
            NSDictionary *responceDict = [NSJSONSerialization
                                          JSONObjectWithData:data options:kNilOptions error:nil];
            NSArray *rows = responceDict[@"rows"];
            if (rows) {
                NSLog(@"%@", rows);
               ftPhotoEntryRowID = [(NSString *)((NSArray *)[rows lastObject])[0] intValue];
            }
        }
        [self reloadSection];
    }];
}
- (void)updateLastInsertedRow {
    if (ftPhotoEntryRowID > 0) {
        ftInsertRowState = kFTStateUpdatingRows;
        [self reloadSection];
        
        [[GoogleServicesHelper sharedInstance] incrementNetworkActivityIndicator];
        [self.ftSQLQuery sqlUpdateWithCompletionHandler:^(NSData *data, NSError *error) {
            [[GoogleServicesHelper sharedInstance] decrementNetworkActivityIndicator];
            ftInsertRowState = kFTStateIdle;
            if (error) {
                NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
                [[GoogleServicesHelper sharedInstance]
                        showAlertViewWithTitle:@"Fusion Tables Error"
                        AndText: [NSString stringWithFormat:@"Error updating rows: %@", errorStr]];
            } else {
                NSDictionary *responceDict = [NSJSONSerialization
                                              JSONObjectWithData:data options:kNilOptions error:nil];
                NSArray *rows = responceDict[@"rows"];
                if (rows) {
                    NSUInteger numRowsUpdated = [(NSString *)((NSArray *)[rows lastObject])[0] intValue];
                    NSLog(@"Updated %lu %@", (unsigned long)numRowsUpdated, (numRowsUpdated == 1) ? @"row" : @"rows");
                }
            }
            [self reloadSection];
        }];
    }    
}
- (void)deleteInsertedRows {
    ftInsertRowState = kFTStateDeletingRows;
    [self reloadSection];

    [[GoogleServicesHelper sharedInstance] incrementNetworkActivityIndicator];
    [self.ftSQLQuery sqlDeleteWithCompletionHandler:^(NSData *data, NSError *error) {
        [[GoogleServicesHelper sharedInstance] decrementNetworkActivityIndicator];
        ftInsertRowState = kFTStateIdle;
        if (error) {
            NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
            [[GoogleServicesHelper sharedInstance]
                    showAlertViewWithTitle:@"Fusion Tables Error"
                    AndText: [NSString stringWithFormat:@"Error deleting rows: %@", errorStr]];
            
        } else {
            ftPhotoEntryRowID = 0;
        }
        [self reloadSection];
    }];
}

#pragma mark - helpers
// rotates entry index from sampleUpdateData.plist
- (NSDictionary *)rotatingSampleDataPhotoEntry {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"sampleUpdateData" ofType:@"plist"];
    NSArray *updateEntries = [NSArray arrayWithContentsOfFile:plistPath];    
    NSDictionary *updateEntry = [NSArray arrayWithContentsOfFile:plistPath]
                                                [ftPhotoEntrySampleDataRotatingIdx];        
    if (++ftPhotoEntrySampleDataRotatingIdx >= [updateEntries count]) {
        ftPhotoEntrySampleDataRotatingIdx = 0;
    }
    
    return updateEntry;
}

@end


