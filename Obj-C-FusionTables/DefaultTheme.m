//
//  DefaultTheme.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 6/8/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "DefaultTheme.h"
#import <QuartzCore/QuartzCore.h>

@implementation DefaultTheme

- (UIColor *)baseTintColor {
    return nil;
}
- (NSArray *)customBarButtonItemsBackForTarget:(id)target WithAction:(SEL)actionSelector {
    UIImage * customBackButtonImage = [UIImage imageNamed:@"custom-back-btn.png"];
    UIImage * customBackButtonImageHigh = [UIImage imageNamed:@"custom-back-btn-high.png"];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    backButton.frame = CGRectMake(0.0, 0.0,
                                  customBackButtonImage.size.width,
                                  customBackButtonImage.size.height);
    
    [backButton setImage:customBackButtonImage forState:UIControlStateNormal];
    [backButton setImage:customBackButtonImageHigh forState:UIControlStateHighlighted];
    
    [backButton addTarget:target action:actionSelector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 2;
    return @[spacer, customBarItem];
}
- (NSArray *)customAddBarButtonItemsForTarget:(id)target WithAction:(SEL)actionSelector {
    UIImage * controlStateNormalImage = [UIImage imageNamed:@"add-icon.png"];
    UIImage *controlStateHighlightedImage = [AppGeneralServicesController
                                             colorizeImage:controlStateNormalImage
                                             color:[UIColor grayColor]];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    editButton.frame = CGRectMake(0.0, 0.0,
                                  controlStateNormalImage.size.width,
                                  controlStateNormalImage.size.height);
    
    [editButton setImage:controlStateNormalImage forState:UIControlStateNormal];
    [editButton setImage:controlStateHighlightedImage forState:UIControlStateHighlighted];
    
    [editButton addTarget:target action:actionSelector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 14;
    return @[spacer, customBarItem];
}
- (NSArray *)customEditBarButtonItemsForTarget:(id)target WithAction:(SEL)actionSelector {
    UIImage *controlStateNormalImage = [UIImage imageNamed:@"start-editing.png"];
    UIImage *controlStateHighlightedImage = [AppGeneralServicesController
                                             colorizeImage:controlStateNormalImage
                                             color:[UIColor grayColor]];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    editButton.frame = CGRectMake(0.0, 0.0,
                                  controlStateNormalImage.size.width,
                                  controlStateNormalImage.size.height);
    
    [editButton setImage:controlStateNormalImage forState:UIControlStateNormal];
    [editButton setImage:controlStateHighlightedImage forState:UIControlStateHighlighted];
    
    [editButton addTarget:target action:actionSelector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 14;
    return @[spacer, customBarItem];
}
- (NSArray *)customDoneBarButtonItemsForTarget:(id)target WithAction:(SEL)actionSelector {
    UIImage *controlStateNormalImage = [UIImage imageNamed:@"done-editing.png"];
    UIImage *controlStateHighlightedImage = [AppGeneralServicesController
                                             colorizeImage:controlStateNormalImage
                                             color:[UIColor grayColor]];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    doneButton.frame = CGRectMake(0.0, 0.0,
                                  controlStateNormalImage.size.width,
                                  controlStateNormalImage.size.height);
    
    [doneButton setImage:controlStateNormalImage forState:UIControlStateNormal];
    [doneButton setImage:controlStateHighlightedImage forState:UIControlStateHighlighted];
    
    [doneButton addTarget:target action:actionSelector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 8;
    return @[spacer, customBarItem];
}
- (UIButton *)tableViewCellAccessoryCopyLinButtonForTarget:(id)target WithAction:(SEL)actionSelector {
    return nil;
}
- (void)addGlassGradientToView:(UIView *)view Alpha:(CGFloat)alpha {
    CAGradientLayer *glassGradient = [CAGradientLayer layer];
    glassGradient.frame =  view.bounds;
    glassGradient.colors = @[(id)[UIColor colorWithWhite:1.0f alpha:alpha].CGColor,
                             (id)[UIColor colorWithWhite:1.0f alpha:alpha/2].CGColor,
                             (id)[UIColor colorWithWhite:0.75f alpha:alpha/2].CGColor,
                             (id)[UIColor colorWithWhite:0.4f alpha:alpha/2].CGColor,
                             (id)[UIColor colorWithWhite:1.0f alpha:alpha].CGColor];
    glassGradient.locations = @[@0.0f,
                                @0.5f,
                                @0.5f,
                                @0.8f,
                                @1.0f];
    glassGradient.cornerRadius = view.layer.cornerRadius;
    [view.layer addSublayer:glassGradient];
}

@end
