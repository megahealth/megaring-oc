//
//  DeviceManagerViewController+Methods.m
//  MegaRingBLE
//
//  Created by Superman on 2018/5/22.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "DeviceManagerViewController+Methods.h"
#import "UIViewController+Extension.h"
#import "DeviceUpgradeViewController.h"
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
// 收取数据并解析 -- MRDataTypeMonitor -- data. 
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


#pragma mark test    method --- 在 'DeviceManagerViewController+Methods.h' 中有更多的注释.(en: There are more comments in 'DeviceManagerViewController+Methods.h')
/***
 *
 *
   1.请带上指环后，手与指环保持不动至少30 分钟来测试hrv 的data。
     After wearing the ring, keep your hand still with the ring for at least 30 minutes to test the data of HRV.
 
   2.指环的hrv数据不好测量，最好带回家测第二天获取指环的数据.
     The HRV data of the ring is not easy to measure. You'd better take it home and get the ring data the next day.
  
   3.当开启睡眠模式 --- > 至少82s产生日常血氧数据 ---- > 至少30分钟产生睡眠数据 ----->      30 分钟产生HRV数据（在手指与指环一直保持不动的情况下）
     When the sleep mode is turned on -- > generate daily blood oxygen data for at least 82S -- > generate sleep data for at least 30 minutes -- > generate HRV data for 30 minutes (when the fingers and rings remain stationary)
 *
 */


/**
 
 requestdata: Finish: followed by   xxxdevice.isDownloadingData = NO;
 
 1.@Required
 2.@Required
 
 */
- (void)requestDailySleepHRVSportDataTest {
    
    //   1. @Required     (在项目中把xxxdevice.isDownloadingData 的值赋上 如下.)
    
    if (self.device.isDownloadingData == YES) {// 1. @ Required
       NSLog(@"syncing data, mission cancel");
        return;
    }
    
    [self.device requestData:MRDataTypeDaily progress:^(float progress) {
        NSLog(@"----get---progress:%.4f", progress);
    } finish:^(NSData *data, MRMonitorStopType stopType, MRDeviceMonitorMode mode) {
        self.device.isDownloadingData = NO; //  2.  @Required
        NSLog(@"Dailydata:%@", data);
        
       if (data) {
            NSArray *dailyReports = [MRApi parseDaily:data];  // 
            NSLog(@"dailyReports----%@", dailyReports);
           
           [self saveDailyData:dailyReports];
           
//            1.  deal data ... save daily data.  可以保存daily data 到本地。
           
           //2. Method....
           [self requestDailySleepHRVSportDataTest];
       }else{
           //1 . updata daily data/  可以把daily data 上传到服务器..
           
          //  2.  Whether the ring has other data.
           
           NSLog(@"self.shouldSyncData---------%d",self.shouldSyncData);
           
           if (self.shouldSyncData) {
               
               [self requestReportDataTestType:MRDataTypeMonitor]; // 获取指环中的睡眠运动数据....
           }
       }
    }];
    
}
-(void)saveDailyData:(NSArray<MRDailyReport *> *) dailyArray {
    
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:2];
    [newArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:Temporary_Daily_DATA_KEY]];
    
    for (MRDailyReport * dailyReport in dailyArray) {
        
        NSDictionary * dict =  [dailyReport mj_keyValues];
//        NSLog(@"---dailyReport--------------%@",[dailyReport mj_keyValues]);
        
        if ([newArray containsObject:dict] == NO) {
            [newArray addObject:dict];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:newArray.copy forKey:Temporary_Daily_DATA_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
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
 *
 *
 */

#pragma mark test method
/**
 
 requestdata: Finish: followed by   xxxdevice.isDownloadingData = NO;
 
 1.@Required
 2.@Required
 
 */
-(void)requestReportDataTestType:(MRDataType)type {
    
    if (self.device.isDownloadingData == YES) {//1. @ Required
        NSLog(@"syncing data, mission cancel");
        return;
    }
    
    [self.device requestData:type progress:^(float progress) {
        NSLog(@"progress:%.4f", progress);
        
        self.titleNavView.text = [NSString stringWithFormat:@"%@ %.4f",NSLocalizedString(MRGetDataProgress, nil),progress];
        
        if (progress >=1) {
            self.titleNavView.text = NSLocalizedString(MRGetDataFinished, nil);
        }
        
    } finish:^(NSData *data, MRMonitorStopType stopType, MRDeviceMonitorMode mode) {
        self.device.isDownloadingData = NO;//2.  @ Required
        self.shouldSyncData = NO;
        
        // you can deal data .
        
        NSLog(@"data:%@----------mode----------%d", data,mode);
        
        if (data) {
            
//         you can parse data display UI Need network to verify。
            
            NSMutableArray * arrayMM = [NSMutableArray arrayWithCapacity:2];

            [arrayMM addObject:data];
            
            [[NSUserDefaults standardUserDefaults]setValue:arrayMM.copy forKey:@"Ring_Data"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            
            [MRApi parseMonitorData:data completion:^(MRReport *report, NSError *error) {
                
                NSLog(@"report------------%@--------error---------%@",report,error);
                
                // 解析完数据后查看报告.
              NSArray * array =  [[NSUserDefaults standardUserDefaults]objectForKey:Temporary_Daily_DATA_KEY];
                
                NSLog(@"ARRAY-TEMP----------------%@",array);
                
                if (array.count > 0) {
                    report.tempArr = array;
                    
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:Temporary_Daily_DATA_KEY];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
                
                NSLog(@"report.reportType=======%d",report.reportType);
                NSLog(@"user:%@, report type:%d", report.userId, report.reportType);
                NSLog(@"start:%d, duration:%d", report.startTime, report.duration);
                    NSLog(@"sp avg:%.f, min:%.f", report.avgSp, report.minSp);
                    NSLog(@"pr max:%d, min:%d, avg:%d", report.maxPr, report.minPr, report.avgPr);
                    NSLog(@"sp len:%lu, pr len:%lu", (unsigned long)report.spArr.count, (unsigned long)report.prArr.count);
                
                //  ******** test ****  save report data.
                
              /*en: [The simplest storage NSUserDefaults is used in this demo for demonstration. You can use SQLITE, CoreData... ------  To view report details, after data collection -- click the last line].
               
               zh: [本demo中使用 NSUserDefaults 简单的存储以便演示，您可以使用SQLITE ,CoreData... , 要查看报告详情收取完数据后 -- 查看点击最后一行.]
               
               */
                
                
                
                if (report.reportType == MRDeviceMonitorModeHRV) { // Data of HRV .

                    NSLog(@"report.SDNN--------%f--------report.rrArr---------%@",report.SDNN,report.rrArr);
//                 test ...  save hrv report data ...
                    [[NSUserDefaults standardUserDefaults]setValue:[report mj_keyValues] forKey:TEST_SAVE_HRV_DATA_KEY];
                    [[NSUserDefaults standardUserDefaults]synchronize];

                }else if (report.reportType == MRDeviceMonitorModeSleep){
                    //Data of  Sleep.

                    [self.view makeToast:@"Sleep report save success" duration:2 position:CSToastPositionCenter];

                    [[NSUserDefaults standardUserDefaults]setValue:[report mj_keyValues] forKey:TEST_SAVE_SLEEP_DATA_KEY];
                    [[NSUserDefaults standardUserDefaults]synchronize];

                }else if (report.reportType == MRDeviceMonitorModeSport){

                    [self.view makeToast:@"Sport report save success" duration:2 position:CSToastPositionCenter];

                    [[NSUserDefaults standardUserDefaults]setValue:[report mj_keyValues] forKey:TEST_SAVE_SPORT_DATA_KEY];
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
    NSString	*message = [NSString stringWithFormat:@"The device%@ has bound users. Do you want to continue changing users?", self.device.mac];
    UIAlertController	*alert = [UIAlertController alertControllerWithTitle:@"Change user" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction	*cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.device confirmChangingUser:NO];
    }];
    UIAlertAction    *confirmAction = [UIAlertAction actionWithTitle:@"continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.device confirmChangingUser:YES];
    }];

    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:^{}];
}

- (void)saveBindToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kBindTokenCacheKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    [alert dismissViewControllerAnimated:YES completion:^{

    }];
}
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    UIViewController    *vc = [UIViewController currentViewController];
    if ([vc isKindOfClass:[UIAlertController class]]) {
        [vc dismissViewControllerAnimated:NO completion:^{}];
    }
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}


@end
