//
//  AlertView.m
//  News Reader
//
//  Created by sathiyamoorthy N on 26/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView

#pragma mark - Init method
+ (AlertView*)initAlertView {
    AlertView *result = [[[NSBundle mainBundle] loadNibNamed:@"AlertView" owner:nil options:nil] lastObject];
    return result;
}

- (void)addToWindowWithText:(NSString*)text toView:(UIView*)view {
    self.textLabel.text = text;
    [self addAndSetConstraints:view];
    [self performSelector:@selector(closeAlert) withObject:nil afterDelay:10];
}

- (void)closeAlert {
    [self closeAction:nil];
}

- (IBAction)closeAction:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)addAndSetConstraints:(UIView*)parentView {    
    self.translatesAutoresizingMaskIntoConstraints = false;
    [parentView addSubview:self];
    [parentView bringSubviewToFront:self];
    self.layer.cornerRadius = 15.5;
    [self.leftAnchor constraintEqualToAnchor:parentView.leftAnchor constant:10].active = YES;
    [self.rightAnchor constraintEqualToAnchor:parentView.rightAnchor constant:-10].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:parentView.bottomAnchor constant:-150].active = YES;
}

@end
