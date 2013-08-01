//
//  SampleFTQueryBuilder.m
//  Obj-C-FusionTables
//
//  Created by Arseniy Kuznetsov on 5/10/11.
//  Copyright 2011 Arseniy Kuznetsov. All rights reserved.
//

#import "SampleFTQueryBuilder.h"

@implementation SampleFTQueryBuilder

+ (NSArray *)columnNames {
    return @[
             @"entryDate",
             @"entryName",
             @"entryThumbImageURL",
             @"entryURL",
             @"entryURLDescription",
             @"entryNote",
             @"entryImageURL",
             @"markerIcon",
             @"lineColor",
             @"geometry"
             ];
}
+ (NSArray *)columnTypes {
    return @[
             @"STRING",
             @"STRING",
             @"STRING",
             @"STRING",
             @"STRING",
             @"STRING",
             @"STRING",
             @"STRING",
             @"STRING",
             @"LOCATION"
             ];
}

#pragma mark Tour Fusion Table Structure Methods
+ (NSDictionary *)buildFusionTableStructureDictionary:(NSString *)tableTitle
                                   WithDescription:(NSString *)tableDescription IsExportable:(BOOL)exportable{
    NSMutableDictionary *tableDictionary = [NSMutableDictionary dictionary];
    // Table Title
    tableDictionary[@"name"] = tableTitle;
    
    // Table Columns
    tableDictionary[@"columns"] = [SampleFTQueryBuilder buildFusionTableColumns];

    // Table Description
    if (tableDescription) {
        tableDictionary[@"description"] = tableDescription;
    }

    // Exportable?
    tableDictionary[@"isExportable"] = (exportable) ? @"true" : @"false";

    return tableDictionary;
}


#pragma mark Tour Fusion Table Styling
+ (NSDictionary *)buildFusionTableStyleForFusionTableID:(NSString *)fusionTableID {
    NSMutableDictionary *jsonStyleObject = [NSMutableDictionary dictionary];
    jsonStyleObject[@"name"] = @"style-Sample-1";
    jsonStyleObject[@"tableId"] = fusionTableID;
    jsonStyleObject[@"isDefaultForTable"] = @"true";
    
    // Icon Marker Options Object
    NSMutableDictionary *jsonMarkerOptionsObject = [NSMutableDictionary dictionary];
    NSMutableDictionary *jsonIconStylerObject = [NSMutableDictionary dictionary];
    jsonIconStylerObject[@"kind"] = @"fusiontables#fromColumn";
    jsonIconStylerObject[@"columnName"] = @"markerIcon";
    jsonMarkerOptionsObject[@"iconStyler"] = jsonIconStylerObject;
    jsonStyleObject[@"markerOptions"] = jsonMarkerOptionsObject;
    
    // Line Color Options Object
    NSMutableDictionary *jsonPolylineOptionsObject = [NSMutableDictionary dictionary];
    NSMutableDictionary *jsonStrokeColorStylerObject = [NSMutableDictionary dictionary];
    jsonStrokeColorStylerObject[@"kind"] = @"fusiontables#fromColumn";
    jsonStrokeColorStylerObject[@"columnName"] = @"lineColor";
    jsonPolylineOptionsObject[@"strokeWeight"] = @"4";
    jsonPolylineOptionsObject[@"strokeColorStyler"] = jsonStrokeColorStylerObject;
    jsonStyleObject[@"polylineOptions"] = jsonPolylineOptionsObject;

    return jsonStyleObject;    
}

#pragma mark Tour Fusion Table Info Window
+ (NSString *)buildInfoWindowTemplateString {
    NSString *infoWindowTemplateString =
        @"<div class='googft-info-window'"
        "style='font-family: sans-serif; width: 19em; height: 20em; overflow: auto;'>"
        "<img src='{entryThumbImageURL}' style='float:left; width:2em; vertical-align: top; margin-right:.5em'/>"
        "<b>{entryName}</b>"
        "<br>{entryDate}<br>"
        "<p><a href='{entryURL}'>{entryURLDescription}</a>"
        "<p>{entryNote}"
        "<a href='{entryImageURL}' target='_blank'> "
        "<img src='{entryImageURL}' style='width:18.5em; margin-top:.5em; margin-bottom:.5em'/>"
        "</a>"
        "<p>"
        "<p>"
        "</div>";
    return infoWindowTemplateString;
}
+ (NSDictionary *)buildInfoWindowTemplate {
    NSMutableDictionary* jsonObject = [NSMutableDictionary dictionary];
    
    NSString *infoWindowTemplate = [self buildInfoWindowTemplateString];
    
    jsonObject[@"body"] = infoWindowTemplate;
    jsonObject[@"name"] = @"template-Sample-1";
    
    return jsonObject;
}

@end










