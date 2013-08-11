//
//  SampleViewController.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 23/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

/****
    Shows usage of Obj-C-FusionTables for 
    setting Fusion Table Map Styles and Templates, as well as for base Fusion Tables rows ops.
    For the sake data safety, changes are allowed only for Fusion Tables created in this app.
 
    SampleViewController is using GroupedUITableViews (https://github.com/akpw/GroupedUITableViews),
    isolating the logic of Fusion Table ops in small dedicated UITableView sections controller classes.
****/

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
