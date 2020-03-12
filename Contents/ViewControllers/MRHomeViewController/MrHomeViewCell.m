//
//  MRHomeViewCell.m
//  MegaRingBLE
//
//  Created by Superman on 2018/5/4.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "MRHomeViewCell.h"
#import "MRHomeViewModel.h"
#import "DemoDefines.h"

@implementation MRHomeViewCell


#pragma mark -
#pragma mark Methods & logical

- (void)setUpWithModel:(MRHomeViewCellModel *)cellModel {
    self.nameLab.text = cellModel.name;
    self.macLab.text = cellModel.mac;
    self.snLab.text = cellModel.sn;
    
    self.stateLab.text = cellModel.isConnected ? NSLocalizedString(MRConnected, nil) : NSLocalizedString(MRDisconnected, nil);
    self.stateLab.textColor = cellModel.isConnected ? MAIN_COLOR_BLUE : [UIColor lightGrayColor];
    self.RSSILab.text = [NSString stringWithFormat:@"%@", cellModel.RSSI];
    
    static NSMutableArray	*imgs;
    if (imgs == nil) {
        imgs = [NSMutableArray new];
        NSArray	*imgNames = @[@"signal0", @"signal1", @"signal2", @"signal3", @"signal4"];
        for (NSInteger i=0; i<imgNames.count; i++) {
            [imgs addObject:[UIImage imageNamed:imgNames[i]]];
        }
    }
    self.RSSIImgView.image = imgs[cellModel.RSSILevel];
}





#pragma mark -
#pragma mark Basic Settings

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
