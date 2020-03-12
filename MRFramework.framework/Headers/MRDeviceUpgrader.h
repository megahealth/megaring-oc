//
//  MRDeviceUpgrader.h
//  MRFramework
//
//  Created by cheng cheng on 2019/10/23.
//  Copyright © 2019 Superman. All rights reserved.
//

/*
 * 设备升级
 * 固件版本要和硬件相对应, 比如2代指环要使用 V2 固件;
 * 升级过程中需要断开重连, 请保持蓝牙开启;
 * 升级完成后设备自动断开;
 */

#import <Foundation/Foundation.h>
#import "MRDefines.h"

NS_ASSUME_NONNULL_BEGIN


@class MRDevice;

@protocol MRDeviceUpgraderDelegate <NSObject>


/*
 * 实现以下回调
 * 如果升级过程中连续 10 秒以上未执行以下回调, 可认为升级失败
 */
- (void)upgradeStateUpdated:(MRUpgradeState)state;  // 升级中的状态变化

- (void)dataProgressUpdated:(float)progress;        // 数据包发送进度


@end


@interface MRDeviceUpgrader : NSObject

+ (instancetype)defaultInstance;

@property (nonatomic, strong) MRDevice *_Nullable device;

// 固件绝对路径
@property (nonatomic, copy) NSString *_Nullable firmware;

@property (nonatomic, assign) MRUpgradeState upgradeState;
@property (nonatomic, assign) float dataProgress;


@property (nonatomic, weak) id<MRDeviceUpgraderDelegate> delegate;

- (void)start;

- (void)stop;


@end

NS_ASSUME_NONNULL_END
