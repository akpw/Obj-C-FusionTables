//
//  FTTable.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 25/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "FTResource.h"

@interface FTTable : FTResource

#pragma mark - Creates a Fusion Table
- (void)createFusionTable:(NSDictionary *)tableDictionary
                    WithCompletionHandler:(FTAPIHandler)handler;

- (void)setPublicSharingForFusionTableID:(NSString *)fusionTableID
                    WithCompletionHandler:(FTAPIHandler)handler;

@end
