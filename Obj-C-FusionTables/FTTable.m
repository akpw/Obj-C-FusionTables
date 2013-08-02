//
//  FTTable.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 25/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "FTTable.h"
#import "GoogleAuthorizationController.h"

@implementation FTTable

#pragma mark - Creates a Fusion Table
- (void)createFusionTable:(NSDictionary *)tableDictionary WithCompletionHandler:(FTAPIHandler)handler {
    NSString *url = [NSString stringWithFormat:@"%@", GOOGLE_FT_QUERY_API_URL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];

    [[GoogleAuthorizationController sharedInstance] authorizeHTTPFetcher:fetcher WithCompletionHandler:^{
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tableDictionary
                                                           options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        
        NSData *postData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];

        [fetcher setPostData:postData];
        [fetcher beginFetchWithCompletionHandler:handler];
    }];
}

#define GOOGLE_GDRIVE_API_URL @("https://www.googleapis.com/drive/v2/files")
- (void)setPublicSharingForFusionTableID:(NSString *)fusionTableID
                   WithCompletionHandler:(FTAPIHandler)handler {
    
    [[SimpleGoogleServiceHelpers sharedInstance] setPublicSharingForFileWithID:fusionTableID
                                WithCompletionHandler:^(NSData *data, NSError *error) {
    }];
    
}


@end
