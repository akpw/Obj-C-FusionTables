//
//  FTBuilder.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 25/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "FTBuilder.h"

@implementation FTBuilder

#pragma mark - Fusion Tables Structure
+ (NSArray *)columnNames {
    // define in descendants
    return nil;
}
+ (NSArray *)columnTypes {
    // define in descendants
    return nil;
}
#pragma mark - Builds the columns string for create Fusion Table statement
+ (NSArray *)buildFusionTableColumns {
    NSMutableArray *tableColumns = [NSMutableArray array];
    
    NSArray *columnNames = [self columnNames];
    NSArray *columnTypes = [self columnTypes];
    if ([columnTypes count] != [columnNames count]) {
        [NSException raise:@"FusionTableBuilderException" format:@"Columns names / types number mismatch!"];
    } else {
        NSUInteger columnTypesIndex = 0;
        for (NSString *columumnNameString in columnNames) {
            NSMutableDictionary *aColumn = [NSMutableDictionary dictionary];
            aColumn[@"name"] = columumnNameString;
            aColumn[@"type"] = columnTypes[columnTypesIndex];
            [tableColumns addObject:aColumn];
            columnTypesIndex++;
        }
    }
    return tableColumns;
}
+ (NSDictionary *)buildFusionTableStructureDictionary:(NSString *)tableTitle
                                      WithDescription:(NSString *)tableDescription IsExportable:(BOOL)exportable{
    return nil;
}

#pragma mark - Fusion Tables Styles
+ (NSDictionary *)buildFusionTableStyleForFusionTableID:(NSString *)fusionTableID {
    return nil;
}

#pragma mark - Builds FTable Info Window Template
+ (NSDictionary *)buildInfoWindowTemplate {
    return nil;
}

#pragma mark - Fusion Tables SQLQuery Statements
#pragma mark - BUilds Fusion Tables SQL Query Describe Statement
+ (NSString *)builDescribeStringForFusionTableID:(NSString *)fusionTableID {
    NSString *sqlString = [NSString stringWithFormat:@"DESCRIBE %@", fusionTableID];
    return sqlString;
};

#pragma mark - Builds Fusion Tables SQL Query Insert Statement
+ (NSString *)builSQLInsertStringForFTTableID:(NSString *)fusionTableID, ... {
    NSString *insertString = nil;
    NSMutableString *sqlInsertTemplateString = nil;

    NSArray *columnNames = [self columnNames];
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
+ (NSString *)builSQLUpdateStringForRowID:(NSUInteger)rowID FTTableID:(NSString *)fusionTableID, ... {
    NSString *ftUpdateString = nil;
    NSMutableString *sqlUPdateTemplateString = nil;

    NSArray *columnNames = [self columnNames];
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
+ (NSString *)buildDeleteAllRowStringForFusionTableID:(NSString *)fusionTableID {
    NSString *sqlString = [NSString stringWithFormat:
                           @"DELETE FROM %@ ", fusionTableID];
    return sqlString;
}
+ (NSString *)buildDeleteRowStringForFusionTableID:(NSString *)fusionTableID RowID:(NSUInteger)rowID {
    NSString *sqlString = [NSString stringWithFormat:
                           @"DELETE FROM %@ WHERE ROWID = '%u'", fusionTableID, rowID];
    return sqlString;
}

#pragma mark - Tour Fusion Table String Helpers
+ (NSString *)buildFTStringValueString:(NSString *)sourceString {
    NSString *ftStringValueString = [sourceString stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
    ftStringValueString = [NSString stringWithFormat:@"'%@'", ftStringValueString];
    return [ftStringValueString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark Tour Fusion Table KML Elements Builders
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










