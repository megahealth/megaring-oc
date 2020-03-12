//
//  DeviceManagerViewCell.h
//  MegaRingBLE
//
//  Created by Superman on 2018/5/21.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DeviceManagerViewCellModel;

@interface DeviceManagerViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UILabel *infoTitleLab;
@property (strong, nonatomic) IBOutlet UILabel *infoDetailLab;
@property (strong, nonatomic) IBOutlet UIView *infoIndicator;



@property (strong, nonatomic) IBOutlet UIView *actionView;
@property (strong, nonatomic) IBOutlet UILabel *actionTitleLab;





- (void)setUpWithModel:(DeviceManagerViewCellModel *)cellModel;



@end
