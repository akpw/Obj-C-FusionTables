//
//  FusionTableViewerViewController.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 31/12/14.
//  Copyright (c) 2014 Arseniy Kuznetsov. All rights reserved.
//

#import "FusionTableViewerViewController.h"
#import "GoogleServicesHelper.h"

enum FTViews {
    kDataView = 0,
    kMapView
};

@interface FusionTableViewerViewController ()
    @property (nonatomic, retain) UILabel *infoLabel;
    @property (nonatomic, retain) UIWebView *webView;
    @property (nonatomic, retain) UISegmentedControl *viewSwitcher;
@end

@implementation FusionTableViewerViewController

#pragma mark - Init
- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _infoLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];    
        _infoLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        _infoLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        _infoLabel.text = @"Loading...";
    }
    return _infoLabel;
}
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];  
        _webView.translatesAutoresizingMaskIntoConstraints = NO;
        _webView.delegate = self;
    }
    return _webView;
}
- (UISegmentedControl *)viewSwitcher {
    if (!_viewSwitcher) {
        _viewSwitcher = [[UISegmentedControl alloc] initWithItems:
                            [NSArray arrayWithObjects:@"Data View", @"Map View", nil]];
        [_viewSwitcher addTarget:self action:@selector(switchFTViews:) 
                            forControlEvents: UIControlEventValueChanged];
        [_viewSwitcher setSelectedSegmentIndex:kMapView];
    }
    return _viewSwitcher;
} 

#pragma mark - View lifecycle
- (void)loadView {
    UIView *view = [[UIView alloc] init];    
    [view addSubview:self.webView];
    [view addSubview:self.infoLabel];   
    
    self.view = view;       
    [self updateConstraints];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];           
    self.navigationItem.leftBarButtonItem = 
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
                                                  target:self action:@selector(showFTShareActionSheet)];
    self.navigationItem.titleView = self.viewSwitcher;    
    [self switchFTViews:self.viewSwitcher];
}
- (void)updateConstraints {
    NSMutableArray *constraints = [NSMutableArray array];
    
    // info label constraints
    NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:self.infoLabel 
                                                                   attribute:NSLayoutAttributeCenterX 
                                                                   relatedBy:NSLayoutRelationEqual 
                                                                      toItem:self.view 
                                                                   attribute:NSLayoutAttributeCenterX 
                                                                  multiplier:1.0 
                                                                    constant:0.0];
    NSLayoutConstraint *yConstraint = [NSLayoutConstraint constraintWithItem:self.infoLabel 
                                                                   attribute:NSLayoutAttributeCenterY 
                                                                   relatedBy:NSLayoutRelationEqual 
                                                                      toItem:self.view 
                                                                   attribute:NSLayoutAttributeCenterY 
                                                                  multiplier:1.0 
                                                                    constant:0.0];    
    [constraints addObjectsFromArray:@[xConstraint, yConstraint]];
    
    // web view constraints
    NSDictionary *views = @{@"webView": self.webView};    
    NSArray *cH = [NSLayoutConstraint constraintsWithVisualFormat:@"|[webView]|" 
                                                          options:0 metrics:nil views:views];
    [constraints addObjectsFromArray:cH];
    
    NSArray *cV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[webView]|" 
                                                          options:0 metrics:nil views:views];
    [constraints addObjectsFromArray:cV];
    
    // activate contraints
    [NSLayoutConstraint activateConstraints:constraints];   
}

#pragma mark - Switching views
- (void)switchFTViews:(id)sender {
    switch (self.viewSwitcher.selectedSegmentIndex) {
        case kDataView: {
            NSURLRequest *urlReq = [NSURLRequest requestWithURL:
                                        [NSURL URLWithString:self.ftDataURL]];
            [self.webView loadRequest:urlReq];    
            break;
        }
        case kMapView: {
            NSURLRequest *urlReq = [NSURLRequest requestWithURL:
                                        [NSURL URLWithString:self.ftMapURL]];
            [self.webView loadRequest:urlReq];    
            break;
        }
        default:
            break;
    }     
}

#pragma mark - UIWebViewDelegate methods
- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.infoLabel.hidden = NO;
    self.webView.hidden = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.infoLabel.hidden = YES;
    self.webView.hidden = NO;
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
             pasteBoard.string = 
                (self.viewSwitcher.selectedSegmentIndex == kMapView) ? self.ftMapURL : self.ftDataURL;
             
             [[GoogleServicesHelper sharedInstance] 
                        showAlertViewWithTitle:@"URL copied to Clipboard" AndText:@""];
        }];        
    [sharinController addAction:copyToClipboardAction];

    UIAlertAction *openInSafariAction = [UIAlertAction actionWithTitle:@"Open in Safari"
         style:UIAlertActionStyleDefault 
         handler:^(UIAlertAction *action) {    
             NSString *urlString = 
                (self.viewSwitcher.selectedSegmentIndex == kMapView) ? self.ftMapURL : self.ftDataURL;
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
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