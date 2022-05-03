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

// get hrv data . 2.
-(void)requestReportDataTestType:(MRDataType)type;


@end
