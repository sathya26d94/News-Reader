//
//  SyncEngine.h
//  News Reader
//
//  Created by sathiyamoorthy N on 23/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOC.h"

@interface SyncEngine : NSObject

+ (SyncEngine *)sharedInstance;

/*!
 @brief Fetches the JSON data from the API server
 @param urlString API URL
 @param successBlock return the response object as dictionary
 */
- (void)fetchFilesAsynchronouslyWithURL:(NSString*)urlString withSuccess:(SuccessBlock)successBlock;

/*!
 @brief Save the given data to the core data, removes one year old data, ignore dupicates
 @param data result dictionary from api
 @param successBlock return the success/failure response
 */
- (void)saveArticles:(id) data withSuccess:(SuccessBlock)successBlock;

@end
