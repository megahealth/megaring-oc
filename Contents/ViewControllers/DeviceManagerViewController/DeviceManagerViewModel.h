//
//  DeviceManagerViewModel.h
//  MegaRingBLE
//
//  Created by Superman on 2018/5/21.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MRDevice;

@interface DeviceManagerViewModel : NSObject

@property (nonatomic, strong) NSArray	*sectionTitleArr;

@property (nonatomic, strong) NSMutableArray	*modelArr;



@property (nonatomic, strong) MRDevice	*device;

- (instancetype)initWithDevice:(MRDevice *)device;

/*
 * 刷新
 */
- (void)reloadModel;

- (void)updateSN;

- (void)updateVersion;

- (void)updateConnectState;

- (void)updateBattery;

- (void)updateLiveDataValue:(NSArray *)liveData;

- (void)updateMonitorState;


/*
 * 还原
 */
- (void)reset;



@end






@interface DeviceManagerViewCellModel : NSObject

@property (nonatomic, strong) NSIndexPath	*indexPath;

@property (nonatomic, copy) NSString	*title;

@property (nonatomic, copy) NSString	*detail;

@property (nonatomic, assign) BOOL	 isFresh;




@end
