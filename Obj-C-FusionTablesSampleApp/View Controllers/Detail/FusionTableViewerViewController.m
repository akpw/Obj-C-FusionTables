//
//  FusionTableViewerViewController.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 31/12/14.
//  Copyright (c) 2014 Arseniy Kuznetsov. All rights reserved.
//

#import "FusionTableViewerViewController.h"
#import "GoogleServicesHelper.h"

@implementation FusionTableViewerViewController

#define THE_WEB_VIEW_TAG 45
#define GOOGLE_ERROR_DOMAIN_CODE_INTERNAL_ERROR 500
- (void)loadView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];  
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    webView.delegate = self;
    webView.tag = THE_WEB_VIEW_TAG;
    
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:[NSURL URLWithString:self.ftSharingURL]];
    [webView loadRequest:urlReq];
    
    [view addSubview:webView];
    self.view = view;    
    
    [self updateConstraintsForTraitCollection:self.traitCollection];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.ftTableName;
    
    self.navigationItem.leftBarButtonItem = 
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
                                                  target:self action:@selector(showFTShareActionSheet)];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
}
- (void)showWebView {
}

- (void)updateConstraintsForTraitCollection:(UITraitCollection *)collection {
    UIWebView *webView = (UIWebView *)[self.view viewWithTag:THE_WEB_VIEW_TAG];
    
    NSDictionary *views = @{
                            @"webView": webView
                            };
    
    NSMutableArray *newConstraints = [NSMutableArray array];
    
    NSArray *cH = [NSLayoutConstraint 
                                    constraintsWithVisualFormat:@"|[webView]|" 
                                    options:0 metrics:nil views:views];
    [newConstraints addObjectsFromArray:cH];
    
    NSArray *cV = [NSLayoutConstraint 
                                    constraintsWithVisualFormat:@"V:|[webView]|" 
                                    options:0 metrics:nil views:views];
    [newConstraints addObjectsFromArray:cV];
    
    [NSLayoutConstraint activateConstraints:newConstraints];   
}

#pragma mark - Sharing ActionSheets Handlers
- (void)showFTShareActionSheet {
    UIAlertController *sharinController = [UIAlertController 
                                                alertControllerWithTitle:@"Share Fusion Table"
                                                message:nil 
                                                preferredStyle:UIAlertControllerStyleActionSheet];    

    UIAlertAction *copyToClipboardAction = [UIAlertAction actionWithTitle:@"Copy URL to Clipboard"
             style:UIAlertActionStyleDefault 
             handler:^(UIAlertAction *action) {                                                                     
                 UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
                 pasteBoard.string = self.ftSharingURL;
                 
                 [[GoogleServicesHelper sharedInstance] 
                            showAlertViewWithTitle:@"URL copied to Clipboard" AndText:@""];
        }];        
    [sharinController addAction:copyToClipboardAction];

    UIAlertAction *openInSafariAction = [UIAlertAction actionWithTitle:@"Open in Safari"
         style:UIAlertActionStyleDefault 
         handler:^(UIAlertAction *action) {                                                                     
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.ftSharingURL]];
    }];        
    [sharinController addAction:openInSafariAction];        
    
    // cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" 
                                           style:UIAlertActionStyleDefault handler:nil];        
    [sharinController addAction:cancelAction];

    // configure popover
    UIPopoverPresentationController *popover = sharinController.popoverPresentationController;
    if (popover) {
        popover.barButtonItem = self.navigationItem.leftBarButtonItem;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }            
    [self presentViewController:sharinController animated:YES completion:nil];    
}




@end




/*
 UIAlertAction *sendViaEmailAction = [UIAlertAction actionWithTitle:@"Send via Email"
 style:UIAlertActionStyleDefault 
 handler:^(UIAlertAction *action) {                                                                     
 if ([MFMailComposeViewController canSendMail]) {
 MFMailComposeViewController *mailController = 
 [[MFMailComposeViewController alloc] init];
 
 [mailController setMailComposeDelegate:self];
 [mailController setSubject:@"Sharing a new Fusion Table"];
 [mailController setMessageBody:[NSString stringWithFormat:
 @"Sharing a new Fusion Table: %@", self.ftSharingURL]
 isHTML:YES];
 
 [[GoogleServicesHelper sharedInstance]     
 presentController:mailController animated:YES completionHandler:nil];
 } else {
 [[GoogleServicesHelper sharedInstance]
 showAlertViewWithTitle:@"Email not set"
 AndText:@"To send emails from this device, "
 "please first set up an email account in the device Settings"];
 }
 }];        
 [sharinController addAction:sendViaEmailAction];

 
 #pragma mark - MFMailComposeViewController
 - (void)mailComposeController:(MFMailComposeViewController*)controller
 didFinishWithResult:(MFMailComposeResult)result
 error:(NSError*)error {
 AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
 [appDelegate.navigationController dismissViewControllerAnimated:YES completion:nil];
 }
 */