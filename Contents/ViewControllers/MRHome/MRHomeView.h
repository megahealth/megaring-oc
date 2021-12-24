//
//  MRHomeView.h
//  MegaRingBLE
//
//  Created by Superman on 2018/5/4.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MRHomeViewModel;

@interface MRHomeView : UIView <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) MRHomeViewModel	*viewModel;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void)reloadTableAtIndex:(NSInteger)index;

- (void)deselectSelectedCell;


@property (nonatomic, copy) void	 (^selectAction)(NSIndexPath *indexPath);



@end
