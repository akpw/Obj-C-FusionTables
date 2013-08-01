//
//  FTTemplate.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 25/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "FTTemplate.h"

@implementation FTTemplate

#pragma mark - Setting FT templates metadata
- (void)queryTemplatesForFusionTable:(NSString *)fusionTableID WithCompletionHandler:(FTAPIHandler)handler {
    [self queryFusionTablesAPI:fusionTableID QueryType:@"templates" WithCompletionHandler:handler];
}

#pragma mark - Setting FT templates metadata
- (void)setFusionTableInfoWindow:(NSDictionary *)infoWindowTemplateDictionary
                        ForFusionTableID:(NSString *)fusionTableID
                        WithCompletionHandler:(FTAPIHandler)handler {
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoWindowTemplateDictionary
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    [self modifyFusionTablesAPI:fusionTableID ForQueryType:@"templates"
                 PostDataString:jsonString WithCompletionHandler:handler];
}


@end
