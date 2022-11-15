//
//  WorkoutReportViewModel.h
//  BHealth
//
//  Created by cheng cheng on 20/3/2020.
//  Copyright © 2020 zhaoguan. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface WorkoutReportViewModel : NSObject

@property (nonatomic, strong) MRReport *report;

@property (nonatomic, assign) BOOL reportValid;

@property (nonatomic, copy) NSString *maxPr;
@property (nonatomic, copy) NSString *avgPr;
@property (nonatomic, copy) NSString *minPr;

@property (nonatomic, copy) NSString *duration;

@property (nonatomic, strong) NSArray *prArr;

@property (nonatomic, assign) int prScaleTop;
@property (nonatomic, assign) int prScaleStep;
@property (nonatomic, assign) int prScaleBottom;

@property (nonatomic, copy) NSString *shareTime;

// model property, may not be equal to those from report
@property (nonatomic, assign) int startAt;
@property (nonatomic, assign) int endAt;


// 日常报告
@property (nonatomic, strong) NSArray *dailyReports;

@property (nonatomic, copy) NSString *steps;
@property (nonatomic, copy) NSString *cal;
@property (nonatomic, assign) BOOL stepsValid;
@property (nonatomic, assign)int height;
@property (nonatomic,assign) int weight;


- (void)updateCalories:(double)calories;


@end


