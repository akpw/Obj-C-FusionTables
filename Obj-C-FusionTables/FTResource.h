//
//  FusionTablesResource.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 25/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FTAPIHandler)(NSData *data, NSError *error);

@interface FTResource : NSObject

#define GOOGLE_FT_QUERY_URL (@"https://www.googleapis.com/fusiontables/v1/query")
#pragma mark - Fusion Tables SQL API
#pragma mark SQL API for accessing FT data rows
- (void)queryFusionTablesSQL:(NSString *)sql WithCompletionHandler:(FTAPIHandler)handler;

#pragma mark SQL API for modifying FT data rows
- (void)modifyFusionTablesSQL:(NSString *)sql WithCompletionHandler:(FTAPIHandler)handler;


#define GOOGLE_FT_QUERY_API_URL @"https://www.googleapis.com/fusiontables/v1/tables"
#pragma mark - Fusion Tables API
#pragma mark API for accessing FT metadata info (table structure,styles, and templates)
- (void)queryFusionTablesAPI:(NSString *)fusionTableID
                    QueryType:(NSString *)theType
                    WithCompletionHandler:(FTAPIHandler)handler;

#pragma mark API for setting FT metadata info (table structure,styles, and templates)
- (void)modifyFusionTablesAPI:(NSString *)fusionTableID
                    ForQueryType:(NSString *)theType
                    PostDataString:(NSString *)postDataString
        WithCompletionHandler:(FTAPIHandler)handler;

@end
