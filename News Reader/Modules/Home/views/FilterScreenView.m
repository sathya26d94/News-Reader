//
//  FilterScreenView.m
//  News Reader
//
//  Created by sathiyamoorthy N on 25/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

#import "FilterScreenView.h"

@implementation FilterScreenView

#pragma mark - Init method
+ (FilterScreenView*)initFilterScreenView {
    FilterScreenView *result = [[[NSBundle mainBundle] loadNibNamed:@"FilterScreenView" owner:nil options:nil] lastObject];
    return result;
}

#pragma mark - initialize data
- (void)setupView:(BOOL)isSortByNewFirst publisher:(NSString *)publisher author:(NSString *)author {
    self.isSortByNewFirst = isSortByNewFirst;
    self.publisherTextField.text = publisher;
    self.AuthorTextField.text = author;
    
    self.sortTypeOld.on = !isSortByNewFirst;
    self.sortTypeNew.on = isSortByNewFirst;
}

#pragma mark - IBActions
- (IBAction)applyAction:(id)sender {
    if ([[self delegate] respondsToSelector:@selector(filterApplied:publisher:author:)]) {
        [self.delegate filterApplied:_isSortByNewFirst publisher:self.publisherTextField.text author:self.AuthorTextField.text];
    }
    [self removeFromSuperview];
}

- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)newSwitch:(id)sender forEvent:(UIEvent *)event {
    self.isSortByNewFirst = !self.isSortByNewFirst;
    self.sortTypeOld.on = !self.isSortByNewFirst;
    self.sortTypeNew.on = self.isSortByNewFirst;
}

- (IBAction)oldSwitch:(id)sender forEvent:(UIEvent *)event {
    self.isSortByNewFirst = !self.isSortByNewFirst;
    self.sortTypeOld.on = !self.isSortByNewFirst;
    self.sortTypeNew.on = self.isSortByNewFirst;
}

@end
