//
//  SleepReportView.h
//  BHealth
//
//  Created by cheng cheng on 23/3/2020.
//  Copyright © 2020 zhaoguan. All rights reserved.
//

#import <UIKit/UIKit.h>



@class SleepReportViewModel;
@class SleepReportSpTrendView;
@class HDReportsAxisTimeView;
@class SleepReportPrTrendView;
@class SleepReportStageTrendView;
@class SleepReportTempTrendView;


@interface SleepReportView : UIView

@property (nonatomic, strong) SleepReportViewModel *model;

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet SleepReportSpTrendView *spTrendView;
@property (weak, nonatomic) IBOutlet HDReportsAxisTimeView *spTimeAxis;
@property (weak, nonatomic) IBOutlet UIView *alertLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertLineTopCons;

@property (weak, nonatomic) IBOutlet UILabel *odi;
@property (weak, nonatomic) IBOutlet UILabel *avgSp;
@property (weak, nonatomic) IBOutlet UILabel *minSp;

@property (weak, nonatomic) IBOutlet UILabel *duration95;
@property (weak, nonatomic) IBOutlet UILabel *duration90;
@property (weak, nonatomic) IBOutlet UILabel *duration85;
@property (weak, nonatomic) IBOutlet UILabel *duration80;
@property (weak, nonatomic) IBOutlet UILabel *percent95;
@property (weak, nonatomic) IBOutlet UILabel *percent90;
@property (weak, nonatomic) IBOutlet UILabel *percent85;
@property (weak, nonatomic) IBOutlet UILabel *percent80;

@property (weak, nonatomic) IBOutlet SleepReportPrTrendView *prTrendView;
@property (weak, nonatomic) IBOutlet HDReportsAxisTimeView *prTimeAxis;

@property (weak, nonatomic) IBOutlet UILabel *maxPr;
@property (weak, nonatomic) IBOutlet UILabel *avgPr;
@property (weak, nonatomic) IBOutlet UILabel *minPr;

@property (weak, nonatomic) IBOutlet SleepReportStageTrendView *stageTrendView;
@property (weak, nonatomic) IBOutlet HDReportsAxisTimeView *stageTimeAxis;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *awakeWidthCons;
@property (weak, nonatomic) IBOutlet UILabel *awakeDuration;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remWidthCons;
@property (weak, nonatomic) IBOutlet UILabel *remDuration;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lightWidthCons;
@property (weak, nonatomic) IBOutlet UILabel *lightDuration;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deepWidthCons;
@property (weak, nonatomic) IBOutlet UILabel *deepDuration;

@property (weak, nonatomic) IBOutlet UILabel *start;
@property (weak, nonatomic) IBOutlet UILabel *latency;
@property (weak, nonatomic) IBOutlet UILabel *duration;


-  (void)refresh;
@property (weak, nonatomic) IBOutlet UIView *contentView;


@property (weak, nonatomic) IBOutlet UILabel *invalid1;
@property (weak, nonatomic) IBOutlet UILabel *invalid2;
@property (weak, nonatomic) IBOutlet UILabel *invalid3;
@property (weak, nonatomic) IBOutlet UILabel *stageInvalid;

@property (weak, nonatomic) IBOutlet UIImageView *ttlImg;




///！温度趨勢图

@property (weak, nonatomic) IBOutlet UIView *tempYAxis;
@property (weak, nonatomic) IBOutlet UIView *tempXAxis;

@property (weak, nonatomic) IBOutlet SleepReportTempTrendView *tempTrendView;

@property (weak, nonatomic) IBOutlet UILabel *maxTempLab;
@property (weak, nonatomic) IBOutlet UILabel *minTempLab;
@property (weak, nonatomic) IBOutlet UILabel *tempUnit;

@property (nonatomic, strong) NSMutableArray *hourTempArr;

@property (nonatomic, assign) float avgTemp;

@property (nonatomic, assign) float maxTemp;
@property (nonatomic, assign) int maxTempIdx;

@property (nonatomic, assign) float minTemp;
@property (nonatomic, assign) int minTempIdx;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tempHightCons;


/// 温度柱状图


///! 折线图
/// 五分钟一个点连线

- (void)showTemp:(NSArray *)tempArr;



/// 折线图


// 呼吸率

@property (weak, nonatomic) IBOutlet SleepReportPrTrendView *respiratoryTrendView;

@property (weak, nonatomic) IBOutlet HDReportsAxisTimeView *respiratoryAxisTimeView;

@property (weak, nonatomic) IBOutlet UILabel *invalid4;

@property (weak, nonatomic) IBOutlet UILabel *respiratoryMaximumLabel;
@property (weak, nonatomic) IBOutlet UILabel *respiratoryMinimumLabel;

@property (weak, nonatomic) IBOutlet UILabel *respiratoryAverageLabel;


@property (weak, nonatomic) IBOutlet UILabel *maxRespiratoryLabel;

@property (weak, nonatomic) IBOutlet UILabel *averageRespiratoryLabel;


@property (weak, nonatomic) IBOutlet UILabel *minRespiratoryLabel;

@property (weak, nonatomic) IBOutlet UILabel *averageRespiNotice;
@property (weak, nonatomic) IBOutlet UILabel *respiratoryRateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *respiratoryHeightCons;

@property (weak, nonatomic) IBOutlet UIView *respiView;









@end

