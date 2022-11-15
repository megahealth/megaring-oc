//
//  HRVReportPlotView.m
//  BHealth
//
//  Created by Ulric on 19/11/2021.
//  Copyright © 2021 zhaoguan. All rights reserved.
//

#import "HRVReportPlotView.h"
#import "UIViewExt.h"
extern long hrvPlotColor;

@interface HRVReportPlotView ()

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) CAShapeLayer *pathLayer;
@property (nonatomic, assign) BOOL didLayout;

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, assign) int maxX;
@property (nonatomic, assign) int maxY;

@end

@implementation HRVReportPlotView

// MARK: data

- (void)strokeWithData:(NSArray *)dataArr maxX:(int)maxX maxY:(int)maxY {
    _dataArr = dataArr;
    self.maxX = maxX;
    self.maxY = maxY;
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
    for (int i=0; i<self.dataArr.count-1; i+=step) {
        CGPoint point = [self pointWithIndex:i];
        [self.path moveToPoint:point];
        [self.path addLineToPoint:point];
    }
    self.pathLayer.path = self.path.CGPath;
    self.pathLayer.fillColor = [UIColor clearColor].CGColor;
    [self setNeedsDisplay];
}

- (CGPoint)pointWithIndex:(NSInteger)i {
    int  value0 = [self.dataArr[i] intValue];
    int  value1 = [self.dataArr[i+1] intValue];
    CGFloat x = self.width * value0 / MAX(self.maxX, 1);
    CGFloat y = self.height * (self.maxY - value1) / MAX(self.maxY, 1);
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
        _pathLayer.fillColor = [UIColor redColor].CGColor;
        _pathLayer.strokeColor =[UIColor redColor].CGColor;
        
//        hexColor(hrvPlotColor).CGColor;
        _pathLayer.lineWidth = 4;
        _pathLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:_pathLayer];
    }
    return _pathLayer;
}


@end
