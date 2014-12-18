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
#import "AppDelegate.h"
#import "AppIconsController.h"
#import "SampleViewController.h"

// Defines rows in section
enum SampleViewControllerFTSharingInfoSectionRows {
    kSampleViewControllerFTSharingInfoRowSection = 0,
    SampleViewControllerFTSharingInfoSectionNumRows
};

// FTable sharing states
typedef NS_ENUM (NSUInteger, FTSharingStates) {
    kFTStateIdle = 0,
    kFTStateSharing,
    kFTStateShorteningURL
};

@interface SampleViewControllerFTSharingInfoSection ()
    @property (nonatomic, strong) NSString *sharingURL;
@end

@implementation SampleViewControllerFTSharingInfoSection {
    FTSharingStates ftSharingRowState;
}

#pragma mark - Memory management
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Section Init
- (void)initSpecifics {
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] 
        addObserverForName:START_FT_SHARING_NOTIFICATION 
        object:nil queue:[NSOperationQueue mainQueue] 
        usingBlock:^(NSNotification *notification) {
            [weakSelf shareFusionTableWithCompletionHandler:^{
                [weakSelf shortenURLWithCompletionHandler:^{
                    [weakSelf reloadSection];
                    [weakSelf showFTShareActionSheet];
                }];
            }];            
    }];
}

#pragma mark - GroupedTableSectionsController Table View Data Source
- (NSUInteger)numberOfRows {
    return (ftSharingRowState == kFTStateIdle) ? 0 : SampleViewControllerFTSharingInfoSectionNumRows;
}
- (void)configureCell:(UITableViewCell *)cell ForRow:(NSUInteger)row {
    switch (ftSharingRowState) {
        case kFTStateSharing:
            cell.textLabel.text = @"Sharing Fusion Table...";
            break;
        case kFTStateShorteningURL:
            cell.textLabel.text = @"Shortening the sharing URL...";
            break;
        default:
            break;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.userInteractionEnabled = NO;
    cell.backgroundColor = [UIColor lightGrayColor];
}


#pragma mark - GroupedTableSectionsController Table View Delegate
- (CGFloat)heightForRow:(NSInteger)row {
    return 44.0f;
}
- (CGFloat)heightForFooterInSection {
    return 1;
}
- (CGFloat)heightForHeaderInSection {
    return 1;
}

#pragma mark - FT user permissions / sharing
- (void)shareFusionTableWithCompletionHandler:(void_completion_handler_block)completionHandler {
    ftSharingRowState = kFTStateSharing;
    [self reloadSection];
    
    [[GoogleServicesHelper sharedInstance] incrementNetworkActivityIndicator];
    [[GoogleServicesHelper sharedInstance] setPublicSharingForFileWithID:[self ftTableID]
                                                         WithCompletionHandler:^(NSData *data, NSError *error) {
    [[GoogleServicesHelper sharedInstance] decrementNetworkActivityIndicator];
        ftSharingRowState = kFTStateIdle;
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
// Simple URL Shortener 
- (void)shortenURLWithCompletionHandler:(void_completion_handler_block)completionHandler {
    ftSharingRowState = kFTStateShorteningURL;
    [self reloadSection];
    
    [[GoogleServicesHelper sharedInstance] incrementNetworkActivityIndicator];
    [[GoogleServicesHelper sharedInstance] shortenURL:[self longShareURL]
                                      WithCompletionHandler:^(NSData *data, NSError *error) {
         [[GoogleServicesHelper sharedInstance] decrementNetworkActivityIndicator];
         ftSharingRowState = kFTStateIdle;
         if (error) {
             NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
             [[GoogleServicesHelper sharedInstance]
                    showAlertViewWithTitle:@"Fusion Tables Error"
                    AndText: [NSString stringWithFormat:@"Error Sharing Fusion Table: %@", errorStr]];
         } else {
             NSDictionary *lines = [NSJSONSerialization
                                    JSONObjectWithData:data options:kNilOptions error:nil];
             NSLog(@"%@", lines);
             self.sharingURL = lines[@"id"];
             completionHandler ();
         }
     }];
}
- (NSString *)longShareURL {
    return [NSString stringWithFormat:
                @"https://www.google.com/fusiontables/embedviz?q=select+col9+from+%@&viz=MAP"
                "&h=false&lat=50.088555878607316&lng=14.429294793701292&t=1&z=15&l=col9&noCache=%@",
                [self ftTableID],
                [[GoogleServicesHelper sharedInstance] random4DigitNumberString]];
}

#pragma mark - Sharing ActionSheets Handlers
#define QUICK_SHARE_TO_CLIPBOARD (@"Copy to Clipboard")
#define QUICK_SHARE_TO_EMAIL (@"Send via Email")
#define QUICK_SHARE_TO_SAFARI (@"Open in Safari")
- (void)showFTShareActionSheet {
    if (self.sharingURL) {
        UIActionSheet *quickShareActionSheet = [[UIActionSheet alloc]
                                                initWithTitle:@"Share Fusion Table"
                                                delegate:self
                                                cancelButtonTitle:nil
                                                destructiveButtonTitle:nil
                                                otherButtonTitles:nil];
        [quickShareActionSheet addButtonWithTitle:QUICK_SHARE_TO_EMAIL];
        [quickShareActionSheet addButtonWithTitle:QUICK_SHARE_TO_CLIPBOARD];
        [quickShareActionSheet addButtonWithTitle:QUICK_SHARE_TO_SAFARI];
        quickShareActionSheet.cancelButtonIndex = [quickShareActionSheet addButtonWithTitle:@"Cancel"];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [quickShareActionSheet showInView:appDelegate.navigationController.view ];
    }
}

#define CLIPBOARD_COPY_INFO_ACTION_SHEET_TAG 6548445
- (void)copyToDeviceCLipboard {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = self.sharingURL;
    
    UIActionSheet *clipboardCopyActionSheet = [[UIActionSheet alloc] initWithTitle:@"URL copied to Clipboard"
                                                                          delegate:self
                                                                 cancelButtonTitle:@"OK"
                                                            destructiveButtonTitle:nil
                                                                 otherButtonTitles:nil];
    clipboardCopyActionSheet.tag = CLIPBOARD_COPY_INFO_ACTION_SHEET_TAG;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [clipboardCopyActionSheet showInView:appDelegate.navigationController.view ];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag != CLIPBOARD_COPY_INFO_ACTION_SHEET_TAG) {
        if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:QUICK_SHARE_TO_CLIPBOARD]) {
            [self copyToDeviceCLipboard];
        } else {
            if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:QUICK_SHARE_TO_EMAIL]) {
                [self sendViaEmail];
            } else {
                if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:QUICK_SHARE_TO_SAFARI]) {
                    [self openInSafari];
                }
            }
        }
    }
}
#undef QUICK_SHARE_TO_CLIPBOARD
#undef QUICK_SHARE_TO_EMAIL
#undef QUICK_SHARE_TO_SAFARI
#undef CLIPBOARD_COPY_ACTION_SHEET_TAG

- (void)sendViaEmail {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        
        [mailController setMailComposeDelegate:self];
        [mailController setSubject:@"Sharing a new Fusion Table"];
        [mailController setMessageBody:[NSString stringWithFormat:@"Sharing a new Fusion Table: %@",
                                        self.sharingURL]
                                        isHTML:YES];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate.navigationController presentViewController:mailController animated:YES completion:nil];
    } else {
        [[GoogleServicesHelper sharedInstance]
            showAlertViewWithTitle:@"Email not set"
            AndText:@"To send emails from this device, please first set up an email account in the device Settings"];
    }
    
}
#pragma mark - MFMailComposeViewController
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)openInSafari {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.sharingURL]];
}

@end



