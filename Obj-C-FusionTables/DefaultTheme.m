//
//  DefaultTheme.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 6/8/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

/****
    Sample App Appearance customization, default theme
****/

#import "DefaultTheme.h"
#import "AppIconsController.h"

@implementation DefaultTheme

#pragma mark - App tint color customization, default impl
- (UIColor *)baseTintColor {
    return nil;
}

#pragma mark - UIBarButtonItem customization, default impl
- (NSArray *)customBarButtonItemsBackForTarget:(id)target WithAction:(SEL)actionSelector {
    UIImage *customImage = [AppIconsController
                               navBarCustomBackButtonImage][IconsControllerIconTypeNormal];
    UIImage *customImageHigh = [AppIconsController
                               navBarCustomBackButtonImage][IconsControllerIconTypeHighlighted];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    backButton.frame = CGRectMake(0.0, 0.0,
                                  customImage.size.width,
                                  customImage.size.height);    
    [backButton setImage:customImage forState:UIControlStateNormal];
    [backButton setImage:customImageHigh forState:UIControlStateHighlighted];
    [backButton addTarget:target action:actionSelector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 2;
    return @[spacer, customBarItem];
}
- (NSArray *)customAddBarButtonItemsForTarget:(id)target WithAction:(SEL)actionSelector {
    UIImage *customImage = [AppIconsController
                                navBaAddBarButtonImage][IconsControllerIconTypeNormal];
    UIImage *customImageHigh = [AppIconsController
                                navBaAddBarButtonImage][IconsControllerIconTypeHighlighted];
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    editButton.frame = CGRectMake(0.0, 0.0,
                                  customImage.size.width,
                                  customImage.size.height);
    
    [editButton setImage:customImage forState:UIControlStateNormal];
    [editButton setImage:customImageHigh forState:UIControlStateHighlighted];    
    [editButton addTarget:target action:actionSelector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 14;
    return @[spacer, customBarItem];
}
- (NSArray *)customEditBarButtonItemsForTarget:(id)target WithAction:(SEL)actionSelector {
    UIImage *customImage = [AppIconsController
                                            navBarItemEditButtonImage][IconsControllerIconTypeNormal];
    UIImage *customImageHigh = [AppIconsController
                                             navBarItemEditButtonImage][IconsControllerIconTypeHighlighted];    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    editButton.frame = CGRectMake(0.0, 0.0,
                                  customImage.size.width,
                                  customImage.size.height);
    
    [editButton setImage:customImage forState:UIControlStateNormal];
    [editButton setImage:customImageHigh forState:UIControlStateHighlighted];
    [editButton addTarget:target action:actionSelector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 14;
    return @[spacer, customBarItem];
}
- (NSArray *)customDoneBarButtonItemsForTarget:(id)target WithAction:(SEL)actionSelector {
    UIImage *customImage = [AppIconsController
                                            navBarItemDoneButtonImage][IconsControllerIconTypeNormal];
    UIImage *customImageHigh = [AppIconsController
                                             navBarItemDoneButtonImage][IconsControllerIconTypeHighlighted];
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    doneButton.frame = CGRectMake(0.0, 0.0,
                                  customImage.size.width,
                                  customImage.size.height);
    
    [doneButton setImage:customImage forState:UIControlStateNormal];
    [doneButton setImage:customImageHigh forState:UIControlStateHighlighted];
    
    [doneButton addTarget:target action:actionSelector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 8;
    return @[spacer, customBarItem];
}

@end
