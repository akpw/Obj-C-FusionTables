//
//  FusionTablesResource.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 25/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

/*
    Enables read-write access to Fusion Table API Resources such as tables, styles, and templates.
*/

#import <Foundation/Foundation.h>
#import "GoogleAuthorizationController.h"

@interface FTAPIResource : NSObject

#pragma mark - Fusion Tables API
#pragma mark API for accessing Fusion Table metadata info (table structure,styles, and templates)
- (void)queryFusionTablesResource:(NSString *)resourceTypeID
                WithCompletionHandler:(ServiceAPIHandler)handler;

#pragma mark API for setting FT metadata info (table structure,styles, and templates)
- (void)modifyFusionTablesResource:(NSString *)resourceTypeID
                PostDataString:(NSString *)postDataString
                WithCompletionHandler:(ServiceAPIHandler)handler;

#pragma mark deletes a Fusion Table resource (i.e. table/style/template) with specified resourceTypeID
- (void)deleteFusionTablesResource:(NSString *)resourceTypeID
             WithCompletionHandler:(ServiceAPIHandler)handler;

@end
