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

//  ObjCFusionTablesFTAPIResourceTests.m
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
     Tests  Obj-C-FusionTables FT API Resources Base Operations
        * Fusion Table: insert, list, delete
        * Fusion Table Style: insert, list, delete
        * Fusion Table Template: insert, list, delete 
     
     The test cases goes sequentially from creating a table / style / template 
     through deleting and restoring the tested Google account to its initial state
****/


#import "ObjCFusionTablesFTAPIResourceTests.h"

static NSString *_sFusionTableID;
static NSString *_sFusionTableStyleID;
static NSString *_sFusionTableTemplateID;

@implementation ObjCFusionTablesFTAPIResourceTests 

#pragma mark - Initialization
- (FTStyle *)ftStyleResource {
    if (!_ftStyleResource) {
        _ftStyleResource = [[FTStyle alloc] init];
        _ftStyleResource.ftStyleDelegate = self;
    }
    return _ftStyleResource;
}
- (FTTemplate *)ftTemplateResource {
    if (!_ftTemplateResource) {
        _ftTemplateResource = [[FTTemplate alloc] init];
        _ftTemplateResource.ftTemplateDelegate = self;
    }
    return _ftTemplateResource;
}

#pragma mark - FTDelegate methods
- (NSString *)ftTableID {
    return _sFusionTableID;
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

#pragma mark - FTTemplateDelegate methods
- (NSString *)ftTemplateID {
    return _sFusionTableTemplateID;
}
- (NSString *)ftTemplateBody {
    return
    @"<div class='googft-info-window'"
    "style='font-family: sans-serif; width: 19em; height: 20em; overflow: auto;'>"
    "<img src='{entryThumbImageURL}' style='float:left; width:2em; vertical-align: top; margin-right:.5em'/>"
    "<b>{entryName}</b>"
    "<br>{entryDate}<br>"
    "<p><a href='{entryURL}'>{entryURLDescription}</a>"
    "<p>{entryNote}"
    "<a href='{entryImageURL}' target='_blank'> "
    "<img src='{entryImageURL}' style='width:18.5em; margin-top:.5em; margin-bottom:.5em'/>"
    "</a>"
    "<p>"
    "<p>"
    "</div>";
}

#pragma mark Fusion Tables - Inserts Tests
- (void)testObjCFusionTables_000_InsertTable {
    [self insertTestTableWithCompletionHandler:^(NSString *tableID) {
        _sFusionTableID = tableID;
    }];
}
- (void)testObjCFusionTables_001_InsertStyle {
    STAssertNotNil([self ftTableID], 
                   @"for Insert Style, the FTStyleDelegate Fusion Table ID the should not be nil");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [self.ftStyleResource insertFTStyleWithCompletionHandler:^(NSData *data, NSError *error) {
        dispatch_semaphore_signal(semaphore);
        if (error) {
            NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
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
            NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
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
            NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
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
            NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
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
            NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
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
            NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
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
            NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
            STFail (@"Error Deleting Fusion Table Template With ID: %@, %@", [self ftTemplateID], errorStr);
        } else {
            NSLog(@"Deleted Fusion Table Template with ID: %@", [self ftTemplateID]);
        }
    }];
    [self waitForSemaphore:semaphore WithTimeout:10];
}
- (void)testObjCFusionTables_022_DeleteTable {
    [self deleteTestTableWithCompletionHandler:nil];
}

@end
