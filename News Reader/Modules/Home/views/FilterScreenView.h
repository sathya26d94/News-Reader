//
//  FilterScreenView.h
//  News Reader
//
//  Created by sathiyamoorthy N on 25/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FilterScreenViewDelegate <NSObject>

-(void)filterApplied:(BOOL)isSortByNewFirst publisher:(NSString *)publisher author:(NSString *)author;

@end

@interface FilterScreenView : UIView
@property (weak, nonatomic) IBOutlet UISwitch *sortTypeOld;
@property (weak, nonatomic) IBOutlet UISwitch *sortTypeNew;
@property (weak, nonatomic) IBOutlet UITextField *publisherTextField;
@property (weak, nonatomic) IBOutlet UITextField *AuthorTextField;

@property (assign, nonatomic) BOOL isSortByNewFirst;

/*! This is FilterScreenViewDelegate, use this to receive updates on Filterview */
@property (nonatomic, weak) id<FilterScreenViewDelegate> delegate;

+ (FilterScreenView*)initFilterScreenView;

/*!
 @brief Setupview with the given data
 @param isSortByNewFirst isSortByNewFirst
 @param publisher publisher
 @param author author
 */
- (void)setupView:(BOOL)isSortByNewFirst publisher:(NSString *)publisher author:(NSString *)author;

@end

NS_ASSUME_NONNULL_END
