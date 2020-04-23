//
//  Router.h
//  News Reader
//
//  Created by sathiyamoorthy N on 22/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Router : NSObject

+ (Router *)sharedInstance;
+ (UINavigationController *)navigationController;


+ (void)showHomeScreen;


@end


