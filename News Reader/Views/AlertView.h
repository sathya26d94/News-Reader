//
//  AlertView.h
//  News Reader
//
//  Created by sathiyamoorthy N on 26/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertView : UIView
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

+ (AlertView*)initAlertView;
- (void)addToWindowWithText:(NSString*)text toView:(UIView*)view;

@end

NS_ASSUME_NONNULL_END
