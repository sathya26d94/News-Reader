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
#import "AlertView.h"
#import <News_Reader-Swift.h>
#import "Appdelegate.h"


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

#pragma mark -class initialization method
- (id)init {
    self = [super init];
    return self;
}

#pragma mark - singleton navi controller
+ (UINavigationController *)navigationController {
    static dispatch_once_t once;
    static UINavigationController *dataBaseDAOObject;
    dispatch_once(&once, ^{
        dataBaseDAOObject = [[UINavigationController alloc] init];
    });
    return dataBaseDAOObject;
}

#pragma mark - set home view
+ (void)showHomeScreen {
    HomeViewController *homeVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    homeVC.title = @"News";
    [[Router navigationController] setViewControllers:@[homeVC]];
}

#pragma mark - go to detail
+ (void)showDetailScreen:(UIViewController*)parentVC  articleDetail:(ArticleDetail*)articleDetail {
    if (parentVC == nil) { //Incase called from notifications
        UIViewController *topvc = [UIApplication topViewControllerObjcCWithController:nil];
        if ([topvc isKindOfClass:HomeViewController.class]){
            parentVC = topvc;
        }else if ([topvc isKindOfClass:DetailViewController.class]){
            [topvc.navigationController popViewControllerAnimated:false];
            parentVC = [UIApplication topViewControllerObjcCWithController:nil];
        }else {
            //todo
        }
    }
    DetailViewController *detailVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    detailVC.details = articleDetail;
    [parentVC.navigationController pushViewController:detailVC animated:true];
}

#pragma mark - show alert view
+ (void)showAlertWithMessage:(NSString*)msg {
    UIWindow *window = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
    AlertView *alertView = [AlertView initAlertView];
    [alertView addToWindowWithText:msg toView:window];
}



@end
