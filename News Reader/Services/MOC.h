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

/*! Master managed object context */
- (NSManagedObjectContext *)masterManagedObjectContext;

/*!
 @brief Save master ManagedObjectContext
 */
- (void)saveManagedObjectContext;

/*!
 @brief clear data in the table older than the given date
 @param date records with date older than this will be deleted
 @param successBlock return the success response
 @param failureBlock return the failure response
 */
- (void)clearDataOlderThan:(NSDate*)date tableName:(NSString*)tableName withSuccess:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

@end
