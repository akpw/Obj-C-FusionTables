//
//  FTSQLQuery.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 3/8/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "FTTable.h"
#import "GoogleAuthorizationController.h"

@protocol FTStyleDelegate <NSObject>
@required
- (NSString *)ftTableID;
- (NSString *)ftColumnNames;
@end

@interface FTSQLQuery : NSObject

#pragma mark - Fusion Tables SQL API
#pragma mark SQL API for accessing FT data rows
- (void)queryFusionTablesSQL:(NSString *)sql WithCompletionHandler:(ServiceAPIHandler)handler;

#pragma mark SQL API for modifying FT data rows
- (void)modifyFusionTablesSQL:(NSString *)sql WithCompletionHandler:(ServiceAPIHandler)handler;


#pragma mark - Query Statements Helpers
- (NSString *)builDescribeStringForFusionTableID:(NSString *)fusionTableID;

- (NSString *)builSQLInsertStringForColumnNames:(NSArray *)columnNames FTTableID:(NSString *)fusionTableID, ...;

- (NSString *)builSQLUpdateStringForRowID:(NSUInteger)rowID ColumnNames:(NSArray *)columnNames FTTableID:(NSString *)fusionTableID, ...;

- (NSString *)buildDeleteAllRowStringForFusionTableID:(NSString *)fusionTableID;
- (NSString *)buildDeleteRowStringForFusionTableID:(NSString *)fusionTableID RowID:(NSUInteger)rowID;

- (NSString *)buildFTStringValueString:(NSString *)sourceString;

- (NSString *)buildKMLLineString:(NSString *)coordinatesString;
- (NSString *)buildKMLPointString:(NSString *)coordinatesString;
- (NSString *)buildKMLPolygonString:(NSString *)coordinatesString;




@end
