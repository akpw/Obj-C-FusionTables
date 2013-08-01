//
//  SampleViewControllerFTStylingSection.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 19/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "SampleViewControllerFTStylingSection.h"
#import <QuartzCore/QuartzCore.h>
#import "AppGeneralServicesController.h"
#import "SampleFTBuilder.h"
#import "FTStyle.h"
#import "FTTemplate.h"

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

#pragma mark - GroupedTableSectionsController Table View Data Source
#define FT_ACTION_TYPE_KEY (@"FT_Action_Type_Key")
- (void)configureCell:(UITableViewCell *)cell ForRow:(NSUInteger)row {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    cell.backgroundColor = (self.fusionTableID) ? [UIColor whiteColor] : [UIColor lightGrayColor];    
    cell.userInteractionEnabled = (self.fusionTableID) ? YES : NO;
    
    UIButton *actionButton = [self ftActionButton];
    cell.accessoryView = actionButton;    
    switch (row) {
        case kSampleViewControllerFTStylingSectionStyleRow:
            cell.textLabel.text = @"Set FT Table Styling";
            if (!ftStylingApplied) {
                cell.accessoryView = actionButton;
                [actionButton.layer setValue:@(kFTActionTypeStyle) forKey:FT_ACTION_TYPE_KEY];
            } else {
                cell.accessoryView = nil;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        case kSampleViewControllerFTStylingSectionSetInfoWindowRow:
            cell.textLabel.text = @"Set Info Window Template";
            if (!ftInfoWindowTemplateApplied) {
                cell.accessoryView = actionButton;
                [actionButton.layer setValue:@(kFTActionTypeInfoWindow) forKey:FT_ACTION_TYPE_KEY];
            } else {
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

- (void)ftSetStyle {
    if (self.fusionTableID) {
        ftStylingState = kFTStateApplyingStyling;
        [[AppGeneralServicesController sharedInstance] incrementNetworkActivityIndicator];
        [self reloadSection];

        NSDictionary *styleDict = [SampleFTBuilder
                                   buildFusionTableStyleForFusionTableID:self.fusionTableID];
        FTStyle *ftStyle = [[FTStyle alloc] init];
        [ftStyle setFusionTableStyle:styleDict
                    ForFusionTableID:self.fusionTableID
                    WithCompletionHandler:^(NSData *data, NSError *error) {
            [[AppGeneralServicesController sharedInstance] decrementNetworkActivityIndicator];
            if (error) {
                NSData *data = [[error userInfo] valueForKey:@"data"];
                NSString *infoString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [[AppGeneralServicesController sharedInstance]
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
- (void)ftSetInfoWindowTemplate {
    if (self.fusionTableID) {
        ftStylingState = kFTStateApplyingInfoWindoTemplate;
        [self reloadSection];
        
        NSDictionary *templDict = [SampleFTBuilder buildInfoWindowTemplate];
        FTTemplate *ftTemplate = [[FTTemplate alloc] init];
        [[AppGeneralServicesController sharedInstance] incrementNetworkActivityIndicator];
        [ftTemplate setFusionTableInfoWindow:templDict ForFusionTableID:self.fusionTableID
                                            WithCompletionHandler:^(NSData *data, NSError *error) {
           [[AppGeneralServicesController sharedInstance] decrementNetworkActivityIndicator];
           if (error) {
               NSData *data = [[error userInfo] valueForKey:@"data"];
               NSString *infoString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
               [[AppGeneralServicesController sharedInstance]
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

#pragma mark - GroupedTableSectionsController Table View Delegate
- (NSString *)titleForFooterInSection {
    NSString *footerString = nil;
    if (self.fusionTableID) {
        switch (ftStylingState) {
            case kFTStateIdle:
                footerString = @"Sets Fusion Table Info Window & Styling";
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
        footerString = @"Create Fusion Table before Styling";
    }
    return footerString;
}
- (CGFloat)heightForFooterInSection {
    return 40.0f;
}
- (float)heightForRow:(NSInteger)row {
    return 36.0f;
}




@end
