//
//  MRHomeViewController.m
//  MegaRingBLE
//
//  Created by Superman on 2018/5/4.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "MRHomeViewController.h"
#import <MRFramework/MRFramework.h>
#import "MRHomeViewController+Methods.h"
#import "MRNavigarionController.h"
#import "MRHomeView.h"
#import "MRHomeViewModel.h"
#import "DeviceManagerViewController.h"
#import "MRIndicatorView.h"
#import "MRDefaultView.h"
#import <CoreBluetooth/CoreBluetooth.h>


@interface MRHomeViewController () <MRConnecterDelegate, CBCentralManagerDelegate>

@property (nonatomic, assign) BOOL usingCustomConnecter;

@property (nonatomic, strong) CBCentralManager *central;


@end

@implementation MRHomeViewController

#pragma mark -
#pragma mark User Actions

- (IBAction)filterButtonClicked:(UIButton *)sender {
}

- (IBAction)logButtonClicked:(UIButton *)sender {
}

- (void)setViewActions {
    __weak typeof(self) weakself = self;
    self.homeView.selectAction = ^(NSIndexPath *indexPath) {
        MRDevice	*device = weakself.homeView.viewModel.deviceArr[indexPath.row];
        DeviceManagerViewController	*deviceVC = [[DeviceManagerViewController alloc] initWithDevice:device];
        [weakself.navigationController pushViewController:deviceVC animated:YES];
    };
}


#pragma mark -
#pragma mark Delegate Methods - MRConnecterDelegate

- (void)connecter:(MRConnecter *)connecter didDiscoverDevice:(MRDevice *)device {
    NSInteger	 index = [self.homeView.viewModel deviceDiscovered:device];
    [self.homeView reloadTableAtIndex:index];
}

- (void)connecter:(MRConnecter *)connecter didUpdateDeviceConnectState:(MRDevice *)device {
    NSInteger	 index = [self.homeView.viewModel updateOldDevice:device];
    [self.homeView reloadTableAtIndex:index];
    
    for (DeviceManagerViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[DeviceManagerViewController class]]) {
            vc.device = device;
        }
    }
}


#pragma mark -
#pragma mark Delegate Methods - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    [[MRConnecter defaultConnecter] centralManagerDidUpdateState:central];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    [[MRConnecter defaultConnecter] centralManager:central didDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [[MRConnecter defaultConnecter] centralManager:central didConnectPeripheral:peripheral];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [[MRConnecter defaultConnecter] centralManager:central didDisconnectPeripheral:peripheral error:error];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [[MRConnecter defaultConnecter] centralManager:central didFailToConnectPeripheral:peripheral error:error];
}




#pragma mark -
#pragma mark Notification Methods - kMRCentralStateUpdatedNotification

- (void)MRCentralStateUpdated:(NSNotification *)noti {
    BOOL     isCentralPowerOn = [MRConnecter defaultConnecter].isCentralPowerOn;
    
    [MRDefaultView showDefaultView:isCentralPowerOn == NO];
    
    if (isCentralPowerOn) {
        [self.homeView.viewModel resetModel];
        [[MRConnecter defaultConnecter] startScanning];
    } else {
        [self.homeView.viewModel updateAllDevices];
    }
    [self.homeView.tableView reloadData];
}

- (void)deviceConnecteStateUpdated:(NSNotification *)noti {
    MRDevice *device = noti.object;
    NSLog(@"%@ connecte state: %d", device.name, device.connectState);
}




#pragma mark -
#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setUp];
    self.homeView.viewModel = [[MRHomeViewModel alloc] init];
    
    self.usingCustomConnecter = YES;
    if (self.usingCustomConnecter) {
        dispatch_queue_t     queue = dispatch_queue_create("CustomConnecterQueue", NULL);
        NSDictionary    *options = @{CBCentralManagerOptionShowPowerAlertKey:@NO};
        self.central = [[CBCentralManager alloc] initWithDelegate:self queue:queue options:options];
        [MRConnecter defaultConnecter].customCentral = self.central;
    }
    
    [MRConnecter defaultConnecter].delegate = self;
    [MRConnecter defaultConnecter].autoStopScanning = YES;
    
    
    [self setViewActions];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MRCentralStateUpdated:) name:kMRCentralStateUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceConnecteStateUpdated:) name:MRDeviceConnectStateUpdatedNotification object:nil];
    
    NSLog(@"SDK version:%s algorithm:%d", MRFrameworkVersionString, kMRAlgorithmVersion);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.homeView deselectSelectedCell];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self testParseData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
