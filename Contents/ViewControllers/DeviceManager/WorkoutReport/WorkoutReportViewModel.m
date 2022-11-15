//
//  WorkoutReportViewModel.m
//  BHealth
//
//  Created by cheng cheng on 20/3/2020.
//  Copyright © 2020 zhaoguan. All rights reserved.
//

#import "WorkoutReportViewModel.h"


@implementation WorkoutReportViewModel

- (void)setReport:(MRReport *)report {
    _report = report;
    
    self.reportValid = report.avgPr > 0 && report.prArr.count > 0;
    
    self.avgPr = [NSString stringWithFormat:@"%d", report.avgPr];
    self.minPr = [NSString stringWithFormat:@"%d", report.minPr];
    self.maxPr = [NSString stringWithFormat:@"%d", report.maxPr];
    
    int duration = report.duration;
    self.startAt = report.originStart;
    self.endAt = report.originEnd;
    if (self.endAt < self.startAt) {
        for (int i=0; i<report.prArr.count; i++) {
            int pr = [report.prArr[i] intValue];
            if (pr > 220) {
                duration = i;
                self.endAt = self.startAt + duration;
                break;
            }
        }
    }
    
    if (duration >= 3600) {
        self.duration = [NSString stringWithFormat:@"%d%@%d%@", duration/3600, NSLocalizedString(MHHours, nil), (duration%3600) / 60, NSLocalizedString(MHMinutes, nil)];
    } else {
        self.duration = [NSString stringWithFormat:@"%d%@", duration / 60, NSLocalizedString(MHMinutes, nil)];
    }
    
    self.prArr = report.prArr;
    
    int grid = 5;
    int delta = MAX((report.maxPr - report.minPr) * 0.1, 4);
    int interval = ceil((report.maxPr - report.minPr + delta) * 1.0 / grid) * grid;
    
    self.prScaleStep = interval / grid;
    self.prScaleTop = report.maxPr + delta / 2;
    self.prScaleBottom = self.prScaleTop - interval;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.startAt];
    self.shareTime = localizedStringFromDate(date, @"yyyyMMMMd");
    
    self.steps = [NSString stringWithFormat:@"%d", report.steps];
    self.stepsValid = report.steps > 0 ;
    // && report.steps < report.duration * 4;
}

- (void)setDailyReports:(NSArray *)dailyReports {
//    HDReportAnalyzer *analyzer = [[HDReportAnalyzer alloc] init];
//    analyzer.dailyReports = dailyReports;
//    self.steps = [NSString stringWithFormat:@"%d", analyzer.dailyCalStep];
//    self.cal = [NSString stringWithFormat:@"%.1f", analyzer.dailyCalorie];
    
    
    int lastStart = 0;
    double duration = 0;
    double calorie = 0;
    int totalStep = 0;
    int calStep = 0;
    
    for (NSDictionary *daily in dailyReports) {
        int start = [daily[@"start"] intValue];
        int end = [daily[@"end"] intValue];
        if (start == lastStart) {
            continue;
        }
        lastStart = start;
        
        int step = [daily[@"steps"] intValue];
        double distance = self.height * 0.415 * step / 100;
        
        if (distance > 0) {
            totalStep += step;
            
            BOOL valid = YES;
            
            if (valid) {
                calStep += step;
                duration += (end-start);
                calorie += distance / 1000.0 * self.weight;
            }
        }
    }
    
    
    self.steps = [NSString stringWithFormat:@"%d", calStep];
    self.cal = [NSString stringWithFormat:@"%.1f", calorie];
      
    
    
}

-(int)weight {
    
    
    int weight = 70;
    
    return weight;
}

-(int)height
{
    
    int height = 170;
    
//    self.gender == 1 ? 170 : 160;

    return height;
}




- (void)updateCalories:(double)calories {
    double cal = calories;
    if (calories <= 0) {
       
        cal = self.height * 0.415 * self.report.steps / 100 / 1000.0 * self.weight;
    }
    self.cal = [NSString stringWithFormat:@"%.1f", cal];
}



@end
