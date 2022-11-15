//
//  HRVReportViewController.m
//  BHealth
//
//  Created by Ulric on 17/11/2021.
//  Copyright © 2021 zhaoguan. All rights reserved.
//

#import "HRVReportViewController.h"
#import "HRVReportView.h"
#import "HRVReportViewModel.h"

#import "UIViewExt.h"

@interface HRVReportViewController ()
@property (nonatomic, strong) MRReport *report;
@property (strong, nonatomic) IBOutlet HRVReportView *_view;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *shareItem;

@property (nonatomic, strong) UIActivityViewController *activityVC;

@end

@implementation HRVReportViewController

- (instancetype)initWithReport:(MRReport *)report {
    if (self = [super init]) {
        self.report = report;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"HRV Report Detail";
    
    [self loadReport];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)loadReport {
    
    if (self.report.SDNN > 0) {
        
            self._view.model.report = self.report;
            [self._view updateData];
    }
    
 
}

@end
