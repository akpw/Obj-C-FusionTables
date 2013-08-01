//
//  FTTemplate.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 25/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "FTResource.h"

@interface FTTemplate : FTResource


#pragma mark - Quering FT templates metadata
- (void)queryTemplatesForFusionTable:(NSString *)fusionTableID WithCompletionHandler:(FTAPIHandler)handler;

#pragma mark - Setting FT templates metadata
- (void)setFusionTableInfoWindow:(NSDictionary *)infoWindowTemplateDictionary
                    ForFusionTableID:(NSString *)fusionTableID
                    WithCompletionHandler:(FTAPIHandler)handler;


@end
