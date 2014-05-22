//
//  MainViewController.m
//  TestStoryboard
//
//  Created by Marvin on 19/05/14.
//  Copyright (c) 2014 Marvin. All rights reserved.
//

#import "MainViewController.h"
#import "MainCell.h"
#import "DetailViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) NSMutableArray *arrAllDetails;
@property (nonatomic, strong) NSMutableArray *filterdDetails;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation MainViewController

const int totalPages = 4;

#pragma mark - View life cycle

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"TableView";

    _arrAllDetails = [[NSMutableArray alloc] init];
    _filterdDetails = [[NSMutableArray alloc] init];

    for(int i=0;i<10;i++){
        [_arrAllDetails addObject:[NSString stringWithFormat:@"Test %d",_currentIndex+i+1]];
    }

    //[self.searchDisplayController.searchResultsTableView registerClass:[MainCell class] forCellReuseIdentifier:@"MainCell"];
    //[self.searchDisplayController.searchResultsTableView setRowHeight:self.tblView.rowHeight];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView==_tblView){
        return _arrAllDetails.count;
    }else {
        return _filterdDetails.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MainCell";
    MainCell *cell = (MainCell *)[self.tblView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if (cell == nil) {
        cell = [[MainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    if(tableView==self.tblView){
        cell.lblText.text = _arrAllDetails[indexPath.row];
    }else {
        cell.lblText.text = _filterdDetails[indexPath.row];
    }

    cell.tag = indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(_currentIndex<=totalPages){
        return 44;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(_currentIndex<=totalPages)
        return _footerView;
    else
        return nil;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString * segueIdentifier = [segue identifier];
    if([segueIdentifier isEqualToString:@"PushToDetail"]){
        DetailViewController *detailController = (DetailViewController *)[segue destinationViewController];
        MainCell *cell = (MainCell *)[_tblView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:[sender tag] inSection:0]];
        detailController.title = cell.lblText.text;
    }
}

- (IBAction)btnLoadMoreClicked:(id)sender {
    _currentIndex++;
    [self loadMoreData];
}

- (void)loadMoreData{
    for(int i=0;i<10;i++){
        [_arrAllDetails addObject:[NSString stringWithFormat:@"Test %d",(i+1)+(_currentIndex*10)]];
    }
    [_tblView reloadData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.searchDisplayController setActive:YES animated:YES];
    [self.searchDisplayController.searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText{
    [_filterdDetails removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@",searchText];
    NSArray *tmpArray = [[NSArray arrayWithArray:_arrAllDetails] filteredArrayUsingPredicate:predicate];
    _filterdDetails = [NSMutableArray arrayWithArray:tmpArray];
    [_tblView reloadData];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString];
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.001);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [Helper searchNoResults:self.searchDisplayController.searchResultsTableView.subviews];
//    });
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchDisplayController setActive:NO animated:YES];
    [_tblView reloadData];
}

@end
