//
//  DeviceManagerViewController.m
//  MegaRingBLE
//
//  Created by Superman on 2018/5/14.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "DeviceManagerViewController.h"

#import "DeviceManagerView.h"
#import "DeviceManagerViewModel.h"
#import "DeviceManagerViewController+Methods.h"
#import "DeviceUpgradeViewController.h"
#import "SyncDailyViewController.h"
#import "TestBPViewController.h"
#import "MJExtension.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define TEST_USER_ID    @"5a4331011579a30038c790de"
//#define TEST_USER_ID    @"c22a674665e1388d020d3c856"

static const NSInteger kCheckDiscoveredDeviceForConnectionDuration = 5;
static const NSInteger kScanDeviceTimeoutDuration = 30;


@interface DeviceManagerViewController () <MRDeviceDelegate>

@property (nonatomic, strong) NSMutableData *bpData;
@property (nonatomic, strong) NSDate *bpStart;

@property (nonatomic, strong) NSTimer *scanTimer;
@property (nonatomic, assign) NSInteger scanTimerCount;

@property (nonatomic, strong)UIButton * reconnectBtn;

@end

@implementation DeviceManagerViewController


-(UILabel *)titleNavView {
    if (_titleNavView == nil) {
        _titleNavView  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width - 100, 30)];
        _titleNavView.font = [UIFont boldSystemFontOfSize:12];
        _titleNavView.textAlignment = 1;
        _titleNavView.textColor = [UIColor redColor];
        
    }
    return _titleNavView;
}

-(UIButton *)reconnectBtn {
    if (_reconnectBtn == nil) {
        _reconnectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reconnectBtn.frame = CGRectMake(0, 0, 60, 30);
        [_reconnectBtn addTarget:self action:@selector(buttonClickReconnect:) forControlEvents:UIControlEventTouchUpInside];
        [_reconnectBtn setTitle:NSLocalizedString(MRClickReconnect, nil) forState:UIControlStateNormal];
        [_reconnectBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _reconnectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _reconnectBtn.hidden = YES;
    }
    return _reconnectBtn;
}

#pragma mark -
#pragma mark User Actions

- (void)setUpViewActions {
//    __weak typeof(self) weakself = self;
    
//    @strongify(self);
    
    @weakify(self);
    self.deviceManagerView.selectAction = ^(NSIndexPath *indexPath) {
        @strongify(self);
        
        switch (indexPath.row) {
            case 0:
                [self connectDevice];
                break;
            
            case 1:
                [self startLiveData];
                
//                [self.device setRawdataEnabled:YES]; // You can open it to receive raw data
                

                break;
                
            case 2:
                [self endLiveData];
                
                break;
                
            case 3:
//                [weakself requestReportData];
                
                
                // sleep hrv ... data  You can view the notes of HRV and other data obtained by this test method
                [self requestDailySleepHRVSportDataTest];
                
                 //  Obtain HRV data through separate test
                 // [weakself requestReportDataTestType:MHBLEDataRequestTypeHRV];
                
            
                break;
                
            case 4:
                [self.device switchToSleepMode];
                
                break;
                
            case 5:
                [self.device switchToSportMode];
                break;
                
            case 6:
                
                [self.device switchToRealtimeMode];  //open realtime  mode //0XD7  See the notes below.
                /***
                 
                 1.If you need data, you can turn on sleep monitoring.With the ring, 82s it will generate valid data;
                 
                 2.If you don't need data, you can turn on real-time monitoring mode，And view real-time data changes.
                 
                 3. When the sleep mode is turned on for at least 30 minutes, the sleep data can be obtained.
                 
                 */
                                
                // [weakself changeMonitorState];  or  [weakself.device switchToSleepMode];
                
//                [self.device switchToSleepMode]; // open sleep get data （spo2 0XD0）
                break;
                
            case 7:
                [self.device switchToNormalModel];
                break;
                
                
            case 8: {
                DeviceUpgradeViewController *upgrade = [[DeviceUpgradeViewController alloc] initWithDevice:self.device];
                [self.navigationController pushViewController:upgrade animated:YES];
            }
                break;
            case 9: {
                SyncDailyViewController *daily = [[SyncDailyViewController alloc] initWithDevice:self.device];
                [self.navigationController pushViewController:daily animated:YES];
            }
                break;
                
            case 10: {
                [self.device switchToPulseMode];
            }
                break;
                
            case 11:{
                [self.device setGLUMode:MRGLUModeInterval5Mins];;
            }
                break;
            case 12: {
                BOOL on = NO;
                int seconds = 60;
                int duration = 60 * 60 * 5;
                BOOL repeat = YES;
                [self.device setPeriodicMonitorOn:on afterSeconds:seconds duration:duration repeat:repeat];
            }
                break;
                
            case 13: {
                [self.device getMonitorTimer];
            }
                break;
                
            case 14: {
//                [weakself.device switchToBPMode];
//                weakself.bpData = [NSMutableData new];
//                weakself.bpStart = [NSDate date];
                
// test:    View the measurement of test blood pressure and how the ECG UI plots.
                
                if (self.device.bloodPressureSupported) { // is if support bloodPressure?   (.bloodPressureSupported)
                    TestBPViewController *vc = [[TestBPViewController alloc] init];
                 
                     vc.device = self.device;
                    
                    if (self.device.deviceOK == YES) { // device is ok
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    
                   
                }else
                {
                    
                    NSLog(@"This ring does not support blood pressure monitoring function for the time being");
                    
                    
                }
                
            }
                break;
                
            case 15: {
                
                NSLog(@"This method has been transferred-----see  Line 4: Click Sync data (data collection process)  zh：直接查看第四行，收取数据的过程");
//                [self requestDailyData];
            }
                break;
                
            default:
                break;
        }
    };
}
//- (BOOL)bloodPressureSupported {
//    NSString *version = self.sw;
//    BOOL valid = [version hasPrefix:@"5."];
//    return valid;
//}


#pragma mark Delegate Methods - MRDeviceDelegate

- (void)deviceDidUpdateConnectState {
    NSLog(@"connected:%d", self.device.connectState);
    
    self.titleNavView.text = (self.device.connectState == 2) ? NSLocalizedString(MRDeviceConnected, nil) :NSLocalizedString(MRDeviceDisReconnecting, nil);
    
    [self.deviceManagerView.viewModel reloadModel];
    [self.deviceManagerView refreshView];
}

- (void)deviceIsReady:(BOOL)isReady {
    NSLog(@"ready:%d", isReady);
    [self.deviceManagerView.viewModel reloadModel];
    [self.deviceManagerView refreshView];
}

- (void)bindDeviceResp:(MRBindResp)bindResp {
    switch (bindResp) {
        case MRBindRespNew:
            [self showAlertWithTitle:NSLocalizedString(MRConnectNewAlert, nil) dissmissAfterDelay:2];
            break;
            
        case MRBindRespOld:
            [self showAlertWithTitle:NSLocalizedString(MRConnectOldAlert, nil) dissmissAfterDelay:2];
            break;
            
        case MRBindRespShake:
            [self showAlertWithTitle:NSLocalizedString(MRShakeToPairAlert, nil) dissmissAfterDelay:10];
            break;
            
        case MRBindRespLowPower:
            [self showAlertWithTitle:NSLocalizedString(MRLowBatteryAlert, nil) dissmissAfterDelay:2];
            break;
            
        case MRBindRespChangeUser:
            [self changeUserAlert];
            break;
            
        case MRBindRespError:
            break;
            
        default:
            break;
    }
}

- (void)finishBindingWithToken:(NSString *)token {
    NSLog(@"new token:%@, sn:%@", token, self.device.sn);
    [self saveBindToken:token];
}

- (nullable NSString *)bindToken {
    NSLog(@"use token:%@", [self cachedBindToken]);
    return [self cachedBindToken];
}

- (NSString *)bindUserIdentifier {
    NSLog(@"user:%@", TEST_USER_ID);
    return TEST_USER_ID;
}

- (NSArray *)bindUserInfo {
    return @[@30, @0, @170, @60];
}

- (void)deviceTimeUpdated:(int)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSLog(@"device time: %@", date);
}

- (void)deviceInfoUpdated {
    [self.deviceManagerView.viewModel reloadModel];
    [self.deviceManagerView refreshView];
}

- (void)deviceBatteryUpdated {
    [self.deviceManagerView.viewModel updateBattery];
    [self.deviceManagerView refreshView];
}

// [SpO2,heart rate,valid,duration,accx,accy,accz]
- (void)liveDataValueUpdated:(NSArray *)liveData {
    NSString *liveDataStr = [NSString stringWithFormat:@"sp:%@, hr:%@, state:%@, duration:%@, accx:%@, accy:%@, accz:%@", liveData[0], liveData[1], liveData[2], liveData[3], liveData[4], liveData[5], liveData[6]];
    NSLog(@"live:%@", liveDataStr);
    
    [self.deviceManagerView.viewModel updateLiveDataValue:liveData];
    [self.deviceManagerView refreshView];
}

- (void)monitorStateUpdated {
    NSLog(@"monitorStateUpdated:%d", self.device.isMonitorOn);
    [self.deviceManagerView.viewModel updateMonitorState];
    [self.deviceManagerView refreshView];
}

#pragma mark -- Devie  delegate :  After the mode switching, what needs to be done in which modes after the proxy connection is successful
- (void)monitorModeUpdated {
    NSLog(@"DeviceManagerViewController --  monitorModeUpdated:%d", self.device.monitorMode);
    
    // test :
    
    if ((self.device.monitorMode == MRDeviceMonitorModeIdle || self.device.monitorMode == MRDeviceMonitorModeNormal) && self.device.isDownloadingData == NO) {

        [self requestDailySleepHRVSportDataTest];   //MARK: ---    Get ring data synchronously , Make sure to clear the data in the ring before starting the monitoring (that is, check the data in the ring)
        
    }else if (self.device.monitorMode == MRDeviceMonitorModeSleep || self.device.monitorMode == MRDeviceMonitorModeSport){
        
        [self startLiveData]; // is if open liveData ？
        
    }else {
        //.....
        
    }
    
    [self.deviceManagerView.viewModel updateMonitorState];
    [self.deviceManagerView refreshView];
}

#pragma mark -- 1. start scanning --

- (void)startScanningDevice {
    
    if ([MRConnecter defaultConnecter].centralManager.isScanning  == NO && self.device.connectState == MRDeviceStateDisconnected && [MRConnecter defaultConnecter].isCentralPowerOn == YES) {
        
        [[MRConnecter defaultConnecter] startScanning];
        if (self.scanTimer.valid == NO) {
            self.scanTimerCount = 0;
            self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scanTimerAction:) userInfo:nil repeats:YES];
        }
    }
      QMRLog(@"scan timer valid:%d", self.scanTimer.isValid);
}
#pragma mark -- 2. timer method.
- (void)scanTimerAction:(NSTimer *)timer {
    
    self.scanTimerCount ++;
// :    5s -- connect device....
    if (self.scanTimerCount % kCheckDiscoveredDeviceForConnectionDuration == 0) {
        [self connectNearestDevice];
    }
    if (self.scanTimerCount > kScanDeviceTimeoutDuration) {
        NSLog(@"scanceTimeCount------> 30s  - stop scanning...");
        [self stopScanningDevcie];
    }
}
#pragma mark -- stop  scanning -- > 30s    Click by yourself  Reconnect ^-^
- (void)stopScanningDevcie {
    
    NSLog(@"----[MRConnecter defaultConnecter].centralManager.isScanning======%d",[MRConnecter defaultConnecter].centralManager.isScanning);
    if ([MRConnecter defaultConnecter].centralManager.isScanning) {
        
        NSLog(@"isscansing----------1---");
        self.titleNavView.text = NSLocalizedString(MRDeviceDisconnected, nil);
        self.reconnectBtn.hidden = NO;
        self.scanTimerCount = 0;
        [[MRConnecter defaultConnecter] stopScanning];
        
    }
    [self.scanTimer invalidate];
     QMRLog(@"scan timer valid:%d", self.scanTimer.isValid);
}
#pragma mark = connect  device
- (void)connectNearestDevice {
    
    MRDevice *device = [self getNearestDevice];
    QMRLog(@"start connect:%@", device);
    [self stopScanningDevcie];
    [[MRConnecter defaultConnecter]connectDevice:device];
}

#pragma mark --- get near device...
- (MRDevice *)getNearestDevice {

    MRDevice *near = nil;
    
    for (MRDevice * nearDevice in [MRConnecter defaultConnecter].discoveredDevices) {
        
        if ([nearDevice.sn isEqualToString:self.device.sn]) {
            
            NSLog(@"======have old device===");
            
            near = nearDevice;
            
            break;
            
        }
    }
    
    return near;
}

- (void)operationFailWithErrorCode:(MRErrCode)errCode {
    NSLog(@"err:%X", errCode);
}

#pragma mark ------ raw data --
- (void)rawdataUpdated:(NSArray<MRRawData *> *)arr {
    NSLog(@"---rawData-------%@", arr);
}

- (void)didSetPeriodicMonitorState:(MRPeriodicMonitorState)state start:(NSString *)start duration:(int)duration repeat:(BOOL)repeat {
    NSLog(@"set perioidic state:%d repeat:%d start:%@ duration:%d", state, repeat, start, duration);
}

- (void)didGetPeriodicMonitorState:(MRPeriodicMonitorState)state start:(NSString *)start duration:(int)duration repeat:(BOOL)repeat {
    NSLog(@"get perioidic state:%d repeat:%d start:%@ duration:%d", state, repeat, start, duration);
}

/// data of blood pressure
//- (void)bpDataUpdated:(NSData *)data {
//    [self.bpData appendData:data];
//    NSInteger duration = self.bpData.length / data.length / 10;
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    [fmt setDateFormat:@"HHmm"];
//    int time = [[fmt stringFromDate:self.bpStart] intValue];
//    @weakify(self);
////  caliSBP: caliDBP:  Highest range value of DBP and SBP parsed
//    [MRApi parseBPData:self.bpData time:time caliSBP:120 caliDBP:80 block:^(MRBPReport *report, NSError *error) {
//        @strongify(self);
//
//        NSLog(@"sbp:%.1f, dbp:%.1f, flag:%d，ecg:%@", report.SBP, report.DBP, report.flag,report.ecg);
//        BOOL finish = report.flag == 1;
//        BOOL failure = report.flag == 2 || duration >= 60;  // failed or timeout
//        if (finish || failure) {
//            [self stopBPMode];
//        }
//
//        if (failure) {
//            NSLog(@"failure!");
//        }
//        if (finish) {
//            NSLog(@"finished"); // and you can save the report data.
//        }
//
//    }];
//}

//- (void)stopBPMode {
//    [self.device switchToNormalModel];
//}


#pragma mark -
#pragma mark Notification Methods - kMRCentralStateUpdatedNotification

- (void)MRCentralStateUpdated:(NSNotification *)noti {}


#pragma mark -
#pragma mark Life Cycle

- (instancetype)initWithDevice:(MRDevice *)device {
    if (self = [super init]) {
        self.device = device;
    }
    return self;
}

- (void)setDevice:(MRDevice *)device {
    _device = device;
    device.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleNavView.text = NSLocalizedString(MRDevicemanager, nil);
//    test mark
    self.shouldSyncData = YES;
    
    self.navigationItem.titleView = self.titleNavView;
    
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc]initWithCustomView:self.reconnectBtn];
    
    self.navigationItem.rightBarButtonItem = barItem;
    
    self.deviceManagerView.viewModel = [[DeviceManagerViewModel alloc] initWithDevice:self.device];
    [self setUpViewActions];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MRCentralStateUpdated:) name:kMRCentralStateUpdatedNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceConnecteStateUpdated:) name:MRDeviceConnectStateUpdatedNotification object:nil];
    
// test use hrvData....
    
//  NSDictionary * dict =  [[NSUserDefaults standardUserDefaults]objectForKey:@"testHRVData"];
//    
//    
//    QMRLog(@"dict------------%@",dict);
//    
//    MRReport * report = [MRReport mj_objectWithKeyValues:dict];
//    
}

#pragma mark -- reconnect ---
-(void)buttonClickReconnect:(UIBarButtonItem *)item {
    
    self.titleNavView.text =  NSLocalizedString(MRDeviceDisReconnecting, nil);
    
//     @"Device disconnected，Reconnecting...";
    
    [self startScanningDevice];
}

#pragma mark --    connect notificationi --
-(void)deviceConnecteStateUpdated:(NSNotification *)noti {
    
    MRDevice *device = noti.object;
    ///test mark Need to synchronize monitoring data
    self.shouldSyncData = YES;
    
    if (device.connectState == MRDeviceStateConnected) {
        device.isDownloadingData = NO;
        NSLog(@"connect successed");
        self.reconnectBtn.hidden = YES;
        [self stopScanningDevcie];
        
    }else if(device.connectState == MRDeviceStateDisconnected){
      
//MARK:    ---  After the device is disconnected, start scanning the connection
        NSLog(@"disconnected");
        [self startScanningDevice];
        
    }else{
        
        
        
        
    }
    
    NSLog(@"%@ connecte state: %d", device.name, device.connectState);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self test];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)test {
    typedef union _frame_control_t {
        struct frame_t {
            uint16_t reserved : 3;      //保留
            uint16_t priority : 2;      //事件优先级:0-3
            uint16_t identify : 1;      //一般用于设备注册时辨别设备使用
            uint16_t connect : 1;       //有数据需要同步
            uint16_t has_mac : 1;       //是否有 MAC Address

            uint16_t encrypted : 1;     //报文是否已加密
            uint16_t bind : 1;          //是否已经绑定
            uint16_t frame_type : 2;    //报文类型
            uint16_t version : 4;       //AIOT 蓝牙协议版本号
        } frame;
        uint8_t udata[2];
    } frame_control_t;
    
    Byte buffer[] = {0x90, 0x00, 0x13, 0x98};
    
    frame_control_t frame = *(frame_control_t *)(buffer+1);
    
    printf("bind:%d", frame.frame.bind);
}







@end
