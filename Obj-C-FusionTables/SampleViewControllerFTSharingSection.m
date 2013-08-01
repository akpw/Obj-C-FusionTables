//
//  SampleViewControllerStartStopTickingButtonSection.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 20/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//


#import "SampleViewControllerFTSharingSection.h"

// FTable styling states
typedef NS_ENUM (NSUInteger, FTInsertRowsStates) {
    kFTStateIdle = 0,
    kFTStateInsertingRows,
    kFTStateInsertedRows,
};


@implementation SampleViewControllerFTSharingSection {
    FTInsertRowsStates ftInsertRowState;
}

// Defines rows in section
enum SampleViewControllerFTInsertSectionRows {
    kSampleViewControllerFTInsertRowSection = 0,
    SampleViewControllerFTInsertSectionNumRows
};



#pragma mark - GroupedTableSectionsController Table View Data Source
- (NSUInteger)numberOfRows {
    return SampleViewControllerFTInsertSectionNumRows;
}

- (void)configureCell:(UITableViewCell *)cell ForRow:(NSUInteger)row {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    cell.backgroundColor = (self.fusionTableID) ? [UIColor whiteColor] : [UIColor lightGrayColor];
    cell.userInteractionEnabled = (self.fusionTableID) ? YES : NO;
    
    switch (row) {
        case kSampleViewControllerFTInsertRowSection:
            cell.textLabel.text = @"Share Fusion Table";
            if (ftInsertRowState == kFTStateInsertedRows) {
                cell.accessoryView = nil;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryView = [self ftActionButton];
            }
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
        switch (ftInsertRowState) {
            case kFTStateIdle:
                footerString = @"Share Fusion Tables";
                break;
            case kFTStateInsertingRows:
                footerString = @"Sharing Fusion Table...";
                break;
            case kFTStateInsertedRows:
                footerString = @"Fusion Tables Shared";
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
