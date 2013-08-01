//
//  SampleViewControllerInsertFTRowsSection.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 19/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "SampleViewControllerInsertFTRowsSection.h"
#import <QuartzCore/QuartzCore.h>
#import "AppGeneralServicesController.h"
#import "SampleFTQueryBuilder.h"
#import "FTResource.h"

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
// updates a route photo, rotating basis
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
    
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.userInteractionEnabled = NO;
    
    switch (row) {
        case kSampleViewControllerFTInsertRowSection:
        {
            cell.textLabel.text = @"Insert FT Rows";
            [actionButton.layer setValue:@(kFTActionInsert) forKey:FT_ACTION_TYPE_KEY];
            if (self.fusionTableID) {
                cell.backgroundColor = [UIColor whiteColor];
                cell.userInteractionEnabled = YES;
            }
            if (lastInsertedRowID > 0) {
                cell.accessoryView = nil;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
        case kSampleViewControllerFTUpdateRowSection:
        {
            cell.textLabel.text = @"Update FT Last Row";
            [actionButton.layer setValue:@(kFTActionUpdate) forKey:FT_ACTION_TYPE_KEY];
            if (lastInsertedRowID > 0) {
                cell.userInteractionEnabled = YES;
                cell.backgroundColor = [UIColor whiteColor];
            }
            break;
        }
        case kSampleViewControllerFTDeleteRowSection:
        {
            cell.textLabel.text = @"Delete FT Rows";
            [actionButton.layer setValue:@(kFTActionDelete) forKey:FT_ACTION_TYPE_KEY];
            if (lastInsertedRowID > 0) {
                cell.userInteractionEnabled = YES;
                cell.backgroundColor = [UIColor whiteColor];
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
    if (self.fusionTableID) {
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
        footerString = @"Create Table before SQL rows ops";
    }
    return footerString;
}
- (CGFloat)heightForFooterInSection {
    return 40.0f;
}
- (float)heightForRow:(NSInteger)row {
    return 36.0f;
}

#pragma mark - FT Action Handlers
#pragma mark - Insert Sample Rows Handler
- (void)insertSampleRows {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"sampleInsertData" ofType:@"plist"];
    NSArray *insertArray = [NSArray arrayWithContentsOfFile:plistPath];
    
    NSString *ftInsertString = nil;
    for (NSDictionary *insertEntry in insertArray) {
        NSString *lineColor = [SampleFTQueryBuilder buildFTStringValueString:insertEntry[@"lineColor"]];
        NSString *insertEntryString = [SampleFTQueryBuilder builSQLInsertStringForFTTableID:
                  self.fusionTableID,
                  [SampleFTQueryBuilder buildFTStringValueString:insertEntry[@"entryDate"]],
                  [SampleFTQueryBuilder buildFTStringValueString:insertEntry[@"entryName"]],
                  [SampleFTQueryBuilder buildFTStringValueString:insertEntry[@"entryThumbImageURL"]],
                  [SampleFTQueryBuilder buildFTStringValueString:insertEntry[@"entryURL"]],
                  [SampleFTQueryBuilder buildFTStringValueString:insertEntry[@"entryURLDescription"]],
                  [SampleFTQueryBuilder buildFTStringValueString:insertEntry[@"entryNote"]],
                  [SampleFTQueryBuilder buildFTStringValueString:insertEntry[@"entryImageURL"]],
                  [SampleFTQueryBuilder buildFTStringValueString:insertEntry[@"markerIcon"]],
                  lineColor,
                  ([lineColor length] > 2) ?  // a quick & dirty way to insert different KML item types
                      [SampleFTQueryBuilder buildKMLLineString:insertEntry[@"geometry"]] :
                      [SampleFTQueryBuilder buildKMLPointString:insertEntry[@"geometry"]]
                 ];
        ftInsertString = (ftInsertString) ?
                [NSString stringWithFormat:@"%@;%@", ftInsertString, insertEntryString] :
                insertEntryString;
    }
    
    ftInsertRowState = kFTStateInsertingRows;
    lastInsertedRowID = 0;
    [self reloadSection];
    
    FTResource *ftResource = [[FTResource alloc] init];
    [[AppGeneralServicesController sharedInstance] incrementNetworkActivityIndicator];
    [ftResource modifyFusionTablesSQL:ftInsertString WithCompletionHandler:^(NSData *data, NSError *error) {
        [[AppGeneralServicesController sharedInstance] decrementNetworkActivityIndicator];
        ftInsertRowState = kFTStateIdle;
        if (error) {
            NSData *data = [[error userInfo] valueForKey:@"data"];
            NSString *infoString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [[AppGeneralServicesController sharedInstance]
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
    if (lastInsertedRowID > 0 && [updatetArray count] > 0) {
        NSDictionary *updateEntry = updatetArray[sampleUpdateDataIndex];
        NSString *ftUpdateEntryString = [SampleFTQueryBuilder builSQLUpdateStringForRowID:lastInsertedRowID
                           FTTableID:self.fusionTableID,
                           [SampleFTQueryBuilder buildFTStringValueString:updateEntry[@"entryDate"]],
                           [SampleFTQueryBuilder buildFTStringValueString:updateEntry[@"entryName"]],
                           [SampleFTQueryBuilder buildFTStringValueString:updateEntry[@"entryThumbImageURL"]],
                           [SampleFTQueryBuilder buildFTStringValueString:updateEntry[@"entryURL"]],
                           [SampleFTQueryBuilder buildFTStringValueString:updateEntry[@"entryURLDescription"]],
                           [SampleFTQueryBuilder buildFTStringValueString:updateEntry[@"entryNote"]],
                           [SampleFTQueryBuilder buildFTStringValueString:updateEntry[@"entryImageURL"]],
                           [SampleFTQueryBuilder buildFTStringValueString:updateEntry[@"markerIcon"]],
                           [SampleFTQueryBuilder buildFTStringValueString:updateEntry[@"lineColor"]],
                           [SampleFTQueryBuilder buildKMLPointString:updateEntry[@"geometry"]]
                           ];
        ftInsertRowState = kFTStateUpdatingRows;
        [self reloadSection];
        
        FTResource *ftResource = [[FTResource alloc] init];
        [[AppGeneralServicesController sharedInstance] incrementNetworkActivityIndicator];
        [ftResource modifyFusionTablesSQL:ftUpdateEntryString WithCompletionHandler:^(NSData *data, NSError *error) {
            [[AppGeneralServicesController sharedInstance] decrementNetworkActivityIndicator];
            ftInsertRowState = kFTStateIdle;
            if (error) {
                NSData *data = [[error userInfo] valueForKey:@"data"];
                NSString *infoString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [[AppGeneralServicesController sharedInstance]
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
    NSString *ftDeleteString = [SampleFTQueryBuilder buildDeleteAllRowStringForFusionTableID:self.fusionTableID];
    
    ftInsertRowState = kFTStateDeletingRows;
    [self reloadSection];

    [[AppGeneralServicesController sharedInstance] incrementNetworkActivityIndicator];
    FTResource *ftResource = [[FTResource alloc] init];
    [ftResource modifyFusionTablesSQL:ftDeleteString WithCompletionHandler:^(NSData *data, NSError *error) {
        [[AppGeneralServicesController sharedInstance] decrementNetworkActivityIndicator];
        ftInsertRowState = kFTStateIdle;
        if (error) {
            NSData *data = [[error userInfo] valueForKey:@"data"];
            NSString *infoString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [[AppGeneralServicesController sharedInstance]
                    showAlertViewWithTitle:@"Fusion Tables Error"
                    AndText: [NSString stringWithFormat:@"Error deleting rows: %@", infoString]];
            
        } else {
            lastInsertedRowID = 0;
        }
        [self reloadSection];
    }];
}



@end



/*
 
 
 // Current Date Value
 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
 [formatter setDateFormat:@"dd MMM, yyyy h:mm a"];
 NSString *dateString = [formatter stringFromDate:[NSDate date]];
 
 
*/
