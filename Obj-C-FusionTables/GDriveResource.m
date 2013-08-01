//
//  GDriveResource.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 1/8/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "GDriveResource.h"
#import "GoogleAuthorizationController.h"

typedef void(^GDriveAPIHandler)(NSData *data, NSError *error);

@implementation GDriveResource

#define GOOGLE_GDRIVE_API_URL @("https://www.googleapis.com/drive/v2/files")
- (void)setPublicSharingForFusionTableID:(NSString *)fusionTableID
                                WithCompletionHandler:(GDriveAPIHandler)handler {
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", GOOGLE_GDRIVE_API_URL, fusionTableID, @"permissions"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    NSMutableDictionary *permissionsDict = [NSMutableDictionary dictionary];
    permissionsDict[@"role"] = @"reader";
    permissionsDict[@"type"] = @"anyone";
    permissionsDict[@"value"] = @"";
   
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:permissionsDict
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    NSData *postData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [[GoogleAuthorizationController sharedInstance] authorizeHTTPFetcher:fetcher WithCompletionHandler:^{
        [fetcher setPostData:postData];
        [fetcher beginFetchWithCompletionHandler:handler];
    }];
    
}

@end
