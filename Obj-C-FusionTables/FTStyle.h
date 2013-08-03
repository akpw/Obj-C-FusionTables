//
//  FTStyle.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 25/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "FTAPIResource.h"

@protocol FTStyleDelegate <NSObject>
@required
- (NSString *)ftTableID;
- (NSString *)ftStyleName;
@optional
- (BOOL)isDefaulForTable;
- (NSDictionary *)ftMarkerOptions;
- (NSDictionary *)ftPolylineOptions;
@end

@interface FTStyle : FTAPIResource

@property (nonatomic, weak) id <FTStyleDelegate> ftStyleDelegate;

#pragma mark - Accessing FT styles metadata
- (void)insertFTStyleWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)lisFTStylesWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)updateFTStyleWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)deleteFTStyleWithCompletionHandler:(ServiceAPIHandler)handler;

@end
