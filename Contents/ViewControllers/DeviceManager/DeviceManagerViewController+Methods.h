//
//  DeviceManagerViewController+Methods.h
//  MegaRingBLE
//
//  Created by Superman on 2018/5/22.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "DeviceManagerViewController.h"
#import <MRFramework/MRFramework.h>
@interface DeviceManagerViewController (Methods)

- (void)connectDevice;

- (void)startLiveData;

- (void)endLiveData;

- (void)changeMonitorState;

- (void)requestReportData;

- (void)requestDailyData;

- (void)changeUserAlert;

- (void)saveBindToken:(NSString *)token;

- (NSString *)cachedBindToken;

- (void)showAlertWithTitle:(NSString *)title dissmissAfterDelay:(NSTimeInterval)delay;


//Test method. test daily sleep and hrv data. 1
- (void)requestDailySleepHRVSportDataTest;

//only get hrv data . 2.
-(void)requestReportDataTestType:(MRDataType)type;


@end



/****      More information，as follows.
 
 
 Zh: SDK 获取指环数据过程：方法简单注解 （何时收取的逻辑请查看demo）
 En: SDK process for obtaining ring data: simple annotation of the method (Please check the demo for the logic of when to charge)

 
 - (void)requestDailySleepHRVSportDataTest {
     
     if (self.device.isDownloadingData == YES) { //@required 写上
        NSLog(@"syncing data, mission cancel");
         return;
     }
 //zh: 1. 先获取指环的日常数据 – MRDataTypeDaily
 //En: 1. First get the daily data of the ring – MRDataTypeDaily
     [self.device requestData:MRDataTypeDaily progress:^(float progress) {
         NSLog(@"----get---progress:%.4f", progress);
     } finish:^(NSData *data, MRMonitorStopType stopType, MRDeviceMonitorMode mode) {
         self.device.isDownloadingData = NO; // 写上 （@required write）
         NSLog(@"Dailydata:%@", data);
      
        if (data) {
             NSArray *dailyReports = [MRApi parseDaily:data];
             NSLog(@"dailyReports----%@", dailyReports);
 //zh：  1. 处理数据… 你可以保存daily data 到本地        en： 1.  deal data ... you can save daily data.
            //zh: 2. 继续获取日常数据直到收取完    en：2. Continue to obtain daily data until the collection is completed
            [self requestDailySleepHRVSportDataTest];
        }else{
 // zh：说明： 指环中没有了日常数据，开始获取指环中产生的睡眠数据。 En：Note: there is no daily data in the ring. Start to obtain the sleep data generated in the ring.
            //zh：1 . 更新daily data： 你可以把daily data 上传到服务器,进行保持
     //en：1. Update daily data: you can upload daily data to the server and keep it
            ——————上传服务器------日常数据 ---
           //  2.  Whether the ring has other data.
            NSLog(@"self.shouldSyncData---------%d",self.shouldSyncData);

            if (self.shouldSyncData) {
                [self requestReportDataTestType:MRDataTypeMonitor]; // zh：3.（类型：MRDataTypeMonitor） 获取指环中的睡眠运动数据...  en： 3. (type: MRDataTypeMonitor)  get sleep movement data in the ring
            }
        }
     }];
     
 }

 -(void)requestReportDataTestType:(MRDataType)type {
     
     if (self.device.isDownloadingData == YES) { // @required
         NSLog(@"syncing data, mission cancel");
         return;
     }
     
     [self.device requestData:type progress:^(float progress) {
         NSLog(@"progress:%.4f", progress);
         
         self.titleNavView.text = [NSString stringWithFormat:@"%@: %.4f",NSLocalizedString(MRGetDataProgress, nil),progress];
         if (progress >=1) {
             self.titleNavView.text = NSLocalizedString(MRGetDataFinished, nil);
         }
     } finish:^(NSData *data, MRMonitorStopType stopType, MRDeviceMonitorMode mode) {
         self.device.isDownloadingData = NO; //@required
         self.shouldSyncData = NO;
         //1. * deal data . //zh： ***** 你可以把睡眠等数据保存到本地.  En：***** Save the data locally
         NSLog(@"data:%@----------mode----------%d", data,mode);
         if (data) {
 ——————zh:上传服务器------睡眠等数据(en: Upload data such as sleep to the server)-----
 // 2.zh： 如下： * 解析数据，上传到服务端； en：As follows: * analyze the data and upload it to the server;
             
 //          zh:  解析数据展示UI. 需要网络验证 .. 上传到服务器。En: Parse data display UI Network authentication is required.. upload to the server.
             [MRApi parseMonitorData:data completion:^(MRReport *report, NSError *error) {
                 
                     NSLog(@"report.reportType=======%d",report.reportType);
                     NSLog(@"user:%@, report type:%d", report.userId, report.reportType);
                     NSLog(@"start:%d, duration:%d", report.startTime, report.duration);
                     NSLog(@"sp avg:%.f, min:%.f", report.avgSp, report.minSp);
                     NSLog(@"pr max:%d, min:%d, avg:%d", report.maxPr, report.minPr, report.avgPr);
                     NSLog(@"sp len:%lu, pr len:%lu", (unsigned long)report.spArr.count, (unsigned long)report.prArr.count);

                  // zh: 4. 展示UI等, 异步将data 上传到服务器  en: 4. Display UI, etc., asynchronously upload data to the server

       //                    NSLog(@"report.SDNN--------%f--------report.rrArr---------%@",report.SDNN,report.rrArr);
 ////                 test ...  save hrv data ...
 //                    [[NSUserDefaults standardUserDefaults]setValue:[report mj_keyValues] forKey:@"testHRVData"];
 //                    [[NSUserDefaults standardUserDefaults]synchronize];
 //
 //                }
                 
             }];
         }
         
         if (type != MHBLEDataRequestTypeHRV) {  //3. Zh:（类型： MHBLEDataRequestTypeHRV ）,获取指环中的HRV数据。 En：(type: MHBLEDataRequestTypeHRV )Get HRV data in the ring。
             [self requestReportDataTestType: MHBLEDataRequestTypeHRV];
         }
     }];
 }



 二：
 zh: 如果解析数据失败，或上传服务器失败；  连网取出本地数据，重新解析数据 [MRApi parseMonitorData… ] 。（上传服务器等操作 ）.

 En：If the data parsing fails or the uploading server fails; Connect the network to take out the local data and re analyze the data ‘[MRApi parseMonitorData… ]’ (Upload server and other operations)


 */
