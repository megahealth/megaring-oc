//
//  MRDefines.h
//  MRBLE
//
//  Created by Superman on 2018/5/18.
//  Copyright © 2018年 Superman. All rights reserved.
//

#ifndef MRDefines_h
#define MRDefines_h


typedef NS_ENUM(int, MRDeviceState) {
    MRDeviceStateDisconnected        	= 0,
    MRDeviceStateConnecting,
    MRDeviceStateConnected,
    MRDeviceStateDisconnecting,
};

typedef NS_ENUM(Byte, MRBatteryState) {
    MRBatteryStateNormal            	= 0x00,
    MRBatteryStateCharging,
    MRBatteryStateFull,
    MRBatteryStateLowPower,
    MRBatteryStateError,
    MRBatteryStateShutdown,
};

typedef NS_ENUM(Byte, MRCMD) {
    MRCMDBind                         	= 0XB0,      	// Bind 绑定
    MRCMDShake                        	= 0XB1,
    MRCMDShutdown                       = 0XB2,
    MRCMDOpenOrCloseHrv              = 0XCD,         //hrv
    MRCMDSetMonitor                     = 0XD0,			// 血氧监测模式 sleep
    MRCMDSetBloodPressure            	= 0XD4,			// 血压模式 blood pressure mode
    MRCMDSetSport                     	= 0XD5,			// 运动模式 sport mode
    MRCMDSetNormal                     	= 0XD6,			// 日常模式 normal mode
    MRCMDSetRealtime                   	= 0XD7,			// 实时模式 realtime mode
    MRCMDHeartBeat                      = 0XD3,
    MRCMDDfuNoti                        = 0XD8,
    MRCMDSetPulseImp                    = 0XDB,         // 脉诊模式 pluse
    MRCMDPeriodicMonitor                = 0XD9,
    MRCMDSetGLU                         = 0XDD,         // 血糖模式 glu
    MRCMDSetTime                        = 0XE0,
    MRCMDReset                          = 0XE2,
    MRCMDSetUserInfo                    = 0XE3,
    MRCMDSetScreenOff                  	= 0XE5,
    MRCMDSetDeviceMode                	= 0XE6,
    MRCMDSetLiveData                    = 0XED,
    MRCMDMonitorData                    = 0XEB,
    MRCMDGetAlertInfo                   = 0XEC,
    MRCMDGetScreenState                 = 0XEE,
    MRCMDMonitorDataDetail              = 0XEF,
    MRCMDDailyDataDetail                = 0XF1,
    MRCMDGLUDataDetail                  = 0XFA,
    MRCMDHRVDataDetail                  = 0XFB,
    
    MRCMDCrashLog                       = 0XF3,
    MRCMDGetMonitorMode                 = 0XF6,
    MRCMDGetMonitorTimer                = 0XF8,
    MRCMDClearCache                     = 0XFC,
};


typedef NS_ENUM(Byte, MRPlatform) {
    MRPlatformIOS                    	= 0X20,
};


typedef NS_ENUM(Byte, MRBindResp) {
    MRBindRespNew                     	= 0X00,		// Connection complete with another user
    MRBindRespOld                     	= 0X01,		// Connection complete with the same user
    MRBindRespShake                   	= 0X02,		// Waiting user to shake the ring to confirm the connection
    MRBindRespLowPower                	= 0X03,		// Connect failed, due to low power
    MRBindRespChangeUser				= 0X04,		// Connecting by new user; Call -[MRDevice confirmChangingUser:] and input YES or NO to continue or not; Usually decided by app user
    MRBindRespError                  	= 0X05,		// Meet some error
};


/*
 * Device's working mode
 * For now, device mode is either sleep or normal
 */
typedef NS_ENUM(Byte, MRDeviceMonitorMode) {
    MRDeviceMonitorModeIdle,            // 0 Idle mode 空闲
    MRDeviceMonitorModeSleep,			// 1 Sleep mode 睡眠模式, 血氧脉率监测
    MRDeviceMonitorModeSport,           // 2 Sport Mode 运动模式, 心率监测
    MRDeviceMonitorModeNormal,			// 3 Normal mode （free） 日常模式, 空闲
    MRDeviceMonitorModeRealTime,        // 4 Real time mode, blood oxygen pulse rate monitoring，But no data will be generated 实时模式, 血氧脉率监测, 但不会产生数据
    MRDeviceMonitorModeBloodPresure,    // 5  Blood pressure mode 血压模式
    MRDeviceMonitorModePulse,           // 6 Pulse detector mode 脉诊仪模式
    MRDeviceMonitorModeGLU      = 0x09, // 9 Blood glucose pattern 血糖模式
    MRDeviceMonitorModeHRV      = 0x0a, // 10 Turn on sleep to generate HRV data  hrv 开启睡眠后，手指与指环保持不动至少30 会产生HRV type 的数据。
    MRDeviceMonitorModeNone     = 0x0f, // no mode.
};


//typedef NS_ENUM(Byte, MHBLEDataRequestType) {
//    MHBLEDataRequestTypeMonitor                = 0XEF,
//    MHBLEDataRequestTypeDaily                 = 0XF1,
//    MHBLEDataRequestTypeGLU                 = 0XFA,
//    MHBLEDataRequestTypeHRV                 = 0XFB,
//};



/*
 * Monitor could end automatically or by user.
 */
typedef NS_ENUM(Byte, MRMonitorStopType) {
    MRMonitorStopOK,			// end by user
    MRMonitorStopTimeout,		// monitor for more than 12 hrs
    MRMonitorStopReset,			// after device reset
    MRMonitorStopMemOut,		// device's memory is full
    MRMonitorStopLowPower,		// Low battery power
    MRMonitorStopCharge,		// charge when monitoring
    MRMonitorStopFlashErr,		// something wrong with flash
    MRMonitorStopBQErr,
    MRMonitorStopACCErr,
    MRMonitorStopAFEErr,
};


typedef NS_ENUM(Byte, MRLiveDataState) {
    MRLiveDataStateValid              	= 0X00,		// valid live data
    MRLiveDataStatePreparing           	= 0X01,		// preparing live data
    MRLiveDataStateInvalid          	= 0X02,		// invalid live data
};

typedef NS_ENUM(NSInteger, MRDeviceType) {
    MRDeviceTypeB,
    MRDeviceTypeC,
    MRDeviceTypeT,
};


typedef NS_ENUM(Byte, MRDataType) {
    MRDataTypeMonitor                	= 0XEF,
    MRDataTypeDaily                   	= 0XF1,
    MRDataTypeGLU                       = 0XFA,
    MHBLEDataRequestTypeHRV                 = 0XFB,
};


typedef NS_ENUM(Byte, MRNotiType) {
    MRNotiTypeBatValue                	= 0XD2,
    MRNotiTypeLiveData                	= 0XED,
    MRNotiTypeReportDataMax          	= 0X6C, // 首字节小于此值的均是监测数据
};

typedef NS_ENUM(Byte, MRErrCode) {
    MRErrCodeSuccess            		= 0X00,
    MRErrCodeNoData                		= 0X02,
    MRErrCodeSleepId                	= 0X20,
    MRErrCodeArgs                   	= 0X21,
    MRErrCodeMonitoring             	= 0X22,
    MRErrCodeWrongFileOption        	= 0X23, // 文件句柄已被占用，重复开启监测或收数据
    MRErrCodeSPMode                 	= 0X24,
    MRErrCodeSportMode              	= 0X25,
    MRErrCodeUnkownCmd             		= 0X9F,
    MRErrCodeRTC                   		= 0XA0,
    MRErrCodeLowPower              		= 0XA1,
    MRErrCodeSpOrHr                		= 0XA2,
    MRErrCodeFlash                 		= 0XA3,
    MRErrCodeCmdRefused            		= 0XA4,
    MRErrCode4405Failed            		= 0XA5,
    MRErrCodeGSensorFailed         		= 0XA6,
    MRErrCodeBQ25120                	= 0XA7,
    MRErrCodeHardware               	= 0XB0,
    MRErrCodeShortRecord            	= 0XC0,
    MRErrCodeNoStop                 	= 0XC1,
    MRErrCodeUnknown                	= 0XFF,
};



typedef NS_ENUM(NSInteger, kMRError) {
    kMRErrorNoError                    	= 0,
    kMRErrorInternalSDK                 = 1,
    kMRErrorUnauthorized              	= 2,
    kMRErrorInputNullData				= 3,
};


typedef NS_ENUM(int, MRUpgradeState) {
    MRUpgradeStateNone      			= 0X00,
    MRUpgradeStateStart,
    MRUpgradeStateReconnecting,
    MRUpgradeStateReconnected,
    MRUpgradeStateSendData,
    MRUpgradeStateFinish,
    MRUpgradeStateSendCommand,
    MRUpgradeStateFail                 	= 0X0F,
};

typedef NS_ENUM(int, MRUpgradeType) {
    MRUpgradeTypeNone                = 0,
    MRUpgradeTypeSoftware            = 1,
    MRUpgradeTypeBoot                = 2,
};

typedef NS_ENUM(NSInteger, MRDeviceHome) {
    MRDeviceHomeMR,
    MRDeviceHomeLM,
};

/// Invalid: Periodic Monitor is off
/// Free: Periodic Monitor is on, but device is not in monitoring
/// Monitoring: Periodic Monitor is on, and device is in monitoring
/// HangOn: May be concurrent with Free: 0x101
typedef NS_OPTIONS(Byte, MRPeriodicMonitorState) {
    MRPeriodicMonitorStateInvalid           = 0X00,
    MRPeriodicMonitorStateFree              = 0X01,
    MRPeriodicMonitorStateMonitoring        = 0X01 << 1,
    MRPeriodicMonitorStateHangOn            = 0X01 << 2,
};

typedef NS_ENUM(int, MRGLUModeInterval) {
    MRGLUModeIntervalOff,
    MRGLUModeInterval5Mins,
    MRGLUModeInterval10Mins,
    MRGLUModeInterval15Mins,
};




#endif /* MRDefines_h */
