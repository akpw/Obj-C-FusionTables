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
#import <QuartzCore/QuartzCore.h>

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

// Sample data for update
// updates a route photo, on rotating basis
typedef NS_ENUM (NSUInteger, FTSampleUpdateDataIndex) {
    kFTSampleUpdateData_idx0 = 0,
    kFTSampleUpdateData_idx1,
    kFTSampleUpdateData_idx2,
    kFTSampleUpdateDataCount
};

@interface SampleViewControllerInsertFTRowsSection ()
    @property (nonatomic, strong) FTSQLQuery *ftSQLQuery;
@end

@implementation SampleViewControllerInsertFTRowsSection {
    FTSQLQueryStates ftInsertRowState;
    NSUInteger lastInsertedRowID;
    FTSampleUpdateDataIndex sampleUpdateDataIndex;
}

#pragma mark - GroupedTableSectionsController Table View Data Source
#pragma mark - Initialisation
- (void)initSpecifics {
    ftInsertRowState = kFTStateIdle;
    lastInsertedRowID = 0;
    sampleUpdateDataIndex = kFTSampleUpdateData_idx0;
    
    [super initSpecifics];
}
- (FTSQLQuery *)ftSQLQuery {
    if (!_ftSQLQuery) {
        _ftSQLQuery = [[FTSQLQuery alloc] init];
        _ftSQLQuery.ftSQLQueryDelegate = self;
    }
    return _ftSQLQuery;
}

- (NSUInteger)numberOfRows {
    return SampleViewControllerFTInsertSectionNumRows;
}

#pragma mark - GroupedTableSectionsController Table View Data Source
#define FT_ACTION_TYPE_KEY (@"FT_Action_Type_Key")
enum FTActionTypes {
    kFTActionInsert = 0,
    kFTActionUpdate,
    kFTActionDelete
};
- (void)configureCell:(UITableViewCell *)cell ForRow:(NSUInteger)row {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = ([self isSampleAppFusionTable]) ? 
                [UIFont systemFontOfSize:16] : [UIFont systemFontOfSize:14];
    
    UIButton *actionButton = [self ftActionButton];
    cell.accessoryView = actionButton;
    if (![self isSampleAppFusionTable]) {
        cell.accessoryView = nil;
        cell.userInteractionEnabled = NO;
        cell.backgroundColor = [UIColor clearColor];
    } else {    
        cell.userInteractionEnabled = YES;
        cell.backgroundColor = [UIColor whiteColor];
    }
    switch (row) {
        case kSampleViewControllerFTInsertRowSection:
        {
            cell.textLabel.text = @"Insert sample rows";
            if (lastInsertedRowID > 0) {
                cell.accessoryView = nil;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                [actionButton.layer setValue:@(kFTActionInsert) forKey:FT_ACTION_TYPE_KEY];                
            }
            break;
        }
        case kSampleViewControllerFTUpdateRowSection:
        {
            cell.textLabel.text = @"Update last sample row";
            if (lastInsertedRowID == 0) {
                cell.accessoryView = nil;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.userInteractionEnabled = NO;
            } else {
                [actionButton.layer setValue:@(kFTActionUpdate) forKey:FT_ACTION_TYPE_KEY];
            }
            break;
        }
        case kSampleViewControllerFTDeleteRowSection:
        {
            cell.textLabel.text = @"Delete sample rows";
            if (lastInsertedRowID == 0) {
                cell.accessoryView = nil;
                cell.userInteractionEnabled = NO;
                cell.accessoryType = UITableViewCellAccessoryNone;
            } else {
                [actionButton.layer setValue:@(kFTActionDelete) forKey:FT_ACTION_TYPE_KEY];                
            }
            break;
        }
        default:
            break;
    }
}
- (void)executeFTAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSNumber *actionType =  (NSNumber *)[button.layer valueForKey:FT_ACTION_TYPE_KEY];
    switch ([actionType integerValue]) {
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
#undef FT_ACTION_TYPE_KEY

#pragma mark - GroupedTableSectionsController Table View Delegate
- (NSString *)titleForFooterInSection {
    NSString *footerString = nil;
    if ([self isSampleAppFusionTable]) {
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
    } else {
        footerString =  @"To enable rows operations, choose\n"
                        "a Fusion Table created with this App";
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
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"sampleUpdateData" ofType:@"plist"];
    NSArray *updatetArray = [NSArray arrayWithContentsOfFile:plistPath];

    NSDictionary *updateEntry = updatetArray[sampleUpdateDataIndex];
    NSString *ftSQLUpdateStatementString = [FTSQLQueryBuilder 
                                        builSQLUpdateStringForRowID:lastInsertedRowID
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

#pragma mark - Insert Sample Rows Handler
- (void)insertSampleRows {   
    ftInsertRowState = kFTStateInsertingRows;
    lastInsertedRowID = 0;
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
               lastInsertedRowID = [(NSString *)((NSArray *)[rows lastObject])[0] intValue];
            }
        }
        [self reloadSection];
    }];
}

#pragma mark - Update Last Inserted Row Handler
// rotates entry index from sampleUpdateData.plist
- (void)rotateSampleUpdateDataIndex {
    sampleUpdateDataIndex++;
    if (sampleUpdateDataIndex + 1 == kFTSampleUpdateDataCount) {
        sampleUpdateDataIndex = kFTSampleUpdateData_idx0;
    }
}
- (void)updateLastInsertedRow {
    if (lastInsertedRowID > 0) {
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
                [self rotateSampleUpdateDataIndex];
                
                NSDictionary *responceDict = [NSJSONSerialization
                                              JSONObjectWithData:data options:kNilOptions error:nil];
                NSArray *rows = responceDict[@"rows"];
                if (rows) {
                    NSUInteger numRowsUpdated = [(NSString *)((NSArray *)[rows lastObject])[0] intValue];
                    NSLog(@"Updated %d %@", numRowsUpdated, (numRowsUpdated == 1) ? @"row" : @"rows");
                }
            }
            [self reloadSection];
        }];
    }    
}

#pragma mark - Delete All Rows Handler
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
            lastInsertedRowID = 0;
        }
        [self reloadSection];
    }];
}

@end


