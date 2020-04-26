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

/*! This is HomeViewModelDelegate delegate, use this to receive updates */
@property (nonatomic, weak) id<HomeViewModelDelegate> delegate;

/*! This is fetchedResultsController property, use this to set datasource to tableview */
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, weak) id fetchedResultsControllerDelegateReceiver;
@property (strong, nonatomic) NSFetchRequest *fetchRequest;
@property (assign, nonatomic) BOOL isSortByNewFirst;
@property (strong, nonatomic) NSString *publisherFilter;
@property (strong, nonatomic) NSString *authorFilter;

/*!
 @brief load api and coredata
 @param receiver controller which needs to receives FetchedResultsControllerDelegate
 */
- (void)loadDataWithFetchedResultsControllerDelegateReceiver:(id)receiver;

/*!
 @brief Apply filter and fetch data from core data
 @param isSortByNewFirst isSortByNewFirst
 @param publisher publisher
 @param author author
 */
- (void)applyfilterAndPerformFetchWithIsSortByNewFirst:(BOOL)isSortByNewFirst publisher:(NSString *)publisher author:(NSString *)author;

@end

NS_ASSUME_NONNULL_END
