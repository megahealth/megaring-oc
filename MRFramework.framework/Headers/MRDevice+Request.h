//
//  MRDevice+Request.h
//  MRFramework
//
//  Created by Superman on 2018/5/23.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "MRDevice.h"
#import "MRDefines.h"

@interface MRDevice (Request)

// 确认更换用户
- (void)confirmChangingUser:(BOOL)confirm;

// 开启实时数据通道
- (void)startLiveData;

// 关闭实时数据通道
- (void)endLiveData;

/*
 * 开关监测, if YES 默认开启血氧监测
 * 不建议使用这个方法, 使用切换模式接口代替
 */
- (void)setMonitorState:(BOOL)isOn;
/*
 * 检查设备中是否有数据并取出
 * type: 数据种类, 目前支持 MRDataTypeMonitor 类型
 * stopType: 停止监测的原因
 * mode: 监测的类型, 目前支持睡眠监测 MRDeviceMonitorModeSleep
 */
- (void)requestData:(MRDataType)type progress:(void (^)(float progress))progressBlock finish:(void (^)(NSData *data, MRMonitorStopType stopType, MRDeviceMonitorMode mode))finishBlock;


/*
 * 切换模式
 */
- (void)switchToSleepMode;      // 睡眠监测

- (void)switchToSportMode;      // 运动监测

- (void)switchToNormalModel;    // 关闭监测

- (void)switchToRealtimeMode;   // 实时监测, 不会记录数据

- (void)switchToPulseMode;      // 脉诊仪模式


- (void)notiStartUpgrade;



/*
 * 开关 rawdata
 * support MRDeviceMonitorModeDefault，MRDeviceMonitorModeSleep，MRDeviceMonitorModeSport，MRDeviceMonitorModePulse
 * deprecated 1.8.2
 */

//- (void)setRawdataEnabled:(BOOL)enabled;


/*
 * 设置定时监测
 * 设备断开时，若处于定时监测时间段内，会自动开启监测
 * 设备连接时，定时监测不生效
 */

- (void)setPeriodicMonitorOn:(BOOL)isOn afterSeconds:(int)seconds duration:(int)monitorDuration repeat:(BOOL)isRepeat;

- (void)getMonitorTimer;


@end
