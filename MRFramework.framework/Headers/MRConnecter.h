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


// Stop scanning automatically after device is connected.
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





@class CBPeripheral;

@interface MRConnecter (MRCustomConnecter)

@property (nonatomic, strong) CBCentralManager    *customCentral;

- (void)centralManagerDidUpdateState:(CBCentralManager *)central;

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI;

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

- (MRDevice *)deviceWithPeripheral:(CBPeripheral *)peripheral adData:(NSDictionary *)adData RSSI:(NSNumber *)RSSI;


@end
