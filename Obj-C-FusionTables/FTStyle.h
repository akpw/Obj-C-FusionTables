//
//  FTStyle.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 25/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "FTResource.h"

@interface FTStyle : FTResource

#pragma mark - Accessing FT styles metadata
- (void)queryStylesForFusionTable:(NSString *)fusionTableID WithCompletionHandler:(FTAPIHandler)handler;

#pragma mark - Setting FT styles metadata
- (void)setFusionTableStyle:(NSDictionary *)stylesDictionary
                ForFusionTableID:(NSString *)fusionTableID
                WithCompletionHandler:(FTAPIHandler)handler;

@end
