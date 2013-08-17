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

//  FTTemplate.h
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

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


