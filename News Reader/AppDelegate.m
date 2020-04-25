//
//  AppDelegate.m
//  News Reader
//
//  Created by sathiyamoorthy N on 22/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

#import "AppDelegate.h"
#import "Router.h"
#import <UserNotifications/UserNotifications.h>
#import "SyncEngine.h"


@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [Router navigationController];
    [Router showHomeScreen];
    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    return YES;
}


- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"started");
    NSString *url = @"https://moedemo-93e2e.firebaseapp.com/assignment/NewsApp/articles.json";
    [[SyncEngine sharedInstance] fetchFilesAsynchronouslyWithURL:url withSuccess:^(id responseObjects) {
        [[SyncEngine sharedInstance] saveArticles:(id)responseObjects withSuccess:^(id responseObjects) {
            NSLog(@"completed");
            completionHandler(UIBackgroundFetchResultNewData);
        }];
    }];
}


@end
//todos
/*
 1) image caching
 2) download from home
 3) background fetch *
 4) remove old data
 5) MVVM
 6) Push Notification *
 */
