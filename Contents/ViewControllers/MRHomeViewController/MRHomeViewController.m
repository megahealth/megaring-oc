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

@interface MRHomeViewController () <MRConnecterDelegate>

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
}


#pragma mark -
#pragma mark Notification Methods - kMRCentralStateUpdatedNotification

- (void)MRCentralStateUpdated:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL     isCentralPowerOn = [MRConnecter connecter].isCentralPowerOn;
        
        [MRDefaultView showDefaultViewHidden:isCentralPowerOn];
        
        if (isCentralPowerOn) {
            [self.homeView.viewModel resetModel];
            [[MRConnecter connecter] startScanning];
        } else {
            [self.homeView.viewModel updateAllDevices];
        }
        [self.homeView.tableView reloadData];
    });
}






#pragma mark -
#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setUp];
    self.homeView.viewModel = [[MRHomeViewModel alloc] init];
    [MRConnecter connecter].delegate = self;
    [self setViewActions];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MRCentralStateUpdated:) name:kMRCentralStateUpdatedNotification object:nil];
    
    NSLog(@"SDK version:%s, algorithm:%d", MRFrameworkVersionString, kMRAlgorithmVersion);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self testParseData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.homeView deselectSelectedCell];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
