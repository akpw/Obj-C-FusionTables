//
//  FTSQLQuery.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 3/8/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "FTTable.h"
#import "GoogleAuthorizationController.h"

@interface FTSQLQuery : NSObject

#pragma mark - Fusion Tables SQL API
#pragma mark SQL API for accessing FT data rows
- (void)queryFusionTablesSQL:(NSString *)sql WithCompletionHandler:(ServiceAPIHandler)handler;

#pragma mark SQL API for modifying FT data rows
- (void)modifyFusionTablesSQL:(NSString *)sql WithCompletionHandler:(ServiceAPIHandler)handler;


@end
