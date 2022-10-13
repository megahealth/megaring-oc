//
//  MRHomeView.m
//  MegaRingBLE
//
//  Created by Superman on 2018/5/4.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "MRHomeView.h"
#import "MRHomeViewModel.h"
#import "MRHomeViewCell.h"

@implementation MRHomeView

static NSString * homeCellId = @"HomeCellID";
#pragma mark -
#pragma mark Methods & logical

- (void)reloadTableAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.viewModel.modeArr.count) {
        [self.tableView reloadData];
    } else {
        [self reloadTableCellAtIndex:index];
    }
}

- (void)reloadTableCellAtIndex:(NSInteger)index {
    NSIndexPath	*indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    MRHomeViewCell	*cell = [self.tableView cellForRowAtIndexPath:indexPath];
    MRHomeViewCellModel	*cellModel = self.viewModel.modeArr[index];
    [cell setUpWithModel:cellModel];
}

- (void)deselectSelectedCell {
    NSIndexPath	*indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark Delegate Methods - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.modeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MRHomeViewCell	*cell = [self.tableView dequeueReusableCellWithIdentifier:homeCellId];
    MRHomeViewCellModel	*cellModel = self.viewModel.modeArr[indexPath.row];
    [cell setUpWithModel:cellModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectAction) {
        self.selectAction(indexPath);
    }
}


#pragma mark -
#pragma mark Basic Settings

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.rowHeight = 60;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MRHomeViewCell" bundle:nil] forCellReuseIdentifier:homeCellId];
    
}


@end
