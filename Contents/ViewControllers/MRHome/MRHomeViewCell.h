//
//  MRHomeViewCell.h
//  MegaRingBLE
//
//  Created by Superman on 2018/5/4.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MRHomeViewCellModel;

@interface MRHomeViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLab;

@property (strong, nonatomic) IBOutlet UILabel *macLab;

@property (strong, nonatomic) IBOutlet UILabel *snLab;

@property (strong, nonatomic) IBOutlet UILabel *RSSILab;

@property (strong, nonatomic) IBOutlet UIImageView *RSSIImgView;

@property (strong, nonatomic) IBOutlet UILabel *stateLab;


- (void)setUpWithModel:(MRHomeViewCellModel *)cellModel;







@end
