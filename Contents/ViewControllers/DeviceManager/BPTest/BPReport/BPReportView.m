

#import "BPReportView.h"
#import "BPReportViewModel.h"

#import "UIViewExt.h"

static int ecgBgColor = 0xFFB6C1;
static int gridColor = 0xFF69B4;
static int ecgColor = 0xDC143C;

@interface BPReportView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;


@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) CAShapeLayer *pathLayer;

@property (nonatomic, strong) UIBezierPath *gridPath;
@property (nonatomic, strong) CAShapeLayer *gridPathLayer; 

@property (nonatomic, strong) UIBezierPath *gridBoldPath;
@property (nonatomic, strong) CAShapeLayer *gridBoldPathLayer;
@property (weak, nonatomic) IBOutlet UIButton *ecgButton;
@property (weak, nonatomic) IBOutlet UIButton *bloodButton;

@property (nonatomic, assign) float maxY; // Data highest point value
@property (nonatomic, assign) float minY; // Data lowest point value

@property (nonatomic, assign) int start;
@property (nonatomic, assign) int end;

@end

@implementation BPReportView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.path = [UIBezierPath bezierPath];
    self.gridPath = [UIBezierPath bezierPath];
    self.gridBoldPath = [UIBezierPath bezierPath];
    self.ecgBg.backgroundColor = hexColor(ecgBgColor);
    [self.bloodButton  setTitle:@"" forState:UIControlStateNormal];
    [self.ecgButton setTitle:@"" forState:UIControlStateNormal];

}
- (IBAction)helpButtonClick:(UIButton *)sender {
    
//    [HDReportsInfoCardView showCardOnView:APPDELEGATE.window type:sender.tag];
}

- (BPReportViewModel *)model {
    if (_model == nil) {
        _model = [[BPReportViewModel alloc] init];
    }
    return _model;
}

- (void)updateData {
    self.date.text = self.model.date;
    self.pr.text = self.model.pr;
    self.sbp.text = self.model.sbp;
    self.dbp.text = self.model.dbp;
}
#pragma mark -- Draw Grid and  ECG
- (void)updateEcg {
    [self drawGrid];
    [self refreshEcg];
}

- (void)drawGrid {
    [self.gridPath removeAllPoints];
    [self.gridBoldPath removeAllPoints];
    
    int width = 100;
    
    for (int i=1; i<width; i++) {
        CGPoint top = CGPointMake(self.ecgBg.width*i/width, 0);
        CGPoint bottom = CGPointMake(self.ecgBg.width*i/width, self.ecgBg.height);
        
        if (i % 5 == 0) {
            [self.gridBoldPath moveToPoint:top];
            [self.gridBoldPath addLineToPoint:bottom];
        } else {
            [self.gridPath moveToPoint:top];
            [self.gridPath addLineToPoint:bottom];
        }
    }
    
    int height = 40;
    for (int i=1; i<height; i++) {
        CGPoint left = CGPointMake(0, self.ecgBg.height*i/height);
        CGPoint right = CGPointMake(self.ecgBg.width, self.ecgBg.height*i/height);
        
        if (i % 5 == 0) {
            [self.gridBoldPath moveToPoint:left];
            [self.gridBoldPath addLineToPoint:right];
        } else {
            [self.gridPath moveToPoint:left];
            [self.gridPath addLineToPoint:right];
        }
    }
    
    self.gridPathLayer.path = self.gridPath.CGPath;
    self.gridBoldPathLayer.path = self.gridBoldPath.CGPath;
    [self setNeedsDisplay];
}


-(void)refreshEcg{
    if (self.model.ecg.count < 200) {
        return;
    }
    self.end = (int)self.model.ecg.count - 1;
    self.start = self.end - 400;
    if (self.start < 0) {
        self.start = 0;
    }
    
    for (int i=self.start; i<self.end; i++) {
        float value = [self.model.ecg[i] floatValue];
        if (i == self.start) {
            self.maxY = value;
            self.minY = value;
            continue;
        }
        self.maxY = MAX(value, self.maxY);
        self.minY = MIN(value, self.minY);
    }
    
    float maxY = (self.maxY-self.minY) + self.maxY;
    float minY = -(self.maxY-self.minY) + self.minY;
    self.maxY = maxY;
    self.minY = minY;
    
    [self.path removeAllPoints];
    for (int i=self.start; i<self.end; i++) {
        if (i == self.start) {
            [self.path moveToPoint:[self pointWithIndex:i]];
        } else {
            [self.path addLineToPoint:[self pointWithIndex:i]];
        }
    }
    self.pathLayer.path = self.path.CGPath;
    [self setNeedsDisplay];
}

- (CGPoint)pointWithIndex:(NSInteger)i {
    float value = [self.model.ecg[i] floatValue];
    CGFloat x = self.ecg.width * (i-self.start) / MAX(self.end - self.start, 1);
    CGFloat y = self.ecg.height * ((self.maxY - value) * 1.0 / ((self.maxY - self.minY) ?: 1));
    CGPoint  point = CGPointMake(x, y);
    return point;
}

- (CAShapeLayer *)pathLayer {
    if (!_pathLayer) {
        _pathLayer = [CAShapeLayer layer];
        _pathLayer.frame = self.ecg.bounds;
        _pathLayer.fillColor = [UIColor clearColor].CGColor;
        _pathLayer.strokeColor = hexColor(ecgColor).CGColor;
        _pathLayer.lineWidth = 1;
        [self.ecg.layer addSublayer:_pathLayer];
    }
    return _pathLayer;
}

- (CAShapeLayer *)gridPathLayer {
    if (!_gridPathLayer) {
        _gridPathLayer = [CAShapeLayer layer];
        _gridPathLayer.frame = self.ecg.bounds;
        _gridPathLayer.fillColor = [UIColor clearColor].CGColor;
        _gridPathLayer.strokeColor = hexColor(gridColor).CGColor;
        _gridPathLayer.lineWidth = 1;
        [self.ecgBg.layer addSublayer:_gridPathLayer];
    }
    return _gridPathLayer;
}

- (CAShapeLayer *)gridBoldPathLayer {
    if (!_gridBoldPathLayer) {
        _gridBoldPathLayer = [CAShapeLayer layer];
        _gridBoldPathLayer.frame =   self.ecg.bounds;
        _gridBoldPathLayer.fillColor = [UIColor clearColor].CGColor;
        _gridBoldPathLayer.strokeColor = hexColor(gridColor).CGColor;
        _gridBoldPathLayer.lineWidth = 2;
        [self.ecgBg.layer addSublayer:_gridBoldPathLayer];
    }
    return _gridBoldPathLayer;
}
@end
