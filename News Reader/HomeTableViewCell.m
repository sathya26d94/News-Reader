//
//  HomeTableViewCell.m
//  News Reader
//
//  Created by sathiyamoorthy N on 23/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "MOC.h"

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _operation = [[NSOperationQueue alloc] init];
    // Initialization code
}

- (void)setImageView:(ArticleDetail*)detail {
    [_operation cancelAllOperations];
    [_operation addOperationWithBlock:^{        
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: detail.urlToImage]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.articleImageView.image = [UIImage imageWithData: imageData];
//            [[MOC sharedInstance] saveManagedObjectContext];
        });
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
