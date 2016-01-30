/* Copyright (c) 2013 Arseniy Kuznetsov
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//  FTSQLQueryResource.m
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    Provides read-write access to Fusion Table SQL Query API Resource
****/

#import "FTSQLQueryResource.h"

@implementation FTSQLQueryResource

#pragma mark - Fusion Tables SQL Query Resource API
#pragma mark SQL Query Resource API for accessing FT data rows
#define GOOGLE_FT_QUERY_URL (@"https://www.googleapis.com/fusiontables/v2/query")
- (void)queryFusionTablesSQL:(NSString *)sql WithCompletionHandler:(ServiceAPIHandler)handler {
    
    NSString *url = [NSString stringWithFormat:@"%@?sql=%@", GOOGLE_FT_QUERY_URL,
                     [sql stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [[GoogleAuthorizationController sharedInstance] authorizeHTTPFetcher:fetcher
                                                   WithCompletionHandler:^{
                                                       [fetcher beginFetchWithCompletionHandler:handler];
                                                   }];
}

#pragma mark SQL Query Resource API for modifying FT data rows
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
