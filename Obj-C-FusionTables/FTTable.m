//
//  FTTable.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 25/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "FTTable.h"

@implementation FTTable

#pragma mark - Fusion Tables Structure
- (NSDictionary *)ftStructureDictionary {
    NSMutableDictionary *tableDictionary = [NSMutableDictionary dictionary];
    // Table Title
    tableDictionary[@"name"] = [self.ftTableDelegate ftTitle];
    
    // Table Columns
    tableDictionary[@"columns"] = [self.ftTableDelegate ftColumns];
    
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
- (void)insertFusionTableWithCompletionHandler:(ServiceAPIHandler)handler {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self ftStructureDictionary]
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    [self modifyFusionTablesAPI:nil
                 PostDataString:jsonString WithCompletionHandler:handler];
}

#pragma mark - Fusion Tables Structure


- (void)listFusionTablesWithCompletionHandler:(ServiceAPIHandler)handler {
    
}

- (void)updateFusionTableWithCompletionHandler:(ServiceAPIHandler)handler {
    
}

- (void)deleteFusionTableWithCompletionHandler:(ServiceAPIHandler)handler {
    
}




@end
