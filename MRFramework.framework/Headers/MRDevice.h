//
//  MRDevice.h
//  MegaRingBLE
//
//  Created by Superman on 2018/5/4.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRDefines.h"



@protocol MRDeviceDelegate;

@interface MRDevice : NSObject

@property (nonatomic, assign) MRDeviceType deviceType;
@property (nonatomic, assign) MRDeviceHome home;
@property (nonatomic, copy) NSString    *deviceSize;
@property (nonatomic, copy) NSString	*name;
@property (nonatomic, copy) NSString    *mac;
@property (nonatomic, copy) NSString	*identifier;

@property (nonatomic, assign) BOOL	 connectable;
@property (nonatomic, assign) MRDeviceState	 connectState;
@property (nonatomic, strong) NSNumber	*RSSI;
@property (nonatomic, assign) int	 RSSILevel;

@property (nonatomic, copy) NSString	*sn;
@property (nonatomic, copy) NSString	*btVersion;
@property (nonatomic, copy) NSString	*hwVersion;
@property (nonatomic, copy) NSString	*swVersion;

@property (nonatomic, strong) NSData *snData;
@property (nonatomic, strong) NSData *verData;

@property (nonatomic, assign) BOOL	 isIICOk;          	// IIC OK
@property (nonatomic, assign) BOOL	 isGSensorOk;      	// GSensor OK
@property (nonatomic, assign) BOOL	 is4404Ok;         	// 4404 OK

@property (nonatomic, assign) BOOL lmRegistered;


// 设备就绪
@property (nonatomic, assign, getter=isReady) BOOL	 ready;

@property (nonatomic, assign) MRBatteryState	 batState;
@property (nonatomic, assign) int	 batValue;

@property (nonatomic, assign, getter=isMonitorOn) BOOL monitorOn; // 监测状态

@property (nonatomic, assign) MRDeviceMonitorMode monitorMode;

@property (nonatomic, assign) MRGLUModeInterval gluInterval;

@property (nonatomic, assign) int monitorDuration; // 监测时长;

@property (nonatomic, assign, getter=isScreenOff) BOOL	 screenOff;

@property (nonatomic, assign) BOOL isDFUMode;


@property (nonatomic, weak) id<MRDeviceDelegate>	 delegate;

- (NSArray *)RSSIInLast10seconds;



@end










