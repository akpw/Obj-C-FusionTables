//
//  SampleViewControllerStartStopTickingButtonSection.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 20/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//


#import "SampleViewControllerFTSharingSection.h"

// Defines rows in section
enum SampleViewControllerFTSharingSectionRows {
    kSampleViewControllerFTSharingRowSection = 0,
    SampleViewControllerFTSharingSectionNumRows
};


// FTable sharing states
typedef NS_ENUM (NSUInteger, FTSharingStates) {
    kFTStateIdle = 0,
    kFTStateSharing
};


@implementation SampleViewControllerFTSharingSection {
    FTSharingStates ftSharingRowState;
}


#pragma mark - GroupedTableSectionsController Table View Data Source
- (NSUInteger)numberOfRows {
    return SampleViewControllerFTSharingSectionNumRows;
}

- (void)configureCell:(UITableViewCell *)cell ForRow:(NSUInteger)row {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    cell.backgroundColor = (self.fusionTableID) ? [UIColor whiteColor] : [UIColor lightGrayColor];
    cell.userInteractionEnabled = (self.fusionTableID) ? YES : NO;
    
    switch (row) {
        case kSampleViewControllerFTSharingRowSection:
            cell.textLabel.text = @"Share Fusion Table";
            cell.accessoryView = [self ftActionButton];
            break;
        default:
            break;
    }
}
- (void)executeFTAction:(id)sender {
}

#pragma mark - GroupedTableSectionsController Table View Delegate
- (NSString *)titleForFooterInSection {
    NSString *footerString = nil;
    if (self.fusionTableID) {
        switch (ftSharingRowState) {
            case kFTStateIdle:
                footerString = @"Share Fusion Tables";
                break;
            case kFTStateSharing:
                footerString = @"Sharing Fusion Table...";
                break;
            default:
                break;
        }
    } else {
        footerString = @"Create Fusion Table before sharing";
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
