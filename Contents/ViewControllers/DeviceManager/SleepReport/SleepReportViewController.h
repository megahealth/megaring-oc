//
//  SleepReportViewController.h
//  BHealth
//
//  Created by cheng cheng on 20/3/2020.
//  Copyright © 2020 zhaoguan. All rights reserved.
//


@class MRReport;
typedef NS_ENUM(NSInteger, MHUnitType) {
    MHUnitTypeMetric,  // ℃ 
    MHUnitTypeImperial,// ℉
    MHUnitTypeNone,
};
@interface SleepReportViewController : UIViewController

- (instancetype)initWithReport:(MRReport *)report;

@end


