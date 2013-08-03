//
//  FTSQLQuery.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 3/8/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "FTSQLQuery.h"

@implementation FTSQLQuery

#pragma mark - Fusion Tables SQL API
#pragma mark SQL API for accessing FT data rows
#define GOOGLE_FT_QUERY_URL (@"https://www.googleapis.com/fusiontables/v1/query")
- (void)queryFusionTablesSQL:(NSString *)sql WithCompletionHandler:(ServiceAPIHandler)handler {
    
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
- (void)modifyFusionTablesSQL:(NSString *)sql WithCompletionHandler:(ServiceAPIHandler)handler {
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:GOOGLE_FT_QUERY_URL]];
    
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [[GoogleAuthorizationController sharedInstance] authorizeHTTPFetcher:fetcher WithCompletionHandler:^{
        NSData *postData = [[NSString stringWithFormat:@"sql=%@", sql] dataUsingEncoding:NSUTF8StringEncoding];
        [fetcher setPostData:postData];
        
        [fetcher beginFetchWithCompletionHandler:handler];
    }];    
}


@end
