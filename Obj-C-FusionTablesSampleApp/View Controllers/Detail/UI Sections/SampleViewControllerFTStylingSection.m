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

//  SampleViewControllerFTStylingSection.m
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    Shows usage of Obj-C-FusionTables for Fusion Tables Map Styles and Templates
****/

#import "SampleViewControllerFTStylingSection.h"
#import "SampleViewController.h"

// Defines rows in section
enum SampleViewControllerFTStylingSectionRows {
    kSampleViewControllerFTStylingSectionStyleRow = 0,
    kSampleViewControllerFTStylingSectionSetInfoWindowRow,
    kSampleViewControllerFTStylingSectionNumRows
};

// States
typedef NS_ENUM (NSUInteger, FTStylingStates) {
    kFTStateStylingUnknown = 0,
    kFTStateStylingNotSet,
    kFTStateStylingSet,
    kFTStateStylingResolving,
    kFTStateStylingSetting
};
typedef NS_ENUM (NSUInteger, FTWindowTemplateStates) {
    kFTStateWindowTemplateUnknown = 0,
    kFTStateWindowTemplateNotSet,
    kFTStateWindowTemplateSet,
    kFTStateWindowTemplateResolving,
    kFTStateWindowTemplateSetting
};

@implementation SampleViewControllerFTStylingSection {
    FTStylingStates ftStylingState;
    FTWindowTemplateStates ftSWindowTemplateState;
}

#pragma mark - Initialisation
- (void)initSpecifics {
    [super initSpecifics];
    
    ftStylingState = kFTStateStylingUnknown;
    ftSWindowTemplateState = kFTStateWindowTemplateUnknown;
}

#pragma mark - GroupedTableSectionsController Table View Data Source
- (NSUInteger)numberOfRows {
    return kSampleViewControllerFTStylingSectionNumRows;
}
enum FTActionTypes {
    kFTActionTypeStyle = 0,
    kFTActionTypeInfoWindow
};
- (void)configureCell:(UITableViewCell *)cell ForRow:(NSUInteger)row {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    switch (row) {
        case kSampleViewControllerFTStylingSectionStyleRow:
            switch (ftStylingState) {
                case kFTStateStylingNotSet:
                    cell.textLabel.text = @"Set sample FT style";
                    cell.accessoryView = [self ftActionButtonWithTag:kFTActionTypeStyle];
                    break;
                case kFTStateStylingSet:    
                    cell.textLabel.text = @"Sample FT style set";
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    break;
                case kFTStateStylingUnknown:
                    [self ftCheckStyle];
                case kFTStateStylingResolving:
                    cell.textLabel.text = @"Resolving FT styling...";
                    [cell setAccessoryView:[self spinnerView]];
                    break;
                case kFTStateStylingSetting: 
                    cell.textLabel.text = @"Setting FT styling...";
                    [cell setAccessoryView:[self spinnerView]];
                    break;
                default:
                    break;
            }
            break;
        case kSampleViewControllerFTStylingSectionSetInfoWindowRow:
            switch (ftSWindowTemplateState) {
                case kFTStateWindowTemplateNotSet:
                    cell.textLabel.text = @"Set sample Info Window Template";
                    cell.accessoryView = [self ftActionButtonWithTag:kFTActionTypeInfoWindow];
                    break;
                case kFTStateWindowTemplateSet:
                    cell.textLabel.text = @"Sample Info Window Template set";
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    break;
                case kFTStateWindowTemplateUnknown:                    
                    [self ftCheckInfoWindowTemplate];
                case kFTStateWindowTemplateResolving:
                    cell.textLabel.text = @"Resolving Info Window Template...";
                    [cell setAccessoryView:[self spinnerView]];
                    break;
                case kFTStateWindowTemplateSetting:
                    cell.textLabel.text = @"Setting Info Window Template...";
                    [cell setAccessoryView:[self spinnerView]];
                    break;
            }            
            break;
        default:
            break;
    }
}
- (void)executeFTAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case kFTActionTypeStyle:
            [self ftSetStyle];
            break;
        case kFTActionTypeInfoWindow:
            [self ftSetInfoWindowTemplate];
            break;
        default:
            break;
    }
}

#pragma mark - GroupedTableSectionsController Table View Delegate
- (NSString *)titleForHeaderInSection {
    return @"Fusion Table Map Styling";
}

#pragma mark - FT Map Styling
- (void)ftCheckStyle {
    if (ftStylingState != kFTStateStylingResolving) {
        ftStylingState = kFTStateStylingResolving;
        [[GoogleServicesHelper sharedInstance] incrementNetworkActivityIndicator];
        
        FTStyle *ftStyle = [[FTStyle alloc] init];
        ftStyle.ftStyleDelegate = self;
        [ftStyle lisFTStylesWithCompletionHandler:^(NSData *data, NSError *error) {
            [[GoogleServicesHelper sharedInstance] decrementNetworkActivityIndicator];
            ftStylingState = kFTStateStylingNotSet;
            if (error) {
                NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
                [[GoogleServicesHelper sharedInstance]
                     showAlertViewWithTitle:@"Fusion Tables Error"
                     AndText: [NSString stringWithFormat:
                                @"Error listing Fusion Table Styles: %@", errorStr]];
            } else {
                NSDictionary *lines = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:kNilOptions error:nil];
                NSLog(@"Fusion Tables styles: %@", lines);
                NSArray *styles = [NSMutableArray arrayWithArray:lines[@"items"]];
                if ([styles count] != 0) {
                    // styling already set
                    ftStylingState = kFTStateStylingSet;
                }
            }
            [self reloadRow:kSampleViewControllerFTStylingSectionStyleRow];
        }];
    }    
}
- (void)ftSetStyle {
    if (ftStylingState != kFTStateStylingSetting) {
        ftStylingState = kFTStateStylingSetting;
        [[GoogleServicesHelper sharedInstance] incrementNetworkActivityIndicator];
        [self reloadRow:kSampleViewControllerFTStylingSectionStyleRow];
        
        FTStyle *ftStyle = [[FTStyle alloc] init];
        ftStyle.ftStyleDelegate = self;
        [ftStyle insertFTStyleWithCompletionHandler:^(NSData *data, NSError *error) {
            [[GoogleServicesHelper sharedInstance] decrementNetworkActivityIndicator];
            if (error) {
                ftStylingState = kFTStateStylingNotSet;
                NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
                [[GoogleServicesHelper sharedInstance]
                    showAlertViewWithTitle:@"Fusion Tables Error"
                    AndText: [NSString stringWithFormat:@"Error applying Fusion Table Style: %@", 
                                                                                            errorStr]];
            } else {
                ftStylingState = kFTStateStylingSet;
                NSDictionary *styleObject = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions error:nil];
                NSLog(@"Set Fusion Table Styling: %@", styleObject);
            }
            [self reloadRow:kSampleViewControllerFTStylingSectionStyleRow];
        }];
    }    
}

#pragma mark - FT Map Info Window Template
- (void)ftCheckInfoWindowTemplate {
    if (ftSWindowTemplateState != kFTStateWindowTemplateResolving) {
        ftSWindowTemplateState = kFTStateWindowTemplateResolving;
        [[GoogleServicesHelper sharedInstance] incrementNetworkActivityIndicator];
        
        FTTemplate *ftTemplate = [[FTTemplate alloc] init];
        ftTemplate.ftTemplateDelegate = self;
        [ftTemplate lisFTTemplatesWithCompletionHandler:^(NSData *data, NSError *error) {
            [[GoogleServicesHelper sharedInstance] decrementNetworkActivityIndicator];
            ftSWindowTemplateState = kFTStateWindowTemplateNotSet;
            if (error) {
                NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
                [[GoogleServicesHelper sharedInstance]
                 showAlertViewWithTitle:@"Fusion Tables Error"
                 AndText: [NSString stringWithFormat:
                           @"Error listing Fusion Table Styles: %@", errorStr]];
            } else {
                NSDictionary *lines = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:kNilOptions error:nil];
                NSLog(@"Fusion Tables styles: %@", lines);
                NSArray *templates = [NSMutableArray arrayWithArray:lines[@"items"]];
                if ([templates count] != 0) {
                    // info window template already set
                    ftSWindowTemplateState = kFTStateWindowTemplateSet;
                }
            }
            [self reloadRow:kSampleViewControllerFTStylingSectionSetInfoWindowRow];
        }];
    }    
}
- (void)ftSetInfoWindowTemplate {
    if (ftSWindowTemplateState != kFTStateWindowTemplateSetting) {
        ftSWindowTemplateState = kFTStateWindowTemplateSetting;
        [self reloadRow:kSampleViewControllerFTStylingSectionSetInfoWindowRow];
        
        FTTemplate *ftTemplate = [[FTTemplate alloc] init];
        ftTemplate.ftTemplateDelegate = self;
        
        [[GoogleServicesHelper sharedInstance] incrementNetworkActivityIndicator];
        [ftTemplate insertFTTemplateWithCompletionHandler:^(NSData *data, NSError *error) {
           [[GoogleServicesHelper sharedInstance] decrementNetworkActivityIndicator];
           if (error) {
               ftSWindowTemplateState = kFTStateWindowTemplateNotSet;
               NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error]; 
               [[GoogleServicesHelper sharedInstance]
                      showAlertViewWithTitle:@"Fusion Tables Error"
                      AndText: [NSString stringWithFormat:
                                    @"Error applying Fusion Table Style: %@", errorStr]];
           } else {
               ftSWindowTemplateState = kFTStateWindowTemplateSet;
               NSDictionary *ftTemplateDict = [NSJSONSerialization JSONObjectWithData:data
                                                                options:kNilOptions error:nil];
               NSLog(@"Set Fusion Table Info Window Template: %@", ftTemplateDict);
           }
           [self reloadRow:kSampleViewControllerFTStylingSectionSetInfoWindowRow];
       }];
    }    
}

#pragma mark - FTStyleDelegate methods
- (NSDictionary *)ftMarkerOptions {
    return @{
             @"iconStyler": @{
                     @"kind": @"fusiontables#fromColumn",
                     @"columnName": @"markerIcon"}
             };
}
- (NSDictionary *)ftPolylineOptions {
    return @{
             @"strokeWeight" : @"4",
             @"strokeColorStyler" : @{
                     @"kind": @"fusiontables#fromColumn",
                     @"columnName": @"lineColor"}
             };
}

#pragma mark - FTTemplateDelegate methods
- (NSString *)ftTemplateBody {
    return
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
}

@end
