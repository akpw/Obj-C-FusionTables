//
//  GroupedTableUIController.m
//  GroupedUITableViews
//
//  Created by Arseniy Kuznetsov on 4/8/11.
//  Copyright 2011 Arseniy Kuznetsov. All rights reserved.
//

#import "GroupedTableUIController.h"

#pragma mark - 
@implementation GroupedTableUIController

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    // dispatch to section controllers
    [_grandDispatchTable enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [(GroupedTableSectionController *)obj didReceiveMemoryWarning];
    }];
}

#pragma mark - Init
- (GroupedTableUIController *)initWithParentViewController:(id)theParentVC {
    self = [super init];
    if (self) {
        self.parentVC = theParentVC;
        [self buildSectionsDispatchTable];
    }
    return self;
}

#pragma mark - Dispatch table methods
- (void)buildSectionsDispatchTable {
    // to be further specified in a concrete controller
}
- (GroupedTableSectionController *)sectionControllerForSection:(NSUInteger)theSection {
    return (GroupedTableSectionController *)(_grandDispatchTable)[@(theSection)];
}

#pragma mark - number of UITableView sections
- (NSInteger)numberOfSections {
    // to be further specified in a concrete controller
    return 0;
}


@end
