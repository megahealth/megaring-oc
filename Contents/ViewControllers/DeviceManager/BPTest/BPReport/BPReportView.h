//
//  BPReportView.h
//  BHealth
//
//  Created by Ulric on 15/11/2021.
//  Copyright © 2021 zhaoguan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BPReportViewModel;


@interface BPReportView : UIView

@property (nonatomic, strong) BPReportViewModel *model;

@property (weak, nonatomic) IBOutlet UILabel *date;

@property (weak, nonatomic) IBOutlet UIView *ecgBg;

@property (weak, nonatomic) IBOutlet UIView *ecg;

@property (weak, nonatomic) IBOutlet UILabel *pr;

@property (weak, nonatomic) IBOutlet UILabel *sbp;

@property (weak, nonatomic) IBOutlet UILabel *dbp;


- (void)updateData;
- (void)updateEcg;


@end

NS_ASSUME_NONNULL_END
