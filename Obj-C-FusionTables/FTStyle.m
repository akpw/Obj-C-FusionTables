//
//  FTStyle.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 25/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "FTStyle.h"
#import "GoogleAuthorizationController.h"

@implementation FTStyle

#pragma mark - Accessing FT styles metadata
- (void)queryStylesForFusionTable:(NSString *)fusionTableID WithCompletionHandler:(FTAPIHandler)handler {
    [self queryFusionTablesAPI:fusionTableID QueryType:@"styles" WithCompletionHandler:handler];
}

#pragma mark - Setting FT styles metadata
- (void)setFusionTableStyle:(NSDictionary *)stylesDictionary
                    ForFusionTableID:(NSString *)fusionTableID
                    WithCompletionHandler:(FTAPIHandler)handler {
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:stylesDictionary
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    [self modifyFusionTablesAPI:fusionTableID ForQueryType:@"styles"
                 PostDataString:jsonString WithCompletionHandler:handler];
}



@end
