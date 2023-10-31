//
//  MRHomeViewController.m
//  MegaRingBLE
//
//  Created by Superman on 2018/5/4.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "MRHomeViewController.h"

#import "MRHomeViewController+Methods.h"
#import "MRNavigarionController.h"
#import "MRHomeView.h"
#import "MRHomeViewModel.h"
#import "DeviceManagerViewController.h"
#import "MRIndicatorView.h"
#import "MRDefaultView.h"
#import <CoreBluetooth/CoreBluetooth.h>

/**
 
 
     printf("///\n\
 //                          _ooOoo_                          //\n\
 //                         o8888888o                         //\n\
 //                        88\" . \"88                         //\n\
 //                         (| ^_^ |)                         //\n\
 //                        O\\  =  /O                         //\n\
 //                      ____/`---'\\____                      //\n\
 //                    .'  \\\\|     |//  `.                    //\n\
 //                   /  \\\\|||  :  |||//  \\                   //\n\
 //                  /  _||||| -:- |||||-  \\                  //\n\
 //                  |   | \\\\\\  -  /// |   |                  //\n\
 //                  | \\_|  ''\\---/''  |   |                  //\n\
 //                  \\  .-\\__  `-`  ___/-. /                  //\n\
 //                ___`. .'  /--.--\\  `. . ___                //\n\
 //               ."" '<  `.___\\_<|>_/___.'  >'"".                //\n\
 //            | | :  `- \\`.;`\\ _ /`;.`/ - ` : | |            //\n\
 //            \\  \\ `-.   \\_ __\\ /__ _/   .-` /  /            //\n\
 //     ========`-.____`-.___\\_____/___.-`____.-'========     //\n\
 //                          `=---='                          //\n\
 //     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^     //\n\
 //                      ~ Good Luck To You ~           //\n\
 ///\n");
 }

 Tip *****************：
 
 en:  When integrating SDKs, please first view the README or README zh file -- how to integrate and precautions. See Demo logic for details; Use SDK demo for testing. After getting familiar with the logic, integrate it into your own app.
 
 中文：集成SDK时,请先查看README 或 README-zh 文件 -- 如何集成及注意事项。具体查看Demo逻辑等; 多使用SDK demo 测测，熟悉了解逻辑后，再进行集成到自己的App中.
 
 
 */


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
    @weakify(self);
    self.homeView.selectAction = ^(NSIndexPath *indexPath) {
        
        @strongify(self);
        MRDevice	*device = self.homeView.viewModel.deviceArr[indexPath.row];
        
        DeviceManagerViewController	*deviceVC = [[DeviceManagerViewController alloc] initWithDevice:device];
        [self.navigationController pushViewController:deviceVC animated:YES];
    };
}


#pragma mark -
#pragma mark Delegate Methods - MRConnecterDelegate

- (void)connecter:(MRConnecter *)connecter didDiscoverDevice:(MRDevice *)device {
//    NSLog(@"device------sn--------%@",device.sn);
    if (device.sn) { //Filter out empty sn （过滤掉空sn）
        
    NSInteger	 index = [self.homeView.viewModel deviceDiscovered:device];
    [self.homeView reloadTableAtIndex:index];
    }
    
}

- (void)connecter:(MRConnecter *)connecter didUpdateDeviceConnectState:(MRDevice *)device {
    
    if (device.sn) { //Filter out empty sn （过滤掉空sn）
        
    NSInteger	 index = [self.homeView.viewModel updateOldDevice:device];
    [self.homeView reloadTableAtIndex:index];
    
    for (DeviceManagerViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[DeviceManagerViewController class]]) {
            vc.device = device;
        }
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
    
    NSLog(@"-----noti------open ble----%d",[MRConnecter defaultConnecter].isCentralPowerOn);
    
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
    //mark test
    NSLog(@"%@ connecte state: %d", device.name, device.connectState);
}




#pragma mark -
#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setUp];
    self.homeView.viewModel = [[MRHomeViewModel alloc] init];
    
    self.usingCustomConnecter = NO;
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
    
    
    double xxxx = 558.9181518554688;
    
    
    NSString * doubleddddd = [NSString stringWithFormat:@"%.1f",xxxx];
    
    
    
    NSLog(@"xxxx============::::%@",@([doubleddddd floatValue]));
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    NSString *string = [formatter stringFromNumber:@(xxxx)];
    NSLog(@"string=======:%@",string);
    
    
    
    
    
    
//    NSArray * ARRAY =  [MRApi getLogsForUpload];
//
//
//    QMRLog(@"--------logPath-------%@",ARRAY);
   
//    NSArray * array = @[
//            @{
//                @"date":@"2023-3-01",
//                @"duration":@"40"
//            },
//            @{
//                @"date":@"2023-3-01",
//                @"duration":@"80"
//            },
//            @{
//                @"date":@"2023-2-28",
//                @"duration":@"40"
//            },
//            @{
//                @"date":@"2023-2-28",
//                @"duration":@"80"
//            },
//            @{
//                @"date":@"2023-2-28",
//                @"duration":@"0"
//            },
//            @{
//                @"date":@"2023-2-28",
//                @"duration":@"200"
//            },
//
//    @{
//                @"date":@"2023-2-28",
//                @"duration":@"100"
//            },
//            @{
//                @"date":@"2023-2-26",
//                @"duration":@"240"
//            },
//           @{
//                @"date":@"2023-2-26",
//                @"duration":@"30"
//            },
//            @{
//                 @"date":@"2023-2-01",
//                 @"duration":@"40"
//             },
//            @{
//                 @"date":@"2023-1-01",
//                 @"duration":@"900"
//             },
//
//
//        ];
    
    
//
//    NSMutableArray *arrayMutable = [NSMutableArray arrayWithArray:array];
//
//    for (NSInteger i = 0; i < arrayMutable.count; i++) {
//
//        for (NSInteger j = i + 1; j < arrayMutable.count; j++) {
//
//            NSDictionary *tempModel = arrayMutable[i];
//
//            NSDictionary *model = arrayMutable[j];
//
//            if ([tempModel[@"date"] isEqualToString:model[@"date"]]) {
//                if ([tempModel[@"duration"] intValue] < [model[@"duration"] intValue]) {
//                    [arrayMutable removeObjectAtIndex:i];
//                    i--;
//                    break;
//                } else {
//                    [arrayMutable removeObjectAtIndex:j];
//                    j--;
//                }
//            }
//        }
//    }
//
//    NSLog(@"arraymutable::::::::%@", arrayMutable);
    
    
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
 //   [self testParseData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
