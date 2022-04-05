//
//  DeviceManagerViewController.m
//  MegaRingBLE
//
//  Created by Superman on 2018/5/14.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "DeviceManagerViewController.h"
#import <MRFramework/MRFramework.h>
#import "DeviceManagerView.h"
#import "DeviceManagerViewModel.h"
#import "DeviceManagerViewController+Methods.h"
#import "DeviceUpgradeViewController.h"
#import "SyncDailyViewController.h"


#define TEST_USER_ID    @"5a4331011579a30038c790de"
//#define TEST_USER_ID    @"c22a674665e1388d020d3c856"

@interface DeviceManagerViewController () <MRDeviceDelegate>

@property (nonatomic, strong) NSMutableData *bpData;
@property (nonatomic, strong) NSDate *bpStart;

@end

@implementation DeviceManagerViewController

#pragma mark -
#pragma mark User Actions

- (void)setUpViewActions {
    __weak typeof(self) weakself = self;
    self.deviceManagerView.selectAction = ^(NSIndexPath *indexPath) {
        switch (indexPath.row) {
            case 0:
                [weakself connectDevice];
                break;
            
            case 1:
                [weakself startLiveData];
                break;
                
            case 2:
                [weakself endLiveData];
                break;
                
            case 3:
                [weakself requestReportData];
                break;
                
            case 4:
                [weakself.device switchToSleepMode];
                break;
                
            case 5:
                [weakself.device switchToSportMode];
                break;
                
            case 6:
//                [weakself.device switchToRealtimeMode];  open realtime  mode //0XD7
                
                [weakself changeMonitorState]; // open spo2 0XD0.
                
                
                break;
                
            case 7:
                [weakself.device switchToNormalModel];
                break;
                
//            case 8:
//                [weakself.device setRawdataEnabled:YES];
//                break;
//
//            case 9:
//                [weakself.device setRawdataEnabled:NO];
//                break;
                
            case 8: {
                DeviceUpgradeViewController *upgrade = [[DeviceUpgradeViewController alloc] initWithDevice:weakself.device];
                [weakself.navigationController pushViewController:upgrade animated:YES];
            }
                break;
            case 9: {
                SyncDailyViewController *daily = [[SyncDailyViewController alloc] initWithDevice:weakself.device];
                [weakself.navigationController pushViewController:daily animated:YES];
                
//                [weakself.device setRawdataEnabled:YES];
                
            }
                break;
                
            case 10: {
                [weakself.device switchToPulseMode];
            }
                break;
                
            case 11:{
                [weakself.device setGLUMode:MRGLUModeInterval5Mins];;
            }
                break;
            case 12: {
                BOOL on = NO;
                int seconds = 60;
                int duration = 60 * 60 * 5;
                BOOL repeat = YES;
                [weakself.device setPeriodicMonitorOn:on afterSeconds:seconds duration:duration repeat:repeat];
            }
                break;
                
            case 13: {
                [weakself.device getMonitorTimer];
            }
                break;
                
            case 14: {
                [weakself.device switchToBPMode];
                weakself.bpData = [NSMutableData new];
                weakself.bpStart = [NSDate date];
            }
                break;
                
            case 15: {
                [weakself requestDailyData];
            }
                break;
                
            default:
                break;
        }
    };
}


#pragma mark -
#pragma mark Delegate Methods - MRDeviceDelegate

- (void)deviceDidUpdateConnectState {
    NSLog(@"connected:%d", self.device.connectState);
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

// [血氧,脉率,有效性,监测时长,accx,accy,accz]
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

#pragma mark -- 模式状态 -- 。
- (void)monitorModeUpdated {
    NSLog(@"monitorModeUpdated:%d", self.device.monitorMode);
    if (self.device.monitorMode == MRDeviceMonitorModeNormal) {
        
    }

    [self.deviceManagerView.viewModel updateMonitorState];
    [self.deviceManagerView refreshView];
}

- (void)operationFailWithErrorCode:(MRErrCode)errCode {
    NSLog(@"err:%X", errCode);
}

#pragma mark ------
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
- (void)bpDataUpdated:(NSData *)data {
    [self.bpData appendData:data];
    NSInteger duration = self.bpData.length / data.length / 10;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"HHmm"];
    int time = [[fmt stringFromDate:self.bpStart] intValue];
    [MRApi parseBPData:self.bpData time:time caliSBP:120 caliDBP:80 block:^(MRBPReport *report, NSError *error) {
        NSLog(@"sbp:%.1f, dbp:%.1f, flag:%d，ecg:%@", report.SBP, report.DBP, report.flag,report.ecg);
        BOOL finish = report.flag == 1;
        BOOL failure = report.flag == 2 || duration >= 60;  // failed or timeout
        if (finish || failure) {
            [self stopBPMode];
        }
    }];
}

- (void)stopBPMode {
    [self.device switchToNormalModel];
}


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
    self.title = NSLocalizedString(MRDevicemanager, nil);
    self.deviceManagerView.viewModel = [[DeviceManagerViewModel alloc] initWithDevice:self.device];
    [self setUpViewActions];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MRCentralStateUpdated:) name:kMRCentralStateUpdatedNotification object:nil];
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
