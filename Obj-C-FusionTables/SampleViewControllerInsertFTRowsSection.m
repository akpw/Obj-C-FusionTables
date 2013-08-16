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

/****
    Shows usage of Obj-C-FusionTables for Fusion Tables rows operations
****/

#import "SampleViewControllerInsertFTRowsSection.h"
#import "FTSQLQuery.h"
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
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    UIButton *actionButton = [self ftActionButton];
    cell.accessoryView = actionButton;
    
    if (![self isSampleAppFusionTable]) {
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
            [actionButton.layer setValue:@(kFTActionInsert) forKey:FT_ACTION_TYPE_KEY];
            if (lastInsertedRowID > 0) {
                cell.accessoryView = nil;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
        case kSampleViewControllerFTUpdateRowSection:
        {
            cell.textLabel.text = @"Update last sample row";
            [actionButton.layer setValue:@(kFTActionUpdate) forKey:FT_ACTION_TYPE_KEY];
            if (lastInsertedRowID == 0) {
                cell.userInteractionEnabled = NO;
                cell.backgroundColor = [UIColor clearColor];
            }
            break;
        }
        case kSampleViewControllerFTDeleteRowSection:
        {
            cell.textLabel.text = @"Delete sample rows";
            [actionButton.layer setValue:@(kFTActionDelete) forKey:FT_ACTION_TYPE_KEY];
            if (lastInsertedRowID == 0) {
                cell.userInteractionEnabled = NO;
                cell.backgroundColor = [UIColor clearColor];
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
        footerString =  @"For rows operations, please choose\n"
                        "a Fusion Table created with this App";
    }
    return footerString;
}
- (CGFloat)heightForFooterInSection {
    return ([self isSampleAppFusionTable]) ? 40.0f : 60.0f;
}
- (float)heightForRow:(NSInteger)row {
    return 36.0f;
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
#pragma mark - Insert Sample Rows Handler
- (void)insertSampleRows {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"sampleInsertData" ofType:@"plist"];
    NSArray *insertArray = [NSArray arrayWithContentsOfFile:plistPath];
    
    NSString *ftInsertString = nil;
    FTSQLQuery *ftResource = [[FTSQLQuery alloc] init];
    for (NSDictionary *insertEntry in insertArray) {
        NSString *lineColor = [ftResource buildFTStringValueString:insertEntry[@"lineColor"]];
        NSString *insertEntryString = [ftResource
                                                builSQLInsertStringForColumnNames:[self columnNames]
                                                FTTableID:[self ftTableID],
                  [ftResource buildFTStringValueString:insertEntry[@"entryDate"]],
                  [ftResource buildFTStringValueString:insertEntry[@"entryName"]],
                  [ftResource buildFTStringValueString:insertEntry[@"entryThumbImageURL"]],
                  [ftResource buildFTStringValueString:insertEntry[@"entryURL"]],
                  [ftResource buildFTStringValueString:insertEntry[@"entryURLDescription"]],
                  [ftResource buildFTStringValueString:insertEntry[@"entryNote"]],
                  [ftResource buildFTStringValueString:insertEntry[@"entryImageURL"]],
                  [ftResource buildFTStringValueString:insertEntry[@"markerIcon"]],
                  lineColor,
                  ([lineColor length] > 2) ?  // a quick & dirty way to insert different KML item types
                      [ftResource buildKMLLineString:insertEntry[@"geometry"]] :
                      [ftResource buildKMLPointString:insertEntry[@"geometry"]]
                 ];
        ftInsertString = (ftInsertString) ?
                [NSString stringWithFormat:@"%@;%@", ftInsertString, insertEntryString] :
                insertEntryString;
    }
    
    ftInsertRowState = kFTStateInsertingRows;
    lastInsertedRowID = 0;
    [self reloadSection];
    
    [[SimpleGoogleServiceHelpers sharedInstance] incrementNetworkActivityIndicator];
    [ftResource modifyFusionTablesSQL:ftInsertString WithCompletionHandler:^(NSData *data, NSError *error) {
        [[SimpleGoogleServiceHelpers sharedInstance] decrementNetworkActivityIndicator];
        ftInsertRowState = kFTStateIdle;
        if (error) {
            NSData *data = [[error userInfo] valueForKey:@"data"];
            NSString *infoString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [[SimpleGoogleServiceHelpers sharedInstance]
                    showAlertViewWithTitle:@"Fusion Tables Error"
                    AndText: [NSString stringWithFormat:@"Error inserting Rows: %@", infoString]];
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
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"sampleUpdateData" ofType:@"plist"];
    NSArray *updatetArray = [NSArray arrayWithContentsOfFile:plistPath];
    FTSQLQuery *ftResource = [[FTSQLQuery alloc] init];
    if (lastInsertedRowID > 0 && [updatetArray count] > 0) {
        NSDictionary *updateEntry = updatetArray[sampleUpdateDataIndex];
        NSString *ftUpdateEntryString = [ftResource builSQLUpdateStringForRowID:lastInsertedRowID
                                                    ColumnNames:[self columnNames]
                           FTTableID:[self ftTableID],
                           [ftResource buildFTStringValueString:updateEntry[@"entryDate"]],
                           [ftResource buildFTStringValueString:updateEntry[@"entryName"]],
                           [ftResource buildFTStringValueString:updateEntry[@"entryThumbImageURL"]],
                           [ftResource buildFTStringValueString:updateEntry[@"entryURL"]],
                           [ftResource buildFTStringValueString:updateEntry[@"entryURLDescription"]],
                           [ftResource buildFTStringValueString:updateEntry[@"entryNote"]],
                           [ftResource buildFTStringValueString:updateEntry[@"entryImageURL"]],
                           [ftResource buildFTStringValueString:updateEntry[@"markerIcon"]],
                           [ftResource buildFTStringValueString:updateEntry[@"lineColor"]],
                           [ftResource buildKMLPointString:updateEntry[@"geometry"]]
                           ];
        ftInsertRowState = kFTStateUpdatingRows;
        [self reloadSection];
        
        [[SimpleGoogleServiceHelpers sharedInstance] incrementNetworkActivityIndicator];
        [ftResource modifyFusionTablesSQL:ftUpdateEntryString WithCompletionHandler:^(NSData *data, NSError *error) {
            [[SimpleGoogleServiceHelpers sharedInstance] decrementNetworkActivityIndicator];
            ftInsertRowState = kFTStateIdle;
            if (error) {
                NSData *data = [[error userInfo] valueForKey:@"data"];
                NSString *infoString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [[SimpleGoogleServiceHelpers sharedInstance]
                        showAlertViewWithTitle:@"Fusion Tables Error"
                        AndText: [NSString stringWithFormat:@"Error updating rows: %@", infoString]];
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
- (void)deleteInsertedRows {
    FTSQLQuery *ftResource = [[FTSQLQuery alloc] init];
    NSString *ftDeleteString = [ftResource buildDeleteAllRowStringForFusionTableID:[self ftTableID]];
    
    ftInsertRowState = kFTStateDeletingRows;
    [self reloadSection];

    [[SimpleGoogleServiceHelpers sharedInstance] incrementNetworkActivityIndicator];
    [ftResource modifyFusionTablesSQL:ftDeleteString WithCompletionHandler:^(NSData *data, NSError *error) {
        [[SimpleGoogleServiceHelpers sharedInstance] decrementNetworkActivityIndicator];
        ftInsertRowState = kFTStateIdle;
        if (error) {
            NSData *data = [[error userInfo] valueForKey:@"data"];
            NSString *infoString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [[SimpleGoogleServiceHelpers sharedInstance]
                    showAlertViewWithTitle:@"Fusion Tables Error"
                    AndText: [NSString stringWithFormat:@"Error deleting rows: %@", infoString]];
            
        } else {
            lastInsertedRowID = 0;
        }
        [self reloadSection];
    }];
}



@end


