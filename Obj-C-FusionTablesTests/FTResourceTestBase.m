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

#pragma mark - setup / cleanup
- (void)setUp {
    [super setUp]; 
    [self checkGoogleConnection];
}
- (void)tearDown {
    [super tearDown];
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

#pragma mark - FTStyleDelegate methods
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

#pragma mark - Helper Methods
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

@end
