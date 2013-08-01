//
//  SampleViewControllerUIController.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 19/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import "SampleViewControllerUIController.h"
#import "SampleViewControllerFTCreateSection.h"
#import "SampleViewControllerFTStylingSection.h"
#import "SampleViewControllerInsertFTRowsSection.h"
#import "SampleViewControllerInsertFTRowsSection.h"
#import "SampleViewControllerFTSharingSection.h"

// defines the TableView Sections
enum SampleViewControllerSections {
    kSampleViewControllerFTCreateSection = 0,
    kSampleViewControllerFTStylingSection,
    kSampleViewControllerInsertFTRowsSection,
    kSampleViewControllerFTSharingSection,
    kSampleViewControllerNumSections
};

@implementation SampleViewControllerUIController

// Builds the dispatch table for SampleViewController
- (void)buildSectionsDispatchTable {
    self.grandDispatchTable = @{
        @(kSampleViewControllerFTCreateSection):[[SampleViewControllerFTCreateSection alloc]
                                  initWithParentViewController:self.parentVC
                                  SectionID:kSampleViewControllerFTCreateSection
                                  DefaultCellID:@"kSampleViewControllerFTCreateSection"],
        
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
