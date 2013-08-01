//
//  AppDelegate.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 23/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "AppDelegate.h"
#import "SampleViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    SampleViewController *viewController = [[SampleViewController alloc]
                                            initWithNibName:@"GroupedTableViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc]
                                            initWithRootViewController:viewController];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
