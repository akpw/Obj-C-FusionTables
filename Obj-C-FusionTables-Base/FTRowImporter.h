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

//  FTRowImporter.h
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//  Added by Adam Cumiskey on 02/14/2014

/****
    Enables batch uploading of rows to a fusion table. 
    Rows must conform to the FTTableRowDelegate which defines a CSV string
    representation of each row.
****/

#import <Foundation/Foundation.h>
#import "GoogleAuthorizationController.h"

@protocol FTTableRowDelegate <NSObject>
- (NSString *)csvStringForRow;
@end

@interface FTRowImporter : NSObject

// Uploads an array of <FTTableRowDelegate> objects to a fusion table
// Delimiter defaults to commas ','
+ (void)uploadRows:(NSArray *)rows
           toTable:(NSString *)tableID
   customDelimiter:(NSString *)delimiter
    withCompletionHandler:(ServiceAPIHandler)completionHandler;

@end