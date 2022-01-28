//
//  DeviceManagerViewController+Methods.m
//  MegaRingBLE
//
//  Created by Superman on 2018/5/22.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "DeviceManagerViewController+Methods.h"
#import <MRFramework/MRFramework.h>
#import "UIViewController+Extension.h"

static NSString *kBindTokenCacheKey = @"kBindTokenCacheKey";

@implementation DeviceManagerViewController (Methods)

- (void)connectDevice {
    if (self.device.connectState == MRDeviceStateConnected) {
        [[MRConnecter defaultConnecter] disconnectDevice:self.device];
    } else {
        NSLog(@"---self.device-------%@",self.device);
        [[MRConnecter defaultConnecter] connectDevice:self.device];
    }
}

- (void)startLiveData {
    [self.device startLiveData];
}

- (void)endLiveData {
    [self.device endLiveData];
}

- (void)changeMonitorState {
    [self.device setMonitorState:!self.device.isMonitorOn];
}
/**
 
 Requestdata: Finish: followed by   xxxdevice.isDownloadingData = NO;
 
 1.@Required
 2.@ Required
 
 */
// 收取数据并解析
- (void)requestReportData {
    
//    @Required
    if (self.device.isDownloadingData == YES) {
        NSLog(@"syncing data, mission cancel");
        return;
    }
    
    @weakify(self);
    [self.device requestData:MRDataTypeMonitor progress:^(float progress) {
        NSLog(@"progress:%.4f", progress);
    } finish:^(NSData *data, MRMonitorStopType stopType, MRDeviceMonitorMode mode) {
        @strongify(self);
//        @Required
        self.device.isDownloadingData = NO;
        
//        if (data != nil) {
//            [self deatalData:data];
//            [self  requestReportData];
//        }
        
        NSLog(@"daily data length:%lu, stopType:%d, mode:%d", (unsigned long)data.length, stopType, mode);
        
        if (data) {
            [MRApi parseMonitorData:data completion:^(MRReport *report, NSError *error) {
                NSLog(@"user:%@, report type:%d", report.userId, report.reportType);
                NSLog(@"start:%d, duration:%d", report.startTime, report.duration);
                NSLog(@"sp avg:%.f, min:%.f", report.avgSp, report.minSp);
                NSLog(@"pr max:%d, min:%d, avg:%d", report.maxPr, report.minPr, report.avgPr);
                NSLog(@"sp len:%lu, pr len:%lu", (unsigned long)report.spArr.count, (unsigned long)report.prArr.count);
            }];
        }
    }];
}

/**
 
 Requestdata: Finish: followed by   xxxdevice.isDownloadingData = NO;
 
 1.@Required
 2.@ Required
 
 */
- (void)requestDailyData {
    
//    judge  @Required
    if (self.device.isDownloadingData == YES) {
        NSLog(@"syncing data, mission cancel");
        return;

    }
    @weakify(self);
    [self.device requestData:MRDataTypeDaily progress:^(float progress) {
        NSLog(@"progress:%.4f", progress);
    } finish:^(NSData *data, MRMonitorStopType stopType, MRDeviceMonitorMode mode) {
        @strongify(self);
        // @ Required
        self.device.isDownloadingData = NO;
        
    
        NSLog(@"daily data length:%lu, stopType:%d, mode:%d", (unsigned long)data.length, stopType, mode);
        
        if (data) {
            NSArray *dailyReports = [MRApi parseDaily:data];
            NSLog(@"%@", dailyReports);
        }
    }];
}

- (void)changeUserAlert {
    NSString	*message = [NSString stringWithFormat:@"设备%@已有绑定用户,是否要继续更改用户?", self.device.mac];
    UIAlertController	*alert = [UIAlertController alertControllerWithTitle:@"更改用户" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction	*cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.device confirmChangingUser:NO];
    }];
    UIAlertAction    *confirmAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.device confirmChangingUser:YES];
    }];

    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:^{}];
}

- (void)saveBindToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kBindTokenCacheKey];
}

- (NSString *)cachedBindToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kBindTokenCacheKey];
}

- (void)showAlertWithTitle:(NSString *)title dissmissAfterDelay:(NSTimeInterval)delay {
    UIAlertController	*alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction	*confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(MRConfirmOption, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissAlert:alert];
    }];
    [alert addAction:confirmAction];
    
    [self presentViewController:alert animated:YES completion:^{}];
    [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:delay];
}

- (void)dismissAlert:(UIAlertController *)alert {
    [alert dismissViewControllerAnimated:YES completion:^{}];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    UIViewController    *vc = [UIViewController currentViewController];
    if ([vc isKindOfClass:[UIAlertController class]]) {
        [vc dismissViewControllerAnimated:NO completion:^{}];
    }
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}








@end
