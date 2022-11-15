//
//  WorkoutReportTrendView.m
//  BHealth
//
//  Created by cheng cheng on 20/3/2020.
//  Copyright © 2020 zhaoguan. All rights reserved.
//

#import "WorkoutReportTrendView.h"
#import "UIViewExt.h"
@interface WorkoutReportTrendView ()
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) CAShapeLayer *pathLayer;
@property (nonatomic, assign) BOOL didLayout;

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, assign) double yTop;
@property (nonatomic, assign) double yBottom;

@end

@implementation WorkoutReportTrendView



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
        [self drawShadowCurve];
    } else {
        [self performSelector:@selector(startStroke) withObject:nil afterDelay:0.1];
    }
}


- (void)drawCurve {
    int step = MAX(ceil(self.dataArr.count / (self.width*5)), 1);
    BOOL isLastHandOn = YES;
    for (int i=0; i<self.dataArr.count; i+=step) {
        BOOL isHandOn = [self.dataArr[i] intValue] > 0;
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
    self.pathLayer.fillColor = [UIColor clearColor].CGColor;
    [self setNeedsDisplay];
}

- (void)drawShadowCurve {
    CGPoint lastPoint = CGPointMake(0, self.height);
    BOOL isLastHandOn = NO;
    [self.path moveToPoint:lastPoint];
    int invalidCount = 0;  // End rendering when the number of outliers reaches a certain value 异常值达到一定数目后结束渲染
    for (int i=0; i<self.dataArr.count && i<self.duration && self.duration>0 && self.duration < 50000; i+=self.drawStep) {
        CGPoint currentPoint = [self pointWithIndex:i];
        
        int hr = [self.dataArr[i] intValue];
        if (hr > 220) {
            invalidCount ++;
        }
        if (invalidCount > 5) {
            break;
        }
        
        BOOL isHandOn = hr > 0;
        if (isHandOn) {
            if (isLastHandOn == NO) {
                CGPoint bottom = CGPointMake(currentPoint.x, self.height);
                [self.path moveToPoint:bottom];
            }
            [self.path addLineToPoint:currentPoint];
            lastPoint = currentPoint;
        } else {
            if (isLastHandOn) {
                CGPoint lastBottom = CGPointMake(lastPoint.x, self.height);
                [self.path addLineToPoint:lastBottom];
                lastPoint = lastBottom;
            }
        }
        isLastHandOn = isHandOn;
    }
    CGPoint lastBottom = CGPointMake(lastPoint.x, self.height);
    [self.path addLineToPoint:lastBottom];
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
        _pathLayer.fillColor = hexAColor(0xff4f32aa).CGColor;
        _pathLayer.strokeColor = hexColor(0xff4f32).CGColor;
        _pathLayer.lineWidth = 1;
        [self.layer addSublayer:_pathLayer];
    }
    return _pathLayer;
}



@end
