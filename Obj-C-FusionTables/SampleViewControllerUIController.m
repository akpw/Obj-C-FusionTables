//
//  SampleViewControllerUIController.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 19/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "SampleViewControllerUIController.h"
#import "SampleViewControllerFTStylingSection.h"
#import "SampleViewControllerInsertFTRowsSection.h"
#import "SampleViewControllerFTSharingSection.h"

// defines the TableView Sections
enum SampleViewControllerSections {
    kSampleViewControllerFTStylingSection = 0,
    kSampleViewControllerInsertFTRowsSection,
    kSampleViewControllerFTSharingSection,
    kSampleViewControllerNumSections
};

@implementation SampleViewControllerUIController

// Builds the dispatch table for SampleViewController
- (void)buildSectionsDispatchTable {
    self.grandDispatchTable = @{
        @(kSampleViewControllerFTStylingSection):[[SampleViewControllerFTStylingSection alloc]
                                  initWithParentViewController:self.parentVC
                                  SectionID:kSampleViewControllerFTStylingSection
                                  DefaultCellID:@"kSampleViewControllerFTStylingSection"],
                
        @(kSampleViewControllerInsertFTRowsSection):[[SampleViewControllerInsertFTRowsSection alloc]
                                  initWithParentViewController:self.parentVC
                                  SectionID:kSampleViewControllerInsertFTRowsSection
                                  DefaultCellID:@"kSampleViewControllerInsertFTRowsSection"],

        @(kSampleViewControllerFTSharingSection):
                                  [[SampleViewControllerFTSharingSection alloc]
                                  initWithParentViewController:self.parentVC
                                  SectionID:kSampleViewControllerFTSharingSection
                                  DefaultCellID:@"kSampleViewControllerFTSharingSection"]

        
        };
}
- (NSInteger)numberOfSections {
    return kSampleViewControllerNumSections;
}


@end
