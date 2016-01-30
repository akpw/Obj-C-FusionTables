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

//  FusionTablesResource.m
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    Enables read-write access to Fusion Table API Resources such as tables, styles, and templates.
****/

#import "FTAPIResource.h"

@implementation FTAPIResource

#pragma mark - Fusion Tables API
#pragma mark API for accessing FT metadata info (table structure, styles, and templates)
#define GOOGLE_FT_QUERY_API_URL @"https://www.googleapis.com/fusiontables/v2/tables"
- (void)queryFusionTablesResource:(NSString *)resourceTypeID
                    WithCompletionHandler:(ServiceAPIHandler)handler {
    
    NSString *resourceTypeIDString = (resourceTypeID) ? resourceTypeID : @"";
    NSString *url = [NSString stringWithFormat:@"%@%@", GOOGLE_FT_QUERY_API_URL, resourceTypeIDString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [[GoogleAuthorizationController sharedInstance] authorizeHTTPFetcher:fetcher WithCompletionHandler:^{
        [fetcher beginFetchWithCompletionHandler:handler];
    }];
}

#pragma mark API for setting FT metadata info (table structure, styles, and templates)
- (void)modifyFusionTablesResource:(NSString *)resourceTypeID
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

#pragma mark deletes a Fusion Table resource (i.e. table/style/template) with specified resourceTypeID
- (void)deleteFusionTablesResource:(NSString *)resourceTypeID
            WithCompletionHandler:(ServiceAPIHandler)handler {
    NSString *resourceTypeIDString = (resourceTypeID) ? resourceTypeID : @"";
    NSString *url = [NSString stringWithFormat:@"%@%@", GOOGLE_FT_QUERY_API_URL, resourceTypeIDString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"DELETE"];
    
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [[GoogleAuthorizationController sharedInstance] authorizeHTTPFetcher:fetcher WithCompletionHandler:^{
        [fetcher beginFetchWithCompletionHandler:handler];
    }];    
}

@end
