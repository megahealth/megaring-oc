//
//  MRProtocols.h
//  MegaRingBLE
//
//  Created by Superman on 2018/5/4.
//  Copyright © 2018年 Superman. All rights reserved.
//

#ifndef MRProtocols_h
#define MRProtocols_h


#import <MRFramework/MRDefines.h>



@class MRDevice, MRConnecter, MRRawData;


@protocol MRConnecterDelegate <NSObject>

@optional


- (void)scanStateDidUpdate;


- (void)connecter:(MRConnecter *_Nullable)connecter didDiscoverDevice:(MRDevice *_Nullable)device;

- (void)connecter:(MRConnecter *_Nullable)connecter didUpdateDeviceConnectState:(MRDevice *_Nullable)device;



@end





@protocol MRDeviceDelegate <NSObject>

@required

// Device connect state updated
- (void)deviceDidUpdateConnectState;

// Infomation in the binding process
- (void)bindDeviceResp:(MRBindResp)bindResp;

// Device is ready to work
- (void)deviceIsReady:(BOOL)isReady;

// Token refresh after binding process complete
- (void)finishBindingWithToken:(NSString *_Nullable)token;

- (void)deviceTimeUpdated:(int)timestamp;


// user id
- (NSString *_Nonnull)bindUserIdentifier;

// token
- (nullable NSString *)bindToken;

/*
 * User physical signs which may affect final report
 * Format: [age, gender, height, weight], 0 for female, 1 for male
 */


@optional


- (NSArray *_Nonnull)bindUserInfo;

- (void)deviceInfoUpdated; // device info。

- (void)deviceBatteryUpdated; // device battery

- (void)liveDataStateUpdated; //

- (void)monitorStateUpdated;

/**
 * If call [MRDevice startLiveData] && monitor is on, an number array will received every second;
 * Format: [SpO2, PR, state, duration]
 * SpO2 oxygen saturation level
 * PR: pulse rate
 * @see MRLiveDataState
 * duration: since monitor started
 */
- (void)liveDataValueUpdated:(NSArray *_Nullable)liveData;

- (void)monitorModeUpdated; //en： after the monitoring is turned off or turned on successfully, you can view the current mode.（zh：关闭监测或开启监测成功后,您可以查看当前是什么模式）

- (void)screenStateUpdated;


//-(void)gLUModeUpdated; //glu.

- (void)operationFailWithErrorCode:(MRErrCode)errCode;

- (void)rawdataUpdated:(NSArray<MRRawData *> *_Nonnull)arr;
//Returns the binary data of the rawdata channel
- (void)rawdataUpdatedData:(NSData *)data;

- (void)bpDataUpdated:(NSData *)data;

- (void)didSetPeriodicMonitorState:(MRPeriodicMonitorState)state start:(NSString *_Nullable)start duration:(int)duration repeat:(BOOL)repeat;

- (void)didGetPeriodicMonitorState:(MRPeriodicMonitorState)state start:(NSString *_Nullable)start duration:(int)duration repeat:(BOOL)repeat;



@end














#endif /* MRProtocols_h */
