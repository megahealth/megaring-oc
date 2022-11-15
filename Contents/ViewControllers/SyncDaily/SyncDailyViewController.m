//
//  SyncDailyViewController.m
//  MegaRingBLE
//
//  Created by cheng cheng on 22/4/2020.
//  Copyright © 2020 Superman. All rights reserved.
//

#import "SyncDailyViewController.h"

@interface SyncDailyViewController ()
@property (nonatomic, strong) MRDevice *device;

@property (weak, nonatomic) IBOutlet UILabel *from;

@property (weak, nonatomic) IBOutlet UILabel *to;

@property (weak, nonatomic) IBOutlet UILabel *steps;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UITextView *info;

@end

@implementation SyncDailyViewController


- (instancetype)initWithDevice:(MRDevice *)device {
    if (self = [super init]) {
        self.device = device;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //此页面只是对获取日常数据的展示功能等.
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)syncClicked:(UIButton *)sender {
    if (self.device.connectState != MRDeviceStateConnected) {
        self.state.text = @"Device disconnected";
        return;
    }
    
//    @Required
    
    if (self.device.isDownloadingData == YES) {
        NSLog(@"syncing data, mission cancel");
        return;
    }
    
    @weakify(self);
    [self.device requestData:MRDataTypeDaily progress:^(float progress) {
        NSLog(@"progress:%.4f", progress);
        self.state.text = [NSString stringWithFormat:@"progress:%.4f", progress];
    } finish:^(NSData *data, MRMonitorStopType stopType, MRDeviceMonitorMode mode) {
        @strongify(self);
        self.device.isDownloadingData = NO; // @Required
    
        
        
        self.state.text = @"Sync steps finished";
        NSLog(@"data:%@", data);
        [self dealData:data];
    }];
}

- (void)dealData:(NSData *)data {
    NSArray *steps = [self parseDaily:data swVersion:nil userId:nil];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"HH:mm"];
    NSMutableString *info = [NSMutableString new];
    for (MHDailyStep *step in steps) {
        NSDate *start = [NSDate dateWithTimeIntervalSince1970:step.start];
        NSString *startStr = [fmt stringFromDate:start];
        NSDate *end = [NSDate dateWithTimeIntervalSince1970:step.end];
        NSString *endStr = [fmt stringFromDate:end];
        NSString *stepInfo = [NSString stringWithFormat:@"%@-%@ steps:%d, hr:%d, intensity:%d\n", startStr, endStr, step.steps, step.hr, step.intensity];
        [info appendString:stepInfo];
    }
    
    self.info.text = info;
}

- (NSArray *)parseDaily:(NSData *)data swVersion:(NSString *)swVersion userId:(NSString *)userId {
    Byte buffer[data.length];
    [data getBytes:buffer length:data.length];
    
    // MARK: 从版本号所在位置开始解析, 开头需要跳过的长度
    int prefixLen = 12;
    
    // MARK: 用版本号版本控制解析算法, 方便以后兼容
    int version = buffer[prefixLen+0];
    if (version != 0x01) {
        return nil;
    }
    
    /*
     * MARK: currentPoint 为当前时间所在5分钟的起点时间戳
     * 最后一个数据点属于前一个五分钟
     */
    int interval = buffer[prefixLen+1];
    int currentPoint = (int)[[NSDate date] timeIntervalSince1970] / (interval * 60) * (interval * 60);
    
    int eleCount = buffer[prefixLen+2] << 8 | buffer[prefixLen+3];
    
    
    if (eleCount <= 0 || eleCount * 5 + 4 != data.length - prefixLen) {
        return nil;
    }
    
    NSMutableArray *elements = [NSMutableArray new];
    
    for (int i=0; i<eleCount; i++) {
        int p = prefixLen + 4 + i * 5;
        int steps = buffer[p] << 8 | buffer[p+1];
        int hr = buffer[p+2];
        int intensity = buffer[p+3];
        int mode = buffer[p+4];
        int start = currentPoint - (eleCount - i) * interval * 60;
        int end = start + interval * 60;
        
        
        MHDailyStep *step = [[MHDailyStep alloc] init];
        step.start = start;
        step.end = end;
        step.intensity = intensity;
        step.hr = hr;
        step.steps = steps;
        step.mode = mode;
        
        [elements addObject:step];
    }
    
    return elements;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end




@implementation MHDailyStep

@end
