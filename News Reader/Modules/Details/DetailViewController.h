//
//  DetailViewController.h
//  News Reader
//
//  Created by sathiyamoorthy N on 24/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController

@property(strong, nonatomic)ArticleDetail *details;

@end

NS_ASSUME_NONNULL_END
