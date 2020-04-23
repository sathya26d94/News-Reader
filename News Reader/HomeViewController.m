//
//  HomeViewController.m
//  News Reader
//
//  Created by sathiyamoorthy N on 22/04/20.
//  Copyright © 2020 sathiyamoorthy N. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tableArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    self.title = @"News Reader";    
}


#pragma mark - tableview datasource, delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier=@"TableViewCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
    }
    cell.textLabel.text = self.tableArray[indexPath.row];
    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
