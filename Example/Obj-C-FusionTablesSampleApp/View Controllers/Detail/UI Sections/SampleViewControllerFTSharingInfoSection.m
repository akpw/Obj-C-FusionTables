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

//  SampleViewControllerStartStopTickingButtonSection.m
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    Shows usage of Obj-C-FusionTables for setting Fusion Tables user permissions / sharing
****/

#import "SampleViewControllerFTSharingInfoSection.h"
#import "AppGeneralServicesController.h"
#import "AppIconsController.h"
#import "SampleViewController.h"
#import "FusionTableViewerViewController.h"

// Defines rows in section
enum SampleViewControllerFTSharingInfoSectionRows {
    kSampleViewControllerFTSharingStartRow = 0,
    SampleViewControllerFTSharingInfoSectionNumRows
};

// FTable sharing states
typedef NS_ENUM (NSUInteger, FTSharingStates) {
    kFTStateIdle = 0,
    kFTStateSharing,
    kFTStateShorteningURL
};

@interface SampleViewControllerFTSharingInfoSection ()
    @property (nonatomic, strong) NSString *sharedMapURL;
    @property (nonatomic, strong) NSString *sharedDataURL;
@end

@implementation SampleViewControllerFTSharingInfoSection {
    FTSharingStates ftSharingRowState;
}

#pragma mark - GroupedTableSectionsController Table View Data Source
- (NSUInteger)numberOfRows {
    return SampleViewControllerFTSharingInfoSectionNumRows;
}
- (void)configureCell:(UITableViewCell *)cell ForRow:(NSUInteger)row {
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [[AppGeneralServicesController sharedAppTheme] 
                                                tableViewCellButtonBackgroundColor];
    cell.textLabel.text = @"Show Fusion Table";
    cell.textLabel.textColor = [[AppGeneralServicesController sharedAppTheme]
                                                                tableViewCellButtonTextLabelColor];
    cell.userInteractionEnabled = (ftSharingRowState == kFTStateIdle) ? YES : NO;
}

#pragma mark - GroupedTableSectionsController Table View Data Delegate
- (void)tableView:(UITableView *)tableView DidSelectRow:(NSInteger)row {
    [self shareFusionTableWithCompletionHandler:^{
        [self shortenURLWithCompletionHandler:^{
            [self showFTViewer];
        }];
    }];            
}
- (UIView *)viewForFooterInSection {
    UILabel *footerLabel = [[UILabel alloc] init];
    footerLabel.text = [self titleForFooterInSection];
    footerLabel.textColor = [UIColor grayColor];
    footerLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    return footerLabel;
}
- (NSString *)titleForFooterInSection {
    NSString *footerString = nil;
    switch (ftSharingRowState) {
        case kFTStateIdle:
            footerString = @"";
            break;
        case kFTStateSharing:
            footerString = @"Sharing the Fusion Table...";
            break;
        case kFTStateShorteningURL:
            footerString = @"Shortening the sharing URLs...";
            break;
        default:
            break;
    }
    return footerString;
}

#pragma mark - FT user permissions / sharing
- (void)shareFusionTableWithCompletionHandler:(void_completion_handler_block)completionHandler {
    ftSharingRowState = kFTStateSharing;
    [self reloadSection];
    
    [[GoogleServicesHelper sharedInstance] incrementNetworkActivityIndicator];
    [[GoogleServicesHelper sharedInstance] 
                            setPublicSharingForFileWithID:[self ftTableID]
                            WithCompletionHandler:^(NSData *data, NSError *error) {
        [[GoogleServicesHelper sharedInstance] decrementNetworkActivityIndicator];
            ftSharingRowState = kFTStateIdle;
            [self reloadSection];                                
            if (error) {
                NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
                [[GoogleServicesHelper sharedInstance]
                        showAlertViewWithTitle:@"Fusion Tables Error"
                        AndText: [NSString stringWithFormat:@"Error Sharing Fusion Table: %@", errorStr]];
            } else {
                completionHandler ();
            }
     }];
}

#pragma mark - URLs shortening 
- (void)shortenURLWithCompletionHandler:(void_completion_handler_block)completionHandler {
    if (self.sharedMapURL && self.sharedDataURL) {
        completionHandler();
    } else {
        ftSharingRowState = kFTStateShorteningURL;
        [self reloadSection];
        
        void(^errorHandler)(NSError *error, NSString *activityTypeMsg) = 
                                            ^(NSError *error, NSString *activityTypeMsg) {
            NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
            [[GoogleServicesHelper sharedInstance]
                showAlertViewWithTitle:@"Fusion Tables Error"
                AndText: [NSString stringWithFormat:
                            @"Error while %@: %@", activityTypeMsg, errorStr]];    
            ftSharingRowState = kFTStateIdle; 
            [self reloadSection];
        };
        
        // Data URL shortening block
        void_completion_handler_block shareDataUrlBlock = ^{
            [[GoogleServicesHelper sharedInstance] incrementNetworkActivityIndicator];
            [[GoogleServicesHelper sharedInstance] shortenURL:[self longShareDataURL]
                                        WithCompletionHandler:^(NSData *data, NSError *error) {
                [[GoogleServicesHelper sharedInstance] decrementNetworkActivityIndicator];
                ftSharingRowState = kFTStateIdle;                    
                if (error) {
                    errorHandler(error, @"shortening FT Data URL");
                } else {
                    NSDictionary *lines = [NSJSONSerialization
                                                JSONObjectWithData:data 
                                                options:kNilOptions error:nil];
                    NSLog(@"%@", lines);
                    self.sharedDataURL = lines[@"id"];
                    
                    ftSharingRowState = kFTStateIdle; 
                    [self reloadSection];

                    completionHandler ();
                }
            }];
        };
        
        // shorten Map URL, then run the Data URL shortening block 
        [[GoogleServicesHelper sharedInstance] incrementNetworkActivityIndicator];
        [[GoogleServicesHelper sharedInstance] shortenURL:[self longShareMapURL]
                                          WithCompletionHandler:^(NSData *data, NSError *error) {
             [[GoogleServicesHelper sharedInstance] decrementNetworkActivityIndicator];
             if (error) {
                 errorHandler(error, @"shortening FT Map URL");
             } else {
                 NSDictionary *lines = [NSJSONSerialization
                                                JSONObjectWithData:data 
                                                options:kNilOptions error:nil];
                 NSLog(@"%@", lines);
                 self.sharedMapURL = lines[@"id"];
                 shareDataUrlBlock ();
             }
         }];
    }
}
- (NSString *)longShareMapURL {
    return [NSString stringWithFormat:
                @"https://www.google.com/fusiontables/embedviz?q=select+col9+from+%@&viz=MAP"
                "&h=false&lat=50.088555878607316&lng=14.429294793701292&t=1&z=14&l=col9&noCache=%@",
                [self ftTableID],
                [[GoogleServicesHelper sharedInstance] random4DigitNumberString]];
}
- (NSString *)longShareDataURL {
    return [NSString stringWithFormat:
            @"https://fusiontables.google.com/data?docid=%@%@", [self ftTableID], @"#rows:id=1"];
}

#pragma mark - Fusion Table Viewer
- (void)showFTViewer {
    FusionTableViewerViewController *viewer = [[FusionTableViewerViewController alloc] init];
    viewer.ftMapURL = self.sharedMapURL;
    viewer.ftDataURL = self.sharedDataURL;
    viewer.navigationItem.rightBarButtonItem = 
                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                        target:self action:@selector(closeFTViewer:)];
    
    UINavigationController *navController = 
            [[UINavigationController alloc] initWithRootViewController:viewer];    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;

    [[GoogleServicesHelper sharedInstance] presentController:navController 
                                                    animated:YES completionHandler:nil];
}
- (void)closeFTViewer:(id)sender {
    [[GoogleServicesHelper sharedInstance] dismissViewControllerAnimated:YES completion:nil];
}

@end



