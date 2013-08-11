//
//  FTTable.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 25/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

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
    if ([self.ftTableDelegate respondsToSelector:@selector(ftTitle)]) {
        tableDictionary[@"name"] = [self.ftTableDelegate ftTitle];
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
    // Table Description
    if ([self.ftTableDelegate respondsToSelector:@selector(ftDescription)]) {
        tableDictionary[@"description"] = [self.ftTableDelegate ftDescription];
    }    
    // Exportable?
    if ([self.ftTableDelegate respondsToSelector:@selector(ftIsExportable)]) {
        tableDictionary[@"isExportable"] = ([self.ftTableDelegate ftIsExportable]) ? @"true" : @"false";
    } else {
        tableDictionary[@"isExportable"] = @"true";
    }
    
    return tableDictionary;
}

#pragma mark - Public Methods
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
