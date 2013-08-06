//
//  FTTable.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 25/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

/*
    Represents a Fusion Table. 
    Allows common table operations such as insert / list / update delete
*/

#import "FTAPIResource.h"

@protocol FTDelegate <NSObject>
@optional
- (NSString *)ftTableID;
- (NSArray *)ftColumns;
- (NSString *)ftTitle;
- (NSString *)ftDescription;
- (BOOL)ftIsExportable;
@end

@interface FTTable : FTAPIResource

@property (nonatomic, weak) id <FTDelegate> ftTableDelegate;

#pragma mark - Fusion Table Lifecycle Methods
- (void)listFusionTablesWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)insertFusionTableWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)updateFusionTableWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)deleteFusionTableWithCompletionHandler:(ServiceAPIHandler)handler;


@end

