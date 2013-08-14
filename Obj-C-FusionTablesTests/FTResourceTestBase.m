//
//  FTResourceTestBase.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 13/8/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

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

#pragma mark - FTDelegate methods
#define TESTE_FUSION_TABLE_PREFIX (@"ObjC-API_Test_FT_")
- (NSString *)ftTitle {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd-hhmmss"];
    return [NSString stringWithFormat:@"%@%@",
            TESTE_FUSION_TABLE_PREFIX, [formatter stringFromDate:[NSDate date]]];
}
// Sample Fusion Table Columns Definition
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
