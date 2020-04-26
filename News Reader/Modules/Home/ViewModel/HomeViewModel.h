//
//  HomeViewModel.h
//  News Reader
//
//  Created by sathiyamoorthy N on 26/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SyncEngine.h"
#import "ArticleDetail.h"
#import "MOC.h"

@protocol HomeViewModelDelegate <NSObject>

-(void)reloadTable;
-(void)initialFetchCompleted;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewModel : NSObject

@property (nonatomic, weak) id<HomeViewModelDelegate> delegate;
@property (nonatomic, weak) id fetchedResultsControllerDelegateReceiver;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchRequest *fetchRequest;
@property (assign, nonatomic) BOOL isSortByNewFirst;
@property (strong, nonatomic) NSString *publisherFilter;
@property (strong, nonatomic) NSString *authorFilter;

- (void)loadDataWithFetchedResultsControllerDelegateReceiver:(id)receiver;
- (void)applyfilterAndPerformFetchWithIsSortByNewFirst:(BOOL)isSortByNewFirst publisher:(NSString *)publisher author:(NSString *)author;

@end

NS_ASSUME_NONNULL_END
