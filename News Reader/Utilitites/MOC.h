//
//  MOC.h
//  News Reader
//
//  Created by sathiyamoorthy N on 23/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MOC : NSObject


typedef void (^SuccessBlock)(id responseObjects);
typedef void (^FailureBlock)(NSString* failureReason);
+ (MOC *)sharedInstance;
- (NSManagedObjectContext *)masterManagedObjectContext;
- (void)saveManagedObjectContext;
- (void)clearDataOlderThan:(NSDate*)date tableName:(NSString*)tableName withSuccess:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

@end
