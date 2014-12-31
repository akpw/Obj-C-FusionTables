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
#import <QuartzCore/QuartzCore.h>

// Defines rows in section
enum SampleViewControllerFTStylingSectionRows {
    kSampleViewControllerFTStylingSectionStyleRow = 0,
    kSampleViewControllerFTStylingSectionSetInfoWindowRow,
    kSampleViewControllerFTStylingSectionNumRows
};

// FTable styling states
typedef NS_ENUM (NSUInteger, FTStylingStates) {
    kFTStateIdle = 0,
    kFTStateApplyingStyling,
    kFTStateApplyingInfoWindoTemplate
};

@implementation SampleViewControllerFTStylingSection {
    FTStylingStates ftStylingState;
    BOOL ftStylingApplied, ftInfoWindowTemplateApplied;
}

#pragma mark - Initialisation
- (void)initSpecifics {
    [super initSpecifics];
    
    ftStylingState = kFTStateIdle;
    ftStylingApplied = NO;
    ftInfoWindowTemplateApplied = NO;
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
    
    UIButton *actionButton = [self ftActionButton];
    switch (row) {
        case kSampleViewControllerFTStylingSectionStyleRow:
            if (!ftStylingApplied) {
                cell.textLabel.text = @"Set sample FT style";
                cell.accessoryView = actionButton;
                actionButton.tag = kFTActionTypeStyle;
            } else {
                cell.textLabel.text = @"Sample FT style set";
                cell.accessoryView = nil;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        case kSampleViewControllerFTStylingSectionSetInfoWindowRow:
            if (!ftInfoWindowTemplateApplied) {
                cell.textLabel.text = @"Set sample Info Window Template";
                cell.accessoryView = actionButton;
                actionButton.tag = kFTActionTypeInfoWindow;
            } else {
                cell.textLabel.text = @"Sample Info Window Template set";
                cell.accessoryView = nil;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
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

#pragma mark - FT Map Styling
- (void)ftSetStyle {
    if (ftStylingState == kFTStateIdle) {
        ftStylingState = kFTStateApplyingStyling;
        [[GoogleServicesHelper sharedInstance] incrementNetworkActivityIndicator];
        [self reloadSection];

        FTStyle *ftStyle = [[FTStyle alloc] init];
        ftStyle.ftStyleDelegate = self;
        [ftStyle insertFTStyleWithCompletionHandler:^(NSData *data, NSError *error) {
            [[GoogleServicesHelper sharedInstance] decrementNetworkActivityIndicator];
            if (error) {
                NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
                [[GoogleServicesHelper sharedInstance]
                        showAlertViewWithTitle:@"Fusion Tables Error"
                        AndText: [NSString stringWithFormat:@"Error applying Fusion Table Style: %@", errorStr]];
            } else {
                ftStylingApplied = YES;
                NSDictionary *styleObject = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions error:nil];
                NSLog(@"Set Fusion Table Styling: %@", styleObject);
            }
            ftStylingState = kFTStateIdle;
            [self reloadSection];
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


#pragma mark - FT Map Info Window Template
- (void)ftSetInfoWindowTemplate {
    if (ftStylingState == kFTStateIdle) {
        ftStylingState = kFTStateApplyingInfoWindoTemplate;
        [self reloadSection];
        
        FTTemplate *ftTemplate = [[FTTemplate alloc] init];
        ftTemplate.ftTemplateDelegate = self;
        
        [[GoogleServicesHelper sharedInstance] incrementNetworkActivityIndicator];
        [ftTemplate insertFTTemplateWithCompletionHandler:^(NSData *data, NSError *error) {
           [[GoogleServicesHelper sharedInstance] decrementNetworkActivityIndicator];
           if (error) {
               NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error]; 
               [[GoogleServicesHelper sharedInstance]
                      showAlertViewWithTitle:@"Fusion Tables Error"
                      AndText: [NSString stringWithFormat:@"Error applying Fusion Table Style: %@", errorStr]];
           } else {
               ftInfoWindowTemplateApplied = YES;
               NSDictionary *ftTemplateDict = [NSJSONSerialization JSONObjectWithData:data
                                                                options:kNilOptions error:nil];
               NSLog(@"Set Fusion Table Info Window Template: %@", ftTemplateDict);
           }
           ftStylingState = kFTStateIdle;
           [self reloadSection];
       }];
    }    
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

#pragma mark - GroupedTableSectionsController Table View Delegate
- (NSString *)titleForFooterInSection {
    NSString *footerString = nil;
    switch (ftStylingState) {
        case kFTStateIdle:
            footerString = @"Sets Fusion Table Map Styling";
            break;
        case kFTStateApplyingStyling:
            footerString = @"Setting Fusion Table Styling...";
            break;
        case kFTStateApplyingInfoWindoTemplate:
            footerString = @"Setting Info Window Template..";
            break;
        default:
            break;
    }
    return footerString;
}
- (NSString *)titleForHeaderInSection {
    return @"Fusion Table Map Styling";
}


@end
