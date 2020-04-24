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

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSArray *tableArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCell"];

    NSString *url = @"https://moedemo-93e2e.firebaseapp.com/assignment/NewsApp/articles.json";
    [[SyncEngine sharedInstance] fetchFilesAsynchronouslyWithURL:url withSuccess:^(id responseObjects) {
        [[SyncEngine sharedInstance] saveArticles:(id)responseObjects withSuccess:^(id responseObjects) {
            
        }];        
    }];
    self.title = @"News Reader";
    
    NSFetchRequest *fetchRequest = [ArticleDetail fetchRequest];
    
    // Add Sort Descriptors
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"publishedAt" ascending:NO]]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[MOC sharedInstance]masterManagedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultsController setDelegate:self];

    // Perform Fetch
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];

    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
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
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    
    return cell;
}

- (void)configureCell:(HomeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Fetch Record
    ArticleDetail *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = record.author;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSManagedObject *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
//
//        if (record) {
//            [self.fetchedResultsController.managedObjectContext deleteObject:record];
//        }
    }
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
