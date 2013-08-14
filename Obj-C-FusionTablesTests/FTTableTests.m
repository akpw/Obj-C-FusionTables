//
//  FTTableTests.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 12/8/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "FTTableTests.h"
#import "GoogleAuthorizationController.h"

static NSString *_sFusionTableID;

@implementation FTTableTests 

- (void)setUp {
    [super setUp]; 
    [self checkGoogleConnection];
}
- (void)tearDown {
    [super tearDown];
}

#pragma mark - FTDelegate methods
- (NSString *)ftTableID {
    return _sFusionTableID;
}

#pragma mark Fusion Table Insert Test
- (void)testObjCFusionTables_00_Insert {
    STAssertNotNil([self ftTitle], @"for Insert, the FTDelegate Fusion Table Name the should not be nil");
    STAssertNotNil([self ftColumns], @"for Delete, the FTDelegate Fusion Table Columns the should not be nil");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [self.ftTableResource insertFusionTableWithCompletionHandler:^(NSData *data, NSError *error) {
        dispatch_semaphore_signal(semaphore);
        if (error) {
            NSData *data = [[error userInfo] valueForKey:@"data"];            
            NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];                
            STFail (@"Error Inserting Fusion Table: %@", errorStr);
        } else {
            NSDictionary *ftTableDict = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:kNilOptions error:nil];
            if (ftTableDict) {
                NSLog(@"Inserted a new Fusion Table: %@", ftTableDict);
                STAssertNotNil(ftTableDict[@"name"], @"Returned Inserted Fusion Table Name should not be nil");
                STAssertNotNil(ftTableDict[@"tableId"], @"Return Inserted Fusion Table IDs should not be nil");
                _sFusionTableID = ftTableDict[@"tableId"];
            } else {
                STFail (@"Error processsing inserted Fusion Table data");
            }
        }
    }];    
    [self waitForSemaphore:semaphore WithTimeout:10];
}


#pragma mark Fusion Tables Load Test
- (void)testObjCFusionTables_01_LoadList {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);    
    [self.ftTableResource listFusionTablesWithCompletionHandler: ^(NSData *data, NSError *error) {
        dispatch_semaphore_signal(semaphore);
        if (error) {
            NSData *data = [[error userInfo] valueForKey:@"data"];
            NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            STFail (@"Error Fetching Fusion Tables: %@", errorStr);
        } else {
            NSDictionary *lines = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions error:nil];            
            NSArray *ftTableObjects = [NSMutableArray arrayWithArray:lines[@"items"]];
            NSLog(@"Fusion Tables: %@", lines);
            for (NSDictionary *ftTable in ftTableObjects) {
                STAssertNotNil(ftTable[@"name"], @"Loaded Fusion Table Name should not be nil");
                STAssertNotNil(ftTable[@"tableId"], @"Loaded Fusion Table ID should not be nil");
            }
        }
    }];
    [self waitForSemaphore:semaphore WithTimeout:10];
}

#pragma mark Fusion Table Delete Test
- (void)testObjCFusionTables_02_Delete {
    STAssertNotNil([self ftTableID], @"for Delete, the FTDelegate Fusion Table IDs the should not be nil");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);    
    [self.ftTableResource deleteFusionTableWithCompletionHandler:^(NSData *data, NSError *error) {
        dispatch_semaphore_signal(semaphore);
        if (error) {
            NSData *data = [[error userInfo] valueForKey:@"data"];
            NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            STFail (@"Error Deleting Fusion Table With ID: %@, %@", [self ftTableID], errorStr);
        } else {
            NSLog(@"Deleted Fusion Tables with ID: %@", [self ftTableID]);
        }
    }];
    [self waitForSemaphore:semaphore WithTimeout:10];
}


@end
