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

//  FTResourceTestBase.m
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    Base class for  Obj-C-FusionTables Tests
****/

#import "FTResourceTestBase.h"

@implementation FTResourceTestBase

#pragma mark - Init
- (FTTable *)ftTableResource {
    if (!_ftTableResource) {
        _ftTableResource = [[FTTable alloc] init];
        _ftTableResource.ftTableDelegate = self;
    }
    return _ftTableResource;
}

#pragma mark - setup / cleanup
- (void)setUp {
    [super setUp]; 
    [self checkGoogleConnection];
}
- (void)tearDown {
    [super tearDown];
}

#pragma mark - Helper Methods
// waits for the semaphore, allowing the tests run their network ops code
- (void)waitForSemaphore:(dispatch_semaphore_t)semaphore WithTimeout:(NSTimeInterval)timeoutInSeconds {
    NSDate *giveUpDate = [NSDate dateWithTimeIntervalSinceNow:timeoutInSeconds];
    BOOL isMainThread = [NSThread isMainThread];
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW) && [giveUpDate timeIntervalSinceNow] > 0) {
        if (isMainThread) {
            [[NSRunLoop currentRunLoop] 
             runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
        } else {
            [NSThread sleepForTimeInterval:0.01];
        }
    }    
}
// Checks Google Auth status, attemps to connect if needed
- (void)checkGoogleConnection {
    if ([[GoogleAuthorizationController sharedInstance] isAuthorised]) {
        NSLog(@"connected to Google with userID: %@", 
              [[GoogleAuthorizationController sharedInstance] authenticatedUserID]);
    } else {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);    
        [[GoogleAuthorizationController sharedInstance] signInToGoogleWithCompletionHandler:^{
            NSLog(@"connected to Google with userID: %@", 
                  [[GoogleAuthorizationController sharedInstance] authenticatedUserID]);
            dispatch_semaphore_signal(semaphore);
        } CancelHandler:^{
            STFail(@"failed connect to Google");
            dispatch_semaphore_signal(semaphore);
        }];   
        [self waitForSemaphore:semaphore WithTimeout:10];
    }
    STAssertNotNil([[GoogleAuthorizationController sharedInstance] 
                    authenticatedUserID], 
                   @"authenticatedUserID should not be nil");
}

#pragma mark - Test Fusion Table Methods
- (void)insertTestTableWithCompletionHandler:(TableIDProcessingBlock)handler {
    STAssertNotNil([self ftName], 
                   @"for Insert Table, the FTDelegate Fusion Table Name the should not be nil");
    STAssertNotNil([self ftColumns], 
                   @"for Insert Table, the FTDelegate Fusion Table Columns the should not be nil");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [self.ftTableResource insertFusionTableWithCompletionHandler:^(NSData *data, NSError *error) {
        dispatch_semaphore_signal(semaphore);
        if (error) {
            NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
            STFail (@"Error Inserting Fusion Table: %@", errorStr);
        } else {
            NSDictionary *ftTableDict = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:kNilOptions error:nil];
            if (ftTableDict) {
                STAssertNotNil(ftTableDict[@"name"], @"Returned Inserted Fusion Table Name should not be nil");
                STAssertNotNil(ftTableDict[@"tableId"], @"Return Inserted Fusion Table IDs should not be nil");
                NSLog(@"Inserted a new Fusion Table: %@", ftTableDict);

                if (handler)handler(ftTableDict[@"tableId"]);
            } else {
                STFail (@"Error processsing inserted Fusion Table data");
            }
        }
    }];    
    [self waitForSemaphore:semaphore WithTimeout:10];
}
- (void)deleteTestTableWithCompletionHandler:(void_completion_handler_block)handler {
    STAssertNotNil([self ftTableID], 
                   @"for Delete Table, the FTDelegate Fusion Table ID the should not be nil");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);    
    [self.ftTableResource deleteFusionTableWithCompletionHandler:^(NSData *data, NSError *error) {
        dispatch_semaphore_signal(semaphore);
        if (error) {
            NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
            STFail (@"Error Deleting Fusion Table With ID: %@, %@", [self ftTableID], errorStr);
        } else {
            NSLog(@"Deleted Fusion Tables with ID: %@", [self ftTableID]);
            if (handler) handler();
        }
    }];
    [self waitForSemaphore:semaphore WithTimeout:10];
}


#pragma mark - FTDelegate methods
#define TEST_FUSION_TABLE_PREFIX (@"ObjC-API_Test_FT_")
- (NSString *)ftName {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd-hhmmss"];
    return [NSString stringWithFormat:@"%@%@",
            TEST_FUSION_TABLE_PREFIX, [formatter stringFromDate:[NSDate date]]];
}
#undef TEST_FUSION_TABLE_PREFIX
// Test Fusion Table Columns Definition
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
