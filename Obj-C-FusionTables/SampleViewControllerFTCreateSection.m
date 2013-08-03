//
//  SampleViewControllerFTCreateSection.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 19/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "SampleViewControllerFTCreateSection.h"
#import "SimpleGoogleServiceHelpers.h"
#import "FTTable.h"

// Defines rows in section
enum SampleViewControllerFTCreateSectionRows {
    kSampleViewControllerFTCreateSectionCreateRow = 0,
    SampleViewControllerFTCreateSectionNumRows
};

// FTable creation states
typedef NS_ENUM (NSUInteger, FTCreationStates) {
    kFTStateDoesNotExists = 0,
    kFTStatesCreating,
    kFTStatesCreated
};

@implementation SampleViewControllerFTCreateSection {
    FTCreationStates ftState;
}

#pragma mark - Initialisation
- (void)initSpecifics {
    [super initSpecifics];
    
    ftState = kFTStateDoesNotExists;
}

#pragma mark - FTTableDelegate methods
- (NSString *)ftTitle {
    // a quick way of setting a name for the table
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd-hhmmss"];
    return [NSString stringWithFormat:@"Sample_FT_%@", [formatter stringFromDate:[NSDate date]]];
}

#pragma mark - GroupedTableSectionsController Table View Data Source
- (NSUInteger)numberOfRows {
    return SampleViewControllerFTCreateSectionNumRows;
}

- (void)configureCell:(UITableViewCell *)cell ForRow:(NSUInteger)row {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    switch (row) {
        case kSampleViewControllerFTCreateSectionCreateRow:
            if (!self.fusionTableID) {
                cell.accessoryView = [self ftActionButton];
            } else {
                cell.accessoryView = nil;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            cell.textLabel.text = @"Create Fusion Table";
    }
}

#pragma mark Creates Fusion Table Action Handler
- (void)executeFTAction:(id)sender {

    ftState = kFTStatesCreating;
    [[NSNotificationCenter defaultCenter]
            postNotificationName:FUSION_TABLE_CREATION_STARTED_NOTIFICATION object:nil];
    
    FTTable *ftTable = [[FTTable alloc] init];
    ftTable.ftTableDelegate = self;
    
    [[SimpleGoogleServiceHelpers sharedInstance] incrementNetworkActivityIndicator];
    [ftTable insertFusionTableWithCompletionHandler:^(NSData *data, NSError *error) {
        [[SimpleGoogleServiceHelpers sharedInstance] decrementNetworkActivityIndicator];
        if (error) {
            ftState = kFTStateDoesNotExists;
            [[NSNotificationCenter defaultCenter]
                    postNotificationName:FUSION_TABLE_CREATION_FAILED_NOTIFICATION object:nil];
            
            NSData *data = [[error userInfo] valueForKey:@"data"];
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

            [[SimpleGoogleServiceHelpers sharedInstance]
                        showAlertViewWithTitle:@"Fusion Tables Error"
                        AndText: [NSString stringWithFormat:@"Error Creating Fusion Table: %@",
                        str]];
        } else {
            NSDictionary *contentDict = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:kNilOptions error:nil];
            if (contentDict) {
                // All well
                NSString *tableID = contentDict[@"tableId"];

                ftState = kFTStatesCreated;
                [[NSNotificationCenter defaultCenter]
                        postNotificationName:FUSION_TABLE_CREATION_SUCCEDED_NOTIFICATION
                        object:nil
                        userInfo:@{FT_TABLE_ID_KEY: tableID}];
                NSLog(@"Created a new Fusion Table: %@", contentDict);
            } else {
                // the FT Create Table did not return tableid
                [[SimpleGoogleServiceHelpers sharedInstance]
                        showAlertViewWithTitle:@"Fusion Tables Error"
                        AndText:  @"Error Fetching the Fusion Table ID"];
            }
        }        
    }];
}
- (NSArray *)ftColumns {
    return @[
             @{@"name": @"entryDate",
               @"type": @"STRING"
               },
             @{@"name": @"entryName",
               @"type": @"STRING"
               },
             @{@"name": @"entryThumbImageURL",
               @"type": @"STRING"
               },
             @{@"name": @"entryURL",
               @"type": @"STRING"
               },
             @{@"name": @"entryURLDescription",
               @"type": @"STRING"
               },
             @{@"name": @"entryNote",
               @"type": @"STRING"
               },
             @{@"name": @"entryImageURL",
               @"type": @"STRING"
               },
             @{@"name": @"markerIcon",
               @"type": @"STRING"
               },
             @{@"name": @"lineColor",
               @"type": @"STRING"
               },
             @{@"name": @"geometry",
               @"type": @"LOCATION"
               }
             ];
}

#pragma mark - GroupedTableSectionsController Table View Delegate
- (CGFloat)heightForHeaderInSection {
    return 4;
}
- (CGFloat)heightForFooterInSection {
    return (ftState == kFTStatesCreated) ? 56.0f : 30.0f;
}
- (float)heightForRow:(NSInteger)row {
    return 36.0f;
}
- (NSString *)titleForFooterInSection {
    NSString *footerString = nil;
    switch (ftState) {
        case kFTStateDoesNotExists:
            footerString = @"Creates a new Fusion Table";
            break;
        case kFTStatesCreating:
            footerString = @"Now creating a new Fusion Table...";
            break;
        case kFTStatesCreated:
            footerString = [NSString stringWithFormat:@"Created Fusion Table with ID:\n%@", self.fusionTableID];
            break;
        default:
            break;
    }
    return footerString;
}


@end

