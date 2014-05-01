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

//  FTSQLQueryBuilder.m
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    A helper class for building Fusion Tables SQL statements
****/

#import "FTSQLQueryBuilder.h"

@implementation FTSQLQueryBuilder

#pragma mark - Fusion Tables SQLQuery Statements
// Builds Fusion Tables SQL Query Insert Statement
+ (NSString *)builSQLInsertStringForColumnNames:(NSArray *)columnNames 
                                    FTTableID:(NSString *)fusionTableID, ... {
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

// Builds Fusion Tables SQL Query Update Statement
+ (NSString *)builSQLUpdateStringForRowID:(NSUInteger)rowID 
                                    ColumnNames:(NSArray *)columnNames 
                                    FTTableID:(NSString *)fusionTableID, ... {
    NSString *ftUpdateString = nil;
    NSString *sqlUPdateTemplateString = nil;
    
    NSUInteger columnsCount = [columnNames count];
    if (columnsCount > 0) {
        sqlUPdateTemplateString = [NSMutableString  stringWithFormat:@"UPDATE %@ SET ", fusionTableID];
        for (NSString *columumnNameString in columnNames) {
            columnsCount--;
            sqlUPdateTemplateString = (columnsCount == 0) ?
            [NSString stringWithFormat:@"%@%@ = %@ WHERE ROWID = '%@'", sqlUPdateTemplateString,
             columumnNameString, @"%@", [NSString stringWithFormat:@"%lu", (unsigned long)rowID]] :
            [NSString stringWithFormat:@"%@%@ = %@, ", sqlUPdateTemplateString, columumnNameString, @"%@"];
        }
        va_list args;
        va_start(args, fusionTableID);
        ftUpdateString =  [[NSString alloc] initWithFormat:sqlUPdateTemplateString arguments:args];
        va_end(args);
    }
    return ftUpdateString;
}

// Builds Fusion Tables SQL Query Delete Statement
+ (NSString *)buildDeleteAllRowStringForFusionTableID:(NSString *)fusionTableID {
    NSString *sqlString = [NSString stringWithFormat:
                           @"DELETE FROM %@ ", fusionTableID];
    return sqlString;
}
+ (NSString *)buildDeleteRowStringForFusionTableID:(NSString *)fusionTableID RowID:(NSUInteger)rowID {
    NSString *sqlString = [NSString stringWithFormat:
                           @"DELETE FROM %@ WHERE ROWID = '%lu'", fusionTableID, (unsigned long)rowID];
    return sqlString;
}

#pragma mark - Fusion Table SQL Statements Values Helpers
+ (NSString *)buildFTStringValueString:(NSString *)sourceString {
    NSString *ftStringValueString = [sourceString stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
    ftStringValueString = [NSString stringWithFormat:@"'%@'", ftStringValueString];
    return [ftStringValueString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - Fusion Table KML Elements Helpers
+ (NSString *)buildKMLLineString:(NSString *)coordinatesString {
    return [NSString stringWithFormat:
            @"'<LineString> <coordinates> %@ </coordinates> </LineString>'",
            coordinatesString];
}
+ (NSString *)buildKMLPointString:(NSString *)coordinatesString {
    return [NSString stringWithFormat:
            @"'<Point> <coordinates> %@ </coordinates> </Point>'",
            coordinatesString];
}
+ (NSString *)buildKMLPolygonString:(NSString *)coordinatesString {
    return [NSString stringWithFormat:
            @"'<Polygon> <outerBoundaryIs> <coordinates> %@ </coordinates> </outerBoundaryIs> </Polygon>'",
            coordinatesString];
}




@end
