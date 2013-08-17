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

//  ObjCFusionTablesSQLQueryTests.h
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
     Tests  Obj-C-FusionTables SQL Query Resources Base Operations
     
     The test cases goes sequentially from creating a table
     through inserting/updating/deleting rows to restoring 
     the tested Google account to its initial state
****/

#import "FTResourceTestBase.h"
#import "FTSQLQuery.h"

@interface ObjCFusionTablesSQLQueryResourceTests : FTResourceTestBase <FTSQLQueryDelegate>

@property (nonatomic, strong) FTSQLQuery *ftSQLQuery;

@end
