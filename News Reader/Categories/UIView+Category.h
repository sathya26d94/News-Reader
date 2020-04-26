//
//  UIView+Category.h
//  News Reader
//
//  Created by sathiyamoorthy N on 25/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Category)
/*!
 @brief match the parents bounds with constraints
 @param parentView view in which this view needs to be added
 */
- (void)addAndMatchParentConstraintsWithParent:(UIView*)parentView;
@end

NS_ASSUME_NONNULL_END
