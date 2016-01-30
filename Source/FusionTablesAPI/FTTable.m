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

//  FTTable.m
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    Represents a Fusion Table. 
    Suports common table operations, such as insert / list / update delete
****/

#import "FTTable.h"

@implementation FTTable

#pragma mark - Internal Methods
#pragma mark builds Fusion Tables Structure 
- (NSDictionary *)ftStructureDictionary {
    NSMutableDictionary *tableDictionary = [NSMutableDictionary dictionary];    
    // Table Title
    if ([self.ftTableDelegate respondsToSelector:@selector(ftName)]) {
        tableDictionary[@"name"] = [self.ftTableDelegate ftName];
    } else {        
        [NSException raise:@"Obj-C-FusionTables Exception"
                    format:@"For Insert / Update, a table name must be provided  by FTDelegate"];
    }
    // Table Columns
    if ([self.ftTableDelegate respondsToSelector:@selector(ftColumns)]) {
        tableDictionary[@"columns"] = [self.ftTableDelegate ftColumns];
    } else {
        [NSException raise:@"Obj-C-FusionTables Exception"
                    format:@"For Insert / Update, columns definition must be provided  by FTDelegate"];
    }    
    // Exportable?
    if ([self.ftTableDelegate respondsToSelector:@selector(ftIsExportable)]) {
        tableDictionary[@"isExportable"] = ([self.ftTableDelegate ftIsExportable]) ? @"true" : @"false";
    } else {
        tableDictionary[@"isExportable"] = @"true";
    }
    // Table Description
    if ([self.ftTableDelegate respondsToSelector:@selector(ftDescription)]) {
        tableDictionary[@"description"] = [self.ftTableDelegate ftDescription];
    }    
    
    return tableDictionary;
}

#pragma mark - Fusion Table Lifecycle Methods
#pragma mark Retrieves a list of tables for an authenticated user
- (void)listFusionTablesWithCompletionHandler:(ServiceAPIHandler)handler {
    [self queryFusionTablesResource:nil WithCompletionHandler:handler];
}

#pragma mark Creates a new fusion table
- (void)insertFusionTableWithCompletionHandler:(ServiceAPIHandler)handler {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self ftStructureDictionary]
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    [self modifyFusionTablesResource:nil
                 PostDataString:jsonString WithCompletionHandler:handler];
}

#pragma mark Updates fusion table structure
- (void)updateFusionTableWithCompletionHandler:(ServiceAPIHandler)handler {    
    if (![self.ftTableDelegate respondsToSelector:@selector(ftTableID)]) {
        [NSException raise:@"Obj-C-FusionTables Exception"
                    format:@"For this operation, tableID needs to be be provided  by FTDelegate"];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self ftStructureDictionary]
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    NSString *resourceTypeIDString = [NSString stringWithFormat:@"/%@", [self.ftTableDelegate ftTableID]];
    [self modifyFusionTablesResource:resourceTypeIDString
                      PostDataString:jsonString WithCompletionHandler:handler];

}

#pragma mark Deletes fusion table
- (void)deleteFusionTableWithCompletionHandler:(ServiceAPIHandler)handler {
    if (![self.ftTableDelegate respondsToSelector:@selector(ftTableID)]) {
        [NSException raise:@"Obj-C-FusionTables Exception"
                    format:@"For this operation, tableID needs to be be provided  by FTDelegate"];
    }    
    NSString *resourceTypeIDString = [NSString stringWithFormat:@"/%@", [self.ftTableDelegate ftTableID]];
    [self deleteFusionTablesResource:resourceTypeIDString WithCompletionHandler:handler];
}


@end
