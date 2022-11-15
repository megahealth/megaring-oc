//
//  WorkoutReportView.m
//  BHealth
//
//  Created by cheng cheng on 20/3/2020.
//  Copyright © 2020 zhaoguan. All rights reserved.
//

#import "WorkoutReportView.h"
#import "WorkoutReportViewModel.h"
#import "WorkoutReportTrendView.h"
#import "HDReportsAxisTimeView.h"

//#import "HDReportsInfoCardView.h"


@implementation WorkoutReportView


- (IBAction)helpButtonClicked:(UIButton *)sender {
    
    NSLog(@"---sender.tag=============%ld",sender.tag);
    
//    [HDReportsInfoCardView showCardOnView:self type:sender.tag];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    NSString *ttlImgName = NSLocalizedString(MHSportTitleImageName, nil);
    self.ttlImg.image = [UIImage imageNamed:ttlImgName];
}

- (WorkoutReportViewModel *)model {
    if (_model == nil) {
        _model = [[WorkoutReportViewModel alloc] init];
    }
    return _model;
}

- (void)refreshReport {
    if (self.model.report == nil) {
        return;
    }
    
    self.date.text = self.model.shareTime;
    
    [self.timeAxis addTimeStringWithStart:self.model.startAt end:self.model.endAt format:@"HH:mm"];
    self.duration.text = self.model.duration;
    
    self.invalid1.hidden = self.model.reportValid;
    if (self.model.reportValid == NO) {
        return;
    }
    
    self.maxPr.text = self.model.maxPr;
    self.avgPr.text = self.model.avgPr;
    self.minPr.text = self.model.minPr;
    
    self.trendView.duration = self.model.endAt - self.model.startAt;
    self.trendView.max = self.model.report.maxPr;
    self.trendView.min = self.model.report.minPr;
    
    [self.trendView calculateStatisticalValueWithData:self.model.prArr];
    [self refreshScales];
    [self.trendView strokeWithData:self.model.prArr top:self.model.prScaleTop bottom:self.model.prScaleBottom];
    
    [self refreshSteps];
}

- (void)refreshSteps {
    self.steps.text = self.model.steps;
    self.cal.text = self.model.cal;
    
    self.stepsHeightCons.constant = self.model.stepsValid ? 116 : 0;
    self.stepsView.hidden = self.model.stepsValid == NO;
}

- (void)refreshScales {
    for (int i=0; i<self.trendView.superview.subviews.count; i++) {
        UILabel *lab = [self.trendView.superview viewWithTag:i+10];
        if (lab == nil) {
            return;
        }
        
        lab.text = [NSString stringWithFormat:@"%d", self.model.prScaleTop-i*self.model.prScaleStep];
    }
}



@end
