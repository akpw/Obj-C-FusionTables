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

//  FTStyle.m
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    Represents a Fusion Table Style. 
    Suports common table operations, such as insert / list / update delete
****/


#import "FTStyle.h"
#import "GoogleAuthorizationController.h"

@implementation FTStyle

#pragma mark builds Fusion Tables Styles Definition
- (NSDictionary *)ftStyleDictionary {
    NSMutableDictionary *ftStyleObject = [NSMutableDictionary dictionary];
    // Style Name
    if ([self.ftStyleDelegate respondsToSelector:@selector(ftStyleName)]) {
        ftStyleObject[@"name"] = [self.ftStyleDelegate ftStyleName];
    }
    // Style TableID
    if ([self.ftStyleDelegate respondsToSelector:@selector(ftTableID)]) {
        ftStyleObject[@"tableId"] = [self.ftStyleDelegate ftTableID];
    } else {
        [NSException raise:@"Obj-C-FusionTables Exception"
                    format:@"For this operation, tableID needs to be be provided by FTStyleDelegate"];
    }    
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

#pragma mark - Public Methods
#pragma mark - Fusion Table styles Lifecycle Methods
#pragma mark Retrieves a list of styles for a a given tableID
- (void)lisFTStylesWithCompletionHandler:(ServiceAPIHandler)handler {
    if (![self.ftStyleDelegate respondsToSelector:@selector(ftTableID)]) {
        [NSException raise:@"Obj-C-FusionTables Exception"
                    format:@"For this operation, tableID needs to be be provided  by FTStyleDelegate"];
    }
    NSString *resourceTypeIDString = [NSString stringWithFormat:@"/%@/%@",
                                      [self.ftStyleDelegate ftTableID], @"styles"];
    [self queryFusionTablesResource:resourceTypeIDString WithCompletionHandler:handler];
}

#pragma mark Creates a new fusion table style
- (void)insertFTStyleWithCompletionHandler:(ServiceAPIHandler)handler {
    if (![self.ftStyleDelegate respondsToSelector:@selector(ftTableID)]) {
        [NSException raise:@"Obj-C-FusionTables Exception"
                    format:@"For this operation, tableID needs to be be provided  by FTStyleDelegate"];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self ftStyleDictionary]
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    NSString *resourceTypeIDString = [NSString stringWithFormat:@"/%@/%@",
                                            [self.ftStyleDelegate ftTableID], @"styles"];    
    [self modifyFusionTablesResource:resourceTypeIDString
                 PostDataString:jsonString WithCompletionHandler:handler];
}

#pragma mark Updates fusion table style definition
- (void)updateFTStyleWithCompletionHandler:(ServiceAPIHandler)handler {
    if (![self.ftStyleDelegate respondsToSelector:@selector(ftTableID)]) {
        [NSException raise:@"Obj-C-FusionTables Exception"
                    format:@"For this operation, tableID needs to be be provided by FTStyleDelegate"];
    }
    if (![self.ftStyleDelegate respondsToSelector:@selector(ftStyleID)]) {
        [NSException raise:@"Obj-C-FusionTables Exception"
                    format:@"For this operation, styleID needs to be be provided by FTStyleDelegate"];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self ftStyleDictionary]
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    NSString *resourceTypeIDString = [NSString stringWithFormat:@"/%@/%@/%@",
                                              [self.ftStyleDelegate ftTableID], @"styles",
                                              [self.ftStyleDelegate ftStyleID]];
    [self modifyFusionTablesResource:resourceTypeIDString
                      PostDataString:jsonString WithCompletionHandler:handler];
}

#pragma mark Deletes fusion table style with given tableID / styleID
- (void)deleteFTStyleWithCompletionHandler:(ServiceAPIHandler)handler {
    if (![self.ftStyleDelegate respondsToSelector:@selector(ftTableID)]) {
        [NSException raise:@"Obj-C-FusionTables Exception"
                    format:@"For this operation, tableID needs to be be provided by FTStyleDelegate"];
    }
    if (![self.ftStyleDelegate respondsToSelector:@selector(ftStyleID)]) {
        [NSException raise:@"Obj-C-FusionTables Exception"
                    format:@"For this operation, styleID needs to be be provided by FTStyleDelegate"];
    }
    NSString *resourceTypeIDString = [NSString stringWithFormat:@"/%@/%@/%@",
                                      [self.ftStyleDelegate ftTableID], @"styles", [self.ftStyleDelegate ftStyleID]];
    [self deleteFusionTablesResource:resourceTypeIDString WithCompletionHandler:handler];
}


@end
