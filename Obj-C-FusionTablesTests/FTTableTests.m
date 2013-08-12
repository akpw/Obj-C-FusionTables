//
//  FTTableTests.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 12/8/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "FTTableTests.h"
#import "GoogleAuthorizationController.h"


@implementation FTTableTests
- (void)setUp {
    [super setUp];   
    [self googleConnectionCheck];
}
- (void)tearDown {
    [super tearDown];
}

- (void)testLoadFusionTablesList {
    FTTable *ftTable = [[FTTable alloc] init];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);    
    [ftTable listFusionTablesWithCompletionHandler: ^(NSData *data, NSError *error) {
        dispatch_semaphore_signal(semaphore);
        if (error) {
            NSData *data = [[error userInfo] valueForKey:@"data"];
            NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            STFail (@"Error Fetching Fusion Tables: %@", errorStr);
        } else {
            NSDictionary *lines = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions error:nil];
            NSLog(@"Fusion Tables: %@", lines);
        }
    }];
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
    }
}


- (void)googleConnectionCheck {
    if ([[GoogleAuthorizationController sharedInstance] isAuthorised]) {
        NSLog(@"Connected to Google with userID: %@", 
              [[GoogleAuthorizationController sharedInstance] authenticatedUserID]);
    } else {
        STFail(@"Please connect to a Google account before testing");
    }
    STAssertNotNil([[GoogleAuthorizationController sharedInstance] authenticatedUserID], 
                   @"authenticatedUserID should not be nil");    
}

@end

/*
 - (void)waitForCompletionWithTimeout:(NSTimeInterval)timeoutInSeconds {
 NSDate* giveUpDate = [NSDate dateWithTimeIntervalSinceNow:timeoutInSeconds];
 
 // Loop until the callbacks have been called and released, and until
 // the connection is no longer pending, or until the timeout has expired
 BOOL isMainThread = [NSThread isMainThread];
 
 while ([giveUpDate timeIntervalSinceNow] > 0) {
 // Run the current run loop 1/1000 of a second to give the networking
 // code a chance to work
 if (isMainThread) {
 NSDate *stopDate = [NSDate dateWithTimeIntervalSinceNow:0.001];
 [[NSRunLoop currentRunLoop] runUntilDate:stopDate];
 } else {
 [NSThread sleepForTimeInterval:0.001];
 }
 }
 }

 */