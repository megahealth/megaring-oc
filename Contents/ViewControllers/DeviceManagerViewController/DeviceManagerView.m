//
//  DeviceManagerView.m
//  MegaRingBLE
//
//  Created by Superman on 2018/5/21.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "DeviceManagerView.h"
#import "DeviceManagerViewModel.h"
#import "DeviceManagerViewCell.h"

@implementation DeviceManagerView {
    UINib	*_cellNib;
}


#pragma mark -
#pragma mark Delegate Methods - UITableViewDelegate, UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.viewModel.sectionTitleArr[section];
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString	*cellId = @"DeviceManagerViewCell";
    if (_cellNib == nil) {
        _cellNib = [UINib nibWithNibName:cellId bundle:nil];
        [self.tableView registerNib:_cellNib forCellReuseIdentifier:cellId];
    }
    
    DeviceManagerViewCell	*cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];
    DeviceManagerViewCellModel	*cellModel = self.viewModel.modelArr[indexPath.section][indexPath.row];
    [cell setUpWithModel:cellModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2 && self.selectAction) {
        self.selectAction(indexPath);
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.modelArr[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.modelArr.count;
}


#pragma mark -
#pragma mark Methods & logical

- (void)refreshView {
    for (DeviceManagerViewCell *cell in self.tableView.visibleCells) {
        NSIndexPath	*indexPath = [self.tableView indexPathForCell:cell];
        DeviceManagerViewCellModel	*cellModel = self.viewModel.modelArr[indexPath.section][indexPath.row];
        [cell setUpWithModel:cellModel];
    }
}




@end
