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

//  AppDelegate.m
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

#import "AppDelegate.h"
#import "FusionTablesViewController.h"
#import "AppGeneralServicesController.h"
#import "EmptyDetailViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AppGeneralServicesController customizeAppearance];
    
    [[GoogleAuthorizationController sharedInstance] signOutFromGoogle];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     
    UISplitViewController *splitVC = [[UISplitViewController alloc] init];
    splitVC.delegate = self;
    
    FusionTablesViewController *ftMasterVC = [[FusionTablesViewController alloc] init];    
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:ftMasterVC];       
    EmptyDetailViewController *emptyDetailVC = [[EmptyDetailViewController alloc] init];    
    emptyDetailVC.infoLabel.text = @"No Fusion Table Selected";
    
    splitVC.viewControllers = @[navigationController, emptyDetailVC];
    splitVC.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
       
    self.window.rootViewController = splitVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController 
                        collapseSecondaryViewController:(UIViewController *)secondaryViewController 
                        ontoPrimaryViewController:(UIViewController *)primaryViewController {    
    return ([secondaryViewController isKindOfClass:[EmptyDetailViewController class]]) ? YES : NO;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
}


@end






/*
 #import "GTMOAuth2Authentication.h"

 __weak typeof (self) weakSelf = self;
 [[NSNotificationCenter defaultCenter] addObserverForName:kGTMOAuth2UserSignedIn 
 object:nil queue:[NSOperationQueue mainQueue] 
 usingBlock:^(NSNotification *note){
 // to dispose Google Auth extra web view, see link below
 // https://groups.google.com/forum/#!topic/gdata-objectivec-client/4L1AwhwKKoc      
 [weakSelf.window.rootViewController dismissViewControllerAnimated:NO  completion:nil];
 }];     

*/
