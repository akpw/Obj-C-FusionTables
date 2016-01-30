//
//  SampleFTDelegate.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 21/12/14.
//  Copyright (c) 2014 Arseniy Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTTable.h"

@interface SampleFTTableDelegate : NSObject <FTDelegate>

@property (nonatomic, strong) FTTable *ftTable;
@property (nonatomic, strong) NSMutableArray *ftTableObjects;
@property (nonatomic, strong) NSString *selectedFusionTableID;


- (void)loadFusionTablesWithPreprocessingBlock:(void_completion_handler_block)preProcessingBlock 
                             FailedCompletionHandler:(void_completion_handler_block)failHandler
                             CompletionHandler:(void_completion_handler_block)completionHandler;

- (void)insertNewFusionTableWithPreprocessingBlock:(void_completion_handler_block)preProcessingBlock 
                             FailedCompletionHandler:(void_completion_handler_block)failHandler
                             CompletionHandler:(void_completion_handler_block)completionHandler;


- (void)deleteFusionTableWithPreprocessingBlock:(void_completion_handler_block)preProcessingBlock 
                             FailedCompletionHandler:(void_completion_handler_block)failHandler
                             CompletionHandler:(void_completion_handler_block)completionHandler;

- (NSString *)currentActionInfoString;

// a simple Fusion Table name prefix check, to recognise tables created with this app
- (BOOL)isSampleAppFusionTable:(NSUInteger)rowIndex;

@end
