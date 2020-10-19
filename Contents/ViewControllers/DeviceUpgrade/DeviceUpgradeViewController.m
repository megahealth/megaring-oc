//
//  DeviceUpgradeViewController.m
//  MegaRingBLE
//
//  Created by cheng cheng on 2019/10/24.
//  Copyright © 2019 Superman. All rights reserved.
//

#import "DeviceUpgradeViewController.h"
#import <MRFramework/MRFramework.h>
#import "SSZipArchive.h"


@interface DeviceUpgradeViewController () <MRDeviceUpgraderDelegate>

@property (weak, nonatomic) IBOutlet UILabel *CurrentBoot;
@property (weak, nonatomic) IBOutlet UILabel *CurrentSoftware;
@property (weak, nonatomic) IBOutlet UILabel *targetVersion;
@property (weak, nonatomic) IBOutlet UILabel *upgradeState;
@property (weak, nonatomic) IBOutlet UIButton *start;

@property (nonatomic, strong) MRDevice *device;

@property (nonatomic, copy) NSString *firmwareZip;




@end

@implementation DeviceUpgradeViewController

- (instancetype)initWithDevice:(MRDevice *)device {
    if (self = [super init]) {
        self.device = device;
        [MRDeviceUpgrader defaultInstance].delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(MRDeviceUpgrade, nil);
    [self checkDeviceState];
}

- (IBAction)startUpgradeClicked:(UIButton *)sender {
    if ([self checkDeviceState]) {
        [self getFirmwareFilesCallback:^(NSString *firmware, NSError *error) {
            if (error) {
                [self updateState:error.localizedDescription];
            } else {
                [MRDeviceUpgrader defaultInstance].device = self.device;
                [MRDeviceUpgrader defaultInstance].firmware = firmware;
                [[MRDeviceUpgrader defaultInstance] start];
            }
        }];
    }
}

- (BOOL)checkDeviceState {
    BOOL deviceState = NO;
    if (self.device != nil) {
        self.CurrentBoot.text = self.device.btVersion;
        self.CurrentSoftware.text = self.device.swVersion;
        self.targetVersion.text = self.firmwareZip.lastPathComponent;
        if (self.device.connectState == MRDeviceStateConnected) {
            deviceState = YES;
        } else {
            [self updateState:NSLocalizedString(MRDisconnected, nil)];
        }
    } else {
        [self updateState:NSLocalizedString(MRUpgradeNODevice, nil)];
    }
    
    return deviceState;
}

- (void)getFirmwareFilesCallback:(void (^)(NSString *firmware, NSError *error))block {
    NSString    *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString    *unzipPath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"MegaFirmware"]];
    NSFileManager *fManager = [NSFileManager defaultManager];
    [fManager removeItemAtPath:unzipPath error:nil];
    
    [SSZipArchive unzipFileAtPath:self.firmwareZip toDestination:unzipPath progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
    } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
        block(unzipPath, error);
    }];
}

- (NSString *)firmwareZip {
    NSString *zipName = @"MegaRingV3_V9880.zip";
    NSString *zipPath = [[NSBundle mainBundle] pathForResource:zipName ofType:nil];
    return zipPath;
}



// MARK: MRDeviceUpgraderDelegate

- (void)upgradeStateUpdated:(MRUpgradeState)state {
    NSLog(@"upgradeStateUpdated:%d", state);
    self.start.enabled = state == MRUpgradeStateNone || state == MRUpgradeStateFinish;
    switch (state) {
        case MRUpgradeStateNone:
            break;
            
        case MRUpgradeStateStart:
            [self updateState:NSLocalizedString(MRUpgradeStarted, nil)];
            break;
            
        case MRUpgradeStateReconnecting:
            [self updateState:NSLocalizedString(MRUpgradeReconnecting, nil)];
            break;
            
        case MRUpgradeStateReconnected:
            [self updateState:NSLocalizedString(MRUpgradeReconnected, nil)];
            break;
            
        case MRUpgradeStateSendData:
            [self updateState:NSLocalizedString(MRUpgradeStartData, nil)];
            break;
            
        case MRUpgradeStateFinish:
            [self updateState:NSLocalizedString(MRUpgradeFinished, nil)];
            [[MRDeviceUpgrader defaultInstance] stop];
            break;
            
        case MRUpgradeStateFail:
            [self updateState:NSLocalizedString(MRUpgradeFailed, nil)];
            break;
            
        default:
            break;
    }
}

- (void)dataProgressUpdated:(float)progress {
    NSLog(@"dataProgressUpdated:%f", progress);
    NSString *state = [NSString stringWithFormat:@"%@:%.f%%", NSLocalizedString(MRUpgradeSendingData, nil), progress*100];
    [self updateState:state];
}




// MARK: UI

- (void)updateState:(NSString *)state {
    self.upgradeState.text = state;
}






@end
