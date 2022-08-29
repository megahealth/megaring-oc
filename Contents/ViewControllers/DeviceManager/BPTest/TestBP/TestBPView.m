//
//  TestBPView.m
//  BHealth
//
//  Created by cheng cheng on 3/6/2021.
//  Copyright © 2021 zhaoguan. All rights reserved.
//

#import "TestBPView.h"
//#import "SFDualWaySlider.h"
//#import "HDReportsInfoCardView.h"
#import <MRFramework/MRFramework.h>
#import "UIViewExt.h"


//extern int kMinBPValue;
//extern int kMaxBPValue;
//extern int kBPMinMaxSpace;
//extern NSString *kBPInvalidAlert;

@interface TestBPView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *contents;
    @property (weak, nonatomic) IBOutlet UIView *attentions;
    @property (weak, nonatomic) IBOutlet UIView *editBP;
        @property (weak, nonatomic) IBOutlet UIButton *positiveBtn;
        @property (weak, nonatomic) IBOutlet UIButton *negativeBtn;
        @property (weak, nonatomic) IBOutlet UIButton *sbpBtn;
        @property (weak, nonatomic) IBOutlet UIButton *dbpBtn;
    @property (weak, nonatomic) IBOutlet UIView *testing;
        @property (weak, nonatomic) IBOutlet UIView *testingHeader;
            @property (weak, nonatomic) IBOutlet UIView *startTimeView;
                @property (weak, nonatomic) IBOutlet UILabel *startLab;
        @property (weak, nonatomic) IBOutlet UIView *ready;
        @property (weak, nonatomic) IBOutlet UIView *started;
            @property (weak, nonatomic) IBOutlet UIView *canvas;
                @property (nonatomic, strong) UIBezierPath *path;
                @property (nonatomic, strong) CAShapeLayer *pathLayer;
            @property (weak, nonatomic) IBOutlet UIView *liveHeader;
                @property (weak, nonatomic) IBOutlet UILabel *livePrLab;
            @property (weak, nonatomic) IBOutlet UIView *liveBody;
                @property (weak, nonatomic) IBOutlet UILabel *duration;
            @property (weak, nonatomic) IBOutlet UIView *finishHeader;
            @property (weak, nonatomic) IBOutlet UIView *failureHeader;
            @property (weak, nonatomic) IBOutlet UIView *finishBody;
                @property (weak, nonatomic) IBOutlet UILabel *resDBPLab;
                @property (weak, nonatomic) IBOutlet UILabel *resSBPLab;
                @property (weak, nonatomic) IBOutlet UILabel *resPRLab;
            @property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIView *tips;
    // sliderBg's superview
        @property (weak, nonatomic) IBOutlet UIView *sliderBg;
//            @property (nonatomic, strong) SFDualWaySlider *slider;
    @property (weak, nonatomic) IBOutlet UIView *resultTips;


@property (weak, nonatomic) IBOutlet UILabel *debugLab;

@property (nonatomic, strong) NSTimer *timer;   // 定时器 timer
@property (nonatomic, assign) int startIndex; // 已渲染到的数据位置  Data location rendered to
@property (nonatomic, assign) int endIndex; // 已渲染到的数据位置

@property (nonatomic, assign) NSTimeInterval refreshInterval;   // 刷新间隔 refresh interval
@property (nonatomic, assign) int ecgFrequency; // 数据频率 Data frequency
@property (nonatomic, assign) int trendWidth;  // 显示数据量，秒  Display data volume, seconds
@property (nonatomic, assign) float maxY; // 数据最高点值 Data highest point value
@property (nonatomic, assign) float minY; // 数据最低点值 Data lowest point value
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *finishedButtonConstraint;


@end


@implementation TestBPView


- (IBAction)tipsTapped:(id)sender {
    self.tips.hidden = YES;
}

- (IBAction)SBPClicked:(UIButton *)sender {
//    [self showSlider];
    [self showEditor];
}


- (IBAction)DBPClicked:(UIButton *)sender {
//    [self showSlider];
    [self showEditor];
}

- (IBAction)positiveClicked:(UIButton *)sender {
    self.hasHBP = YES;
}

- (IBAction)negativeClicked:(UIButton *)sender {
    self.hasHBP = NO;
}

#pragma mark -- total -------....
- (IBAction)bpInfoClicked:(UIButton *)sender {
//    [HDReportsInfoCardView showCardOnView:APPDELEGATE.window type:sender.tag];
}

- (IBAction)showResTips:(UIButton *)sender {
    self.progress = TestBPProgressResTips;
}

- (IBAction)hideResTips:(UIButton *)sender {
    self.tips.hidden = YES;
}


- (void)setProgress:(TestBPProgress)progress {
    _progress = progress;
    for (UIView *view in self.contents.subviews) {
        view.hidden = view.tag != (progress & 0xF0) >> 4;
    }
    
    self.startTimeView.hidden = progress < TestBPProgressStart;
    
    if (progress >= TestBPProgressTesting && progress <= TestBPProgressFailure) {
        self.ready.hidden = progress >= TestBPProgressStart;
        self.started.hidden = progress < TestBPProgressStart;
        self.liveBody.hidden = progress != TestBPProgressStart;
        self.liveHeader.hidden = YES;
        self.finishBody.hidden = progress != TestBPProgressFinish;
        self.finishHeader.hidden = progress != TestBPProgressFinish;
        self.failureHeader.hidden = progress != TestBPProgressFailure;
        self.buttonView.hidden = progress < TestBPProgressFinish;
        
    }
    if (progress <= TestBPProgressStart) {
        self.ecg = [NSArray new];
        [self.path removeAllPoints];
        self.pathLayer.path = self.path.CGPath;
        [self setNeedsDisplay];
    }
    
    self.tips.hidden = progress != TestBPProgressResTips;
    self.sliderBg.superview.hidden = YES;
    self.resultTips.hidden = progress != TestBPProgressResTips;
    
}

- (void)setSBP:(int)SBP {
    NSString *title = [NSString stringWithFormat:@"%d", SBP];
    [self.sbpBtn setTitle:title forState:UIControlStateNormal];
}

- (int)SBP {
    return self.sbpBtn.titleLabel.text.intValue;
}

- (void)setDBP:(int)DBP {
    NSString *title = [NSString stringWithFormat:@"%d", DBP];
    [self.dbpBtn setTitle:title forState:UIControlStateNormal];
}

- (int)DBP {
    return self.dbpBtn.titleLabel.text.intValue;
}

- (void)setHasHBP:(BOOL)hasHBP {
    self.positiveBtn.selected = hasHBP;
    self.positiveBtn.layer.borderColor = (hasHBP ? hexColor(0x56A3BD) : hexColor(0xFFFFFF)).CGColor;
    self.negativeBtn.selected = !hasHBP;
    self.negativeBtn.layer.borderColor = (!hasHBP ? hexColor(0x56A3BD) : hexColor(0xFFFFFF)).CGColor;
}

- (BOOL)hasHBP {
    return self.positiveBtn.selected;
}

- (void)updateStartTime:(NSDate *)start {
    self.startLab.text = stringFromDate(start, @"HH:mm");
}

- (void)updateDuration:(int)duration {
    self.duration.text = [NSString stringWithFormat:@"%02d:%02d", duration/60, duration%60];
}

- (void)updateLivePR:(int)pr {
    self.livePrLab.text = [NSString stringWithFormat:@"%d", pr];
}

- (void)showReport:(MRBPReport *)report {
    self.resDBPLab.text = [NSString stringWithFormat:@"%.1f", report.DBP];
    self.resSBPLab.text = [NSString stringWithFormat:@"%.1f", report.SBP];
    self.resPRLab.text = [NSString stringWithFormat:@"%d", report.avgPr];
}

- (void)showDebugInfo:(MRBPReport *)report {
//    self.debugLab.text = report.description;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.canvas.backgroundColor = hexColor(0xFFB6C1);
    self.helpButton.layer.cornerRadius = 8;
    self.helpButton.layer.masksToBounds = YES;
//    NSLocalizedString(MHChargerNoticeUpgrade, nil)
    self.helpButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.helpButton setTitle:@"Help" forState:UIControlStateNormal];
    [self.finishedButton setTitle:@"Complete" forState:UIControlStateNormal];
    
    [self addShadowToBtn:self.positiveBtn];
    [self addShadowToBtn:self.negativeBtn];
    [self addShadowToBtn:self.sbpBtn];
    [self addShadowToBtn:self.dbpBtn];
    self.path = [UIBezierPath bezierPath];
    
//    if (kiPhone4 || kiPhone5) {
//        self.finishedButtonConstraint.constant = 35;
//    }
}

- (void)addShadowToBtn:(UIButton *)button {
    button.layer.shadowColor = [UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:0.35].CGColor;
    button.layer.shadowOffset = CGSizeMake(0,2);
    button.layer.shadowRadius = 10;
    button.layer.shadowOpacity = 1;
}

- (void)makeSlider {
    self.sliderBg.layer.shadowOffset = CGSizeMake(1, 1);
    self.sliderBg.layer.shadowRadius = 3;
    self.sliderBg.layer.shadowColor = hexColor(0xFFB6C1).CGColor;
    self.sliderBg.layer.shadowOpacity = 1;
    
//    self.slider = [[SFDualWaySlider alloc] initWithFrame:CGRectMake(0, 0, self.sliderBg.width, 70) minValue:kMinBPValue maxValue:kMaxBPValue blockSpaceValue:kBPMinMaxSpace];
//    self.slider.centralY = self.sliderBg.height / 2;
//    self.slider.progressRadius = 5;
//
//    UIColor *lightColor = [[UIColor alloc] initWithRed:162.0/255.0 green:141.0/255.0 blue:255.0/255.0 alpha:1];
//    UIColor *darkColor = [[UIColor alloc] initWithRed:162.0/255.0 green:141.0/255.0 blue:255.0/255.0 alpha:0.2];
//    self.slider.lightColor = lightColor;
//    self.slider.darkColor = darkColor;
//    self.slider.minIndicateView.backIndicateColor = lightColor;
//    self.slider.maxIndicateView.backIndicateColor = lightColor;
//    [self.sliderBg addSubview:self.slider];
//
//    CCWeakSelf(self)
//    self.slider.sliderValueChanged = ^(CGFloat minValue, CGFloat maxValue) {
//        weakself.SBP = roundf(maxValue);
//        weakself.DBP = roundf(minValue);
//    };
//
//    self.slider.getMinTitle = ^NSString *(CGFloat minValue) {
//        return [NSString stringWithFormat:@"%.f",roundf(minValue)];
//    };
//    self.slider.getMaxTitle = ^NSString *(CGFloat maxValue) {
//        return [NSString stringWithFormat:@"%.f",roundf(maxValue)];
//    };
}

//- (void)showSlider {
//    if (nil == self.slider) {
//        [self makeSlider];
//    }
//    self.tips.hidden = NO;
//    self.sliderBg.superview.hidden = NO;
//    self.resultTips.hidden = YES;
//
//    float DBP = self.DBP;
//    float SBP = self.SBP;
//    self.slider.currentMinValue = DBP;
//    self.slider.currentMaxValue = SBP;
//    [self.slider.minIndicateView setTitle:[NSString stringWithFormat:@"%.f", DBP]];
//    [self.slider.maxIndicateView setTitle:[NSString stringWithFormat:@"%.f", SBP]];
//}

- (void)showEditor {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Edit SBP AND DBP" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = @"Please input";
//        NSLocalizedString(MHEditSBPPlaceholder, nil);
        textField.tag = 2000;
        textField.delegate  = self;
        
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        
        textField.placeholder = @"Please input";
//        NSLocalizedString(MHEditDBPPlaceholder, nil);
        textField.tag =  2001;
        textField.delegate = self;
        
    }];
    alert.textFields.firstObject.text = [NSString stringWithFormat:@"%d", self.SBP];
    alert.textFields.lastObject.text = [NSString stringWithFormat:@"%d", self.DBP];
    
    UIAlertAction *commit = [UIAlertAction actionWithTitle:@"Complete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (alert.textFields.firstObject.text.intValue < 50) {
            
//            [KEYWINDOW makeToast:NSLocalizedString(MHEditSBPPlaceholder, nil) duration:2.0 position:CSToastPositionCenter];
            
            return;
        }
        if (alert.textFields.lastObject.text.intValue < 50) {
//            [KEYWINDOW makeToast:NSLocalizedString(MHEditDBPPlaceholder, nil) duration:2.0 position:CSToastPositionCenter];
            return;
        }
        if (alert.textFields.lastObject.text.intValue > alert.textFields.firstObject.text.intValue) {
//            [KEYWINDOW makeToast:NSLocalizedString(MHEditSBPThanDBPMore, nil) duration:3.0 position:CSToastPositionCenter];
            return;
        }
        
        self.SBP = alert.textFields.firstObject.text.intValue;
        self.DBP = alert.textFields.lastObject.text.intValue;
        
        
        
    }];
    [alert addAction:commit];
    
    [self.viewController presentViewController:alert animated:YES completion:^{}];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    if ([newString rangeOfCharacterFromSet:characterSet].location != NSNotFound)
    {
        return NO;
    }else{
     return textField.tag == 2000 ? ([newString intValue] <= 300 ) : ([newString intValue] <= 140);
    }
}


- (void)showResultTips {
    self.tips.hidden = NO;
    self.sliderBg.superview.hidden = YES;
    self.resultTips.hidden = NO;
}

#pragma mark ---- startEcg
- (void)startEcg {
    if (self.timer.valid == NO) {
        self.refreshInterval = 0.02;
        self.ecgFrequency = 100;
        self.endIndex = 0;
        self.trendWidth = 3;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.refreshInterval target:self selector:@selector(refreshMap) userInfo:nil repeats:YES];
    }
}
#pragma mark ----- stopEcg
- (void)stopEcg {
    [self.timer invalidate];
    self.timer = nil;
    self.endIndex = 0;
}


#pragma mark ----- ecg --- Refresh

-(void)refreshMap{
    int point = self.ecgFrequency * self.refreshInterval;
    if (self.endIndex+point>=self.ecg.count) {
        return;
    }
    
    // When the new data exceeds the refresh rate, jump to the rendering position to the latest data
    if (self.ecg.count - self.endIndex > self.ecgFrequency) {
        self.endIndex = (int)self.ecg.count - self.ecgFrequency;
    } else {
        self.endIndex += point;
    }
    
    self.startIndex = MAX(self.endIndex - self.ecgFrequency*self.trendWidth, 0);
    
    for (int i=self.startIndex; i<self.endIndex; i++) {
        float value = [self.ecg[i] floatValue];
        if (i == self.startIndex) {
            self.maxY = value;
            self.minY = value;
            continue;
        }
        self.maxY = MAX(value, self.maxY);
        self.minY = MIN(value, self.minY);
    }
    
    self.maxY = (self.maxY-self.minY) * 0.1 + self.maxY;
    self.minY = -(self.maxY-self.minY) * 0.1 + self.minY;
    
    [self.path removeAllPoints];
    for (int i=self.startIndex; i<self.endIndex; i++) {
        if (i == self.startIndex) {
            [self.path moveToPoint:[self pointWithIndex:i]];
        } else {
            [self.path addLineToPoint:[self pointWithIndex:i]];
        }
    }
    self.pathLayer.path = self.path.CGPath;
    [self setNeedsDisplay];
}

- (CGPoint)pointWithIndex:(NSInteger)i {
    float value = [self.ecg[i] floatValue];
    CGFloat x = self.canvas.width * (i-self.startIndex) / MAX(self.ecgFrequency*self.trendWidth, 1);
    CGFloat y = self.canvas.height * ((self.maxY - value) * 1.0 / ((self.maxY - self.minY) ?: 1));
    CGPoint  point = CGPointMake(x, y);
    return point;
}

- (BOOL)ecgOngoing {
    return self.timer.valid;
}

- (CAShapeLayer *)pathLayer {
    if (!_pathLayer) {
        _pathLayer = [CAShapeLayer layer];
        _pathLayer.frame = self.canvas.bounds;
        _pathLayer.fillColor = [UIColor clearColor].CGColor;
        _pathLayer.strokeColor = hexColor(0xDC143C).CGColor;
        _pathLayer.lineWidth = 1;
        [self.canvas.layer addSublayer:_pathLayer];
    }
    return _pathLayer;
}


@end
