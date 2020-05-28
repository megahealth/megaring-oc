//
//  DeviceManagerViewCell.m
//  MegaRingBLE
//
//  Created by Superman on 2018/5/21.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "DeviceManagerViewCell.h"
#import "DeviceManagerViewModel.h"

@implementation DeviceManagerViewCell

#pragma mark -
#pragma mark Methods & logical

- (void)setUpWithModel:(DeviceManagerViewCellModel *)cellModel {
    self.infoView.hidden = cellModel.indexPath.section > 1;
    self.actionView.hidden = cellModel.indexPath.section <= 1;
    
    if (cellModel.indexPath.section <= 1) {
        self.infoTitleLab.text = cellModel.title;
        self.infoDetailLab.text = cellModel.detail;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        self.actionTitleLab.text = cellModel.title;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    if (cellModel.indexPath.section == 2 && (cellModel.indexPath.row == 10 || cellModel.indexPath.row == 11)) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (cellModel.isFresh) {
        cellModel.isFresh = NO;
        [self startAnimation];
    }
}

- (void)startAnimation {
    self.infoIndicator.alpha = 1;
    [UIView animateWithDuration:0.8 animations:^{
        self.infoIndicator.alpha = 0;
    }];
}


#pragma mark -
#pragma mark Basic Settings

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tintColor = [UIColor blueColor];
    self.contentView.tintColor = [UIColor blueColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
