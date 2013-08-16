/* Copyright (c) 2013 Arseniy Kuznetsov
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//  GroupedTableUIController.m
//  GroupedUITableViews

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
