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

//  FTTable.h
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    Represents a Fusion Table. 
    Suports common table operations, such as insert / list / update delete
****/

#import "FTAPIResource.h"

@protocol FTDelegate <NSObject>
@optional
- (NSString *)ftTableID;
- (NSArray *)ftColumns;
- (NSString *)ftName;
- (BOOL)ftIsExportable;
- (NSString *)ftDescription;
@end

@interface FTTable : FTAPIResource

@property (nonatomic, weak) id <FTDelegate> ftTableDelegate;

#pragma mark - Fusion Table Lifecycle Methods
- (void)listFusionTablesWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)insertFusionTableWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)updateFusionTableWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)deleteFusionTableWithCompletionHandler:(ServiceAPIHandler)handler;


@end

