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

//  ObjCFTAPIResourceTableTests.h
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
 Tests  Obj-C-FusionTables FT API Resources Base Operations
 * Fusion Table Styles: insert, list, delete
  
 Tests creating / lising / deletion of a Fusion Table Style,
 then restores the tested Google account to its initial state
 ****/

#import "FTTableResourceTestCaseBase.h"
#import "FTStyle.h"

@interface ObjCFTAPIResourceStyleTests : FTTableResourceTestCaseBase <FTStyleDelegate>
    @property (nonatomic, strong) FTStyle *ftStyleResource;
@end

static NSString *_sFusionTableStyleID;

@implementation ObjCFTAPIResourceStyleTests

#pragma mark - Initialization
- (FTStyle *)ftStyleResource {
    if (!_ftStyleResource) {
        _ftStyleResource = [[FTStyle alloc] init];
        _ftStyleResource.ftStyleDelegate = self;
    }
    return _ftStyleResource;
}

#pragma mark -  XCTestCase setup / teardown
- (void)setUp {
    [super setUp];
    [self insertStyle];
}
- (void)tearDown {
    [self deleteStyle];
    [super tearDown];
}

#pragma mark -  XCTestCases
- (void)testListStyles {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);    
    [self.ftStyleResource lisFTStylesWithCompletionHandler: ^(NSData *data, NSError *error) {
        dispatch_semaphore_signal(semaphore);
        if (error) {
            NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
            XCTFail (@"Error Fetching Fusion Table Styles: %@", errorStr);
        } else {
            NSDictionary *ftItems = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:kNilOptions error:nil];       
            NSArray *ftStylebjects = [NSMutableArray arrayWithArray:ftItems[@"items"]];
            XCTAssertNotNil(ftStylebjects, @"Listing Styles should return at least one test style");
            NSLog(@"Fusion Tables Styles: %@", ftStylebjects);
            for (NSDictionary *ftTableStyle in ftStylebjects) {
                XCTAssertNotNil(ftTableStyle[@"styleId"], @"Loaded Fusion Table Style should not be nil");
            }
        }
    }];
    [self waitForSemaphore:semaphore WithTimeout:10];
}

#pragma mark - Test Fusion TableStyle  Insert / Delete Methods
- (void)insertStyle {
    XCTAssertNotNil([self ftTableID], 
                    @"for Insert Style, the FTStyleDelegate Fusion Table ID the should not be nil");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [self.ftStyleResource insertFTStyleWithCompletionHandler:^(NSData *data, NSError *error) {
        dispatch_semaphore_signal(semaphore);
        if (error) {
            NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
            XCTFail (@"Error Inserting Fusion Table Style: %@", errorStr);
        } else {
            NSDictionary *ftStyleDict = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:kNilOptions error:nil];
            if (ftStyleDict) {
                XCTAssertNotNil(ftStyleDict[@"styleId"],
                                @"Returned Inserted Fusion Table Style ID should not be nil");  
                _sFusionTableStyleID = ftStyleDict[@"styleId"];
                NSLog(@"Inserted a new Fusion Table Style: %@", ftStyleDict);
            } else {
                XCTFail (@"Error processsing inserted Fusion Table Style data");
            }
        }
    }];
    [self waitForSemaphore:semaphore WithTimeout:10];
}
- (void)deleteStyle {
    XCTAssertNotNil([self ftTableID], 
                    @"for Delete Style, the FTStyleDelegate Fusion Table ID the should not be nil");
    XCTAssertNotNil([self ftStyleID], 
                    @"for Delete Style, the FTStyleDelegate Style ID the should not be nil");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);    
    [self.ftStyleResource deleteFTStyleWithCompletionHandler:^(NSData *data, NSError *error) {
        dispatch_semaphore_signal(semaphore);
        if (error) {
            NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
            XCTFail (@"Error Deleting Fusion Table Style With ID: %@, %@", [self ftStyleID], errorStr);
        } else {
            NSLog(@"Deleted Fusion Table Style with ID: %@", [self ftStyleID]);
        }
    }];
    [self waitForSemaphore:semaphore WithTimeout:10];
}

#pragma mark - FTStyleDelegate methods
- (NSString *)ftStyleID {
    return _sFusionTableStyleID;
}
- (NSDictionary *)ftMarkerOptions {
    return @{
             @"iconStyler": @{
                     @"kind": @"fusiontables#fromColumn",
                     @"columnName": @"markerIcon"}
             };
}
- (NSDictionary *)ftPolylineOptions {
    return @{
             @"strokeWeight" : @"4",
             @"strokeColorStyler" : @{
                     @"kind": @"fusiontables#fromColumn",
                     @"columnName": @"lineColor"}
             };
}


@end
