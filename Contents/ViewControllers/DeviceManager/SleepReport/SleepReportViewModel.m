//
//  SleepReportViewModel.m
//  BHealth
//
//  Created by cheng cheng on 23/3/2020.
//  Copyright © 2020 zhaoguan. All rights reserved.
//

#import "SleepReportViewModel.h"

//#import "MHPatientInfoManager.h"
//#import "AVPatient.h"
static int  sleepStageValidMinutes = 3*60;

@implementation SleepReportViewModel

- (void)setReport:(MRReport *)report {
    
    _report = report;
    
      self.reportValid =  report.avgPr > 0 && report.prArr.count > 0 && report.avgSp > 0 && report.spArr.count > 0;
    
    NSString *localHour = NSLocalizedString(MHHours, nil);
    NSString *localMinutes = NSLocalizedString(MHMinutes, nil);
    
    self.spArr = report.spArr;
    self.odi = [NSString stringWithFormat:@"%.1f", round(report.odIndex*10)/10];
    self.avgSp = [NSString stringWithFormat:@"%.1f%%", round(report.avgSp*10)/10];
    self.minSp = [NSString stringWithFormat:@"%.1f%%", round(report.minSp*10)/10];
    
    self.duration95 = [NSString stringWithFormat:@"%.2f", round(report.durationUnder95/60.0*100)/100];
    self.duration90 = [NSString stringWithFormat:@"%.2f", round(report.durationUnder90/60.0*100)/100];
    self.duration85 = [NSString stringWithFormat:@"%.2f", round(report.durationUnder85/60.0*100)/100];
    self.duration80 = [NSString stringWithFormat:@"%.2f", round(report.durationUnder80/60.0*100)/100];
    
    self.percent95 = [NSString stringWithFormat:@"%.2f", round(report.percentUnder95*100*100)/100];
    self.percent90 = [NSString stringWithFormat:@"%.2f", round(report.percentUnder90*100*100)/100];
    self.percent85 = [NSString stringWithFormat:@"%.2f", round(report.percentUnder85*100*100)/100];
    self.percent80 = [NSString stringWithFormat:@"%.2f", round(report.percentUnder80*100*100)/100];
    
  
    self.prArr = report.prArr;
    
    
    self.maxPr = [NSString stringWithFormat:@"%d", report.maxPr];
    
    self.avgPr = [NSString stringWithFormat:@"%d", report.avgPr];
    
    self.minPr = [NSString stringWithFormat:@"%d", report.minPr];
    
    
    
    
    
    self.stageValid = report.duration >= (sleepStageValidMinutes*60/82*82);
    
    self.stageArr = self.stageValid ? report.stageArr : nil;
    
    
    //    MARK://TODO respi..
//        self.respiArr = report.respiArr;
    
    int wakeDuration = self.stageValid ? report.wakeMins : 0;
    int remDuration = self.stageValid ? report.remMins : 0;
    int lightDuration = self.stageValid ? report.lightMins : 0;
    int deepDuration = self.stageValid ? report.deepMins : 0;
    
    int stageDutation = wakeDuration + remDuration + lightDuration + deepDuration;
    if (stageDutation <= 0) {
        stageDutation = 1;
    }
    
    self.awakeRatio = wakeDuration * 1.0 / stageDutation;
    self.remRatio = remDuration * 1.0 / stageDutation;
    self.lightRatio = lightDuration * 1.0 / stageDutation;
    self.deepRatio = deepDuration * 1.0 / stageDutation;
    
    if (wakeDuration >= 60) {
        self.awakeDuation = [NSString stringWithFormat:@"%d%@%d%@(%.0f%%)", wakeDuration/60, localHour, wakeDuration%60, localMinutes, self.awakeRatio*100];
    } else {
        self.awakeDuation = [NSString stringWithFormat:@"%d%@(%.0f%%)", wakeDuration, localMinutes, self.awakeRatio*100];
    }
    
    if (remDuration >= 60) {
        self.remDuration = [NSString stringWithFormat:@"%d%@%d%@(%.0f%%)", remDuration/60, localHour, remDuration%60, localMinutes, self.remRatio*100];
    } else {
        self.remDuration = [NSString stringWithFormat:@"%d%@(%.0f%%)", remDuration, localMinutes, self.remRatio*100];
    }
    
    if (lightDuration >= 60) {
        self.lightDuration = [NSString stringWithFormat:@"%d%@%d%@(%.0f%%)", lightDuration/60, localHour, lightDuration%60, localMinutes, self.lightRatio*100];
    } else {
        self.lightDuration = [NSString stringWithFormat:@"%d%@(%.0f%%)", lightDuration, localMinutes, self.lightRatio*100];
    }
    
    if (deepDuration >= 60) {
        self.deepDuartion = [NSString stringWithFormat:@"%d%@%d%@(%.0f%%)", deepDuration/60, localHour, deepDuration%60, localMinutes, self.deepRatio*100];
    } else {
        self.deepDuartion = [NSString stringWithFormat:@"%d%@(%.0f%%)", deepDuration, localMinutes, self.deepRatio*100];
    }
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:report.originStart];
    self.start = stringFromDate(startDate, @"HH:mm");
    self.latency = @"--";
    for (int i=0; i<self.stageArr.count; i++) {
        int stage = [self.stageArr[i] intValue];
        if (stage == 3 || stage == 4) {
            self.latency = [NSString stringWithFormat:@"%d%@", i, localMinutes];
            break;
        }
    }
    
    if (report.duration >= 3600) {
        self.duration = [NSString stringWithFormat:@"%d%@%d%@", report.duration/3600, localHour, (report.duration%3600) / 60, localMinutes];
    } else {
        self.duration = [NSString stringWithFormat:@"%d%@", report.duration / 60, localMinutes];
    }
    
    self.shareTime = localizedStringFromDate(startDate, @"yyyyMMMMd");
    
    
    int max = report.maxPr;
    int min = report.minPr;
    
    int grid = 5;
    int delta = MAX((max - min) * 0.1, 4);
    int interval = ceil((max - min + delta) * 1.0 / grid) * grid;
    
    self.prScaleStep = interval / grid;
    self.prScaleBottom = min - delta / 2;
    self.prScaleTop = self.prScaleBottom + interval;
    
    
    int spMax = 100;
    int spMin = report.minSp;
    int spGrid = 5;
    int spInterval = ceil((spMax - spMin) * 1.0 / spGrid) * spGrid;
    
    self.spScaleTop = spMax;
    self.spScaleStep = spInterval / spGrid;
    self.spScaleBottom = self.spScaleTop - spInterval;
    self.spScaleStep = 5;
    self.spScaleBottom = 75;

    //    MARK://TODO
    self.respiScaleStep = interval / grid;
    self.respiScaleBottom = min - delta / 2;
    self.respiScaleTop = self.respiScaleBottom + interval;
   
}

//- (BOOL)updateSpAlertState {
////    AVPatient *patient = [MHPatientInfoManager currentPatient];
////    BOOL onOffChanged = self.spAlertOn != patient.spo2AlertOn;
////    BOOL valueChanged = self.spAlertLow != patient.spo2AlertLow;
////    self.spAlertOn = patient.spo2AlertOn;
////    self.spAlertLow = patient.spo2AlertLow;
////
////    BOOL changed = onOffChanged || valueChanged;
////
//    return YES;
//}




@end
