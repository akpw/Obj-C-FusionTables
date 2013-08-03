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

- (NSDictionary *)ftStyleDictionary {
    NSMutableDictionary *ftStyleObject = [NSMutableDictionary dictionary];
    ftStyleObject[@"name"] = [self.ftStyleDelegate ftStyleName];
    ftStyleObject[@"tableId"] = [self.ftStyleDelegate ftTableID];
    
    // Default for Fusion Table?
    if ([self.ftStyleDelegate respondsToSelector:@selector(isDefaulForTable)]) {
        ftStyleObject[@"isDefaultForTable"] = ([self.ftStyleDelegate isDefaulForTable]) ? @"true" : @"false";
    } else {
        ftStyleObject[@"isDefaultForTable"] = @"true";
    }
    
    // Icon Marker Options Object
    if ([self.ftStyleDelegate respondsToSelector:@selector(ftMarkerOptions)]) {
        ftStyleObject[@"markerOptions"] = [self.ftStyleDelegate ftMarkerOptions];
    }
    
    // Line Color Options Object
    if ([self.ftStyleDelegate respondsToSelector:@selector(ftPolylineOptions)]) {
        ftStyleObject[@"polylineOptions"] = [self.ftStyleDelegate ftPolylineOptions];
    }
    
    return ftStyleObject;
}

- (void)insertFTStyleWithCompletionHandler:(ServiceAPIHandler)handler {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self ftStyleDictionary]
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    NSString *resourceTypeIDString = [NSString stringWithFormat:@"/%@/%@",
                                            [self.ftStyleDelegate ftTableID], @"styles"];    
    [self modifyFusionTablesAPI:resourceTypeIDString
                 PostDataString:jsonString WithCompletionHandler:handler];
}


- (void)lisFTStylesWithCompletionHandler:(ServiceAPIHandler)handler {
    
}
- (void)updateFTStyleWithCompletionHandler:(ServiceAPIHandler)handler {
    
}
- (void)deleteFTStyleWithCompletionHandler:(ServiceAPIHandler)handler {
    
}



#pragma mark - Accessing FT styles metadata
- (void)queryStylesForFusionTable:(NSString *)fusionTableID WithCompletionHandler:(ServiceAPIHandler)handler {
    [self queryFusionTablesAPI:fusionTableID QueryType:@"styles" WithCompletionHandler:handler];
}




@end
