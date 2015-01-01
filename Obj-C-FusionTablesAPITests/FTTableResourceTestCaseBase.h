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

//  ObjCFusionTablesFTAPIResourceTests.h
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
 Tests  Obj-C-FusionTables FT API Resources Base Operations
 * Fusion Table: insert, list, delete
 
 Tests creating / lising / deletion of a Fusion Table,
 then restores the tested Google account to its initial state
 ****/

#import "FTResourceTestCaseBase.h"
#import "FTTable.h"

@interface FTTableResourceTestCaseBase : FTResourceTestCaseBase <FTDelegate>

@property (nonatomic, strong) FTTable *ftTableResource;

@end
