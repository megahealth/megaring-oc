//
//  HRVReportViewModel.h
//  BHealth
//
//  Created by Ulric on 17/11/2021.
//  Copyright © 2021 zhaoguan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MRReport;

@interface HRVReportViewModel : NSObject

@property (nonatomic, strong) MRReport *report;

@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *heartBeat;
@property (nonatomic, copy) NSString *avgHr;
@property (nonatomic, copy) NSString *rrInterval;
@property (nonatomic, copy) NSString *rrTime;
@property (nonatomic, copy) NSString *maxHr;
@property (nonatomic, copy) NSString *maxHrTime;
@property (nonatomic, copy) NSString *minHr;
@property (nonatomic, copy) NSString *minHrTime;
@property (nonatomic, copy) NSString *tBeat;
@property (nonatomic, copy) NSString *tBeatProportion;
@property (nonatomic, copy) NSString *bBeat;
@property (nonatomic, copy) NSString *bBeatProportion;
@property (nonatomic, copy) NSString *sdnn;
@property (nonatomic, copy) NSString *sdann;
@property (nonatomic, copy) NSString *rmssd;
@property (nonatomic, copy) NSString *nn50;
@property (nonatomic, copy) NSString *pnn50;
@property (nonatomic, copy) NSString *tIdx;
@property (nonatomic, copy) NSString *hfp;
@property (nonatomic, copy) NSString *lfp;
@property (nonatomic, copy) NSString *vlfp;
@property (nonatomic, copy) NSString * lhfr;

@property (nonatomic, strong) NSArray *histArr;
@property (nonatomic, strong) NSArray *hrvArr;
@property (nonatomic, strong) NSArray *freqArr;
@property (nonatomic, strong) NSArray *rrArr;


@end

NS_ASSUME_NONNULL_END
