//
//  DeviceUpgradeViewController.h
//  MegaRingBLE
//
//  Created by cheng cheng on 2019/10/24.
//  Copyright © 2019 Superman. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MRDevice;

@interface DeviceUpgradeViewController : UIViewController

- (instancetype)initWithDevice:(MRDevice *)device;

@end

NS_ASSUME_NONNULL_END
