//
//  HRVReportView.m
//  BHealth
//
//  Created by Ulric on 17/11/2021.
//  Copyright © 2021 zhaoguan. All rights reserved.
//

#import "HRVReportView.h"
#import "HRVReportViewModel.h"

#import "HRVReportDistView.h"
#import "HRVReportHrvView.h"
#import "HRVReportSpectView.h"
#import "HRVReportPlotView.h"

#import "UIViewExt.h"

long hrvDistColor = 0x769BFF;
long hrvHrvColor = 0x5979ED;
long hrvSpectColor = 0x0072BD;
long hrvPlotColor = 0x5aa3bd;


@interface HRVReportView ()


@end

@implementation HRVReportView

- (HRVReportViewModel *)model {
    if (_model == nil) {
        _model = [[HRVReportViewModel alloc] init];
    }
    return _model;
}

- (void)updateData {
    self.startTime.text = self.model.startTime;
    self.endTime.text = self.model.endTime;
    self.duration.text = self.model.duration;
    self.heartBeat.text = self.model.heartBeat;
    self.avgHr.text = self.model.avgHr;
    self.rrInterval.text = self.model.rrInterval;
    self.rrTime.text = self.model.rrTime;
    self.maxHr.text = self.model.maxHr;
    self.maxHrTime.text = self.model.maxHrTime;
    self.minHr.text = self.model.minHr;
    self.minHrTime.text = self.model.minHrTime;
    self.tBeat.text = self.model.tBeat;
    self.tBeatProportion.text = self.model.tBeatProportion;
    self.bBeat.text = self.model.bBeat;
    self.bBeatProportion.text = self.model.bBeatProportion;
    self.sdnn.text = self.model.sdnn;
    self.sdann.text = self.model.sdann;
    self.rmssd.text = self.model.rmssd;
    self.nn50.text = self.model.nn50;
    self.pnn50.text = self.model.pnn50;
    self.tIdx.text = self.model.tIdx;
    self.lhfr.text = self.model.lhfr;
    
    
//    self.hfp.text = self.model.hfp;
//    self.lfp.text = self.model.lfp;
//    self.vlfp.text = self.model.vlfp;
    
    [self refreshDist];
    [self refreshHrv];
    [self refreshSpect];
    [self refreshPlot];
}
// draw UI
- (void)refreshDist {
    int yCnt = 5;
    int xCnt = 6;
    
    int max = 0, min = 0;
    for (NSNumber *value in self.model.report.histArr) {
        max = MAX(max, value.intValue);
        min = MIN(min, value.intValue);
    }
    max = max / yCnt * yCnt + yCnt;
    [self.rrDist strokeWithData:self.model.histArr top:max bottom:min];
    
    
    int yTag = 10;
    for (NSInteger i=0; i<=yCnt; i++) {
        UILabel *label = [self.rrDistView viewWithTag:i+yTag];
        if ([label isKindOfClass:[UILabel class]]) {
            label.text = [NSString stringWithFormat:@"%ld", max/yCnt*i];
        }
    }
    
    int xTag = 20;
    for (NSInteger i=0; i<=xCnt; i++) {
        UILabel *label = [self.rrDistView viewWithTag:i+xTag];
        if ([label isKindOfClass:[UILabel class]]) {
            label.text = [NSString stringWithFormat:@"%.1f", 2.0*i/xCnt];
        }
    }
}

- (void)refreshHrv {
    int yCnt = 5;
    int xCnt = 6;
    
    int max = 0, min = 0;
    for (NSNumber *value in self.model.report.hrvArr) {
        max = MAX(max, value.intValue);
        if (min == 0) {
            min = value.intValue;
        } else {
            min = MIN(min, value.intValue);
        }
    }
    max = max / yCnt * yCnt + yCnt;
    min = MAX(min / yCnt * yCnt - yCnt, 0);
    [self.seqDiag strokeWithData:self.model.hrvArr top:max bottom:min];
    
    int yTag = 10;
    for (NSInteger i=0; i<=yCnt; i++) {
        UILabel *label = [self.seqDiagView viewWithTag:i+yTag];
        if ([label isKindOfClass:[UILabel class]]) {
            label.text = [NSString stringWithFormat:@"%ld", (max-min)/yCnt*i+min];
        }
    }
    
    int xTag = 20;
    for (NSInteger i=0; i<=xCnt; i++) {
        UILabel *label = [self.seqDiagView viewWithTag:i+xTag];
        if ([label isKindOfClass:[UILabel class]]) {
            label.text = [NSString stringWithFormat:@"%.1f", self.model.report.duration/3600.0*i/xCnt];
        }
    }
}

- (void)refreshSpect {
    int yCnt = 5;
    int xCnt = 5;
    
    float max = 0, min = 0;
    for (NSNumber *value in self.model.report.freqArr) {
        max = MAX(max, value.floatValue);
    }
    max = ((int)(max * 100) / yCnt * yCnt + yCnt) / 100.0;
    [self.spect strokeWithData:self.model.freqArr top:max bottom:min];
    
    int yTag = 10;
    for (NSInteger i=0; i<=yCnt; i++) {
        UILabel *label = [self.spectView viewWithTag:i+yTag];
        if ([label isKindOfClass:[UILabel class]]) {
            label.text = [NSString stringWithFormat:@"%.2f", max*i/yCnt];
        }
    }
    
    int xTag = 20;
    for (NSInteger i=0; i<=xCnt; i++) {
        UILabel *label = [self.spectView viewWithTag:i+xTag];
        if ([label isKindOfClass:[UILabel class]]) {
            label.text = [NSString stringWithFormat:@"%.1f", 0.5*i/xCnt];
        }
    }
}

- (void)refreshPlot {
    int yCnt = 9;
    int xCnt = 4;
    
    int maxX = 0, maxY = 0;
    for (int i=0; i<self.model.rrArr.count; i++) {
        int value0 = [self.model.rrArr[i] intValue];
        maxX = MAX(maxX, value0);
        if (i != self.model.rrArr.count-1) {
            int value1 = [self.model.rrArr[i+1] intValue];
            maxY = MAX(maxY, value1);
        }
    }
    int avgRR = 60000 / self.model.report.meanBpm;
    maxX = MAX(avgRR*2, maxX) / xCnt * xCnt + xCnt;
    maxY = MAX(avgRR*2, maxY) / yCnt * yCnt + yCnt;
    [self.plot strokeWithData:self.model.rrArr maxX:maxX maxY:maxY];
    
    int yTag = 10;
    for (NSInteger i=0; i<=yCnt; i++) {
        UILabel *label = [self.plotView viewWithTag:i+yTag];
        if ([label isKindOfClass:[UILabel class]]) {
            label.text = [NSString stringWithFormat:@"%ld", maxY*i/yCnt];
        }
    }
    
    int xTag = 20;
    for (NSInteger i=0; i<=xCnt; i++) {
        UILabel *label = [self.plotView viewWithTag:i+xTag];
        if ([label isKindOfClass:[UILabel class]]) {
            label.text = [NSString stringWithFormat:@"%ld", maxX*i/xCnt];
        }
    }
}


@end
