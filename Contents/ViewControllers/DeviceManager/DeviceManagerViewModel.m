//
//  DeviceManagerViewModel.m
//  MegaRingBLE
//
//  Created by Superman on 2018/5/21.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "DeviceManagerViewModel.h"
#import <UIKit/UIKit.h>

@implementation DeviceManagerViewModel

- (void)reloadModel {
    if (self.device.connectState == MRDeviceStateConnected) {
        [self updateSN];
        [self updateVersion];
        [self updateConnectState];
        if (self.device.isReady) {
            [self updateBattery];
            [self updateMonitorState];
        }
    } else {
        [self reset];
    }
}

- (void)updateSN {
    DeviceManagerViewCellModel	*cellModel = self.modelArr[0][1];
    cellModel.detail = self.device.sn ?: @"";
}

- (void)updateVersion {
    DeviceManagerViewCellModel	*cellModel = self.modelArr[0][2];
    cellModel.detail = self.device.swVersion ?: @"";
}

- (void)updateConnectState {
    static NSArray	*stateDescriptions;
    if (nil == stateDescriptions) {
        stateDescriptions = @[NSLocalizedString(MRDisconnected, nil), NSLocalizedString(MRConnecting, nil), NSLocalizedString(MRConnected, nil), NSLocalizedString(MRDisconnecting, nil)];
    }
    DeviceManagerViewCellModel	*cellModel1 = self.modelArr[1][0];
    cellModel1.detail = stateDescriptions[self.device.connectState];
    
    DeviceManagerViewCellModel	*cellModel2 = self.modelArr[2][0];
    cellModel2.title = self.device.connectState == MRDeviceStateConnected ? NSLocalizedString(MRDisconnectDevice, nil) : NSLocalizedString(MRConnectDevice, nil);
}

- (void)updateBattery {
    DeviceManagerViewCellModel	*cellModel = self.modelArr[1][1];
    cellModel.detail = [NSString stringWithFormat:@"%@ %d%%", [self batStateDescriptionArr][self.device.batState], self.device.batValue];
}

- (void)updateLiveDataValue:(NSArray *)liveData {
    DeviceManagerViewCellModel	*cellModel = self.modelArr[1][3];
    if (liveData.count >= 4) {
        NSString    *liveDataStr = [NSString stringWithFormat:@"%@ %@ %@ %@", liveData[0], liveData[1], liveData[2], liveData[3]];
        cellModel.detail = liveDataStr;
        cellModel.isFresh = YES;
    }
}

- (void)updateMonitorState {
    DeviceManagerViewCellModel	*cellModel1 = self.modelArr[1][2];
    MRDeviceMonitorMode mode = self.device.monitorMode;
    NSArray *stateStrArr = @[NSLocalizedString(MRMonitorOff, nil), NSLocalizedString(MRMonitorSleep, nil), NSLocalizedString(MRMonitorSport, nil), NSLocalizedString(MRMonitorOff, nil), NSLocalizedString(MRMonitorRealtime, nil), NSLocalizedString(MRMonitorBloodPressure, nil), NSLocalizedString(MRMonitorPulse, nil)];
    if (mode < stateStrArr.count && mode >= 0) {
        cellModel1.detail = stateStrArr[mode];
    }
    
//    DeviceManagerViewCellModel	*cellModel2 = self.modelArr[2][3];
//    cellModel2.title = self.device.isMonitorOn ? @"停止监测" : @"开始监测";
}

//- (void)updateRawdata:(NSString *)data {
//    DeviceManagerViewCellModel    *cellModel = self.modelArr[1][4];
//    cellModel.detail = [NSString stringWithFormat:@"%@", data];
//    cellModel.isFresh = YES;
//}


- (void)reset {
    for (NSInteger i=0; i<self.modelArr.count; i++) {
        NSArray    *subModelArr = self.modelArr[i];
        for (NSInteger j=0; j<subModelArr.count; j++) {
            DeviceManagerViewCellModel    *cellModel = subModelArr[j];
            cellModel.title = [self defaultCellModelTitleArr][i][j];
            cellModel.detail = [self defaultCellModelDetailArr][i][j];
        }
    }
}


#pragma mark -
#pragma mark Basic Settings

- (instancetype)initWithDevice:(MRDevice *)device {
    if (self = [super init]) {
        self.device = device;
        [self reloadModel];
    }
    return self;
}

- (NSMutableArray *)modelArr {
    if (!_modelArr) {
        _modelArr = [NSMutableArray new];
        
        for (NSInteger i=0; i<[self defaultCellModelTitleArr].count; i++) {
            NSArray	*subTitleArr = [self defaultCellModelTitleArr][i];
            NSMutableArray	*subModelArr = [NSMutableArray new];
            for (NSInteger j=0; j<subTitleArr.count; j++) {
                NSString	*title = subTitleArr[j];
                DeviceManagerViewCellModel	*cellModel = [[DeviceManagerViewCellModel alloc] init];
                cellModel.indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                cellModel.title = title;
                cellModel.detail = [self defaultCellModelDetailArr][i][j];
                [subModelArr addObject:cellModel];
            }
            [_modelArr addObject:subModelArr];
        }
    }
    return _modelArr;
}

- (NSArray *)sectionTitleArr {
    if (!_sectionTitleArr) {
        _sectionTitleArr =
        @[NSLocalizedString(MRDeviceInfo, nil),
          NSLocalizedString(MRDeviceStatus, nil),
          NSLocalizedString(MRDeviceOpration, nil)];
    }
    return _sectionTitleArr;
}

- (NSArray *)defaultCellModelTitleArr {
    return @[
  @[@"MAC",
    NSLocalizedString(MRDeviceSn, nil),
    NSLocalizedString(MRDeviceSoftwareVer, nil)],
  @[NSLocalizedString(MRConnectStatus, nil),
    NSLocalizedString(MRBatteryStatus, nil),
    NSLocalizedString(MRMonitorStatus, nil),
    NSLocalizedString(MRLiveDataStatus, nil),
//    @"Rawdata"
  ],
  @[NSLocalizedString(MRConnectDevice, nil),
    NSLocalizedString(MREnableLiveData, nil),
    NSLocalizedString(MRDisableLiveData, nil),
    NSLocalizedString(MRSyncData, nil),
    NSLocalizedString(MRStartSleep, nil),
    NSLocalizedString(MRStartSport, nil),
    NSLocalizedString(MRStartRealtime, nil),
    NSLocalizedString(MRStopMonitor, nil),
//    NSLocalizedString(MREnableRawdata, nil),
//    NSLocalizedString(MRDisableRawdata, nil),
    NSLocalizedString(MRDeviceUpgrade, nil),
    NSLocalizedString(MRSteps, nil),
    NSLocalizedString(MRStartPulse, nil),
    NSLocalizedString(MRStarGLU,nil),
    NSLocalizedString(MRSetPeriodicMonitor, nil),
    NSLocalizedString(MRGetPeriodicMonitor, nil),
    NSLocalizedString(MRStartBPMonitor, nil),
    NSLocalizedString(MRSyncDailyData, nil)]];
}

- (NSArray *)defaultCellModelDetailArr {
    NSString    *mac = self.device.mac ?: @"";
    NSString    *sn = self.device.sn ?: @"";
    return @[@[mac, sn, @""], @[NSLocalizedString(MRDisconnected, nil), @"", @"", @"", @"", @""], @[@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"",@""]];
}

- (NSArray *)batStateDescriptionArr {
    return @[
        NSLocalizedString(MRBatteryNormal, nil),
        NSLocalizedString(MRBatteryCharging, nil),
        NSLocalizedString(MRBatteryFull, nil),
        NSLocalizedString(MRBatteryLow, nil),
        NSLocalizedString(MRBatteryError, nil),
        NSLocalizedString(MRBatteryShutdown, nil),
        @""];
}



@end




@implementation DeviceManagerViewCellModel

@end
