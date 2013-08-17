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

//  ObjCFusionTablesSQLQueryTests.m
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    Tests  Obj-C-FusionTables SQL Query Resources Base Operations
 
    The test cases goes sequentially from creating a table
    through inserting/updating/deleting rows to restoring 
    the tested Google account to its initial state
****/


#import "ObjCFusionTablesSQLQueryResourceTests.h"
#import "FTSQLQueryBuilder.h"

static NSString *_sFusionTableID;
static NSUInteger _lastInsertedRowID;

@implementation ObjCFusionTablesSQLQueryResourceTests

#pragma mark - Initialization
- (FTSQLQuery *)ftSQLQuery {
    if (!_ftSQLQuery) {
        _ftSQLQuery = [[FTSQLQuery alloc] init];
        _ftSQLQuery.ftSQLQueryDelegate = self;
    }
    return _ftSQLQuery;
}

#pragma mark Fusion Tables - Inserts Sample Table Test
- (void)testObjCFusionTables_000_InsertTable {
    [self insertTestTableWithCompletionHandler:^(NSString *tableID) {
        _sFusionTableID = tableID;
    }];
}

#pragma mark - Insert Sample Rows Test
- (void)testObjCFusionTables_010_InsertSampleRows {   
    STAssertNotNil([self ftSQLInsertStatement], 
                   @"for Insert Rows, the FTSQLQueryDelegate SQL Insert Statement should not be nil");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [self.ftSQLQuery sqlInsertWithCompletionHandler:^(NSData *data, NSError *error) {
        dispatch_semaphore_signal(semaphore);
        if (error) {
            NSData *data = [[error userInfo] valueForKey:@"data"];
            NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            STFail (@"Error Inserting Fusion Table Style: %@", errorStr);
        } else {
            NSDictionary *responceDict = [NSJSONSerialization
                                          JSONObjectWithData:data options:kNilOptions error:nil];
            NSArray *rows = responceDict[@"rows"];
            if (rows) {
                NSLog(@"%@", rows);
                _lastInsertedRowID = [(NSString *)((NSArray *)[rows lastObject])[0] intValue];
                STAssertTrue(_lastInsertedRowID > 0, @"Last inserted row ID should not be 0");
                NSLog(@"Inserted %d %@", [rows count], ([rows count] == 1) ? @"row" : @"rows");
            } else {
                STFail (@"Error processing Insert Rows responce");                
            }
        }
    }];
    [self waitForSemaphore:semaphore WithTimeout:10];
}

#pragma mark - Update Last Inserted Row Test
- (void)testObjCFusionTables_011_UpdateLastInsertedRow {
    STAssertNotNil([self ftSQLUpdateStatement], 
                   @"for Update Rows, the FTSQLQueryDelegate SQL Update Statement should not be nil");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    if (_lastInsertedRowID > 0) {
        [self.ftSQLQuery sqlUpdateWithCompletionHandler:^(NSData *data, NSError *error) {
            dispatch_semaphore_signal(semaphore);
            if (error) {
                NSData *data = [[error userInfo] valueForKey:@"data"];
                NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                STFail (@"Error Updating Fusion Table Style: %@", errorStr);                
            } else {
                NSDictionary *responceDict = [NSJSONSerialization
                                              JSONObjectWithData:data options:kNilOptions error:nil];
                NSArray *rows = responceDict[@"rows"];
                if (rows) {
                    NSUInteger numRowsUpdated = [(NSString *)((NSArray *)[rows lastObject])[0] intValue];
                    STAssertTrue(numRowsUpdated > 0, @"Number of update rows should not be 0");
                    NSLog(@"Updated %d %@", numRowsUpdated, (numRowsUpdated == 1) ? @"row" : @"rows");
                } else {
                    STFail (@"Error processing Update Rows responce");                
                }
            }
        }];
    }    
    [self waitForSemaphore:semaphore WithTimeout:10];
}

#pragma mark - Delete All Rows Test
- (void)testObjCFusionTables_012_DeleteInsertedRows {
    STAssertNotNil([self ftSQLDeleteStatement], 
                   @"for Delete Rows, the FTSQLQueryDelegate SQL Delete Statement should not be nil");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [self.ftSQLQuery sqlDeleteWithCompletionHandler:^(NSData *data, NSError *error) {
        dispatch_semaphore_signal(semaphore);
        if (error) {
            NSData *data = [[error userInfo] valueForKey:@"data"];
            NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            STFail (@"Error Inserting Fusion Table Style: %@", errorStr);            
        } else {
            NSDictionary *responceDict = [NSJSONSerialization
                                          JSONObjectWithData:data options:kNilOptions error:nil];
            NSArray *rows = responceDict[@"rows"];
            if (rows) {
                NSUInteger numRowsDeleted = [(NSString *)((NSArray *)[rows lastObject])[0] intValue];
                STAssertTrue(numRowsDeleted > 0, @"Number of deleted rows should not be 0");
                NSLog(@"Deleted %d %@", numRowsDeleted, (numRowsDeleted == 1) ? @"row" : @"rows");
            } else {
                STFail (@"Error processing Delete Rows responce");                
            }
        }
    }];
    [self waitForSemaphore:semaphore WithTimeout:10];
}

- (void)testObjCFusionTables_022_DeleteTable {
    [self deleteTestTableWithCompletionHandler:nil];
}

#pragma mark - FTDelegate methods
- (NSString *)ftTableID {
    return _sFusionTableID;
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
    
    NSDictionary *updateEntry = updatetArray[0];
    NSString *ftSQLUpdateStatementString = [FTSQLQueryBuilder 
                                            builSQLUpdateStringForRowID:_lastInsertedRowID
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

@end
