//
//  FTStyle.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 25/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

/****
    Represents a Fusion Table Style. 
    Suports common table operations, such as insert / list / update delete
****/


#import "FTAPIResource.h"

@protocol FTStyleDelegate <NSObject>
@optional
- (NSString *)ftTableID;
- (NSString *)ftStyleID;
- (NSString *)ftStyleName;
- (BOOL)isDefaulForTable;
- (NSDictionary *)ftMarkerOptions;
- (NSDictionary *)ftPolylineOptions;
@end

@interface FTStyle : FTAPIResource

@property (nonatomic, weak) id <FTStyleDelegate> ftStyleDelegate;

#pragma mark - Fusion Table Styles Lifecycle Methods
- (void)lisFTStylesWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)insertFTStyleWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)updateFTStyleWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)deleteFTStyleWithCompletionHandler:(ServiceAPIHandler)handler;

@end
