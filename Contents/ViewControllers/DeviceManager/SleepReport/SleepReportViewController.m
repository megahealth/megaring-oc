//
//  SleepReportViewController.m
//  BHealth
//
//  Created by cheng cheng on 20/3/2020.
//  Copyright © 2020 zhaoguan. All rights reserved.
//

#import "SleepReportViewController.h"
#import "SleepReportView.h"
#import "SleepReportViewModel.h"


@interface SleepReportViewController ()
@property (nonatomic, strong) MRReport *report;

@property (strong, nonatomic) IBOutlet SleepReportView *_view;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *share;
@property (nonatomic, strong) UIWindow *displayWindow;
@property (nonatomic, strong) UIActivityViewController *activityVC;

@property (nonatomic, assign) MHUnitType unitType;

@end

@implementation SleepReportViewController
- (instancetype)initWithReport:(MRReport *)report {
    if (self = [super init]) {
        self.report = report;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadReport];
    self.title = @"Sleep Report Detail";
    
//    NSLocalizedString(MHReportDetail, nil);
//    AVPatient *patient = [MHPatientInfoManager currentPatient];
//    self.unitType = patient.unitType;
    
    self.unitType  = MHUnitTypeMetric ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    if ([self._view.model updateSpAlertState]) {
//        [self._view refresh];
//    }
}

- (void)loadReport {
    self._view.tempHightCons.constant = 0;
    
    self._view.model.report = self.report;
    
    [self loadTemp:self.report.tempArr?:nil];
    [self._view refresh];
    
}

- (void)loadTemp:(NSArray *)tempArr {
    

    NSMutableArray * objArr = [MRDailyReport mj_objectArrayWithKeyValuesArray:tempArr];
    
    [self handleReports:objArr.copy];
}


- (void)showTips:(NSString *)tips {
    if (tips.length <= 0) {
        tips = @"No records";
    }
//    DLog(@"%@", tips);
    
}

- (void)handleReports:(NSArray *)reports {
    
    NSMutableArray * arrayTemper = [NSMutableArray arrayWithCapacity:3];
    for (MRDailyReport * report in reports) {

        int temp = report.temperature;

        if (temp > 0) {
            float tempp = 0.0;
        if (self.unitType == MHUnitTypeMetric) {
            tempp = temp / 10.0;
            [arrayTemper addObject:@(tempp)];

        } else {

            tempp = temp / 10.0 * 1.8 + 32;
            [arrayTemper addObject:@(tempp)];

        }
        }
    }
    
    if (self.unitType == MHUnitTypeMetric) {
        self._view.tempUnit.text = @"℃";
    } else {
        self._view.tempUnit.text = @"℉";
    }
    if (arrayTemper.count > 0) {
        self._view.tempHightCons.constant = 320;
        [self._view layoutIfNeeded];
        [self._view showTemp:arrayTemper];
    }
}


@end
