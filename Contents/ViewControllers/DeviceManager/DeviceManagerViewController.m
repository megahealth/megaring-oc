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

#import <CoreBluetooth/CoreBluetooth.h>

#import "SleepReportViewController.h"
#import "WorkoutReportViewController.h"

#import "HRVReportViewController.h"
#import "MRDeviceManager.h"

#define TEST_USER_ID    @"61a9c462706cde30f53f420a" // I
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
//              Ruh.amoto.25.34@gmail.com
//                Puru-0720@i.softbank.jp
//                Yusk18-kinyoku6@ezweb.ne.jp
                break;
                
            case 2:
//                [self endLiveData];
                [self.device setRawdataEnabled:YES];
                break;
                
            case 3:
                // 【请查看 点击 关闭监测 收取数据的过程】
                NSLog(@"(请查看 点击关闭监测时 收取数据的过程) Please view the process of collecting data when clicking 'close monitoring'");
                
                // sleep hrv ... data  You can view the notes of HRV and other data obtained by this test method
                
                [self requestDailySleepHRVSportDataTest];
                
                break;
                
            case 4:
                if (self.device.batState == MRBatteryStateNormal) {
                    // When the power is normal, turn on the monitoring 电量正常时，开启监测.
                    [self.device switchToSleepMode]; // open sleep.
                }
                
                break;
                
            case 5:
                
                if (self.device.batState == MRBatteryStateNormal) {
                    // When the power is normal, turn on the monitoring 电量正常时，开启监测.
                    [self.device switchToSportMode];
                }
                break;
                
            case 6:
                
                if (self.device.batState == MRBatteryStateNormal) {
                    // When the power is normal, turn on the monitoring 电量正常时，开启监测.
                    [self.device switchToRealtimeMode];
                    
                    
                    
//                    [self.device setRawdataEnabled:YES];
//                    [self startLiveData];
                    
                    
                }
                
                 //open realtime  mode //0XD7  See the notes below. 查看下面的说明.
                /***
                 en:
                 
                 1.If you need data, you can turn on sleep monitoring.With the ring, 82s it will generate valid data;
                 
                 2.If you don't need data, you can turn on real-time monitoring mode，And view real-time data changes.
                 
                 3. When the sleep mode is turned on for at least 30 minutes, the sleep data can be obtained.
                 
                 
                 zh：
                 1.如果您需要数据，可以打开睡眠监测。使用环，大于82秒将生成有效数据；
                 2.如果您不需要数据，可以打开实时监控模式，并查看实时数据。
                 3.当睡眠模式打开至少30分钟时，可以获取睡眠数据。
                 
                 
                 */
                                
                // [weakself changeMonitorState];  or  [weakself.device switchToSleepMode];
                
//                [self.device switchToSleepMode]; // open sleep get data （spo2 0XD0）
                break;
                
            case 7:
                
                if (self.device.monitorMode == MRDeviceMonitorModeSleep || self.device.monitorMode == MRDeviceMonitorModeSport || self.device.monitorMode == MRDeviceMonitorModeRealTime) {
                    
                    [self.device switchToNormalModel]; // Turn off monitoring
                }
                
               
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
                [self startScanningDevice];
                
//                [self.device getMonitorTimer];
            }
                break;
                
            case 14: {
                
// test:   ZG(28)  Circul+ Ring  View the measurement of test blood pressure and how the ECG UI plots.
                
                if (self.device.bloodPressureSupported && self.device.batState == MRBatteryStateNormal) { // is if support bloodPressure? --- Circul+ ring support bloodPressure      (.bloodPressureSupported)  ----- （zh: 指环是否支持血压功能，电量正常时---只有Circul+ （ZG28）指环支持血压功能）
                    TestBPViewController *vc = [[TestBPViewController alloc] init];
                 
                     vc.device = self.device;
                    
                    if (self.device.deviceOK == YES) { // device is ok （zh：指环的硬件是ok的。）
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    
                }else
                {
                    
                    NSLog(@"This ring does not support blood pressure monitoring function for the time being");
                    
                    
                }
                
            }
                break;
                
            case 15: {
                
//                NSLog(@"This method has been transferred-----see  Line 4: Click Sync data (data collection process  Or click to close the process of collecting data during monitoring)  Method:   [self requestDailySleepHRVSportDataTest];   zh：直接查看第四行，收取数据的过程 或点击 关闭监测时 收取数据的过程.....");
//                [self requestDailyData];
                
              
                
                
              //  *************
                
//  1. sleep
                NSDictionary  * dict  =  [[NSUserDefaults standardUserDefaults]objectForKey:TEST_SAVE_SLEEP_DATA_KEY];
        
//  2. hrv             NSDictionary  * dict  =  [[NSUserDefaults standardUserDefaults]objectForKey:TEST_SAVE_HRV_DATA_KEY];  // 获取测试的hrv数据.
//  3. sport            NSDictionary  * dict  =  [[NSUserDefaults standardUserDefaults]objectForKey:TEST_SAVE_SPORT_DATA_KEY]; // 获取sport数据.
                
                if (dict == nil) {
                    [self.view makeToast:@"Report Data == nil，Please check again after retesting" duration:2 position:CSToastPositionCenter];
                    return;
                }
                
/***
 
 Turn on or off the comments below， you see all reports For UI.... (打开或关闭下面的注释，您可以去查看各个报告的UI.)
 
 
 */

                MRReport * report = [MRReport mj_objectWithKeyValues:dict];
                
                //1. see sleep report detail
                     SleepReportViewController * vc = [[SleepReportViewController alloc]initWithReport:report];
                              
                //2. see  hrv report detail
//                     HRVReportViewController * vc = [[HRVReportViewController alloc]initWithReport:report];
                
                //3. see sport report
//                    WorkoutReportViewController * vc = [[WorkoutReportViewController alloc]initWithReport:report];
                
                    [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
                
            default:
                break;
        }
    };
}

#pragma mark Delegate Methods - MRDeviceDelegate
// device connect state delegate
- (void)deviceDidUpdateConnectState {
    NSLog(@"-------------connected:%d", self.device.connectState);
//deviceConnecteStateUpdated:
    [self.deviceManagerView.viewModel reloadModel];
    [self.deviceManagerView refreshView];
}

- (void)deviceIsReady:(BOOL)isReady {
    NSLog(@"ready:%d", isReady);
    [self.deviceManagerView.viewModel reloadModel];
    [self.deviceManagerView refreshView];
}

#pragma mark -- bind ---
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
#pragma mark -- Token returned after successful binding . (绑定成功后，返回的token)
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

#pragma mark -- Read the information of the ring .
/***
 *  You can view the btversion ，hwVersion,sw..
 *  deviceOK..
 *
 */
- (void)deviceInfoUpdated {
    [self.deviceManagerView.viewModel reloadModel];
    [self.deviceManagerView refreshView];
}
#pragma mark device battery charge information
/**
 self.device.batState  == ??
 
 typedef NS_ENUM(Byte, MRBatteryState) {
     MRBatteryStateNormal                = 0x00, (MRBatteryNormal) (== 0, normal-- 电量正常)
     MRBatteryStateCharging,   // ==0x01(Charging --- 充电中)
     MRBatteryStateFull,    //  == 0x02(full -- 充满)
     MRBatteryStateLowPower, /(== 0x03 low power --- 低电)
     MRBatteryStateError, // = 4(eror -- 电池出现问题，错误)
     MRBatteryStateShutdown, //= 5 (shut down -- 摇摆)
 };
 */
// see self.device.batState=?  and self.device.batValue = ?
- (void)deviceBatteryUpdated {
    
    NSLog(@"self.device.batState------------%d-------self.dive.batValue---%d",self.device.batState,self.device.batValue);
    
    [self.deviceManagerView.viewModel updateBattery];
    [self.deviceManagerView refreshView];
}

// [SpO2,heart rate,valid,duration,accx,accy,accz, breath rate]
- (void)liveDataValueUpdated:(NSArray *)liveData {
    NSString *liveDataStr = [NSString stringWithFormat:@"sp:%@, hr:%@, state:%@, duration:%@, accx:%@, accy:%@, accz:%@, breathRate: %@", liveData[0], liveData[1], liveData[2], liveData[3], liveData[4], liveData[5], liveData[6], liveData[7]];
    NSLog(@"-----live:%@", liveDataStr);
    
    [self.deviceManagerView.viewModel updateLiveDataValue:liveData];
    [self.deviceManagerView refreshView];
}

- (void)monitorStateUpdated {
    NSLog(@"monitorStateUpdated:%d", self.device.isMonitorOn);
    [self.deviceManagerView.viewModel updateMonitorState];
    [self.deviceManagerView refreshView];
}

/***
zh： 1. 测试：
    1.1 点击关闭监测，查看数据的收取;
    1.2 点击断开设备，查看重连过程；
    1.3 上电，查看重连及收取数据；
    ......
    查看 self.titleNavView.text 的变化.
 
en： 1. Test:
     1.1 click close monitoring to view data collection;
     1.2 click disconnect device to view the reconnection process;
     1.3 power on, check reconnection and collect data;
     ......
      See the change of 'self.titleNavView.text'.
 
 收取数据，扫描，重连等简单过程,如下 (Simple processes such as data collection, scanning and reconnection are as follows:)
 
 */

#pragma mark -- Devie  delegate :  After the mode switching, what needs to be done in which modes after the proxy connection is successful
// en: 模式切换后，代理连接成功后，在哪些模式下需要做什么
- (void)monitorModeUpdated {
    NSLog(@"DeviceManagerViewController --  monitorModeUpdated:%d", self.device.monitorMode);
    
    // test :
    BOOL isBatteryOKAndGetData = self.device.batState == MRBatteryStateFull || self.device.batState == MRBatteryStateCharging || self.device.batState == MRBatteryStateNormal; // Full charge, charging, data collection under normal conditions  （电量满，充电中，正常时 收取数据）
    
    if ((self.device.monitorMode == MRDeviceMonitorModeIdle || self.device.monitorMode == MRDeviceMonitorModeNormal) && self.device.isDownloadingData == NO && isBatteryOKAndGetData) {

        [self requestDailySleepHRVSportDataTest];   //MARK: ---    Get ring data synchronously , Make sure to clear the data in the ring before starting the monitoring (that is, check the data in the ring)
        
    }else if (self.device.monitorMode == MRDeviceMonitorModeSleep || self.device.monitorMode == MRDeviceMonitorModeSport || self.device.monitorMode == MRDeviceMonitorModeRealTime){
        self.shouldSyncData = YES;
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
    MRDevice *device = [self getNearestOldDevice];
    QMRLog(@"start connect:%@", device);
    [[MRConnecter defaultConnecter] connectDevice:device];
}

#pragma mark --- get near device...
- (MRDevice *)getNearestOldDevice {
    MRDevice *near = nil;
    for (MRDevice * nearDevice in [MRConnecter defaultConnecter].discoveredDevices) {
        if ([nearDevice.sn isEqualToString: self.device.sn]) {
            NSLog(@"======have old device===");
            near = nearDevice;
            self.device = nearDevice;
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

- (void)rawdataUpdatedData:(NSData *)data {
    NSLog(@"----rawData---%@", data);
}

- (void)didSetPeriodicMonitorState:(MRPeriodicMonitorState)state start:(NSString *)start duration:(int)duration repeat:(BOOL)repeat {
    NSLog(@"set perioidic state:%d repeat:%d start:%@ duration:%d", state, repeat, start, duration);
}

- (void)didGetPeriodicMonitorState:(MRPeriodicMonitorState)state start:(NSString *)start duration:(int)duration repeat:(BOOL)repeat {
    NSLog(@"get perioidic state:%d repeat:%d start:%@ duration:%d", state, repeat, start, duration);
}

#pragma mark -
#pragma mark Notification Methods - kMRCentralStateUpdatedNotification

- (void)MRCentralStateUpdated:(NSNotification *)noti {}


#pragma mark -
#pragma mark Life Cycle

- (instancetype)initWithDevice:(MRDevice *)device {
    if (self = [super init]) {
        self.device = device;
        [MRDeviceManager sharedDeviceManager].managerDevice = device;
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
}

#pragma mark --click  reconnect ---
-(void)buttonClickReconnect:(UIBarButtonItem *)item {
    self.titleNavView.text =  NSLocalizedString(MRDeviceDisReconnecting, nil);
//     @"Device disconnected，Reconnecting...
    [self startScanningDevice];
}

#pragma mark --    connect notificationi --
-(void)deviceConnecteStateUpdated:(NSNotification *)noti {
    
    
    
    NSLog(@"woowowwo-----deviceConnecteStateUpdated:---------");
    
    
    MRDevice *device = noti.object;
    ///test mark Need to synchronize monitoring data
    self.shouldSyncData = YES;
    self.titleNavView.text = (self.device.connectState == 2) ? NSLocalizedString(MRDeviceConnected, nil) :NSLocalizedString(MRDeviceDisReconnecting, nil);
    
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
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
