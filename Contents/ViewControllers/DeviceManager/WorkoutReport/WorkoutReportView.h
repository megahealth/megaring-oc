//
//  WorkoutReportView.h
//  BHealth
//
//  Created by cheng cheng on 20/3/2020.
//  Copyright © 2020 zhaoguan. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WorkoutReportViewModel;
@class WorkoutReportTrendView;
@class HDReportsAxisTimeView;

@interface WorkoutReportView : UIView

@property (nonatomic, strong) WorkoutReportViewModel *model;

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet WorkoutReportTrendView *trendView;
@property (weak, nonatomic) IBOutlet HDReportsAxisTimeView *timeAxis;

@property (weak, nonatomic) IBOutlet UILabel *maxPr;

@property (weak, nonatomic) IBOutlet UILabel *avgPr;

@property (weak, nonatomic) IBOutlet UILabel *minPr;

@property (weak, nonatomic) IBOutlet UILabel *duration;

@property (weak, nonatomic) IBOutlet UILabel *steps;

@property (weak, nonatomic) IBOutlet UILabel *cal;


- (void)refreshReport;
- (void)refreshSteps;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *invalid1;
@property (weak, nonatomic) IBOutlet UIImageView *ttlImg;

@property (weak, nonatomic) IBOutlet UIView *stepsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stepsHeightCons;


@end


