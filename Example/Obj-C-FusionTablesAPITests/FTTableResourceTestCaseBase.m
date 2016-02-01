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

//  ObjCFusionTablesFTAPIResourceTests.h
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
 Tests  Obj-C-FusionTables FT API Resources Base Operations
 * Fusion Table: insert, list, delete
 
 Tests creating / lising / deletion of a Fusion Table,
 then restores the tested Google account to its initial state
 ****/


#import "FTTableResourceTestCaseBase.h"

@implementation FTTableResourceTestCaseBase

static NSString *_sFusionTableID;
typedef void(^TableIDProcessingBlock)(NSString *tableID);

#pragma mark - Init
- (FTTable *)ftTableResource {
    if (!_ftTableResource) {
        _ftTableResource = [[FTTable alloc] init];
        _ftTableResource.ftTableDelegate = self;
    }
    return _ftTableResource;
}

#pragma mark -  XCTestCase setup / teardown
- (void)setUp {
    [super setUp];
    
    [self insertTableWithCompletionHandler:^(NSString *tableID) {
        _sFusionTableID = tableID;
    }];    
}
- (void)tearDown {
    [super tearDown];
    [self deleteTableWithCompletionHandler:nil];
}

#pragma mark - Test Fusion Table Insert / Delete Methods
- (void)insertTableWithCompletionHandler:(TableIDProcessingBlock)handler {
    XCTAssertNotNil([self ftName], 
                    @"for Insert Table, the FTDelegate Fusion Table Name the should not be nil");
    XCTAssertNotNil([self ftColumns], 
                    @"for Insert Table, the FTDelegate Fusion Table Columns the should not be nil");
    
    XCTestExpectation *insertTableExpectation = [self expectationWithDescription:@"insertTableWithCompletionHandler"];
    [self.ftTableResource insertFusionTableWithCompletionHandler:^(NSData *data, NSError *error) {
        if (error) {
            NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
            XCTFail (@"Error Inserting Fusion Table: %@", errorStr);
        } else {
            NSDictionary *ftTableDict = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:kNilOptions error:nil];
            if (ftTableDict) {
                XCTAssertNotNil(ftTableDict[@"name"], @"Returned Inserted Fusion Table Name should not be nil");
                XCTAssertNotNil(ftTableDict[@"tableId"], @"Return Inserted Fusion Table IDs should not be nil");
                NSLog(@"Inserted a new Fusion Table: %@", ftTableDict);
                
                if (handler)
                    handler(ftTableDict[@"tableId"]);
            } else {
                XCTFail (@"Error processsing inserted Fusion Table data");
            }
        }
        [insertTableExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}
- (void)deleteTableWithCompletionHandler:(void_completion_handler_block)handler {
    XCTAssertNotNil([self ftTableID], 
                    @"for Delete Table, the FTDelegate Fusion Table ID the should not be nil");
    XCTestExpectation *deleteTableExpectation = [self expectationWithDescription:@"deleteTableWithCompletionHandler"];
    [self.ftTableResource deleteFusionTableWithCompletionHandler:^(NSData *data, NSError *error) {
        if (error) {
            NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
            XCTFail (@"Error Deleting Fusion Table With ID: %@, %@", [self ftTableID], errorStr);
        } else {
            NSLog(@"Deleted Fusion Tables with ID: %@", [self ftTableID]);
            if (handler) handler();
        }
        [deleteTableExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}


#pragma mark - FTDelegate methods
- (NSString *)ftTableID {
    return _sFusionTableID;
}

#define TEST_FUSION_TABLE_PREFIX (@"ObjC-API_Test_FT_")
- (NSString *)ftName {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd-hhmmss"];
    return [NSString stringWithFormat:@"%@%@",
            TEST_FUSION_TABLE_PREFIX, [formatter stringFromDate:[NSDate date]]];
}
#undef TEST_FUSION_TABLE_PREFIX

#pragma mark - Test Fusion Table Columns Definition
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

@end
