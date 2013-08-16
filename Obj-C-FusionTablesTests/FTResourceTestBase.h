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

/****
    Base class for  Obj-C-FusionTables Tests
****/

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
