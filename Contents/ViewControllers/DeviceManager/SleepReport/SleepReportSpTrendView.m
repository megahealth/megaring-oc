//
//  SleepReportSpTrendView.m
//  BHealth
//
//  Created by cheng cheng on 23/3/2020.
//  Copyright © 2020 zhaoguan. All rights reserved.
//

#import "SleepReportSpTrendView.h"
#import "UIViewExt.h"
@interface SleepReportSpTrendView ()

@property (nonatomic, strong) CAShapeLayer *maskLayer;

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) CAShapeLayer *pathLayer;
@property (nonatomic, assign) BOOL didLayout;

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, assign) double yTop;
@property (nonatomic, assign) double yBottom;

@property (nonatomic, strong) UIBezierPath *alertLinePath;
@property (nonatomic, strong) CAShapeLayer *alertLineLayer;
@property (nonatomic, assign) CGFloat alertLinePosition;

@end


@implementation SleepReportSpTrendView

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
        [self strokeAlertLineAtVerticalPosition:self.alertLinePosition];
        if (self.dataArr.count > 0) {
            self.hidden = NO;
        }
    } else {
        [self performSelector:@selector(startStroke) withObject:nil afterDelay:0.1];
    }
}


- (void)drawCurve {
    BOOL isLastHandOn = YES;
    for (int i=0; i<self.dataArr.count && self.duration>0 && self.duration < 50000; i+=self.drawStep) {
        double sp = [self.dataArr[i] doubleValue];
        BOOL isHandOn = sp > 37.00001;
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
    self.layer.mask = self.maskLayer;
    [self setNeedsDisplay];
}

- (void)strokeAlertLineAtVerticalPosition:(CGFloat)position {
    self.alertLinePosition = position;
    [self.alertLinePath removeAllPoints];
    [self.alertLinePath moveToPoint: CGPointMake(0, position)];
    [self.alertLinePath addLineToPoint:CGPointMake(self.width, position)];
    
    self.alertLineLayer.path = self.alertLinePath.CGPath;
    [self setNeedsDisplay];
}

- (CGPoint)pointWithIndex:(NSInteger)i {
    double  value = [self.dataArr[i] doubleValue];
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
        double value = [self.dataArr[i] doubleValue];
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

- (CAShapeLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.frame = self.bounds;
        [self.layer addSublayer:_maskLayer];
    }
    return _maskLayer;
}

- (CAShapeLayer *)pathLayer {
    if (!_pathLayer) {
        _pathLayer = [CAShapeLayer layer];
        _pathLayer.frame = self.bounds;
        _pathLayer.fillColor = [UIColor clearColor].CGColor;
        _pathLayer.strokeColor = HEXCOLOR(0x0e85ff).CGColor;
        _pathLayer.lineWidth = 1;
        [self.maskLayer addSublayer:_pathLayer];
    }
    return _pathLayer;
}

- (UIBezierPath *)alertLinePath {
    if (!_alertLinePath) {
        _alertLinePath = [UIBezierPath bezierPath];
    }
    return _alertLinePath;
}

- (CAShapeLayer *)alertLineLayer {
    if (!_alertLineLayer) {
        _alertLineLayer = [CAShapeLayer layer];
        _alertLineLayer.frame = self.bounds;
        _alertLineLayer.fillColor = [UIColor clearColor].CGColor;
        _alertLineLayer.strokeColor = HEXCOLOR(SPALERT_COLOR).CGColor;
        _alertLineLayer.lineWidth = 1;
        [_alertLineLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:2],nil]];
        [self.maskLayer addSublayer:_alertLineLayer];
    }
    return _alertLineLayer;
}

@end
