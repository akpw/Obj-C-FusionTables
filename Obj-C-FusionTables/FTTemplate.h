//
//  FTTemplate.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 25/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "FTAPIResource.h"

@protocol FTTemplateDelegate <NSObject>
@required
- (NSString *)ftTableID;
- (NSString *)ftTemplateName;
- (NSString *)ftTemplateBody;
@end


@interface FTTemplate : FTAPIResource

@property (nonatomic, weak) id<FTTemplateDelegate> ftTemplateDelegate;

- (void)insertFTTemplateWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)lisFTTemplatesWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)updateFTTemplateWithCompletionHandler:(ServiceAPIHandler)handler;
- (void)deleteFTTemplateWithCompletionHandler:(ServiceAPIHandler)handler;


#pragma mark - Quering FT templates metadata
- (void)queryTemplatesForFusionTable:(NSString *)fusionTableID WithCompletionHandler:(ServiceAPIHandler)handler;

#pragma mark - Setting FT templates metadata
- (void)setFusionTableInfoWindow:(NSDictionary *)infoWindowTemplateDictionary
                    ForFusionTableID:(NSString *)fusionTableID
                    WithCompletionHandler:(ServiceAPIHandler)handler;


@end
