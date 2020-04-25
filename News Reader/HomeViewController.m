//
//  HomeViewController.m
//  News Reader
//
//  Created by sathiyamoorthy N on 22/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

#import "HomeViewController.h"
#import "SyncEngine.h"
#import "ArticleDetail.h"
#import "MOC.h"
#import "HomeTableViewCell.h"
#import "Router.h"
#import "FilterScreenView.h"
#import "Categories/UIView+Category.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, FilterScreenViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchRequest *fetchRequest;
@property (assign, nonatomic) BOOL isSortByNewFirst;
@property (strong, nonatomic) NSString *publisherFilter;
@property (strong, nonatomic) NSString *authorFilter;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSortByNewFirst = true;
    self.publisherFilter = @"";
    self.authorFilter = @"";
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    NSString *url = @"https://moedemo-93e2e.firebaseapp.com/assignment/NewsApp/articles.json";
    [[SyncEngine sharedInstance] fetchFilesAsynchronouslyWithURL:url withSuccess:^(id responseObjects) {
        [[SyncEngine sharedInstance] saveArticles:(id)responseObjects withSuccess:^(id responseObjects) {
            
        }];        
    }];
    
    self.fetchRequest = [ArticleDetail fetchRequest];
    [self performFetch];
    
    UIBarButtonItem *moreButton = [[UIBarButtonItem alloc]
                                  initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStyleDone 
                                  target:self
                                  action:@selector(moreButton:)];
    
    self.navigationItem.rightBarButtonItems= [NSArray arrayWithObjects:moreButton,nil];
    
    
}

- (void)moreButton:(id)sender{
    FilterScreenView *filterView = [FilterScreenView initFilterScreenView];
    filterView.delegate = self;
    [filterView setupView:_isSortByNewFirst publisher:self.publisherFilter author:self.authorFilter];
    [filterView addAndMatchParentConstraintsWithParent:self.view];
}


#pragma mark Fetched Results Controller Delegate Methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            HomeTableViewCell *updateCell = [self.tableView cellForRowAtIndexPath:indexPath];
            if ([self.tableView.visibleCells containsObject:updateCell]) {
                [self configureCell:(HomeTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            }
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
    }
}

#pragma mark -
#pragma mark Table View datasource Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier=@"HomeTableViewCell";
    HomeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    
    return cell;
}

- (void)configureCell:(HomeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Fetch Record
    cell.imageView.image = [[UIImage alloc] init];
    ArticleDetail *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleLabelView.text = record.title;
    cell.descriptionLabelView.text = record.descriptions;
    cell.authorLabel.text = record.author;
    cell.dateLabel.text = [NSDateFormatter localizedStringFromDate:record.publishedAt
                                                         dateStyle:NSDateFormatterShortStyle
                                                         timeStyle:kCFDateFormatterShortStyle];
    if (record.imageData != nil) {
        cell.imageView.image = [UIImage imageWithData: record.imageData];
    }else {
        [cell setImageView:record];
    }
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ArticleDetail *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [Router showDetailScreen:self articleDetail:record];
}

- (void)filterApplied:(BOOL)isSortByNewFirst publisher:(NSString *)publisher author:(NSString *)author {
    self.isSortByNewFirst = isSortByNewFirst;
    self.publisherFilter = publisher;
    self.authorFilter = author;
    [self performFetch];
}

- (void)performFetch {
    
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
    
    [self.fetchedResultsController setDelegate:self];
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (error) {
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    [self.tableView reloadData];
}

@end
