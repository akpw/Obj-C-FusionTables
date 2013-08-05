//
//  FTTemplate.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 25/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "FTTemplate.h"

@implementation FTTemplate

- (NSDictionary *)ftTemplateDictionary {
    NSMutableDictionary *ftTemplateObject = [NSMutableDictionary dictionary];
    
    ftTemplateObject[@"body"] = [self.ftTemplateDelegate ftTemplateBody];
    ftTemplateObject[@"name"] = [self.ftTemplateDelegate ftTemplateName];
    
    return ftTemplateObject;
}
- (void)insertFTTemplateWithCompletionHandler:(ServiceAPIHandler)handler {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self ftTemplateDictionary]
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    NSString *resourceTypeIDString = [NSString stringWithFormat:@"/%@/%@",
                                      [self.ftTemplateDelegate ftTableID], @"templates"];
    [self modifyFusionTablesResource:resourceTypeIDString
                 PostDataString:jsonString WithCompletionHandler:handler];
}

- (void)lisFTTemplatesWithCompletionHandler:(ServiceAPIHandler)handler {
    
}
- (void)updateFTTemplateWithCompletionHandler:(ServiceAPIHandler)handler {
    
}
- (void)deleteFTTemplateWithCompletionHandler:(ServiceAPIHandler)handler {
    
}




#pragma mark - Setting FT templates metadata
- (void)queryTemplatesForFusionTable:(NSString *)fusionTableID WithCompletionHandler:(ServiceAPIHandler)handler {
    NSString *resourceTypeIDString = [NSString stringWithFormat:@"/%@/%@", fusionTableID, @"templates"];
    [self queryFusionTablesResource:resourceTypeIDString WithCompletionHandler:handler];
}

#pragma mark - Setting FT templates metadata
- (void)setFusionTableInfoWindow:(NSDictionary *)infoWindowTemplateDictionary
                        ForFusionTableID:(NSString *)fusionTableID
                        WithCompletionHandler:(ServiceAPIHandler)handler {
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoWindowTemplateDictionary
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];

    NSString *resourceTypeIDString = [NSString stringWithFormat:@"/%@/%@", fusionTableID, @"templates"];
    
    [self modifyFusionTablesResource:resourceTypeIDString
                 PostDataString:jsonString WithCompletionHandler:handler];
}


@end
