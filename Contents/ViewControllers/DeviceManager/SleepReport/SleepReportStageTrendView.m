//
//  SleepReportStageTrendView.m
//  BHealth
//
//  Created by cheng cheng on 23/3/2020.
//  Copyright © 2020 zhaoguan. All rights reserved.
//

#import "SleepReportStageTrendView.h"
#import "UIViewExt.h"


#define STAGE_COLOR_LEAVE        STAGE_COLOR_AWAKE
#define STAGE_COLOR_AWAKE          0XF9BE70
#define STAGE_COLOR_REM            0X57D2A7
#define STAGE_COLOR_LIGHT       0X2276FC
#define STAGE_COLOR_DEEP        0X8415FA

static NSString    *stageValue = @"kDayReportStageValue";
static NSString    *stageCount = @"kDayReportStageCount";


@interface SleepReportStageTrendView ()
@property (nonatomic, assign) BOOL didLayout;

@property (nonatomic, strong) CAShapeLayer    *chartLayer;
@property (nonatomic, strong) CAShapeLayer    *maskLayer;

/*
 The array stores a dictionary describing consecutive identical values. The dictionary contains the value size and the number of consecutive occurrences of the value;
 
 * 该数组存储描述连续相同值的字典, 字典包含数值大小和该值连续出现的次数;
 * [{value:value1, count:count1}, {value:value2, count:count2}, {value:value3, count:count3}, {value:value4, count:count4}, ...]
 */
@property (nonatomic, strong) NSMutableArray    *perfectDataArr;

@property (nonatomic, assign) CGFloat     unitHeight;
@property (nonatomic, assign) CGFloat     unitWidth;

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, assign) NSInteger minutes;

@end

@implementation SleepReportStageTrendView


- (void)strokeWithData:(NSArray *)dataArr minutes:(NSInteger)minutes {
    self.dataArr = dataArr;
    self.minutes = minutes;
    
    NSArray    *subLayers = [NSArray arrayWithArray:self.chartLayer.sublayers];
    for (CAShapeLayer *subLayer in subLayers) {
        [subLayer removeFromSuperlayer];
    }
    
    if (dataArr.count > 0) {
        [self prepareDataArr];
        [self startStroke];
    }
}
// draw UI.
- (void)startStroke {
    if (self.didLayout == NO) {
        [self performSelector:@selector(startStroke) withObject:nil afterDelay:0.1];
        return;
    }
    
    CGFloat totalWidth = 0;
    if (self.minutes > 0) {
        
        totalWidth = self.width * self.dataArr.count / self.minutes;
    }

    self.unitHeight = self.height / 4;
    self.unitWidth = totalWidth / self.dataArr.count;
    
    CGFloat     curXPosition = 0;
    for (NSInteger i=0; i<self.perfectDataArr.count && totalWidth > 0; i++) {
        NSInteger     value = [self.perfectDataArr[i][stageValue] integerValue];
        NSInteger     count = [self.perfectDataArr[i][stageCount] integerValue];
        CGFloat     layerWidth = count * self.unitWidth;
        
        UIColor    *color = [UIColor clearColor];
        CGFloat     lineWidth = self.unitHeight * 1;
        NSInteger    stageValue = 0;
        if (value == 0) {
            color = HEXCOLOR(STAGE_COLOR_AWAKE);
            stageValue = 1;
        } else if (value == 2) {
            color = HEXCOLOR(STAGE_COLOR_REM);
            stageValue = 2;
        } else if (value == 3) {
            color = HEXCOLOR(STAGE_COLOR_LIGHT);
            stageValue = 3;
        } else if (value == 4) {
            color = HEXCOLOR(STAGE_COLOR_DEEP);
            stageValue = 4;
        } else if (value == 6) {
            color = [UIColor clearColor];
            stageValue = 0;
            lineWidth = 0;
        }
        
        CAShapeLayer    *subLayer = [CAShapeLayer layer];
        subLayer.frame = CGRectMake(curXPosition, 0, layerWidth, self.frame.size.height);
        subLayer.fillColor = color.CGColor;
        subLayer.strokeColor = color.CGColor;
        subLayer.lineWidth = lineWidth;
        
        UIBezierPath    *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, self.frame.size.height/4*stageValue - lineWidth / 2)];
        [path addLineToPoint:CGPointMake(layerWidth, self.frame.size.height/4*stageValue - lineWidth / 2)];
        subLayer.path = path.CGPath;
        [self.chartLayer addSublayer:subLayer];
        
        curXPosition += layerWidth;
    }
    
    CABasicAnimation    *ani = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    ani.fromValue = @0;
    ani.toValue = @1;
    ani.duration = 1.0;
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.maskLayer addAnimation:ani forKey:@"strokeEnd"];
}


#pragma mark -
#pragma mark Basic Settings

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutIfNeeded];
    self.didLayout = YES;
}

- (CAShapeLayer *)chartLayer {
    if (!_chartLayer) {
        _chartLayer = [CAShapeLayer layer];
        _chartLayer.frame = self.bounds;
        [self.layer addSublayer:_chartLayer];
    }
    return _chartLayer;
}

- (CAShapeLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.frame = self.bounds;
        _maskLayer.fillColor = [UIColor clearColor].CGColor;
        _maskLayer.strokeColor = [UIColor blackColor].CGColor;
        _maskLayer.strokeStart = 0;
        _maskLayer.strokeEnd = 1;
        _maskLayer.lineWidth = self.height;
        UIBezierPath    *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, self.height/2)];
        [path addLineToPoint:CGPointMake(self.width, self.height/2)];
        _maskLayer.path = path.CGPath;
        self.layer.mask = _maskLayer;
    }
    return _maskLayer;
}

- (void)prepareDataArr {
    self.perfectDataArr = [NSMutableArray new];
    
    NSInteger     curValue = [[self.dataArr firstObject] integerValue];
    NSInteger     curCount = 0;
    
    for (NSInteger i=0; i<self.dataArr.count; i++) {
        NSInteger     value = [self.dataArr[i] integerValue];
        if (value == curValue) {
            curCount ++;
        } else {
            NSDictionary    *subData = @{stageValue:@(curValue), stageCount:@(curCount)};
            [self.perfectDataArr addObject:subData];
            curValue = value;
            curCount = 1;
        }
        
        if (i == self.dataArr.count - 1) {
            NSDictionary    *subData = @{stageValue:@(curValue), stageCount:@(curCount)};
            [self.perfectDataArr addObject:subData];
        }
    }
}



@end
