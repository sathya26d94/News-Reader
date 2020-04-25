//
//  Router.m
//  News Reader
//
//  Created by sathiyamoorthy N on 22/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

#import "Router.h"
#import "HomeViewController.h"
#import "DetailViewController.h"

@implementation Router

#pragma mark - Singleton
+ (Router *)sharedInstance {
    static dispatch_once_t once;
    static Router *dataBaseDAOObject;
    dispatch_once(&once, ^{
        dataBaseDAOObject = [[self alloc] init];
    });
    return dataBaseDAOObject;
}

+ (UINavigationController *)navigationController {
    static dispatch_once_t once;
    static UINavigationController *dataBaseDAOObject;
    dispatch_once(&once, ^{
        dataBaseDAOObject = [[UINavigationController alloc] init];
    });
    return dataBaseDAOObject;
}

#pragma mark -class initialization method
- (id)init {
    self = [super init];
    return self;
}

+ (void)showHomeScreen {
    HomeViewController *homeVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    homeVC.title = @"News";
    [[Router navigationController] setViewControllers:@[homeVC]];
}

+ (void)showDetailScreen:(UIViewController*)parentVC  articleDetail:(ArticleDetail*)articleDetail {
    DetailViewController *detailVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    detailVC.details = articleDetail;
    [parentVC.navigationController pushViewController:detailVC animated:true];
}


@end
