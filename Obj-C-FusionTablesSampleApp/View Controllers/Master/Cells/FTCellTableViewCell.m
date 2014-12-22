//
//  FTInfoCellTableViewCell.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 21/12/14.
//  Copyright (c) 2014 Arseniy Kuznetsov. All rights reserved.
//

#import "FTCellTableViewCell.h"
#import "GoogleAuthorizationController.h"
#import "FusionTablesViewController.h"
#import "AppIconsController.h"

@implementation FTCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier])) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.imageView.image = [AppIconsController fusionTablesImage];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.detailTextLabel.backgroundColor = [UIColor whiteColor];
        self.detailTextLabel.textColor = [UIColor grayColor];
    }    
    return self;
}



@end
