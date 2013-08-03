//
//  FTQueryBuilder.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 25/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTSQLQueryBuilder : NSObject

#pragma mark - Fusion Tables SQL Query Statements
+ (NSString *)builDescribeStringForFusionTableID:(NSString *)fusionTableID;

+ (NSString *)builSQLInsertStringForColumnNames:(NSArray *)columnNames FTTableID:(NSString *)fusionTableID, ...;

+ (NSString *)builSQLUpdateStringForRowID:(NSUInteger)rowID ColumnNames:(NSArray *)columnNames FTTableID:(NSString *)fusionTableID, ...;

+ (NSString *)buildDeleteAllRowStringForFusionTableID:(NSString *)fusionTableID;
+ (NSString *)buildDeleteRowStringForFusionTableID:(NSString *)fusionTableID RowID:(NSUInteger)rowID;

+ (NSString *)buildFTStringValueString:(NSString *)sourceString;

+ (NSString *)buildKMLLineString:(NSString *)coordinatesString;
+ (NSString *)buildKMLPointString:(NSString *)coordinatesString;
+ (NSString *)buildKMLPolygonString:(NSString *)coordinatesString;


@end
