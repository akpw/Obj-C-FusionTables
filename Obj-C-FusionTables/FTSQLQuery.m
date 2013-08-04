//
//  FTSQLQuery.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 3/8/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "FTSQLQuery.h"

@implementation FTSQLQuery

#pragma mark - Fusion Tables SQL API
#pragma mark SQL API for accessing FT data rows
#define GOOGLE_FT_QUERY_URL (@"https://www.googleapis.com/fusiontables/v1/query")
- (void)queryFusionTablesSQL:(NSString *)sql WithCompletionHandler:(ServiceAPIHandler)handler {
    
    NSString *url = [NSString stringWithFormat:@"%@?sql=%@", GOOGLE_FT_QUERY_URL,
                     [sql stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [[GoogleAuthorizationController sharedInstance] authorizeHTTPFetcher:fetcher
                                                   WithCompletionHandler:^{
                                                       [fetcher beginFetchWithCompletionHandler:handler];
                                                   }];
}

#pragma mark SQL API for modifying FT data rows
- (void)modifyFusionTablesSQL:(NSString *)sql WithCompletionHandler:(ServiceAPIHandler)handler {
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:GOOGLE_FT_QUERY_URL]];
    
    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [[GoogleAuthorizationController sharedInstance] authorizeHTTPFetcher:fetcher WithCompletionHandler:^{
        NSData *postData = [[NSString stringWithFormat:@"sql=%@", sql] dataUsingEncoding:NSUTF8StringEncoding];
        [fetcher setPostData:postData];
        
        [fetcher beginFetchWithCompletionHandler:handler];
    }];    
}





#pragma mark - Fusion Tables SQLQuery Statements
#pragma mark - BUilds Fusion Tables SQL Query Describe Statement
- (NSString *)builDescribeStringForFusionTableID:(NSString *)fusionTableID {
    NSString *sqlString = [NSString stringWithFormat:@"DESCRIBE %@", fusionTableID];
    return sqlString;
};

#pragma mark - Builds Fusion Tables SQL Query Insert Statement
- (NSString *)builSQLInsertStringForColumnNames:(NSArray *)columnNames FTTableID:(NSString *)fusionTableID, ... {
    NSString *insertString = nil;
    NSString *sqlInsertTemplateString = nil;
    
    NSUInteger columnsCount = [columnNames count];
    if (columnsCount > 0) {
        sqlInsertTemplateString = [NSMutableString  stringWithFormat:@"INSERT INTO %@ (", fusionTableID];
        for (NSString *columumnNameString in columnNames) {
            columnsCount--;
            sqlInsertTemplateString = (columnsCount == 0) ?
            [NSString stringWithFormat:@"%@%@) VALUES (", sqlInsertTemplateString, columumnNameString] :
            [NSString stringWithFormat:@"%@%@, ", sqlInsertTemplateString, columumnNameString];
        }
        // Values placeholders
        columnsCount = [columnNames count];
        for (int i=0; i<columnsCount; i++) {
            sqlInsertTemplateString = ((i+1) == columnsCount) ?
            [NSString stringWithFormat:@"%@%@)", sqlInsertTemplateString, @"%@"] :
            [NSString stringWithFormat:@"%@%@, ", sqlInsertTemplateString, @"%@"];
        }
    }
    va_list args;
    va_start(args, fusionTableID);
    insertString =  [[NSString alloc] initWithFormat:sqlInsertTemplateString arguments:args];
    va_end(args);
    
    return insertString;
}

#pragma mark - Builds Fusion Tables SQL Query Update Statement
- (NSString *)builSQLUpdateStringForRowID:(NSUInteger)rowID ColumnNames:(NSArray *)columnNames FTTableID:(NSString *)fusionTableID, ... {
    NSString *ftUpdateString = nil;
    NSString *sqlUPdateTemplateString = nil;
    
    NSUInteger columnsCount = [columnNames count];
    if (columnsCount > 0) {
        sqlUPdateTemplateString = [NSMutableString  stringWithFormat:@"UPDATE %@ SET ", fusionTableID];
        for (NSString *columumnNameString in columnNames) {
            columnsCount--;
            sqlUPdateTemplateString = (columnsCount == 0) ?
            [NSString stringWithFormat:@"%@%@ = %@ WHERE ROWID = '%@'", sqlUPdateTemplateString,
             columumnNameString, @"%@", [NSString stringWithFormat:@"%d", rowID]] :
            [NSString stringWithFormat:@"%@%@ = %@, ", sqlUPdateTemplateString, columumnNameString, @"%@"];
        }
        va_list args;
        va_start(args, fusionTableID);
        ftUpdateString =  [[NSString alloc] initWithFormat:sqlUPdateTemplateString arguments:args];
        va_end(args);
    }
    return ftUpdateString;
}

#pragma mark - Builds Fusion Tables SQL Query Delete Statement
- (NSString *)buildDeleteAllRowStringForFusionTableID:(NSString *)fusionTableID {
    NSString *sqlString = [NSString stringWithFormat:
                           @"DELETE FROM %@ ", fusionTableID];
    return sqlString;
}
- (NSString *)buildDeleteRowStringForFusionTableID:(NSString *)fusionTableID RowID:(NSUInteger)rowID {
    NSString *sqlString = [NSString stringWithFormat:
                           @"DELETE FROM %@ WHERE ROWID = '%u'", fusionTableID, rowID];
    return sqlString;
}

#pragma mark - Tour Fusion Table String Helpers
- (NSString *)buildFTStringValueString:(NSString *)sourceString {
    NSString *ftStringValueString = [sourceString stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
    ftStringValueString = [NSString stringWithFormat:@"'%@'", ftStringValueString];
    return [ftStringValueString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark Tour Fusion Table KML Elements Builders
- (NSString *)buildKMLLineString:(NSString *)coordinatesString {
    return [NSString stringWithFormat:
            @"'<LineString> <coordinates> %@ </coordinates> </LineString>'",
            coordinatesString];
}
- (NSString *)buildKMLPointString:(NSString *)coordinatesString {
    return [NSString stringWithFormat:
            @"'<Point> <coordinates> %@ </coordinates> </Point>'",
            coordinatesString];
}
- (NSString *)buildKMLPolygonString:(NSString *)coordinatesString {
    return [NSString stringWithFormat:
            @"'<Polygon> <outerBoundaryIs> <coordinates> %@ </coordinates> </outerBoundaryIs> </Polygon>'",
            coordinatesString];
}




@end
