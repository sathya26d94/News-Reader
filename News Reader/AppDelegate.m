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
#import "Reachability.h"


@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

#pragma mark - App life cycle delegates
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [Router navigationController];
    [self.window makeKeyAndVisible];
    [Router showHomeScreen];
    
    [self setBackgroundFetchInterval];
    [self requestPushNotificationPermission];
    [self addReachabilityObserver];
    [self checkForReachability];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //Allows downloads to continue in background
    __block UIBackgroundTaskIdentifier backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^(void) {
        [application endBackgroundTask:backgroundTaskIdentifier];
    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
}

#pragma mark - BackgroundFetch
- (void)setBackgroundFetchInterval {
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
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

#pragma mark - UNUserNotificationCenter delegates
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^) (UNNotificationPresentationOptions))completionHandler {
    
    UNNotificationPresentationOptions presentationOptions = UNNotificationPresentationOptionSound + UNNotificationPresentationOptionAlert;
    completionHandler(presentationOptions);
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    NSString *articelTitle = response.notification.request.content.body;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ArticleDetail"];
    [fetchRequest setIncludesPropertyValues:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", articelTitle];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray *fetchedObjects = [[[MOC sharedInstance]masterManagedObjectContext]  executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count > 0) {
        [Router showDetailScreen:nil articleDetail:(ArticleDetail*)fetchedObjects[0]];
    }
}

#pragma mark - request user permission
- (void)requestPushNotificationPermission {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
    }];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

#pragma mark - observe reachability

- (void)addReachabilityObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkForReachability) name:kReachabilityChangedNotification object:nil];
}

- (void)checkForReachability {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable) {
        [Router showAlertWithMessage:@"Network connection seems to be offline,You continue reading downloaded articles"];
    }else{
        // Else do something else
    }
}


@end
//todos
/*
 use data.id for unique
 5) MVVM *
 9) clear in filter
 ● Visually interactive design to list details.
 ● Custom design, font and icons to make app more user friendly.
 ● Use your imagination and add features which would make things easier for end
 users.
 */
