//
//  SampleViewController.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 23/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "SampleViewController.h"
#import "SampleViewControllerUIController.h"
#import "AppGeneralServicesController.h"

@implementation SampleViewController

#pragma mark - View lifecycle
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItems = [[AppGeneralServicesController sharedAppTheme]
                                                        customBarButtonItemsBackForTarget:self
                                                        WithAction:@selector(goBack)];
    self.title = @"FT API Example";
    
    // the UI controller that will be dispatching related TableView messages to individual section controllers
    self.uiController = [[SampleViewControllerUIController alloc] initWithParentViewController:self];
}



@end
