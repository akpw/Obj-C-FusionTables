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

//  SampleViewController.m
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

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

    self.title = @"FT API Example";
    
    self.navigationItem.leftBarButtonItems = [[AppGeneralServicesController sharedAppTheme]
                                                        customBarButtonItemsBackForTarget:self
                                                        WithAction:@selector(goBack)];
    if ([self isSampleAppFusionTable]) { 
            self.navigationItem.rightBarButtonItems = [[AppGeneralServicesController sharedAppTheme]
                                               customShareBarButtonItemsForTarget:self
                                               WithAction:@selector(shareFusionTable)];
    }
    
    // the UI controller that will be dispatching related TableView messages to individual section controllers
    self.uiController = [[SampleViewControllerUIController alloc] initWithParentViewController:self];
}

#pragma mark - Fusion Table Name Check
// a simple Fusion Table name prefix check,
// used to recognise tables created with this app
- (BOOL)isSampleAppFusionTable {
    NSString *tableName = [self fusionTableName];
    return ([tableName rangeOfString:SAMPLE_FUSION_TABLE_PREFIX].location != NSNotFound);
}

#pragma mark - Fusion Table Sharing
- (void)shareFusionTable {
    [[NSNotificationCenter defaultCenter] 
        postNotificationName:START_FT_SHARING_NOTIFICATION
        object:self userInfo:nil];
}


@end
