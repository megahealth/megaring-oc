//
//  HRVReportHrvView.m
//  BHealth
//
//  Created by Ulric on 19/11/2021.
//  Copyright © 2021 zhaoguan. All rights reserved.
//

#import "HRVReportHrvView.h"
#import "UIViewExt.h"

extern long hrvHrvColor;

@interface HRVReportHrvView ()

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) CAShapeLayer *pathLayer;
@property (nonatomic, assign) BOOL didLayout;

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, assign) int yTop;
@property (nonatomic, assign) int yBottom;

@end

@implementation HRVReportHrvView

// MARK: data

- (void)strokeWithData:(NSArray *)dataArr top:(int)top bottom:(int)bottom {
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
    int step = MAX(ceil(self.dataArr.count / (self.width*10)), 1);
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

- (CGPoint)pointWithIndex:(NSInteger)i {
    double  value = [self.dataArr[i] intValue];
    CGFloat x = self.width * i / MAX(self.dataArr.count, 1);
    CGFloat y = self.height * ((self.yTop - value) * 1.0 / (self.yTop - self.yBottom));
    CGPoint  point = CGPointMake(x, y);
    return point;
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
        _pathLayer.strokeColor = hexColor(hrvHrvColor).CGColor;
        _pathLayer.lineWidth = 1;
        [self.layer addSublayer:_pathLayer];
    }
    return _pathLayer;
}

@end
