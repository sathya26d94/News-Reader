//
//  UIView+Category.m
//  News Reader
//
//  Created by sathiyamoorthy N on 25/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)

#pragma mark - constriant to match parent
- (void)addAndMatchParentConstraintsWithParent:(UIView*)parentView {
    self.translatesAutoresizingMaskIntoConstraints = false;
    [parentView addSubview:self];
    
    [self.topAnchor constraintEqualToAnchor:parentView.topAnchor constant:0].active = YES;
    [self.leftAnchor constraintEqualToAnchor:parentView.leftAnchor constant:0].active = YES;
    [self.rightAnchor constraintEqualToAnchor:parentView.rightAnchor constant:0].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:parentView.bottomAnchor constant:0].active = YES;
}


@end
