//
//  FusionTablesResource.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 25/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "FTAPIResource.h"

@implementation FTAPIResource

#pragma mark - Fusion Tables API
#pragma mark API for accessing FT metadata info (table structure,styles, and templates)
#define GOOGLE_FT_QUERY_API_URL @"https://www.googleapis.com/fusiontables/v1/tables"
- (void)queryFusionTablesAPI:(NSString *)fusionTableID
                    QueryType:(NSString *)theType
                    WithCompletionHandler:(ServiceAPIHandler)handler {
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", GOOGLE_FT_QUERY_API_URL, fusionTableID, theType];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [[GoogleAuthorizationController sharedInstance] authorizeHTTPFetcher:fetcher WithCompletionHandler:^{
        [fetcher beginFetchWithCompletionHandler:handler];
    }];
}

#pragma mark API for setting FT metadata info (table structure,styles, and templates)
- (void)modifyFusionTablesAPI:(NSString *)resourceTypeID
                    PostDataString:(NSString *)postDataString
                    WithCompletionHandler:(ServiceAPIHandler)handler {
    
    NSString *resourceTypeIDString = (resourceTypeID) ? resourceTypeID : @"";
    
    NSString *url = [NSString stringWithFormat:@"%@%@", GOOGLE_FT_QUERY_API_URL, resourceTypeIDString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [[GoogleAuthorizationController sharedInstance] authorizeHTTPFetcher:fetcher WithCompletionHandler:^{
        NSData *postData = [postDataString dataUsingEncoding:NSUTF8StringEncoding];
        [fetcher setPostData:postData];
        [fetcher beginFetchWithCompletionHandler:handler];
    }];
}


@end
