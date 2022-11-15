//
//  SleepReportPrTrendView.m
//  BHealth
//
//  Created by cheng cheng on 23/3/2020.
//  Copyright © 2020 zhaoguan. All rights reserved.
//

#import "SleepReportPrTrendView.h"
#import "UIViewExt.h"


@interface SleepReportPrTrendView ()

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) CAShapeLayer *pathLayer;
@property (nonatomic, assign) BOOL didLayout;

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, assign) double yTop;
@property (nonatomic, assign) double yBottom;

@end


@implementation SleepReportPrTrendView

// MARK: data

- (void)strokeWithData:(NSArray *)dataArr top:(double)top bottom:(double)bottom {
    _dataArr = dataArr;
    self.yTop = top;
    self.yBottom = bottom;
    [self.path removeAllPoints];
    [self startStroke];
}


// MARK: UI

- (void)startStroke {
    if (self.didLayout) {
        [self drawCurve];
    } else {
        [self performSelector:@selector(startStroke) withObject:nil afterDelay:0.1];
    }
}


- (void)drawCurve {
    BOOL isLastHandOn = YES;
    for (int i=0; i<self.dataArr.count && self.duration>0 && self.duration < 50000; i+=self.drawStep) {
        int pr = [self.dataArr[i] intValue];
        BOOL isHandOn = pr > 0;
        if (isHandOn) {
            if (isLastHandOn && i > 0) {
                [self.path addLineToPoint:[self pointWithIndex:i]];
            } else {
                [self.path moveToPoint:[self pointWithIndex:i]];
            }
        }
        isLastHandOn = isHandOn;
    }
    self.pathLayer.path = self.path.CGPath;
    [self setNeedsDisplay];
}

- (CGPoint)pointWithIndex:(NSInteger)i {
    double  value = [self.dataArr[i] doubleValue];
    value = MIN(value, self.max);
    value = MAX(value, self.min);
    CGFloat x = self.width * i / MAX(self.duration, 1);
    CGFloat y = self.height * ((self.yTop - value) * 1.0 / (self.yTop - self.yBottom));
    CGPoint  point = CGPointMake(x, y);
    return point;
}

- (void)calculateStatisticalValueWithData:(NSArray *)dataArr {
    self.dataArr = dataArr;
    self.drawStep = MAX(ceil(self.dataArr.count / 2000.0), 1);
    self.minValueInPicture = 0;
    self.maxValueInPicture = 0;
    for (int i=0; i<self.dataArr.count; i+=self.drawStep) {
        int value = [self.dataArr[i] intValue];
        BOOL valid = value > 0;
        if (valid) {
            if (value > self.maxValueInPicture) {
                self.maxValueInPicture = value;
            }
            if (self.minValueInPicture <= 0 || value < self.minValueInPicture) {
                self.minValueInPicture = value;
            }
        }
    }
}


#pragma mark -
#pragma mark - overwrite

- (void)awakeFromNib {
    [super awakeFromNib];
    self.path = [UIBezierPath bezierPath];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutIfNeeded];
    self.didLayout = YES;
}

- (CAShapeLayer *)pathLayer {
    if (!_pathLayer) {
        _pathLayer = [CAShapeLayer layer];
        _pathLayer.frame = self.bounds;
        _pathLayer.fillColor = [UIColor clearColor].CGColor;
        _pathLayer.strokeColor = HEXCOLOR(0x1dab24).CGColor;
        _pathLayer.lineWidth = 1;
        [self.layer addSublayer:_pathLayer];
    }
    return _pathLayer;
}


@end
