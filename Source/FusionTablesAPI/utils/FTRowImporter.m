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

//  FTRowImporter.m
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//  Added by Adam Cumiskey on 02/14/2014

/****
    Enables batch uploading of rows to a fusion table
    Rows must conform to the FTTableRowDelegate which defines a CSV string
    representation of each row.
****/

#import "FTRowImporter.h"

@implementation FTRowImporter

#define GOOGLE_FT_UPLOAD_API_URL @"https://www.googleapis.com/upload/fusiontables/v2/tables"
+ (void)uploadRows:(NSArray *)rows
           toTable:(NSString *)tableID
   customDelimiter:(NSString *)delimiter
    withCompletionHandler:(ServiceAPIHandler)completionHandler {
    
    // Create the url and add the custom delimiter
    NSString *url = [NSString stringWithFormat:@"%@/%@/import", GOOGLE_FT_UPLOAD_API_URL, tableID];
    if (delimiter && ![delimiter isEqualToString:@""]) {
        url = [NSString stringWithFormat:@"%@?delimiter=%@", url, delimiter];
    }
    
    // Create the request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setValue:@"application/octet-stream; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    // Authorize and send
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [[GoogleAuthorizationController sharedInstance] authorizeHTTPFetcher:fetcher
                                                   WithCompletionHandler:^{
                                                       [fetcher setPostData:[self postDataForRows:rows]];
                                                       [fetcher beginFetchWithCompletionHandler:completionHandler];
                                                   }];
}

+ (NSData *)postDataForRows:(NSArray *)rows {
    
    // Create a CSV string from each row
    NSMutableString *csvString = [NSMutableString string];
    for (id object in rows) {
        if ([object respondsToSelector:@selector(csvStringForRow)]) {
            NSString *rowString = [object performSelector:@selector(csvStringForRow)
                                               withObject:nil];
            [csvString appendFormat:@"%@\n", rowString];
        }
    }
    // Return the csvString as UTF-8 encoded data
    return [csvString dataUsingEncoding:NSUTF8StringEncoding];
}

@end