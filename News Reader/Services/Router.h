//
//  Router.h
//  News Reader
//
//  Created by sathiyamoorthy N on 22/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ArticleDetail.h"


@interface Router : NSObject

+ (Router *)sharedInstance;
+ (UINavigationController *)navigationController;

/*!
 @brief Navigate to detail view controller
 @param parentVC parent viewcontroller
 @param articleDetail Article details which has URL to load the article
 */
+ (void)showDetailScreen:(UIViewController*)parentVC  articleDetail:(ArticleDetail*)articleDetail;

/*!
 @brief Navigate to Home view
 */
+ (void)showHomeScreen;

/*!
 @brief Show Alerts
 @param msg message needs to be displayed
 */
+ (void)showAlertWithMessage:(NSString*)msg;


@end


