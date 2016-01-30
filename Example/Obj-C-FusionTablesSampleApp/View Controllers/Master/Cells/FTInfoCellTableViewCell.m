//
//  FTInfoCellTableViewCell.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 21/12/14.
//  Copyright (c) 2014 Arseniy Kuznetsov. All rights reserved.
//

#import "FTInfoCellTableViewCell.h"
#import "GoogleAuthorizationController.h"
#import "SampleFTTableDelegate.h"

@implementation FTInfoCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier])) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.contentView.backgroundColor = [UIColor lightGrayColor];
        self.detailTextLabel.backgroundColor = [UIColor lightGrayColor];
        self.detailTextLabel.textColor = [UIColor whiteColor];
        self.detailTextLabel.textAlignment = NSTextAlignmentCenter;        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // layout detailTextLabel to take entire cell width
    self.detailTextLabel.frame = CGRectMake(0, self.detailTextLabel.frame.origin.y, 
                                            self.frame.size.width, self.detailTextLabel.frame.size.height);      
}

@end
