//
//  FTResourceTestBase.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 13/8/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "FTTable.h"
#import "FTTemplate.h"
#import "FTStyle.h"

@interface FTResourceTestBase : SenTestCase <FTDelegate, FTStyleDelegate, FTTemplateDelegate> 

@property (nonatomic, strong) FTTable *ftTableResource;
@property (nonatomic, strong) FTStyle *ftStyleResource;
@property (nonatomic, strong) FTTemplate *ftTemplateResource;

#pragma mark - Helper Methods
- (void)checkGoogleConnection;
- (void)waitForSemaphore:(dispatch_semaphore_t)semaphore WithTimeout:(NSTimeInterval)timeoutInSeconds;

@end
