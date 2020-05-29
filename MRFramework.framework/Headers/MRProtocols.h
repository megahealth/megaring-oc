//
//  MRProtocols.h
//  MegaRingBLE
//
//  Created by Superman on 2018/5/4.
//  Copyright © 2018年 Superman. All rights reserved.
//

#ifndef MRProtocols_h
#define MRProtocols_h

#import "MRDefines.h"



@class MRDevice, MRConnecter;


@protocol MRConnecterDelegate <NSObject>

@optional

- (void)connecter:(MRConnecter *_Nullable)connecter didDiscoverDevice:(MRDevice *_Nullable)device;

- (void)connecter:(MRConnecter *_Nullable)connecter didUpdateDeviceConnectState:(MRDevice *_Nullable)device;



@end





@protocol MRDeviceDelegate <NSObject>

@optional

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
- (NSArray *_Nonnull)bindUserInfo;


- (void)deviceInfoUpdated;

- (void)deviceBatteryUpdated;

- (void)liveDataStateUpdated;

- (void)monitorStateUpdated;

/*
 * If call [MRDevice startLiveData] && monitor is on, an number array will received every second;
 * Format: [SpO2, PR, state, duration]
 * SpO2: oxygen saturation level
 * PR: pulse rate
 * state: MRLiveDataState
 * duration: since monitor started
 */
- (void)liveDataValueUpdated:(NSArray *_Nullable)liveData;

- (void)monitorModeUpdated;

- (void)screenStateUpdated;



- (void)operationFailWithErrorCode:(MRErrCode)errCode;

- (void)rawdataUpdated:(NSArray *_Nullable)data;



@end














#endif /* MRProtocols_h */
