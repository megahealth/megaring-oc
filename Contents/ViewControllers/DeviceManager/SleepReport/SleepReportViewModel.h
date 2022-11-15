//
//  SleepReportViewModel.h
//  BHealth
//
//  Created by cheng cheng on 23/3/2020.
//  Copyright © 2020 zhaoguan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SleepReportViewModel : NSObject

@property (nonatomic, strong) MRReport *report;

@property (nonatomic, assign) BOOL reportValid;
@property (nonatomic, assign) BOOL stageValid;


@property (nonatomic, strong) NSArray *spArr;
@property (nonatomic, copy) NSString *odi;
@property (nonatomic, copy) NSString *avgSp;
@property (nonatomic, copy) NSString *minSp;

@property (nonatomic, copy) NSString *duration95;
@property (nonatomic, copy) NSString *duration90;
@property (nonatomic, copy) NSString *duration85;
@property (nonatomic, copy) NSString *duration80;
@property (nonatomic, copy) NSString *percent95;
@property (nonatomic, copy) NSString *percent90;
@property (nonatomic, copy) NSString *percent85;
@property (nonatomic, copy) NSString *percent80;

@property (nonatomic, strong) NSArray *prArr;

@property (nonatomic, strong) NSArray * respiArr;

@property (nonatomic, copy) NSString *maxPr;
@property (nonatomic, copy) NSString *avgPr;
@property (nonatomic, copy) NSString *minPr;

@property (nonatomic, strong) NSArray *stageArr;
@property (nonatomic, assign) double awakeRatio;
@property (nonatomic, assign) double remRatio;
@property (nonatomic, assign) double lightRatio;
@property (nonatomic, assign) double deepRatio;
@property (nonatomic, copy) NSString *awakeDuation;
@property (nonatomic, copy) NSString *remDuration;
@property (nonatomic, copy) NSString *lightDuration;
@property (nonatomic, copy) NSString *deepDuartion;

@property (nonatomic, copy) NSString *start;
@property (nonatomic, copy) NSString *latency;
@property (nonatomic, copy) NSString *duration;

@property (nonatomic, assign) int prScaleTop;
@property (nonatomic, assign) int prScaleStep;
@property (nonatomic, assign) int prScaleBottom;

@property (nonatomic, copy) NSString *shareTime;


@property (nonatomic, assign) BOOL spAlertOn;
@property (nonatomic, assign) int spAlertLow;
- (BOOL)updateSpAlertState;

@property (nonatomic, assign) int spScaleTop;
@property (nonatomic, assign) int spScaleStep;
@property (nonatomic, assign) int spScaleBottom;


@property (nonatomic, assign) int respiScaleTop;
@property (nonatomic, assign) int respiScaleStep;
@property (nonatomic, assign) int respiScaleBottom;





@end

