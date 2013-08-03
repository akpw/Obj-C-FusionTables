//
//  FusionTablesResource.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 25/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoogleAuthorizationController.h"

@interface FTAPIResource : NSObject

#pragma mark - Fusion Tables API
#pragma mark API for accessing Fusion Table metadata info (table structure,styles, and templates)
- (void)queryFusionTablesAPI:(NSString *)fusionTableID
                    QueryType:(NSString *)theType
                    WithCompletionHandler:(ServiceAPIHandler)handler;

#pragma mark API for setting FT metadata info (table structure,styles, and templates)
- (void)modifyFusionTablesAPI:(NSString *)resourceTypeID
                PostDataString:(NSString *)postDataString
                WithCompletionHandler:(ServiceAPIHandler)handler;

@end
