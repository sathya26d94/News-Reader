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
#import "UIImageView+WebCache.h"
#import "Categories/UIView+Category.h"
#import "HomeViewModel.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, FilterScreenViewDelegate, HomeViewModelDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)HomeViewModel *viewModel;
@property (strong, nonatomic)FilterScreenView *filterView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setUpViewModel];
}

#pragma mark - UISetups
- (void)setupUI {
    [self setupTableView];
    [self addMoreButtonToNavigationController];
}

- (void)setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
}

- (void)showFilterView {
    if ([self.view.subviews containsObject:self.filterView]) {
        return;
    }
    if (self.filterView == nil) {
        self.filterView = [FilterScreenView initFilterScreenView];
    }
    self.filterView.delegate = self;
    [self.filterView setupView:self.viewModel.isSortByNewFirst publisher:self.viewModel.publisherFilter author:self.viewModel.authorFilter];
    [self.filterView addAndMatchParentConstraintsWithParent:self.view];
}

- (void)addMoreButtonToNavigationController {
    UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStyleDone target:self action:@selector(moreButtonAction:)];
    self.navigationItem.rightBarButtonItems= [NSArray arrayWithObjects:moreButton,nil];
}

#pragma mark - IBAction
- (void)moreButtonAction:(id)sender{
    [self showFilterView];
}

#pragma mark - ViewModel setup
- (void)setUpViewModel {
    self.viewModel = [[HomeViewModel alloc] init];
    [self.viewModel loadDataWithFetchedResultsControllerDelegateReceiver:self];
    self.viewModel.delegate = self;
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

#pragma mark - Table View datasource Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.viewModel.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.viewModel.fetchedResultsController sections];
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
    ArticleDetail *record = [self.viewModel.fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleLabelView.text = record.title;
    cell.descriptionLabelView.text = record.descriptions;
    cell.authorLabel.text = record.author;
    cell.dateLabel.text = [NSDateFormatter localizedStringFromDate:record.publishedAt dateStyle:NSDateFormatterShortStyle timeStyle:kCFDateFormatterShortStyle];
    [cell.articleImageView sd_cancelCurrentImageLoad];
    [cell.articleImageView sd_setImageWithURL:[[NSURL alloc] initWithString:record.urlToImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ArticleDetail *record = [self.viewModel.fetchedResultsController objectAtIndexPath:indexPath];
    [Router showDetailScreen:self articleDetail:record];
}

#pragma mark - FilterScreenViewDelegate
- (void)filterApplied:(BOOL)isSortByNewFirst publisher:(NSString *)publisher author:(NSString *)author {
    [self.viewModel applyfilterAndPerformFetchWithIsSortByNewFirst:isSortByNewFirst publisher:publisher author:author];
}

#pragma mark - HomeViewModelDelegate
- (void)reloadTable {
    [self.tableView reloadData];
}

@end
