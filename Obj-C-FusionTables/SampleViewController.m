//
//  SampleViewController.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 23/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "SampleViewController.h"
#import "SampleViewControllerUIController.h"

@interface SampleViewController ()

@end

@implementation SampleViewController

#pragma mark - Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Fusion Tables Sample";
    
    // the UI controller that will be dispatching related TableView messages to individual section controllers
    self.uiController = [[SampleViewControllerUIController alloc] initWithParentViewController:self];
}


@end
