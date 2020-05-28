//
//  MRHomeViewModel.h
//  MegaRingBLE
//
//  Created by Superman on 2018/5/4.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MRDevice, MRHomeViewCellModel;

@interface MRHomeViewModel : NSObject

@property (nonatomic, strong) NSMutableArray<MRDevice *>	*deviceArr;

@property (nonatomic, strong) NSMutableArray<MRHomeViewCellModel *>	*modeArr;

- (void)resetModel;

- (NSInteger)deviceDiscovered:(MRDevice *)device;

- (NSInteger)updateOldDevice:(MRDevice *)device;

- (void)addNewDevice:(MRDevice *)device;

- (void)updateAllDevices;



@end








@interface MRHomeViewCellModel : NSObject

@property (nonatomic, copy) NSString	*name;

@property (nonatomic, copy) NSString	*mac;

@property (nonatomic, copy) NSString    *sn;

@property (nonatomic, strong) NSNumber	*RSSI;

@property (nonatomic, assign) int	 RSSILevel;

@property (nonatomic, assign) BOOL	 isConnected;


- (instancetype)initWithDevice:(MRDevice *)device;

- (void)setUpWithDevice:(MRDevice *)device;









@end
