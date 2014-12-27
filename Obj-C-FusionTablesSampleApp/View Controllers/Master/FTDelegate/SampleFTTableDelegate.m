//
//  SampleFTDelegate.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 21/12/14.
//  Copyright (c) 2014 Arseniy Kuznetsov. All rights reserved.
//

#import "SampleFTTableDelegate.h"
#import "SampleViewController.h"
#import "EmptyDetailViewController.h"
#import "AppDelegate.h"

// processing states
typedef NS_ENUM (NSUInteger, FTProcessingStates) {
    kFTStateIdle = 0,
    kFTStateAuthenticating,
    kFTStateRetrieving,
    kFTStateInserting,
    kFTStateDeleting
};

@implementation SampleFTTableDelegate {
    FTProcessingStates ftProcessingState;
}

#pragma mark - Initialization
- (instancetype)init {
    self = [super init];
    if (self) {        
        ftProcessingState = ([[GoogleAuthorizationController sharedInstance] isAuthorised]) ? 
                                                            kFTStateIdle : kFTStateAuthenticating;
    }
    return self;
}

- (FTTable *)ftTable {
    if (!_ftTable) {
        _ftTable = [[FTTable alloc] init];
        _ftTable.ftTableDelegate = self;
    }
    return _ftTable;
}

#pragma mark - FTDelegate methods
- (NSString *)ftTableID {
    return self.selectedFusionTableID;
}

- (NSString *)ftName {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd-hhmmss"];
    return [NSString stringWithFormat:@"%@%@",
            SAMPLE_FUSION_TABLE_PREFIX, [formatter stringFromDate:[NSDate date]]];
}

// Sample Fusion Table Columns Definition
- (NSArray *)ftColumns {
    return @[
             @{@"name": @"entryDate",
               @"type": @"STRING"
               },
             @{@"name": @"entryName",
               @"type": @"STRING"
               },
             @{@"name": @"entryThumbImageURL",
               @"type": @"STRING"
               },
             @{@"name": @"entryURL",
               @"type": @"STRING"
               },
             @{@"name": @"entryURLDescription",
               @"type": @"STRING"
               },
             @{@"name": @"entryNote",
               @"type": @"STRING"
               },
             @{@"name": @"entryImageURL",
               @"type": @"STRING"
               },
             @{@"name": @"markerIcon",
               @"type": @"STRING"
               },
             @{@"name": @"lineColor",
               @"type": @"STRING"
               },
             @{@"name": @"geometry",
               @"type": @"LOCATION"
               }
             ];
}

#pragma mark - FTTable manipulation methods
// loads list of Fusion Tables for authenticated user
- (void)loadFusionTablesWithPreprocessingBlock:(void_completion_handler_block)preProcessingBlock 
                            FailedCompletionHandler:(void_completion_handler_block)failHandler
                            CompletionHandler:(void_completion_handler_block)completionHandler {
    if (ftProcessingState == kFTStateIdle || ftProcessingState == kFTStateAuthenticating) {
        [[GoogleServicesHelper sharedInstance] incrementNetworkActivityIndicator];        
        [[GoogleAuthorizationController sharedInstance] authorizedRequestWithCompletionHandler:^{
            ftProcessingState =  kFTStateRetrieving;
            self.ftTableObjects = nil;           
            if (preProcessingBlock) { 
                preProcessingBlock();
            }                    
            [self.ftTable listFusionTablesWithCompletionHandler:^(NSData *data, NSError *error) {
                [[GoogleServicesHelper sharedInstance] decrementNetworkActivityIndicator];
                ftProcessingState = kFTStateIdle;
                if (error) {
                    NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
                    [[GoogleServicesHelper sharedInstance]
                        showAlertViewWithTitle:@"Fusion Tables Error" AndText: 
                        [NSString stringWithFormat:@"Error Fetching Fusion Tables: %@", errorStr]];
                    if (failHandler) {
                        failHandler();
                    }                       
                } else {
                    NSDictionary *lines = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:kNilOptions error:nil];
                    NSLog(@"Fusion Tables: %@", lines);
                    self.ftTableObjects = [NSMutableArray arrayWithArray:lines[@"items"]];
                    if (completionHandler) {
                        completionHandler();
                    }                    
                }                
            }];
         } CancelHandler:^ {
             // if login was cancelled, give a user another chance to reconsider
             [[GoogleServicesHelper sharedInstance] decrementNetworkActivityIndicator];        
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ 
                    [self loadFusionTablesWithPreprocessingBlock:preProcessingBlock 
                              FailedCompletionHandler:failHandler CompletionHandler:completionHandler];
             });              
         }];
    }
}

// inserts a new Fusion Tables
- (void)insertNewFusionTableWithPreprocessingBlock:(void_completion_handler_block)preProcessingBlock 
                            FailedCompletionHandler:(void_completion_handler_block)failHandler
                            CompletionHandler:(void_completion_handler_block)completionHandler {
    if (ftProcessingState == kFTStateIdle) {
        ftProcessingState = kFTStateInserting;
        if (preProcessingBlock) { 
            preProcessingBlock();
        }        
        [[GoogleServicesHelper sharedInstance] incrementNetworkActivityIndicator];
        [self.ftTable insertFusionTableWithCompletionHandler:^(NSData *data, NSError *error) {
            [[GoogleServicesHelper sharedInstance] decrementNetworkActivityIndicator];
            ftProcessingState = kFTStateIdle;   
            if (error) {
                NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];                
                [[GoogleServicesHelper sharedInstance]
                     showAlertViewWithTitle:@"Fusion Tables Error" AndText: 
                        [NSString stringWithFormat:@"Error Inserting Fusion Table: %@", errorStr]];
                if (failHandler) {
                    failHandler();
                }                                
            } else {
                NSDictionary *ftTableDict = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:kNilOptions error:nil];
                if (ftTableDict) {
                    NSLog(@"Inserted a new Fusion Table: %@", ftTableDict);                    
                    [self.ftTableObjects insertObject:ftTableDict atIndex:0];                    
                    completionHandler();
                } else {
                    // the FT Create Insert did not return sound info
                    [[GoogleServicesHelper sharedInstance]
                         showAlertViewWithTitle:@"Fusion Tables Error"
                         AndText:  @"Error processsing inserted Fusion Table data"];        
                    if (failHandler) {
                        failHandler();
                    }                                    
                }
            }            
        }];
    }
}

// inserts a new Fusion Tables
- (void)deleteFusionTableWithPreprocessingBlock:(void_completion_handler_block)preProcessingBlock 
                            FailedCompletionHandler:(void_completion_handler_block)failHandler
                            CompletionHandler:(void_completion_handler_block)completionHandler {
    if (ftProcessingState == kFTStateIdle) {
        ftProcessingState = kFTStateDeleting;
        if (preProcessingBlock) { 
            preProcessingBlock();
        }           
        [[GoogleServicesHelper sharedInstance] incrementNetworkActivityIndicator];
        [self.ftTable deleteFusionTableWithCompletionHandler:^(NSData *data, NSError *error) {
            [[GoogleServicesHelper sharedInstance] decrementNetworkActivityIndicator];
            ftProcessingState = kFTStateIdle;
            if (error) {
                NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
                [[GoogleServicesHelper sharedInstance]
                     showAlertViewWithTitle:@"Fusion Tables Error"
                     AndText: [NSString stringWithFormat:@"Error deleting Fusion Table: %@", errorStr]];
                if (failHandler) {
                    failHandler();
                }                     
            } else {
                // Table deleted, run the handler
                completionHandler();
            }            
        }];
    }
}

- (NSString *)currentActionInfoString {
    NSString *processingStateString = @"";
    switch (ftProcessingState) {
        case kFTStateIdle: {
            NSString *userID = [[GoogleAuthorizationController sharedInstance] authenticatedUserID];
            if (userID) {
                processingStateString = [NSString stringWithFormat:@"Fusion Tables for userID: %@", userID];
            } else {
                processingStateString = [NSString stringWithFormat:@"Pull down to retrieve your Fusion Tables"];
            }
            break;
        }
        case kFTStateAuthenticating:
            processingStateString = @"... authenticating for a Google Account";
            break;
        case kFTStateRetrieving:
            processingStateString = @"... retrieving list of Fusion Tables";
            break;
        case kFTStateInserting:
            processingStateString = @"... creating a new Fusion Table";
            break;
        case kFTStateDeleting:
            processingStateString = @"... deleting Fusion Table";
            break;
        default:
            break;
    }
    return processingStateString;
}


@end
