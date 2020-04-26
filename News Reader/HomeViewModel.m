//
//  HomeViewModel.m
//  News Reader
//
//  Created by sathiyamoorthy N on 26/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

#import "HomeViewModel.h"

@implementation HomeViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeVariables];
    }
    return self;
}

- (void)initializeVariables {
    self.isSortByNewFirst = true;
    self.publisherFilter = @"";
    self.authorFilter = @"";
    self.fetchRequest = [ArticleDetail fetchRequest];
}

- (void)loadDataWithFetchedResultsControllerDelegateReceiver:(id)receiver {
    self.fetchedResultsControllerDelegateReceiver = receiver;
    [self performAPIFetch];
    [self performCoreDataFetch];
}

- (void)performAPIFetch {
    NSString *url = @"https://moedemo-93e2e.firebaseapp.com/assignment/NewsApp/articles.json";
    [[SyncEngine sharedInstance] fetchFilesAsynchronouslyWithURL:url withSuccess:^(id responseObjects) {
        [[SyncEngine sharedInstance] saveArticles:(id)responseObjects withSuccess:^(id responseObjects) {
            
        }];
    }];
}

- (void)applyfilterAndPerformFetchWithIsSortByNewFirst:(BOOL)isSortByNewFirst publisher:(NSString *)publisher author:(NSString *)author {
    self.isSortByNewFirst = isSortByNewFirst;
    self.publisherFilter = publisher;
    self.authorFilter = author;
    [self performCoreDataFetch];
}

#pragma mark - Utilities
- (void)performCoreDataFetch {
    [self.fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"publishedAt" ascending:!self.isSortByNewFirst]]];
    NSMutableArray *compoundPredicateArray = [NSMutableArray array];
    if ([_authorFilter length] > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author CONTAINS[cd] %@", _authorFilter];
        [compoundPredicateArray addObject:predicate];
    }
    if ([_publisherFilter length] > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"publisher CONTAINS[cd] %@", _publisherFilter];
        [compoundPredicateArray addObject:predicate];
    }
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates: compoundPredicateArray];
    [self.fetchRequest setPredicate:predicate];
    if (self.fetchedResultsController == nil) {
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest managedObjectContext:[[MOC sharedInstance]masterManagedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    }
    [self.fetchedResultsController setDelegate:self.fetchedResultsControllerDelegateReceiver];
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (error) {
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    if ([[self delegate] respondsToSelector:@selector(reloadTable)]) {
        [self.delegate reloadTable];
    }
}

@end
