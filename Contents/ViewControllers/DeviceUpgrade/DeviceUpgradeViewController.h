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
//device-------------name:MR, sn:C11E82109001175, mac:BC:E5:9F:48:86:79, RSSI:-62, adData:{
//    kCBAdvDataIsConnectable = 1;
//    kCBAdvDataLocalName = MR;
//    kCBAdvDataManufacturerData = {length = 37, bytes = 0x00007986 489fe5bc 01010100 00000000 ... 00009ad6 02000000 };
//    kCBAdvDataRxPrimaryPHY = 129;
//    kCBAdvDataRxSecondaryPHY = 0;
//    kCBAdvDataServiceUUIDs =     (
//        FAB1
//    );
//    kCBAdvDataTimestamp = "692784514.837436";
//}
