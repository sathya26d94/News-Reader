//
//  DetailViewController.m
//  News Reader
//
//  Created by sathiyamoorthy N on 24/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

#import "DetailViewController.h"
#import <WebKit/WebKit.h>
#import "MOC.h"
#import "UIView+Category.h"
#import <UserNotifications/UserNotifications.h>

@interface DetailViewController ()<WKNavigationDelegate>
@property(strong, nonatomic)UIBarButtonItem *offlineDownloadButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoader;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
    webView.navigationDelegate = self;
    NSURL *nsurl=[NSURL URLWithString:self.details.url];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:nsurl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    
    NSString *title;
    if (self.details.websiteData) {
        [webView loadData:self.details.websiteData MIMEType:@"type/html" characterEncodingName:@"" baseURL:nsurl];
        title = @"Saved";
    }else{
        [webView loadRequest:theRequest];
        title = @"Save for Later";
    }
    [webView addAndMatchParentConstraintsWithParent:self.view];
    
    self.offlineDownloadButton = [[UIBarButtonItem alloc]
                                  initWithTitle:title style:UIBarButtonItemStyleDone
                                  target:self
                                  action:@selector(downloadAction:)];
    self.navigationItem.rightBarButtonItems= [NSArray arrayWithObjects:self.offlineDownloadButton,nil];
    
    
}

- (void)downloadAction:(id)sender{
    self.offlineDownloadButton.title = @"Saving...";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *nsurl=[NSURL URLWithString:self.details.url];
        NSData *data = [[NSData alloc] initWithContentsOfURL:nsurl];
        if (data) {
            self.details.websiteData = data;
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [[MOC sharedInstance] saveManagedObjectContext];
            self.offlineDownloadButton.title = @"Saved";
            [self sendLocalNotification];
        });
    });
    
}

- (void)sendLocalNotification {
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Download Completed";
    content.body = self.details.title;
    content.sound = [UNNotificationSound defaultSound];
    content.userInfo = @{@"title": self.details.title};
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"UYLLocalNotification" content:content trigger:trigger];
    // add notification for current notification centre
    [center addNotificationRequest:request withCompletionHandler:nil];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.view bringSubviewToFront:_activityLoader];
    [_activityLoader startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [_activityLoader stopAnimating];
}

@end

