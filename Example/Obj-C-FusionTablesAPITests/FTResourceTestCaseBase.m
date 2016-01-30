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

//  FTResourceTestBase.h
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    Base class for  all Obj-C-FusionTables Tests
****/

#import "FTResourceTestCaseBase.h"
#import "GoogleAuthorizationController.h"

@implementation FTResourceTestCaseBase

#pragma mark -  XCTestCase setup / teardown
- (void)setUp {
    [super setUp]; 
    [self checkGoogleConnection];
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
        [[GoogleAuthorizationController sharedInstance] registerClientID:
            @"get your API key from: https://developers.google.com/fusiontables/docs/v2/using#APIKey"];
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [[GoogleAuthorizationController sharedInstance] signInToGoogleWithCompletionHandler:^{
            NSLog(@"connected to Google with userID: %@", 
                  [[GoogleAuthorizationController sharedInstance] authenticatedUserID]);
            dispatch_semaphore_signal(semaphore);
        } CancelHandler:^{
            XCTFail(@"failed connect to Google");
            dispatch_semaphore_signal(semaphore);
        }];   
        [self waitForSemaphore:semaphore WithTimeout:15];
    }
//    XCTAssertNotNil([[GoogleAuthorizationController sharedInstance] 
//                        authenticatedUserID], @"authenticatedUserID should not be nil");
}




@end
