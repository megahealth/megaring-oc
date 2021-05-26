//
//  MRConnecter.h
//  MegaRingBLE
//
//  Created by Superman on 2018/5/3.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBCentralManager, MRDevice;

@protocol MRConnecterDelegate;

@interface MRConnecter : NSObject


+ (instancetype)defaultConnecter;


@property (nonatomic, assign) BOOL	 isCentralPowerOn;


// Stop scanning after device is connected automatically.
@property (nonatomic, assign) BOOL   autoStopScanning;

@property (nonatomic, weak) id<MRConnecterDelegate>	 delegate;


- (void)startScanning;

- (void)stopScanning;





/*
 * default is NO;
 * if a nonull value is set to RSSIFilter, the value of isRSSIFilterOn would turn YES immediately;
 */
@property (nonatomic, assign, getter=isRSSIFilterOn) BOOL	 RSSIFilterOn;

@property (nonatomic, strong) NSNumber	*RSSIFilter;




- (void)connectDevice:(MRDevice *)device;

- (void)disconnectDevice:(MRDevice *)device;





@end
