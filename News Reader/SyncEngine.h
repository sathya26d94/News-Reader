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
- (void)fetchFilesAsynchronouslyWithURL:(NSString*)urlString withSuccess:(SuccessBlock)successBlock;
- (void)saveArticles:(id) data withSuccess:(SuccessBlock)successBlock;

@end
