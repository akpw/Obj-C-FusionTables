//
//  FTTable.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 25/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "FTAPIResource.h"

@protocol FTDelegate <NSObject>
@required
- (NSArray *)ftColumns;
- (NSString *)ftTitle;

@optional
- (NSString *)ftDescription;
- (BOOL)ftIsExportable;
@end

@interface FTTable : FTAPIResource

@property (nonatomic, weak) id <FTDelegate> ftTableDelegate;

#pragma mark - Fusion Table Structure / Lifecycle Methods
- (void)insertFusionTableWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)listFusionTablesWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)updateFusionTableWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)deleteFusionTableWithCompletionHandler:(ServiceAPIHandler)handler;


@end

