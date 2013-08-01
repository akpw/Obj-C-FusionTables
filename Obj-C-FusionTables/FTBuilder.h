//
//  FTBuilder.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 25/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTBuilder : NSObject


#pragma mark - Fusion Tables Structure
+ (NSArray *)columnNames;
+ (NSArray *)columnTypes;
+ (NSArray *)buildFusionTableColumns;
+ (NSDictionary *)buildFusionTableStructureDictionary:(NSString *)tableTitle
                                      WithDescription:(NSString *)tableDescription IsExportable:(BOOL)exportable;

#pragma mark - Fusion Tables Styling
+ (NSDictionary *)buildFusionTableStyleForFusionTableID:(NSString *)fusionTableID;
+ (NSDictionary *)buildInfoWindowTemplate;

#pragma mark - Fusion Tables SQL Query Statements
+ (NSString *)builDescribeStringForFusionTableID:(NSString *)fusionTableID;
+ (NSString *)builSQLInsertStringForFTTableID:(NSString *)fusionTableID, ...;

+ (NSString *)builSQLUpdateStringForRowID:(NSUInteger)rowID FTTableID:(NSString *)fusionTableID, ...;


+ (NSString *)buildDeleteAllRowStringForFusionTableID:(NSString *)fusionTableID;
+ (NSString *)buildDeleteRowStringForFusionTableID:(NSString *)fusionTableID RowID:(NSUInteger)rowID;

+ (NSString *)buildFTStringValueString:(NSString *)sourceString;

+ (NSString *)buildKMLLineString:(NSString *)coordinatesString;
+ (NSString *)buildKMLPointString:(NSString *)coordinatesString;
+ (NSString *)buildKMLPolygonString:(NSString *)coordinatesString;


@end
