//
//  DeviceManagerViewController.h
//  MegaRingBLE
//
//  Created by Superman on 2018/5/14.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRDevice, DeviceManagerView;

@interface DeviceManagerViewController : UIViewController

//test hrv mark.
@property (nonatomic ,assign)BOOL shouldSyncData;

@property (nonatomic, strong) MRDevice	*device;

- (instancetype)initWithDevice:(MRDevice *)device;

@property (strong, nonatomic) IBOutlet DeviceManagerView *deviceManagerView;
// title... 
@property (nonatomic, strong)UILabel * titleNavView;


@end
