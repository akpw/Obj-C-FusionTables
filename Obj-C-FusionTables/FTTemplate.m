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

//  FTTemplate.m
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    Represents a Fusion Table Info Window Template. 
    Suports common table operations, such as insert / list / update delete
****/

#import "FTTemplate.h"

@implementation FTTemplate

#pragma mark builds Fusion Tables Template Definition
- (NSDictionary *)ftTemplateDictionary {
    NSMutableDictionary *ftTemplateObject = [NSMutableDictionary dictionary];
    // Template Name
    if ([self.ftTemplateDelegate respondsToSelector:@selector(ftTemplateName)]) {
        ftTemplateObject[@"name"] = [self.ftTemplateDelegate ftTemplateName];
    }
    // Template Body    
    if ([self.ftTemplateDelegate respondsToSelector:@selector(ftTemplateBody)]) {
        ftTemplateObject[@"body"] = [self.ftTemplateDelegate ftTemplateBody];
    }    
    return ftTemplateObject;
}

#pragma mark - Public Methods
#pragma mark - Fusion Table templates Lifecycle Methods
#pragma mark Retrieves a list of templates for a a given tableID
- (void)lisFTTemplatesWithCompletionHandler:(ServiceAPIHandler)handler {
    if (![self.ftTemplateDelegate respondsToSelector:@selector(ftTableID)]) {
        [NSException raise:@"Obj-C-FusionTables Exception"
                    format:@"For this operation, tableID needs to be be provided  by FTTemplateDelegate"];
    }
    NSString *resourceTypeIDString = [NSString stringWithFormat:@"/%@/%@",
                                      [self.ftTemplateDelegate ftTableID], @"templates"];
    [self queryFusionTablesResource:resourceTypeIDString WithCompletionHandler:handler];
}

#pragma mark Creates a new fusion table template
- (void)insertFTTemplateWithCompletionHandler:(ServiceAPIHandler)handler {
    if (![self.ftTemplateDelegate respondsToSelector:@selector(ftTableID)]) {
        [NSException raise:@"Obj-C-FusionTables Exception"
                    format:@"For this operation, tableID needs to be be provided  by FTTemplateDelegate"];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self ftTemplateDictionary]
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    NSString *resourceTypeIDString = [NSString stringWithFormat:@"/%@/%@",
                                      [self.ftTemplateDelegate ftTableID], @"templates"];
    [self modifyFusionTablesResource:resourceTypeIDString
                 PostDataString:jsonString WithCompletionHandler:handler];
}

#pragma mark Updates fusion table style definition
- (void)updateFTTemplateWithCompletionHandler:(ServiceAPIHandler)handler {
    if (![self.ftTemplateDelegate respondsToSelector:@selector(ftTableID)]) {
        [NSException raise:@"Obj-C-FusionTables Exception"
                    format:@"For this operation, tableID needs to be be provided  by FTTemplateDelegate"];
    }
    if (![self.ftTemplateDelegate respondsToSelector:@selector(ftTemplateID)]) {
        [NSException raise:@"Obj-C-FusionTables Exception"
                    format:@"For this operation, templateID needs to be be provided  by FTTemplateDelegate"];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self ftTemplateDictionary]
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    NSString *resourceTypeIDString = [NSString stringWithFormat:@"/%@/%@/%@",
                                      [self.ftTemplateDelegate ftTableID], @"templates",
                                      [self.ftTemplateDelegate ftTemplateID]];
    [self modifyFusionTablesResource:resourceTypeIDString
                      PostDataString:jsonString WithCompletionHandler:handler];
}

#pragma mark Deletes fusion table template with given tableID / templateID
- (void)deleteFTTemplateWithCompletionHandler:(ServiceAPIHandler)handler {
    if (![self.ftTemplateDelegate respondsToSelector:@selector(ftTableID)]) {
        [NSException raise:@"Obj-C-FusionTables Exception"
                    format:@"For this operation, tableID needs to be be provided  by FTTemplateDelegate"];
    }
    if (![self.ftTemplateDelegate respondsToSelector:@selector(ftTemplateID)]) {
        [NSException raise:@"Obj-C-FusionTables Exception"
                    format:@"For this operation, templateID needs to be be provided  by FTTemplateDelegate"];
    }
    NSString *resourceTypeIDString = [NSString stringWithFormat:@"/%@/%@/%@",
                                      [self.ftTemplateDelegate ftTableID], @"templates",
                                      [self.ftTemplateDelegate ftTemplateID]];
    [self deleteFusionTablesResource:resourceTypeIDString WithCompletionHandler:handler];
}


@end
