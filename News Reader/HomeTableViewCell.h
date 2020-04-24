//
//  HomeTableViewCell.h
//  News Reader
//
//  Created by sathiyamoorthy N on 23/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabelView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) NSOperationQueue *operation;
- (void)setImageView:(ArticleDetail*)detail;

@end

NS_ASSUME_NONNULL_END
