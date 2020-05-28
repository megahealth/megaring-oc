//
//  DeviceManagerView.h
//  MegaRingBLE
//
//  Created by Superman on 2018/5/21.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DeviceManagerViewModel;

@interface DeviceManagerView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) DeviceManagerViewModel	*viewModel;

@property (strong, nonatomic) IBOutlet UITableView *tableView;


- (void)refreshView;


@property (nonatomic, copy) void	 (^selectAction)(NSIndexPath *indexPath);





@end
