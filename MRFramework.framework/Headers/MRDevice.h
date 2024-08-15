//
//  MRDevice.h
//  MegaRingBLE
//
//  Created by Superman on 2018/5/4.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MRFramework/MRDefines.h>

@class CBPeripheral;
@protocol MRDeviceDelegate;

@interface MRDevice : NSObject

@property (nonatomic,assign)int totalRawLen;
@property (nonatomic,strong)NSMutableData * rawData;

@property (nonatomic, assign) MRDeviceType deviceType;
@property (nonatomic, assign) MRDeviceHome home;
@property (nonatomic, copy) NSString    *deviceSize;
@property (nonatomic, copy) NSString	*name;
@property (nonatomic, copy) NSString    *mac;
@property (nonatomic, copy) NSString	*identifier; // Properties of the peripheral  self.peripheral.identifier.UUIDString; （）

@property (nonatomic, assign) BOOL	 connectable;
@property (nonatomic, assign) MRDeviceState	 connectState; // The status of the device connection.
@property (nonatomic, strong) NSNumber	*RSSI; // Signal of equipment
@property (nonatomic, assign) int	 RSSILevel;// Signal level of equipment: 0-4

@property (nonatomic, copy) NSString	*sn; // 设备的编号，可以作为标识 （Equipment number, which can be used as identification）
@property (nonatomic, copy) NSString	*btVersion;
@property (nonatomic, copy) NSString	*hwVersion;
@property (nonatomic, copy) NSString	*swVersion;

@property (nonatomic, strong) NSData *snData;
@property (nonatomic, strong) NSData *verData;

@property (nonatomic, strong) CBPeripheral * peripheral;
// 通过查看IICOk ，GSensorOk， 4404Ok 查看硬件是否 OK; 都是等于 == 1 说明硬件没有问题；否则有问题；（Translated as: Check whether the hardware is OK by checking iicok, gsensorok and 4404ok; All are equal to = = 1, indicating that there is no problem with the hardware; Otherwise there will be problems;）
@property (nonatomic, strong) NSDictionary * adData;
@property (nonatomic, assign) BOOL	 isIICOk;          	// IIC OK
@property (nonatomic, assign) BOOL	 isGSensorOk;      	// GSensor OK
@property (nonatomic, assign) BOOL	 is4404Ok;         	// 4404 OK

//MARK://TODO...
@property (nonatomic, assign) BOOL     deviceOK;             // The above three are yes, the watch is the ring is good （example：(device.deviceOK == YES)）

@property (nonatomic, assign) BOOL lmRegistered;

// 设备就绪
@property (nonatomic, assign, getter=isReady) BOOL	 ready;

@property (nonatomic, assign) MRBatteryState	 batState;
@property (nonatomic, assign) int	 batValue;

@property (nonatomic, assign, getter=isMonitorOn) BOOL monitorOn; // 监测状态


@property (nonatomic, assign) BOOL isScreenOn;

@property (nonatomic, assign) BOOL isDownloadingData; // is if syn data ？ YES  is syn data . 

@property (nonatomic, assign) int chargeDuration;        // 充电分钟数

@property (nonatomic, assign, readonly) BOOL bloodPressureSupported; // (指环是否支持血压的监测；) --例： self.bloodPressureSupported == YES; 判断：跳转到血压监测页面；或不显示血压测量功能等 (Does the ring support blood pressure monitoring-- Example: self bloodPressureSupported == YES;  Judgment: jump to the blood pressure monitoring page; Or the blood pressure measurement function is not displayed)





@property (nonatomic, assign) MRDeviceMonitorMode monitorMode;

@property (nonatomic, assign) MRGLUModeInterval gluInterval;

@property (nonatomic, assign) int monitorDuration; //Monitoring duration （ 监测时长）;

@property (nonatomic, assign, getter=isScreenOff) BOOL	 screenOff;

@property (nonatomic, assign) BOOL isDFUMode;
@property (nonatomic ,assign) BOOL isOpenBloodNoti;// if set YES , MRDeviceDelegate method ---> - (void)bpDataUpdated:(NSData *)data (invalid) use notification --->  name: (MRRawdataReceivedNotification) ;


@property (nonatomic, weak) id<MRDeviceDelegate>	 delegate;

- (NSArray *)RSSIInLast10seconds;

- (void)stopTimer;

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral adData:(NSDictionary *)adData RSSI:(NSNumber *)RSSI;
@end










