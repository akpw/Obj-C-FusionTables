//
//  SampleViewControllerFTStylingSection.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 19/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SampleViewControllerFTBaseSection.h"
#import "FTStyle.h"
#import "FTTemplate.h"

/****
    Shows usage of Obj-C-FusionTables for Fusion Tables Map Styles and Templates
****/

@interface SampleViewControllerFTStylingSection : SampleViewControllerFTBaseSection
                                                        <FTStyleDelegate, FTTemplateDelegate>

@end
