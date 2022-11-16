//
//  SleepReportView.m
//  BHealth
//
//  Created by cheng cheng on 23/3/2020.
//  Copyright © 2020 zhaoguan. All rights reserved.
//

#import "SleepReportView.h"
#import "SleepReportViewModel.h"
#import "SleepReportPrTrendView.h"
#import "SleepReportSpTrendView.h"

#import "HDReportsAxisTimeView.h"
#import "SleepReportStageTrendView.h"
#import "SleepReportTempTrendView.h"

#import "UIViewExt.h"

@interface SleepReportView ()

@property (nonatomic, assign) float tempStep;
@property (nonatomic, assign) float tempRange;
@property (nonatomic, assign) float tempBottom;

@property (nonatomic, assign) CGFloat tempLineWidth;

@property (nonatomic, strong) UIBezierPath *tempLinePath;
@property (nonatomic, strong) CAShapeLayer *tempLinepathLayer;

@property (nonatomic, strong) NSArray *tempArr;


@end






@implementation SleepReportView

- (IBAction)helpButtonClicked:(UIButton *)sender {
    
    
    NSLog(@"sender.tag---------------%ld",sender.tag);
    
//    [HDReportsInfoCardView showCardOnView:self type:sender.tag];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    NSString *ttlImgName = NSLocalizedString(MHSleepTitleImageName, nil);
    self.ttlImg.image = [UIImage imageNamed:ttlImgName];
    
    
    
    self.respiratoryMaximumLabel.text =  @"Maximum";
    
//    NSLocalizedString(MHMaximum, nil);
    self.respiratoryAverageLabel.text = @"Average";
//    NSLocalizedString(MHAverage, nil);
    self.respiratoryMinimumLabel.text = @"Minimum";
//    NSLocalizedString(MHMinimum, nil);
    
    self.tempLinePath = [UIBezierPath bezierPath];
}



- (SleepReportViewModel *)model {
    if (_model == nil) {
        _model = [[SleepReportViewModel alloc] init];
    }
    return _model;
}

- (void)refresh {
    if (self.model.report == nil) {
        return;
    }
    self.date.text = self.model.shareTime;
    
    int spTrendTop = self.model.spScaleTop;
    int spTrendBottom = self.model.spScaleBottom;
    
    BOOL alertOn = self.model.spAlertOn;
    int alertLow = self.model.spAlertLow;
    
    if (alertOn == NO) {
        alertLow = SPALERT_LOW_DEFAULT;
    }
    if (alertLow > spTrendTop) {
        alertLow = spTrendTop;
    }
    if (alertLow < spTrendBottom) {
        alertLow = spTrendBottom;
    }
    alertLow = 88;
    float scale = 1;
    if (spTrendTop - spTrendBottom > 0) {
        scale = (spTrendTop - alertLow) * 1.0 / (spTrendTop - spTrendBottom);
    }
    
    self.alertLine.hidden = YES;
    self.alertLineTopCons.constant = self.spTrendView.height * scale;
    [self.spTrendView strokeAlertLineAtVerticalPosition:self.spTrendView.height * scale + 1];
    [self.spTimeAxis addTimeStringWithStart:self.model.report.originStart end:self.model.report.originEnd format:@"HH:mm"];
    [self.prTimeAxis addTimeStringWithStart:self.model.report.originStart end:self.model.report.originEnd format:@"HH:mm"];
    
    
    [self.respiratoryAxisTimeView addTimeStringWithStart:self.model.report.originStart end:self.model.report.originEnd format:@"HH:mm"];
    
    [self.stageTimeAxis addTimeStringWithStart:self.model.report.originStart end:self.model.report.originEnd format:@"HH:mm"];
    self.start.text = self.model.start;
    self.latency.text = self.model.latency;
    self.duration.text = self.model.duration;
    
    self.invalid1.hidden = self.model.reportValid;
    self.invalid2.hidden = self.model.reportValid;
    self.invalid3.hidden = self.model.reportValid;
    self.stageInvalid.hidden = !(self.model.reportValid && !self.model.stageValid);
    if (self.model.reportValid == NO) {
        return;
    }
    
    
    self.spTrendView.duration = self.model.report.originEnd - self.model.report.originStart;
    self.spTrendView.min = self.model.report.minSp;
    [self.spTrendView calculateStatisticalValueWithData:self.model.spArr];
    [self.spTrendView strokeWithData:self.model.spArr top:spTrendTop bottom:spTrendBottom];
    
    
    self.odi.text = self.model.odi;
    self.avgSp.text = self.model.avgSp;
    self.minSp.text = self.model.minSp;
    
    self.duration95.text = self.model.duration95;
    self.duration90.text = self.model.duration90;
    self.duration85.text = self.model.duration85;
    self.duration80.text = self.model.duration80;
    self.percent95.text = self.model.percent95;
    self.percent90.text = self.model.percent90;
    self.percent85.text = self.model.percent85;
    self.percent80.text = self.model.percent80;
    
    
    [self.prTrendView calculateStatisticalValueWithData:self.model.prArr];
//    [self refreshScales];
    self.prTrendView.duration = self.model.report.originEnd - self.model.report.originStart;
    self.prTrendView.max = self.model.report.maxPr;
    self.prTrendView.min = self.model.report.minPr;
    [self.prTrendView strokeWithData:self.model.prArr top:self.model.prScaleTop bottom:self.model.prScaleBottom];
    
    self.maxPr.text = self.model.maxPr;
    self.avgPr.text = self.model.avgPr;
    self.minPr.text = self.model.minPr;
    
    
    
    int respiAAAA = 0;
//    self.model.respiArr.count
    if (respiAAAA == 0) {
        self.respiView.hidden = YES;
        self.respiratoryHeightCons.constant = 0;
        [self refreshScales];
        
    }else{
//    MARK://TODO...
        self.respiView.hidden = NO;
        self.respiratoryHeightCons.constant = 325;

        [self.respiratoryTrendView calculateStatisticalValueWithData:self.model.respiArr];
        [self refreshScales];
        self.respiratoryTrendView.duration = self.model.report.originEnd - self.model.report.originStart;
        self.respiratoryTrendView.max = self.model.report.maxPr;
        self.respiratoryTrendView.min = self.model.report.minPr;
        [self.respiratoryTrendView strokeWithData:self.model.respiArr top:self.model.respiScaleTop bottom:self.model.respiScaleBottom];
        self.maxRespiratoryLabel.text = self.model.maxPr;
        self.averageRespiratoryLabel.text = self.model.avgPr;
        self.minRespiratoryLabel.text = self.model.minPr;
        
        
    }
    
    
    NSInteger minutes = (self.model.report.originEnd - self.model.report.originStart) / 60;
    [self.stageTrendView strokeWithData:self.model.stageArr minutes:minutes];
    
    self.awakeWidthCons.constant = self.width / 2 * self.model.awakeRatio;
    self.remWidthCons.constant = self.width / 2 * self.model.remRatio;
    self.lightWidthCons.constant = self.width / 2 * self.model.lightRatio;
    self.deepWidthCons.constant = self.width / 2 * self.model.deepRatio;
    
    [self hideItemByCons:self.awakeWidthCons];
    [self hideItemByCons:self.remWidthCons];
    [self hideItemByCons:self.lightWidthCons];
    [self hideItemByCons:self.deepWidthCons];
    
    self.awakeDuration.text = self.model.awakeDuation;
    self.remDuration.text = self.model.remDuration;
    self.lightDuration.text = self.model.lightDuration;
    self.deepDuration.text = self.model.deepDuartion;
}

- (void)hideItemByCons:(NSLayoutConstraint *)cons {
    UIView *item = (UIView *)cons.firstItem;
    BOOL hidden = cons.constant <= 0.00001 && [item isMemberOfClass:[IBCustomView class]];
    item.hidden = hidden;
}

- (void)refreshScales {
    for (int i=0; i<self.prTrendView.superview.subviews.count; i++) {
        UILabel *lab = [self.prTrendView.superview viewWithTag:i+10];
        if (lab == nil) {
            break;
        }
        
        lab.text = [NSString stringWithFormat:@"%d", self.model.prScaleTop-i*self.model.prScaleStep];
    }
    
    for (int i=0; i<self.spTrendView.superview.subviews.count; i++) {
        UILabel *lab = [self.spTrendView.superview viewWithTag:i+10];
        if (lab == nil) {
            break;
        }
        
        lab.text = [NSString stringWithFormat:@"%d", self.model.spScaleTop-i*self.model.spScaleStep];
    }
    
    if (self.respiratoryHeightCons.constant > 0) {
        
    
    for (int i=0; i<self.respiratoryTrendView.superview.subviews.count; i++) {
        UILabel *lab = [self.respiratoryTrendView.superview viewWithTag:i+10];
        if (lab == nil) {
            break;
        }
        
        lab.text = [NSString stringWithFormat:@"%d", self.model.respiScaleTop-i*self.model.respiScaleStep];
    }
        
    }  
}


- (void)showTemp:(NSArray *)tempArr {
    self.tempArr = tempArr;
    
    NSNumber *avg = [tempArr valueForKeyPath:@"@avg.floatValue"];
    NSNumber *max = [tempArr valueForKeyPath:@"@max.floatValue"];
    NSNumber *min = [tempArr valueForKeyPath:@"@min.floatValue"];
    NSString * avgg = [NSString stringWithFormat:@"%.2f",[avg floatValue]];
    NSString * maxx = [NSString stringWithFormat:@"%.2f",[max floatValue]];
    NSString * minn = [NSString stringWithFormat:@"%.2f",[min floatValue]];
    self.maxTemp = [maxx  floatValue];
    self.minTemp = [minn floatValue];
    self.avgTemp = [avgg floatValue];
    [self calculateYAxis];
    [self refreshXAxis];
    [self refreshYAxis];
    [self drawTemp];
}

- (void)calculateYAxis {
    float offset = MAX(self.maxTemp-self.avgTemp, self.avgTemp-self.minTemp);
    int grids = 6;
    self.tempStep = ceilf(offset * 2 / grids * 1.2 * 10) / 10;
    self.tempRange = self.tempStep * grids;
    self.tempBottom = 0 - self.tempRange / 2 + self.avgTemp;
}

- (void)refreshXAxis {
    int endAt = self.model.report.originEnd;
    int startAt = self.model.report.originStart;
    
    int duration = endAt - startAt;
    BOOL showIntermediate = duration >= 5*60; // 时长在五分钟以上的显示中间时间刻度
    double step = duration * 1.0 / 4;
    for (UILabel *lab in self.tempXAxis.subviews) {
        if ([lab isKindOfClass:[UILabel class]]) {
            double time = startAt + step * lab.tag;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
            NSString *string = localizedStringFromDate(date, @"HH:mm");
            if ((lab.tag > 0 && lab.tag < 5) && showIntermediate == NO) {
                string = @"";
            }
            lab.text = string;
//            NSLog(@"--time--:%f, tag:%ld", time, (long)lab.tag);
        }
    }
}

- (void)refreshYAxis {
    for (UILabel *label in self.tempYAxis.subviews) {
        int tag = (int)label.tag;
        float tempreture = self.tempBottom + self.tempStep * tag;
        label.text = [NSString stringWithFormat:@"%.1f", tempreture];
    }
}

- (void)drawTemp {
    BOOL isLastHandOn = YES;
    for (int i=0; i<self.tempArr.count; i++) {
        CGPoint point = [self pointWithIndex:i];
        BOOL isHandOn = CGPointEqualToPoint(point, CGPointZero) == NO;
        
        if (isHandOn) {
            if (isLastHandOn && i > 0) {
                [self.tempLinePath addLineToPoint:[self pointWithIndex:i]];
            } else {
                [self.tempLinePath moveToPoint:[self pointWithIndex:i]];
            }
        }
        isLastHandOn = isHandOn;
    }
    self.tempLinepathLayer.path = self.tempLinePath.CGPath;
    [self setNeedsDisplay];
}

- (CGPoint)pointWithIndex:(NSUInteger)i {
    if (self.tempArr.count <= 1) {
        return CGPointZero;
    }
    double  value = [self.tempArr[i] floatValue];
    if (value <= 0) {
        return CGPointZero;
    }
    
    float offset = value - self.avgTemp;
    CGFloat x = i * (SCREEN_WIDTH - 65) / (self.tempArr.count-1);
    CGFloat y2 = (self.tempRange / 2 - offset) / MAX(self.tempRange, 0.1) * self.tempTrendView.height;
    
    return CGPointMake(x, y2);
}


- (void)showExtremeValue {
}


#pragma mark -
#pragma mark - overwrite

- (CAShapeLayer *)tempLinepathLayer {
    if (!_tempLinepathLayer) {
        _tempLinepathLayer = [CAShapeLayer layer];
        _tempLinepathLayer.frame = self.bounds;
        _tempLinepathLayer.strokeColor = hexColor(0x569eff).CGColor;
        _tempLinepathLayer.fillColor = [UIColor clearColor].CGColor;
        _tempLinepathLayer.lineWidth = 1;
        _tempLinepathLayer.lineCap = kCALineCapRound;
        [self.tempTrendView.layer addSublayer:_tempLinepathLayer];
    }
    return _tempLinepathLayer;
}

- (CGFloat)tempLineWidth {
//    return self.tempTrendView.width / 24 * 4 / 6;
    return 1;
}






@end
