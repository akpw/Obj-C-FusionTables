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

//  FTSQLQuery.m
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.


/****
    Represents a Fusion Table SQL query resource 
    Suports common table rows operations, 
    such as handling rows of data and executing queries 
****/


#import "FTSQLQuery.h"

@implementation FTSQLQuery

#pragma mark - Fusion Table SQL query Methods
#pragma mark Queries a Fusion Table for data
- (void)sqlSelectWithCompletionHandler:(ServiceAPIHandler)handler {
    if (![self.ftSQLQueryDelegate respondsToSelector:@selector(ftSQLSelectStatement)]) {
        [NSException raise:@"Obj-C-FusionTables Exception"
                    format:@"For SQL Select, SQL Select Statement definition must be provided  by FTSQLQueryDelegate"];
    }       
    [self queryFusionTablesSQL:[self.ftSQLQueryDelegate ftSQLSelectStatement] WithCompletionHandler:handler];    
}

#pragma mark Execute an Insert Statement against a Fusion Table 
- (void)sqlInsertWithCompletionHandler:(ServiceAPIHandler)handler {
    if (![self.ftSQLQueryDelegate respondsToSelector:@selector(ftSQLInsertStatement)]) {
        [NSException raise:@"Obj-C-FusionTables Exception"
                    format:@"For SQL Insert, SQL Insert Statement definition must be provided  by FTSQLQueryDelegate"];
    }       
    [self modifyFusionTablesSQL:[self.ftSQLQueryDelegate ftSQLInsertStatement] WithCompletionHandler:handler];    
}

#pragma mark Execute an Update Statement against a Fusion Table 
- (void)sqlUpdateWithCompletionHandler:(ServiceAPIHandler)handler {
    if (![self.ftSQLQueryDelegate respondsToSelector:@selector(ftSQLUpdateStatement)]) {
        [NSException raise:@"Obj-C-FusionTables Exception"
                    format:@"For SQL Update, SQL Update Statement definition must be provided  by FTSQLQueryDelegate"];
    }       
    [self modifyFusionTablesSQL:[self.ftSQLQueryDelegate ftSQLUpdateStatement] WithCompletionHandler:handler];    
    
}

#pragma mark Execute an Delete Statement against a Fusion Table 
- (void)sqlDeleteWithCompletionHandler:(ServiceAPIHandler)handler {
    if (![self.ftSQLQueryDelegate respondsToSelector:@selector(ftSQLDeleteStatement)]) {
        [NSException raise:@"Obj-C-FusionTables Exception"
                    format:@"For SQL Delete, SQL Delete Statement definition must be provided  by FTSQLQueryDelegate"];
    }       
    [self modifyFusionTablesSQL:[self.ftSQLQueryDelegate ftSQLDeleteStatement] WithCompletionHandler:handler];       
}


@end
