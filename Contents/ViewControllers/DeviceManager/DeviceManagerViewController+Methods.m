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
#import "MJExtension.h"

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
        
        self.title = [NSString stringWithFormat:@"data: %@",data];
        
//        if (data != nil) {
//            [self deatalData:data];
//            [self  requestReportData];
//        }
        
//        NSLog(@"data-----------: %@",data);
        
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


#pragma mark test    method。
/***
 *
 *
   1.请带上指环后，手与指环保持不动至少30 分钟来测试hrv 的data。
     After wearing the ring, keep your hand still with the ring for at least 30 minutes to test the data of HRV.
 
   2.指环的hrv数据不好测量，最好带回家测第二天获取指环的数据.
     The HRV data of the ring is not easy to measure. You'd better take it home and get the ring data the next day.
  
   3.当开启睡眠模式 --- > 至少82s产生日常血氧数据 ---- > 至少30分钟产生睡眠数据 ----->      28分钟产生hrv数据（在手指与指环一直保持不动的情况下）
     When the sleep mode is turned on -- > generate daily blood oxygen data for at least 82S -- > generate sleep data for at least 30 minutes -- > generate HRV data for 28 minutes (when the fingers and rings remain stationary)
 *
 */
- (void)requestDailySleepHRVSportDataTest {
    
    if (self.device.isDownloadingData == YES) {
       NSLog(@"syncing data, mission cancel");
        return;
    }
    
    [self.device requestData:MRDataTypeDaily progress:^(float progress) {
        NSLog(@"----get---progress:%.4f", progress);
    } finish:^(NSData *data, MRMonitorStopType stopType, MRDeviceMonitorMode mode) {
        self.device.isDownloadingData = NO;
        NSLog(@"Dailydata:%@", data);
       if (data) {
            NSArray *dailyReports = [MRApi parseDaily:data];
            NSLog(@"dailyReports----%@", dailyReports);
//            1.  deal data ... save daily data.
           
           //2. Method....
           [self requestDailySleepHRVSportDataTest];
       }else{
           //1 . updata daily data/
          //  2.  Whether the ring has other data.
           if (self.shouldSyncData) {
               [self requestReportDataTestType:MRDataTypeMonitor];
           }
       }
    }];
    
}


#pragma mark test  hrv  method。
/***
 *
 *
   1.请带上指环后，手与指环保持不动至少30 分钟来测试hrv 的data。
     After wearing the ring, keep your hand still with the ring for at least 30 minutes to test the data of HRV. (!!! Rings and fingers are immovable)
 
   2.指环的hrv数据不好测量，最好带回家测第二天获取指环的数据.
     The HRV data of the ring is not easy to measure. You'd better take it home and get the ring data the next day.
  
   3.当开启睡眠模式 --- > 至少82s产生日常血氧数据 ---- > 至少30分钟产生睡眠数据 ----->      至少30分钟产生hrv数据（在手指与指环一直保持不动的情况下）
     When the sleep mode is turned on -- > generate daily blood oxygen data for at least 82S -- > generate sleep data for at least 30 minutes -- > generate HRV data for 30 minutes (when the fingers and rings remain stationary)
 *
 */
#pragma mark test method
-(void)requestReportDataTestType:(MRDataType)type {
    
    if (self.device.isDownloadingData == YES) {
        NSLog(@"syncing data, mission cancel");
        return;
    }
    
    [self.device requestData:type progress:^(float progress) {
        NSLog(@"progress:%.4f", progress);
    } finish:^(NSData *data, MRMonitorStopType stopType, MRDeviceMonitorMode mode) {
        self.device.isDownloadingData = NO;
        self.shouldSyncData = NO;
        
        //deal data .
        NSLog(@"data:%@----------mode----------%d", data,mode);
        
        if (data) {
            [MRApi parseMonitorData:data completion:^(MRReport *report, NSError *error) {
                
                    NSLog(@"report.reportType=======%d",report.reportType);
                    NSLog(@"user:%@, report type:%d", report.userId, report.reportType);
                    NSLog(@"start:%d, duration:%d", report.startTime, report.duration);
                    NSLog(@"sp avg:%.f, min:%.f", report.avgSp, report.minSp);
                    NSLog(@"pr max:%d, min:%d, avg:%d", report.maxPr, report.minPr, report.avgPr);
                    NSLog(@"sp len:%lu, pr len:%lu", (unsigned long)report.spArr.count, (unsigned long)report.prArr.count);
                    
                    NSLog(@"SDNN===========%f",report.SDNN);
                
                if (report.reportType == 10) {
                    QMRLog(@"hrvData----------------%@",[report mj_keyValues]);
                    [[NSUserDefaults standardUserDefaults]setValue:[report mj_keyValues] forKey:@"testHRVData"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                }
                
                
            }];
        }
        
        if (type != MHBLEDataRequestTypeHRV) {
            [self requestReportDataTestType: MHBLEDataRequestTypeHRV];
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

// 收取数据并解析
- (void)requestReportData:(MRDataType)type {
    
//    @Required
    if (self.device.isDownloadingData == YES) {
        NSLog(@"syncing data, mission cancel");
        return;
    }
    
    @weakify(self);
    [self.device requestData:type progress:^(float progress) {
        NSLog(@"progress:%.4f", progress);
    } finish:^(NSData *data, MRMonitorStopType stopType, MRDeviceMonitorMode mode) {
        @strongify(self);
//        @Required
        self.device.isDownloadingData = NO;
        
//        if (data != nil) {
//            [self deatalData:data];
//            [self  requestReportData];
//        }
        
    //   if (type != MHBLEDataRequestTypeHRV) {
      //     [self requestReportData:MHBLEDataRequestTypeHRV];
     // }
//
        
        
//        NSLog(@"data: %@",data);
        
        self.title = [NSString stringWithFormat:@"data: %@",data];
        
        
        
        
        NSLog(@"daily data length:%lu, stopType:%d, mode:%d", (unsigned long)data.length, stopType, mode);
//
        if (data) {
            [MRApi parseMonitorData:data completion:^(MRReport *report, NSError *error) {
                NSLog(@"user:%@, report type:%d", report.userId, report.reportType);
                NSLog(@"start:%d, duration:%d", report.startTime, report.duration);
                NSLog(@"sp avg:%.f, min:%.f", report.avgSp, report.minSp);
                NSLog(@"pr max:%d, min:%d, avg:%d", report.maxPr, report.minPr, report.avgPr);
                NSLog(@"sp len:%lu, pr len:%lu", (unsigned long)report.spArr.count, (unsigned long)report.prArr.count);
                
                
                NSLog(@"SDNN-------------%f",report.SDNN);
                
            }];
        }
    }];
}






@end
