//
//  SampleViewControllerFTStylingSection.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 19/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

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

#pragma mark - GroupedTableSectionsController Table View Data Source
enum FTActionTypes {
    kFTActionTypeStyle = 0,
    kFTActionTypeInfoWindow
};
#define FT_ACTION_TYPE_KEY (@"FT_Action_Type_Key")
- (void)configureCell:(UITableViewCell *)cell ForRow:(NSUInteger)row {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    UIButton *actionButton = [self ftActionButton];
    cell.accessoryView = actionButton;    
    switch (row) {
        case kSampleViewControllerFTStylingSectionStyleRow:
            if (!ftStylingApplied) {
                cell.textLabel.text = @"Set sample FT style";
                cell.accessoryView = actionButton;
                [actionButton.layer setValue:@(kFTActionTypeStyle) forKey:FT_ACTION_TYPE_KEY];
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
                [actionButton.layer setValue:@(kFTActionTypeInfoWindow) forKey:FT_ACTION_TYPE_KEY];
            } else {
                cell.textLabel.text = @"Sample Info Window Template set";
                cell.accessoryView = nil;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }            
            break;
        default:
            break;
    }
    if (![self isSampleAppFusionTable]) {
        cell.userInteractionEnabled = NO;
        cell.backgroundColor = [UIColor clearColor];
    }
}
- (void)executeFTAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSNumber *actionType =  (NSNumber *)[button.layer valueForKey:FT_ACTION_TYPE_KEY];
    switch ([actionType integerValue]) {
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
#undef FT_ACTION_TYPE_KEY


#pragma mark - FT Map Styling
- (void)ftSetStyle {
    if (ftStylingState == kFTStateIdle) {
        ftStylingState = kFTStateApplyingStyling;
        [[SimpleGoogleServiceHelpers sharedInstance] incrementNetworkActivityIndicator];
        [self reloadSection];

        FTStyle *ftStyle = [[FTStyle alloc] init];
        ftStyle.ftStyleDelegate = self;
        [ftStyle insertFTStyleWithCompletionHandler:^(NSData *data, NSError *error) {
            [[SimpleGoogleServiceHelpers sharedInstance] decrementNetworkActivityIndicator];
            if (error) {
                NSData *data = [[error userInfo] valueForKey:@"data"];
                NSString *infoString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [[SimpleGoogleServiceHelpers sharedInstance]
                        showAlertViewWithTitle:@"Fusion Tables Error"
                        AndText: [NSString stringWithFormat:@"Error applying Fusion Table Style: %@",
                        infoString]];
            } else {
                ftStylingApplied = YES;
                NSArray *lines = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions error:nil];
                NSLog(@"Set Fusion Table Styling: %@", lines);
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
        
        [[SimpleGoogleServiceHelpers sharedInstance] incrementNetworkActivityIndicator];
        [ftTemplate insertFTTemplateWithCompletionHandler:^(NSData *data, NSError *error) {
           [[SimpleGoogleServiceHelpers sharedInstance] decrementNetworkActivityIndicator];
           if (error) {
               NSData *data = [[error userInfo] valueForKey:@"data"];
               NSString *infoString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
               [[SimpleGoogleServiceHelpers sharedInstance]
                      showAlertViewWithTitle:@"Fusion Tables Error"
                      AndText: [NSString stringWithFormat:@"Error applying Fusion Table Style: %@",
                      infoString]];
           } else {
               ftInfoWindowTemplateApplied = YES;
               NSArray *lines = [NSJSONSerialization JSONObjectWithData:data
                                                                options:kNilOptions error:nil];
               NSLog(@"Set Fusion Table Info Window Template: %@", lines);
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
    if ([self isSampleAppFusionTable]) {
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
    } else {
        footerString = @"To apply map styling, please choose\n"
                        "a Fusion Table created with this App";
    }
    return footerString;
}
- (NSString *)titleForHeaderInSection {
    return @"Fusion Table Map Styling";
}
- (CGFloat)heightForHeaderInSection {
    return 32.0f;
}
- (CGFloat)heightForFooterInSection {
    return ([self isSampleAppFusionTable]) ? 40.0f : 60.0f;
}
- (float)heightForRow:(NSInteger)row {
    return 36.0f;
}




@end
