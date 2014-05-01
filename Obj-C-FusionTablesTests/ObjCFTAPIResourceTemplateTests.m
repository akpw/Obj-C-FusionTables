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
 * Fusion Table Template: insert, list, delete
 
 Tests creating / lising / deletion of a Fusion Table Template,
 then restores the tested Google account to its initial state
 ****/

#import "ObjCFTAPIResourceTableTests.h"
#import "FTTemplate.h"

@interface ObjCFTAPIResourceTemplateTests : ObjCFTAPIResourceTableTests <FTTemplateDelegate>
    @property (nonatomic, strong) FTTemplate *ftTemplateResource;
@end

static NSString *_sFusionTableTemplateID;

@implementation ObjCFTAPIResourceTemplateTests

#pragma mark - Initialization
- (FTTemplate *)ftTemplateResource {
    if (!_ftTemplateResource) {
        _ftTemplateResource = [[FTTemplate alloc] init];
        _ftTemplateResource.ftTemplateDelegate = self;
    }
    return _ftTemplateResource;
}

#pragma mark -  XCTestCase setup / teardown
- (void)setUp {
    [super setUp];
    [self insertTemplate];
}
- (void)tearDown {
    [self deleteTemplate];
    [super tearDown];
}

#pragma mark -  XCTestCases
- (void)testListTemplates {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);    
    [self.ftTemplateResource lisFTTemplatesWithCompletionHandler: ^(NSData *data, NSError *error) {
        dispatch_semaphore_signal(semaphore);
        if (error) {
            NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
            XCTFail (@"Error Fetching Fusion Table Templates: %@", errorStr);
        } else {
            NSDictionary *ftItems = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:kNilOptions error:nil];            
            NSArray *ftTemplateObjects = [NSMutableArray arrayWithArray:ftItems[@"items"]];
            XCTAssertNotNil(ftTemplateObjects, @"Listing Templates should return at least one test template");
            NSLog(@"Fusion Tables Templates: %@", ftTemplateObjects);
            for (NSDictionary *ftTableTemplate in ftTemplateObjects) {
                XCTAssertNotNil(ftTableTemplate[@"templateId"], @"Loaded Fusion Table Template ID should not be nil");
            }
        }
    }];
    [self waitForSemaphore:semaphore WithTimeout:10];
}

#pragma mark - Test Fusion Table Template Insert / Delete Methods
- (void)insertTemplate {
    XCTAssertNotNil([self ftTableID], 
                    @"for Insert Template, the FTTemplateDelegate Fusion Table ID the should not be nil");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [self.ftTemplateResource insertFTTemplateWithCompletionHandler:^(NSData *data, NSError *error) {
        dispatch_semaphore_signal(semaphore);
        if (error) {
            NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
            XCTFail (@"Error Inserting Fusion Table Template: %@", errorStr);
        } else {
            NSDictionary *ftTemplateDict = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions error:nil];
            if (ftTemplateDict) {
                XCTAssertNotNil(ftTemplateDict[@"templateId"],
                                @"Returned Inserted Fusion Table Template ID should not be nil");  
                _sFusionTableTemplateID = ftTemplateDict[@"templateId"];
                NSLog(@"Inserted a new Fusion Table Style: %@", ftTemplateDict);
            } else {
                XCTFail (@"Error processsing inserted Fusion Table Template data");
            }
        }
    }];
    [self waitForSemaphore:semaphore WithTimeout:10];
}
- (void)deleteTemplate {
    XCTAssertNotNil([self ftTableID], 
                    @"for Delete Template, the FTTemplateDelegate Fusion Table ID the should not be nil");
    XCTAssertNotNil([self ftTemplateID], 
                    @"for Delete Template, the FTTemplateDelegate Template ID the should not be nil");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);    
    [self.ftTemplateResource deleteFTTemplateWithCompletionHandler:^(NSData *data, NSError *error) {
        dispatch_semaphore_signal(semaphore);
        if (error) {
            NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
            XCTFail (@"Error Deleting Fusion Table Template With ID: %@, %@", [self ftTemplateID], errorStr);
        } else {
            NSLog(@"Deleted Fusion Table Template with ID: %@", [self ftTemplateID]);
        }
    }];
    [self waitForSemaphore:semaphore WithTimeout:10];
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

@end
