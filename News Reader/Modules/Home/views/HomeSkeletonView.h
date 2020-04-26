//
//  HomeSkeletonView.h
//  News Reader
//
//  Created by sathiyamoorthy N on 26/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <News_Reader-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeSkeletonView : UIView
+ (HomeSkeletonView*)initHomeSkeletonView;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet UIView *view7;
@property (weak, nonatomic) IBOutlet UIView *view8;
@property (weak, nonatomic) IBOutlet UIView *view9;
@property (weak, nonatomic) IBOutlet UIView *view10;
@property (weak, nonatomic) IBOutlet UIView *view11;
@property (weak, nonatomic) IBOutlet UIView *view12;
@property (weak, nonatomic) IBOutlet UIView *view13;
@property (weak, nonatomic) IBOutlet UIView *view14;
@property (weak, nonatomic) IBOutlet UIView *view15;
@property (weak, nonatomic) IBOutlet UIView *view16;
@property (weak, nonatomic) IBOutlet UIView *view17;
@property (weak, nonatomic) IBOutlet UIView *view18;
@property (weak, nonatomic) IBOutlet UIView *view19;
@property (weak, nonatomic) IBOutlet UIView *view20;

-(void)createAnimeTimer;
-(void)removeThisView;

@end

NS_ASSUME_NONNULL_END
