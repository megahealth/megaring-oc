//
//  HRVReportDistView.m
//  BHealth
//
//  Created by Ulric on 19/11/2021.
//  Copyright © 2021 zhaoguan. All rights reserved.
//

#import "HRVReportDistView.h"

#import "UIViewExt.h"

extern long hrvDistColor;

@interface HRVReportDistView ()

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) CAShapeLayer *pathLayer;
@property (nonatomic, assign) BOOL didLayout;

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, assign) int yTop;
@property (nonatomic, assign) int yBottom;

@end

@implementation HRVReportDistView



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
    for (int i=0; i<self.dataArr.count; i++) {
        CGPoint start = [self pointWithIndex:i];
        CGPoint end = CGPointMake(start.x, self.height);
        [self.path moveToPoint:[self pointWithIndex:i]];
        [self.path addLineToPoint:end];
    }
    self.pathLayer.path = self.path.CGPath;
    self.pathLayer.fillColor = [UIColor clearColor].CGColor;
    [self setNeedsDisplay];
}

- (CGPoint)pointWithIndex:(NSInteger)i {
    double  value = [self.dataArr[i] intValue];
    CGFloat x = self.width * i / 200;
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
        _pathLayer.strokeColor = hexColor(hrvDistColor).CGColor;
        _pathLayer.lineWidth = 1;
        [self.layer addSublayer:_pathLayer];
    }
    return _pathLayer;
}

@end
