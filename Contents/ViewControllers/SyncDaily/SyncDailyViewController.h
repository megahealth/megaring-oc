//
//  SyncDailyViewController.h
//  MegaRingBLE
//
//  Created by cheng cheng on 22/4/2020.
//  Copyright © 2020 Superman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRDevice;

@interface SyncDailyViewController : UIViewController

- (instancetype)initWithDevice:(MRDevice *)device;



@end






@interface MHDailyStep : NSObject

@property (nonatomic, assign) int start;
@property (nonatomic, assign) int end;
@property (nonatomic, assign) int hr;
@property (nonatomic, assign) int intensity;
@property (nonatomic, assign) int steps;
@property (nonatomic, assign) int mode;



@end
