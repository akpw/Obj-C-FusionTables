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

//  FTSQLQueryBuilder.h
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    A helper class for building Fusion Tables SQL statements
****/

#import <Foundation/Foundation.h>
@interface FTSQLQueryBuilder : NSObject

#pragma mark - Fusion Tables SQLQuery Statements Helpers
+ (NSString *)builSQLInsertStringForColumnNames:(NSArray *)columnNames 
                                FTTableID:(NSString *)fusionTableID, ...;
+ (NSString *)builSQLUpdateStringForRowID:(NSUInteger)rowID 
                                ColumnNames:(NSArray *)columnNames 
                                FTTableID:(NSString *)fusionTableID, ...;
+ (NSString *)buildDeleteAllRowStringForFusionTableID:(NSString *)fusionTableID;
+ (NSString *)buildDeleteRowStringForFusionTableID:(NSString *)fusionTableID RowID:(NSUInteger)rowID;


#pragma mark - Fusion Table SQL Statements Values Helpers
+ (NSString *)buildFTStringValueString:(NSString *)sourceString;

#pragma mark - Fusion Table KML Elements Helpers
+ (NSString *)buildKMLLineString:(NSString *)coordinatesString;
+ (NSString *)buildKMLPointString:(NSString *)coordinatesString;
+ (NSString *)buildKMLPolygonString:(NSString *)coordinatesString;




@end
