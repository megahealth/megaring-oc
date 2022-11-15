//
//  WorkoutReportViewController.m
//  BHealth
//
//  Created by cheng cheng on 20/3/2020.
//  Copyright © 2020 zhaoguan. All rights reserved.
//

#import "WorkoutReportViewController.h"

#import "WorkoutReportView.h"
#import "WorkoutReportViewModel.h"


@interface WorkoutReportViewController ()

@property (nonatomic, strong) MRReport *report;
@property (strong, nonatomic) IBOutlet WorkoutReportView *_view;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *share;
@property (nonatomic, strong) UIWindow *displayWindow;
@property (nonatomic, strong) UIActivityViewController *activityVC;


@end

@implementation WorkoutReportViewController


- (instancetype)initWithReport:(MRReport *)report {
    if (self = [super init]) {
        self.report = report;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadReport];
    self.title = @"Sport Report Detail";
//    NSLocalizedString(MHReportDetail, nil);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)loadReport {
    
    self._view.model.report = self.report;
    
    [self._view.model updateCalories:0];
    [self._view refreshReport];
    
}

@end
