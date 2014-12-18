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

//  FTSQLQuery.h
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    Represents a Fusion Table SQL query resource
    Suports common table rows operations, 
    such as handling rows of data and executing queries 
****/

#import "FTSQLQueryResource.h"

@protocol FTSQLQueryDelegate <NSObject>
@optional
- (NSString *)ftSQLSelectStatement;
- (NSString *)ftSQLInsertStatement;
- (NSString *)ftSQLUpdateStatement;
- (NSString *)ftSQLDeleteStatement;
@end

@interface FTSQLQuery : FTSQLQueryResource

@property (nonatomic, weak) id<FTSQLQueryDelegate> ftSQLQueryDelegate;

#pragma mark - Fusion Table SQL query Methods
- (void)sqlSelectWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)sqlInsertWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)sqlUpdateWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)sqlDeleteWithCompletionHandler:(ServiceAPIHandler)handler;


@end
