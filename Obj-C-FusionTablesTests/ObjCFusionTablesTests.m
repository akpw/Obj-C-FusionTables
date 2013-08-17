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

//  ObjCFusionTablesTests.m
//  Obj-C-FusionTables

/****
    Tests  Obj-C-FusionTables Base Operations
        * Fusion Table: insert, list, delete
        * Fusion Table Style: insert, list, delete
        * Fusion Table Template: insert, list, delete 
 
    The test cases goes sequentially from creating a table / style / template 
    through deleting & restoring the tested Google account to its initial state
****/


#import "ObjCFusionTablesTests.h"

static NSString *_sFusionTableID;
static NSString *_sFusionTableStyleID;
static NSString *_sFusionTableTemplateID;

@implementation ObjCFusionTablesTests 

#pragma mark - FTDelegate / FTStyleDelegate / FTTemplateDelegate ID methods
- (NSString *)ftTableID {
    return _sFusionTableID;
}
- (NSString *)ftStyleID {
    return _sFusionTableStyleID;
}
- (NSString *)ftTemplateID {
    return _sFusionTableTemplateID;
}

#pragma mark Fusion Tables - Inserts Tests
- (void)testObjCFusionTables_000_InsertTable {
    STAssertNotNil([self ftName], 
                   @"for Insert Table, the FTDelegate Fusion Table Name the should not be nil");
    STAssertNotNil([self ftColumns], 
                   @"for Insert Table, the FTDelegate Fusion Table Columns the should not be nil");
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
                STAssertNotNil(ftTableDict[@"name"], @"Returned Inserted Fusion Table Name should not be nil");
                STAssertNotNil(ftTableDict[@"tableId"], @"Return Inserted Fusion Table IDs should not be nil");
                _sFusionTableID = ftTableDict[@"tableId"];
                NSLog(@"Inserted a new Fusion Table: %@", ftTableDict);
            } else {
                STFail (@"Error processsing inserted Fusion Table data");
            }
        }
    }];    
    [self waitForSemaphore:semaphore WithTimeout:10];
}
- (void)testObjCFusionTables_001_InsertStyle {
    STAssertNotNil([self ftTableID], 
                   @"for Insert Style, the FTStyleDelegate Fusion Table ID the should not be nil");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [self.ftStyleResource insertFTStyleWithCompletionHandler:^(NSData *data, NSError *error) {
        dispatch_semaphore_signal(semaphore);
        if (error) {
            NSData *data = [[error userInfo] valueForKey:@"data"];
            NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            STFail (@"Error Inserting Fusion Table Style: %@", errorStr);
        } else {
            NSDictionary *ftStyleDict = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:kNilOptions error:nil];
            if (ftStyleDict) {
                STAssertNotNil(ftStyleDict[@"styleId"],
                               @"Returned Inserted Fusion Table Style ID should not be nil");  
                _sFusionTableStyleID = ftStyleDict[@"styleId"];
                NSLog(@"Inserted a new Fusion Table Style: %@", ftStyleDict);
            } else {
                STFail (@"Error processsing inserted Fusion Table Style data");
            }
        }
    }];
    [self waitForSemaphore:semaphore WithTimeout:10];
}
- (void)testObjCFusionTables_002_InsertTemplate {
    STAssertNotNil([self ftTableID], 
                   @"for Insert Template, the FTTemplateDelegate Fusion Table ID the should not be nil");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [self.ftTemplateResource insertFTTemplateWithCompletionHandler:^(NSData *data, NSError *error) {
        dispatch_semaphore_signal(semaphore);
        if (error) {
            NSData *data = [[error userInfo] valueForKey:@"data"];
            NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            STFail (@"Error Inserting Fusion Table Template: %@", errorStr);
        } else {
            NSDictionary *ftTemplateDict = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:kNilOptions error:nil];
            if (ftTemplateDict) {
                STAssertNotNil(ftTemplateDict[@"templateId"],
                               @"Returned Inserted Fusion Table Template ID should not be nil");  
                _sFusionTableTemplateID = ftTemplateDict[@"templateId"];
                NSLog(@"Inserted a new Fusion Table Style: %@", ftTemplateDict);
            } else {
                STFail (@"Error processsing inserted Fusion Table Template data");
            }
        }
    }];
    [self waitForSemaphore:semaphore WithTimeout:10];
}


#pragma mark Fusion Tables - Lists Tests
- (void)testObjCFusionTables_010_listTables {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);    
    [self.ftTableResource listFusionTablesWithCompletionHandler: ^(NSData *data, NSError *error) {
        dispatch_semaphore_signal(semaphore);
        if (error) {
            NSData *data = [[error userInfo] valueForKey:@"data"];
            NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            STFail (@"Error Fetching Fusion Tables: %@", errorStr);
        } else {
            NSDictionary *ftItems = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions error:nil];            
            NSArray *ftTableObjects = [NSMutableArray arrayWithArray:ftItems[@"items"]];
            NSLog(@"Fusion Tables: %@", ftTableObjects);
            for (NSDictionary *ftTable in ftTableObjects) {
                STAssertNotNil(ftTable[@"name"], @"Loaded Fusion Table Name should not be nil");
                STAssertNotNil(ftTable[@"tableId"], @"Loaded Fusion Table ID should not be nil");
            }
        }
    }];
    [self waitForSemaphore:semaphore WithTimeout:10];
}
- (void)testObjCFusionTables_011_ListStyles {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);    
    [self.ftStyleResource lisFTStylesWithCompletionHandler: ^(NSData *data, NSError *error) {
        dispatch_semaphore_signal(semaphore);
        if (error) {
            NSData *data = [[error userInfo] valueForKey:@"data"];
            NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            STFail (@"Error Fetching Fusion Table Styles: %@", errorStr);
        } else {
            NSDictionary *ftItems = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions error:nil];       
            NSArray *ftStylebjects = [NSMutableArray arrayWithArray:ftItems[@"items"]];
            STAssertNotNil(ftStylebjects, @"Listing Styles should return at least one test style");
            NSLog(@"Fusion Tables Styles: %@", ftStylebjects);
            for (NSDictionary *ftTableStyle in ftStylebjects) {
                STAssertNotNil(ftTableStyle[@"styleId"], @"Loaded Fusion Table Style should not be nil");
            }
        }
    }];
    [self waitForSemaphore:semaphore WithTimeout:10];
}
- (void)testObjCFusionTables_012_ListTemplates {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);    
    [self.ftTemplateResource lisFTTemplatesWithCompletionHandler: ^(NSData *data, NSError *error) {
        dispatch_semaphore_signal(semaphore);
        if (error) {
            NSData *data = [[error userInfo] valueForKey:@"data"];
            NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            STFail (@"Error Fetching Fusion Table Templates: %@", errorStr);
        } else {
            NSDictionary *ftItems = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions error:nil];            
            NSArray *ftTemplateObjects = [NSMutableArray arrayWithArray:ftItems[@"items"]];
            STAssertNotNil(ftTemplateObjects, @"Listing Templates should return at least one test template");
            NSLog(@"Fusion Tables Templates: %@", ftTemplateObjects);
            for (NSDictionary *ftTableTemplate in ftTemplateObjects) {
                STAssertNotNil(ftTableTemplate[@"templateId"], @"Loaded Fusion Table Template ID should not be nil");
            }
        }
    }];
    [self waitForSemaphore:semaphore WithTimeout:10];
}

#pragma mark Fusion Tables - Delete Tests
- (void)testObjCFusionTables_020_DeleteStyle {
    STAssertNotNil([self ftTableID], 
                   @"for Delete Style, the FTStyleDelegate Fusion Table ID the should not be nil");
    STAssertNotNil([self ftStyleID], 
                   @"for Delete Style, the FTStyleDelegate Style ID the should not be nil");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);    
    [self.ftStyleResource deleteFTStyleWithCompletionHandler:^(NSData *data, NSError *error) {
        dispatch_semaphore_signal(semaphore);
        if (error) {
            NSData *data = [[error userInfo] valueForKey:@"data"];
            NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            STFail (@"Error Deleting Fusion Table Style With ID: %@, %@", [self ftStyleID], errorStr);
        } else {
            NSLog(@"Deleted Fusion Table Style with ID: %@", [self ftStyleID]);
        }
    }];
    [self waitForSemaphore:semaphore WithTimeout:10];
}
- (void)testObjCFusionTables_021_DeleteTemplate {
    STAssertNotNil([self ftTableID], 
                   @"for Delete Template, the FTTemplateDelegate Fusion Table ID the should not be nil");
    STAssertNotNil([self ftTemplateID], 
                   @"for Delete Template, the FTTemplateDelegate Template ID the should not be nil");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);    
    [self.ftTemplateResource deleteFTTemplateWithCompletionHandler:^(NSData *data, NSError *error) {
        dispatch_semaphore_signal(semaphore);
        if (error) {
            NSData *data = [[error userInfo] valueForKey:@"data"];
            NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            STFail (@"Error Deleting Fusion Table Template With ID: %@, %@", [self ftTemplateID], errorStr);
        } else {
            NSLog(@"Deleted Fusion Table Template with ID: %@", [self ftTemplateID]);
        }
    }];
    [self waitForSemaphore:semaphore WithTimeout:10];
}
- (void)testObjCFusionTables_022_DeleteTable {
    STAssertNotNil([self ftTableID], 
                   @"for Delete Table, the FTDelegate Fusion Table ID the should not be nil");
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
