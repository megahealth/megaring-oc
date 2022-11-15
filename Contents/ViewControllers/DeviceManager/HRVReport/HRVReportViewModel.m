//
//  HRVReportViewModel.m
//  BHealth
//
//  Created by Ulric on 17/11/2021.
//  Copyright © 2021 zhaoguan. All rights reserved.
//

#import "HRVReportViewModel.h"
#import "UIViewExt.h"
@implementation HRVReportViewModel

- (void)setReport:(MRReport *)report {
    _report = report;
    
    NSDate *start = [NSDate dateWithTimeIntervalSince1970:report.originStart];
    self.startTime = stringFromDate(start, @"HH:mm");
    
    NSDate *end = [NSDate dateWithTimeIntervalSince1970:report.originEnd];
    self.endTime = stringFromDate(end, @"HH:mm");
    
    int duration = report.duration;
    if (duration >= 3600) {
        self.duration = [NSString stringWithFormat:@"%d%@%d%@", duration/3600, @" h ", (duration%3600) / 60, @" min "];
    } else {
        self.duration = [NSString stringWithFormat:@"%d%@", duration / 60, @" min "];
    }
    self.heartBeat = [NSString stringWithFormat:@"%d", report.heartBeat];
    self.avgHr = [NSString stringWithFormat:@"%.2f", report.meanBpm];
    self.rrInterval = [NSString stringWithFormat:@"%d", report.maxRRInterval];
    NSDate *rrDate = [NSDate dateWithTimeIntervalSince1970:report.maxRRTime + report.originStart];
    self.rrTime = stringFromDate(rrDate, @"HH:mm");
    self.maxHr = [NSString stringWithFormat:@"%d", report.maxPr];
    NSDate *maxHrDate = [NSDate dateWithTimeIntervalSince1970:report.maxHRTime + report.originStart];
    self.maxHrTime = stringFromDate(maxHrDate, @"HH:mm");
    self.minHr = [NSString stringWithFormat:@"%d", report.minPr];
    NSDate *minHrDate = [NSDate dateWithTimeIntervalSince1970:report.minHRTime + report.originStart];
    self.minHrTime = stringFromDate(minHrDate, @"HH:mm");
    self.tBeat = [NSString stringWithFormat:@"%d", report.tBeat];
    self.tBeatProportion = [NSString stringWithFormat:@"%.2f%%", report.tBeatProportion];
    self.bBeat = [NSString stringWithFormat:@"%d", report.bBeat];
    self.bBeatProportion = [NSString stringWithFormat:@"%.2f%%", report.bBeatProportion];
    self.sdnn = [NSString stringWithFormat:@"%.2f", report.SDNN];
    self.sdann = [NSString stringWithFormat:@"%.2f", report.SDANN];
    self.rmssd = [NSString stringWithFormat:@"%.2f", report.RMSSD];
    self.nn50 = [NSString stringWithFormat:@"%d", report.NN50];
    self.pnn50 = [NSString stringWithFormat:@"%.2f", report.pNN50];
    self.tIdx = [NSString stringWithFormat:@"%.2f", report.tIdx];
    self.hfp = [NSString stringWithFormat:@"%.2f", report.hfp];
    self.lfp = [NSString stringWithFormat:@"%.2f", report.lfp];
    self.vlfp = [NSString stringWithFormat:@"%.2f", report.vlfp];
    self.lhfr = [NSString stringWithFormat:@"%.2f", report.lhfr];
    
    self.histArr = report.histArr;
    self.hrvArr = report.hrvArr;
    self.freqArr = report.freqArr;
    self.rrArr = report.rrArr;
}



@end
