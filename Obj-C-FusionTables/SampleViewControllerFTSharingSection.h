//
//  SampleViewControllerFTSharingSection.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 20/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "SampleViewControllerFTBaseSection.h"
#import <MessageUI/MessageUI.h>

/****
    Shows usage of Obj-C-FusionTables for setting Fusion Tables user permissions / sharing
****/

@interface SampleViewControllerFTSharingSection : SampleViewControllerFTBaseSection
                                <UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@end
