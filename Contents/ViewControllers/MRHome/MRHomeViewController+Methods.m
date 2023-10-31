//
//  MRHomeViewController+Methods.m
//  MegaRingBLE
//
//  Created by Superman on 2018/5/4.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "MRHomeViewController+Methods.h"
#import "SyncDailyViewController.h"

@implementation MRHomeViewController (Methods)

- (void)setUp {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightItemView];
}


- (void)testParseData {
    NSString *dataName = @"mock_spo2.bin";
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:dataName ofType:nil];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:dataPath];
    [MRApi parseMonitorData:data completion:^(MRReport *report, NSError *error) {
        NSLog(@"user:%@, report type:%d", report.userId, report.reportType);
        NSLog(@"start:%d, duration:%d", report.startTime, report.duration);
        NSLog(@"sp avg:%.f, min:%.f", report.avgSp, report.minSp);
        NSLog(@"pr max:%d, min:%d, avg:%d", report.maxPr, report.minPr, report.avgPr);
        NSLog(@"sp len:%lu, pr len:%lu", (unsigned long)report.spArr.count, (unsigned long)report.prArr.count);
        
        QMRLog(@"%@------report---------%@", [NSThread currentThread],[report mj_keyValues]);
    }];
}

- (void)testParseDaily {
    NSString *dataFile = @"data";
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:dataFile ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    
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
    NSLog(@"%@", info);
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



@end
