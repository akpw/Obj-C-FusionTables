//
//  FTTemplate.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 25/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

/****
    Represents a Fusion Table Info Window Template. 
    Suports common table operations, such as insert / list / update delete
****/


#import "FTAPIResource.h"

@protocol FTTemplateDelegate <NSObject>
@optional
- (NSString *)ftTableID;
- (NSString *)ftTemplateID;
- (NSString *)ftTemplateName;
- (NSString *)ftTemplateBody;
@end

@interface FTTemplate : FTAPIResource

@property (nonatomic, weak) id<FTTemplateDelegate> ftTemplateDelegate;

#pragma mark - Fusion Table Styles Lifecycle Methods
- (void)lisFTTemplatesWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)insertFTTemplateWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)updateFTTemplateWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)deleteFTTemplateWithCompletionHandler:(ServiceAPIHandler)handler;


@end


