//
//  HomeSkeletonView.m
//  News Reader
//
//  Created by sathiyamoorthy N on 26/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

#import "HomeSkeletonView.h"

@implementation HomeSkeletonView
BOOL animeBool;
NSTimer *animeTimer;

+ (HomeSkeletonView*)initHomeSkeletonView {
    HomeSkeletonView *result = [[[NSBundle mainBundle] loadNibNamed:@"HomeSkeletonView" owner:nil options:nil] lastObject];
    return result;
}

-(void)createAnimeTimer {
    [animeTimer invalidate];
    animeTimer= nil;
    [self setColorWithOpacity:0.47];
    animeBool = true;
    animeTimer =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeAnimeOpacity) userInfo:nil repeats:YES];
}

-(void)removeThisView {
    [animeTimer invalidate];
    animeTimer= nil;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)changeAnimeOpacity {
    CGFloat val = animeBool ? 0.55 : 0.47;
    [UIView animateWithDuration:0.5 animations:^{
        [self setColorWithOpacity:val];
    }];
    animeBool = !animeBool;    
}

- (void)setColorWithOpacity:(CGFloat)val {
    self.view1.backgroundColor = [self getAnimeColorWithOpacity:val];
    self.view2.backgroundColor = [self getAnimeColorWithOpacity:val];
    self.view3.backgroundColor = [self getAnimeColorWithOpacity:val];
    self.view4.backgroundColor = [self getAnimeColorWithOpacity:val];
    self.view5.backgroundColor = [self getAnimeColorWithOpacity:val];
    self.view6.backgroundColor = [self getAnimeColorWithOpacity:val];
    self.view7.backgroundColor = [self getAnimeColorWithOpacity:val];
    self.view8.backgroundColor = [self getAnimeColorWithOpacity:val];
    self.view9.backgroundColor = [self getAnimeColorWithOpacity:val];
    self.view10.backgroundColor = [self getAnimeColorWithOpacity:val];
    self.view11.backgroundColor = [self getAnimeColorWithOpacity:val];
    self.view12.backgroundColor = [self getAnimeColorWithOpacity:val];
    self.view13.backgroundColor = [self getAnimeColorWithOpacity:val];
    self.view14.backgroundColor = [self getAnimeColorWithOpacity:val];
    self.view15.backgroundColor = [self getAnimeColorWithOpacity:val];
    self.view16.backgroundColor = [self getAnimeColorWithOpacity:val];
    self.view17.backgroundColor = [self getAnimeColorWithOpacity:val];
    self.view18.backgroundColor = [self getAnimeColorWithOpacity:val];
    self.view19.backgroundColor = [self getAnimeColorWithOpacity:val];
    self.view20.backgroundColor = [self getAnimeColorWithOpacity:val];
}

-(UIColor*)getAnimeColorWithOpacity:(CGFloat)alpha {
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha];
}


@end
