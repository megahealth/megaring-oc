//
//  MRDeviceManager.h
//  MegaRingBLE
//
//  Created by feiyang cai on 2022/12/15.
//  Copyright © 2022 Superman. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MRDevice;
NS_ASSUME_NONNULL_BEGIN

@interface MRDeviceManager : NSObject<NSCopying>
@property (nonatomic ,strong)MRDevice * managerDevice;

+(instancetype)sharedDeviceManager;

@end

NS_ASSUME_NONNULL_END
