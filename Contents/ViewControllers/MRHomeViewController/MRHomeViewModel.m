//
//  MRHomeViewModel.m
//  MegaRingBLE
//
//  Created by Superman on 2018/5/4.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "MRHomeViewModel.h"
#import <MRFramework/MRFramework.h>

@implementation MRHomeViewModel

- (NSInteger)deviceDiscovered:(MRDevice *)device {
    if ([self.deviceArr containsObject:device]) {
        return [self updateOldDevice:device];
    } else {
        [self addNewDevice:device];
        return -1;
    }
    
//    return [self updateOldDevice:device];
}

- (NSInteger)updateOldDevice:(MRDevice *)device {
    NSInteger	 index = [self.deviceArr indexOfObject:device];
    if (index != NSNotFound) {
        [self.deviceArr replaceObjectAtIndex:index withObject:device];
        MRHomeViewCellModel    *existModel = self.modeArr[index];
        [existModel setUpWithDevice:device];
    }
    
//    NSInteger index = NSNotFound;
//    for (NSInteger i=0; i<self.deviceArr.count; i++) {
//        MRDevice *oldDevice = self.deviceArr[i];
//        if ([oldDevice.mac isEqualToString:device.mac]) {
//            index = i;
//        }
//    }
//
//    if (index == NSNotFound) {
//        [self addNewDevice:device];
//    } else {
//        [self.deviceArr replaceObjectAtIndex:index withObject:device];
//        MRHomeViewCellModel *existModel = self.modeArr[index];
//        [existModel setUpWithDevice:device];
//    }
    
    return index;
}

- (void)addNewDevice:(MRDevice *)device {
    [self.deviceArr addObject:device];
    MRHomeViewCellModel	*newModel = [[MRHomeViewCellModel alloc] initWithDevice:device];
    [self.modeArr addObject:newModel];
}

- (void)updateAllDevices {
    for (NSInteger i=0; i<self.modeArr.count; i++) {
        MRDevice	*device = self.deviceArr[i];
        MRHomeViewCellModel	*model = self.modeArr[i];
        [model setUpWithDevice:device];
    }
}



#pragma mark -
#pragma mark Basic Settings

- (instancetype)init {
    if (self = [super init]) {
        [self resetModel];
    }
    return self;
}

- (void)resetModel {
    self.modeArr = [NSMutableArray new];
    self.deviceArr = [NSMutableArray new];
}

@end





@implementation MRHomeViewCellModel

- (instancetype)initWithDevice:(MRDevice *)device {
    if (self = [super init]) {
        [self setUpWithDevice:device];
    }
    return self;
}

- (void)setUpWithDevice:(MRDevice *)device {
    self.name = device.name;
    self.mac = device.mac;
    self.sn = device.sn;
    self.RSSI = device.RSSI;
    self.RSSILevel = device.RSSILevel;
    self.isConnected = device.connectState == MRDeviceStateConnected;
}


@end
