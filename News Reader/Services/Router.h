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
+ (void)showDetailScreen:(UIViewController*)parentVC  articleDetail:(ArticleDetail*)articleDetail;

+ (void)showHomeScreen;
+ (void)showAlertWithMessage:(NSString*)msg;


@end


