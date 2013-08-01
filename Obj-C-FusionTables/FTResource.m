//
//  FusionTablesResource.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 25/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "FTResource.h"
#import "GoogleAuthorizationController.h"

@implementation FTResource

#pragma mark - Fusion Tables SQL API
#pragma mark SQL API for accessing FT data rows
- (void)queryFusionTablesSQL:(NSString *)sql WithCompletionHandler:(FTAPIHandler)handler {
    
    NSString *url = [NSString stringWithFormat:@"%@?sql=%@", GOOGLE_FT_QUERY_URL,
                     [sql stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];

    [[GoogleAuthorizationController sharedInstance] authorizeHTTPFetcher:fetcher
                                                            WithCompletionHandler:^{
        [fetcher beginFetchWithCompletionHandler:handler];
    }];
}

#pragma mark SQL API for modifying FT data rows
- (void)modifyFusionTablesSQL:(NSString *)sql WithCompletionHandler:(FTAPIHandler)handler {
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:GOOGLE_FT_QUERY_URL]];
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];

    [[GoogleAuthorizationController sharedInstance] authorizeHTTPFetcher:fetcher WithCompletionHandler:^{
        NSData *postData = [[NSString stringWithFormat:@"sql=%@", sql] dataUsingEncoding:NSUTF8StringEncoding];
        [fetcher setPostData:postData];
        
        [fetcher beginFetchWithCompletionHandler:handler];
    }];    
}



#pragma mark - Fusion Tables API
#pragma mark API for accessing FT metadata info (table structure,styles, and templates)
- (void)queryFusionTablesAPI:(NSString *)fusionTableID
                    QueryType:(NSString *)theType
                    WithCompletionHandler:(FTAPIHandler)handler {
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", GOOGLE_FT_QUERY_API_URL, fusionTableID, theType];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [[GoogleAuthorizationController sharedInstance] authorizeHTTPFetcher:fetcher WithCompletionHandler:^{
        [fetcher beginFetchWithCompletionHandler:handler];
    }];
}

#pragma mark API for setting FT metadata info (table structure,styles, and templates)
- (void)modifyFusionTablesAPI:(NSString *)fusionTableID
                    ForQueryType:(NSString *)theType
                    PostDataString:(NSString *)postDataString
                    WithCompletionHandler:(FTAPIHandler)handler {
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", GOOGLE_FT_QUERY_API_URL, fusionTableID, theType];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSData *postData = [postDataString dataUsingEncoding:NSUTF8StringEncoding];
    
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [[GoogleAuthorizationController sharedInstance] authorizeHTTPFetcher:fetcher WithCompletionHandler:^{
        [fetcher setPostData:postData];
        [fetcher beginFetchWithCompletionHandler:handler];
    }];
}


@end
