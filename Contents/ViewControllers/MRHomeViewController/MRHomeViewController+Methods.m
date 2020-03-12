//
//  MRHomeViewController+Methods.m
//  MegaRingBLE
//
//  Created by Superman on 2018/5/4.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "MRHomeViewController+Methods.h"
#import <MRFramework/MRFramework.h>

@implementation MRHomeViewController (Methods)

- (void)setUp {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightItemView];
}


- (void)testParseData {
    NSString *dataName = @"/Users/chengcheng/Documents/work/MegaRingSDK/mega-MRFramework-ios/MegaRingBLE/Contents/Resource/ReportData/sleep/test2";
//    NSString *dataPath = [[NSBundle mainBundle] pathForResource:dataName ofType:@"bin"];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:dataName];
    [MRApi parseMonitorData:data mode:MRDeviceMonitorModeSleep completion:^(MRReport *report, NSError *error) {
        if (error) {
            NSLog(@"error:%@", error);
        } else {
            NSLog(@"new style");
            NSLog(@"start:%d", report.startTime);
            NSLog(@"duration:%d", report.duration);
            NSLog(@"avg:%f, min:%f", report.avgSp, report.minSp);
            NSLog(@"max:%d, min:%d, avg:%d", report.maxPr, report.minPr, report.avgPr);
            NSLog(@"%f, %d", report.odIndex, report.odCount);
//            NSLog(@"sp:%@\npr:%@", report.spArr, report.prArr);
        }
    }];
}



@end
