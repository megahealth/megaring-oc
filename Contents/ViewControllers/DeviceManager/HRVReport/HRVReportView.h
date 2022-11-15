//
//  HRVReportView.h
//  BHealth
//
//  Created by Ulric on 17/11/2021.
//  Copyright © 2021 zhaoguan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HRVReportViewModel;

@class HRVReportDistView;
@class HRVReportHrvView;
@class HRVReportSpectView;
@class HRVReportPlotView;
@class IBCustomView;

@interface HRVReportView : UIView

@property (nonatomic, strong) HRVReportViewModel *model;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *duration;

@property (weak, nonatomic) IBOutlet UILabel *heartBeat;
@property (weak, nonatomic) IBOutlet UILabel *avgHr;

@property (weak, nonatomic) IBOutlet UILabel *rrInterval;
@property (weak, nonatomic) IBOutlet UILabel *rrTime;

@property (weak, nonatomic) IBOutlet UILabel *maxHr;
@property (weak, nonatomic) IBOutlet UILabel *maxHrTime;

@property (weak, nonatomic) IBOutlet UILabel *minHr;
@property (weak, nonatomic) IBOutlet UILabel *minHrTime;

@property (weak, nonatomic) IBOutlet UILabel *tBeat;
@property (weak, nonatomic) IBOutlet UILabel *tBeatProportion;

@property (weak, nonatomic) IBOutlet UILabel *bBeat;
@property (weak, nonatomic) IBOutlet UILabel *bBeatProportion;


@property (weak, nonatomic) IBOutlet UILabel *sdnn;
@property (weak, nonatomic) IBOutlet UILabel *sdann;
@property (weak, nonatomic) IBOutlet UILabel *rmssd;

@property (weak, nonatomic) IBOutlet UILabel *nn50;
@property (weak, nonatomic) IBOutlet UILabel *pnn50;
@property (weak, nonatomic) IBOutlet UILabel *tIdx;

@property (weak, nonatomic) IBOutlet UILabel *hfp;
//@property (weak, nonatomic) IBOutlet UILabel *lfp;
//@property (weak, nonatomic) IBOutlet UILabel *vlfp;
//@property (weak, nonatomic) IBOutlet UILabel *lhft;
@property (weak, nonatomic) IBOutlet UILabel *lhfr;

@property (weak, nonatomic) IBOutlet UIView *rrDistView;
@property (weak, nonatomic) IBOutlet HRVReportDistView *rrDist;

@property (weak, nonatomic) IBOutlet UIView *seqDiagView;
@property (weak, nonatomic) IBOutlet HRVReportHrvView *seqDiag;

@property (weak, nonatomic) IBOutlet IBCustomView *spectView;
@property (weak, nonatomic) IBOutlet HRVReportSpectView *spect;


@property (weak, nonatomic) IBOutlet IBCustomView *plotView;
@property (weak, nonatomic) IBOutlet HRVReportPlotView *plot;



- (void)updateData;


@end

NS_ASSUME_NONNULL_END
