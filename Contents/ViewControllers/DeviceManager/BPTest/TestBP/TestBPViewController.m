//
//  TestBPViewController.m
//  BHealth
//
//  Created by cheng cheng on 2/6/2021.
//  Copyright © 2021 zhaoguan. All rights reserved.
//

#import "TestBPViewController.h"
#import "TestBPView.h"
#import <MRFramework/MRFramework.h>
#import "BPReportViewController.h"
#import "MJExtension.h"

@interface TestBPViewController ()<MRDeviceDelegate>
@property (strong, nonatomic) IBOutlet TestBPView *_view;
//@property (nonatomic, strong) AVPatient *patient;
@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSMutableData *data;

@end

@implementation TestBPViewController

#pragma mark --- go helpVc。
- (IBAction)helpButtonClick:(UIButton *)sender {
//    HDMeasureBloodPressureHelpVC * vc = [HDMeasureBloodPressureHelpVC new];
//    [self.navigationController pushViewController:vc animated:YES];
//
}

- (IBAction)stopTesting:(id)sender {
    [self stop];
    [self leave];
}


- (IBAction)submitClicked:(UIButton *)sender {
        int sbp = self._view.SBP;
        int dbp = self._view.DBP;
    [[NSUserDefaults standardUserDefaults]setValue:@(sbp) forKey:@"UserID_SBP"];
    
    [[NSUserDefaults standardUserDefaults]setValue:@(dbp) forKey:@"UserId_DBP"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self leave];
    
    return;
    
//    static BOOL updating = NO;
//    if (updating == YES) {
//        return;
//    }
//    int sbp = self._view.SBP;
//    int dbp = self._view.DBP;
//    BOOL valid = sbp <= kMaxBPValue && dbp >= kMinBPValue && sbp > dbp;
//    if (valid == NO) {
//        [HUDView textHUD:kBPInvalidAlert detail:nil onView:self.view];
//        return;
//    }
//
}

#pragma mark -- finish jump   ----- BPReportVc  test..
- (IBAction)finishClicked:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"Complete"]) {
        
        NSDictionary * dict  = [[NSUserDefaults standardUserDefaults]objectForKey:@"BPReportData"];
        
        MRBPReport * report = [MRBPReport mj_objectWithKeyValues:dict];
        
        BPReportViewController * vc = [[BPReportViewController alloc]initWithReport:report];
        int time = [stringFromDate(self.start, @"HHmm") intValue];
        vc.parseTime = time;
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
        
//        [self stop];
//        [self leave];
    }else{
        [self startBP];
        self._view.progress = TestBPProgressReady;
    }
}

- (IBAction)restartCLicked:(UIButton *)sender {
    [self startBP];
    self._view.progress = TestBPProgressReady;
}

- (IBAction)reEditClicked:(UIButton *)sender {
    self._view.progress = TestBPProgressEditBP;
}

// MARK: data & methods
- (void)prepareData {
    
    self._view.skipEditBP = YES;
//    test : dbp --- 
   NSNumber * dbp = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserID_DBP"];
    NSNumber * sbp = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserID_SBP"];
    
    
    self._view.SBP =  sbp ? sbp.intValue : 120;
    self._view.DBP =  dbp ? dbp.intValue : 80;
    self._view.hasHBP = NO;
    
}

- (void)startBP {
    [self.device switchToBPMode];
    self.data = [NSMutableData data];
    self.start = [NSDate date];
    [self._view updateStartTime:self.start];
    self._view.progress = TestBPProgressTesting;
}

- (void)stop {
    
    [self.device switchToNormalModel];
    [self._view stopEcg];
}

- (void)leave {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self._view stopEcg];
}

- (void)presentDisconncetAlert {
//    HUDView *hud = [HUDView textHUD:NSLocalizedString(MHDisconnected, nil) detail:nil onView:self.view];
//    hud.completionBlock = ^{
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    };
}

#pragma mark -- save report  test....
- (void)saveReport:(MRBPReport *)report {
    report.startTime =  [[NSDate date] timeIntervalSince1970];
    NSDictionary * dict = [report mj_keyValues];
    [[NSUserDefaults standardUserDefaults]setValue:dict forKey:@"BPReportData"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self prepareData];
    
    self.device.isOpenBloodNoti = YES; // if set YES , MRDeviceDelegate method ---> - (void)bpDataUpdated:(NSData *)data (invalid) use notification --->  notification name: (MRRawdataReceivedNotification)   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bpDataUpdatednoti:) name:MRRawdataReceivedNotification object:nil]; See below
    
    self.device.delegate = self;
    self._view.progress = TestBPProgressAttention;
    if (self._view.skipEditBP) {
        [self startBP];
    } else {
        self._view.progress = TestBPProgressEditBP;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectStateUpdated:) name:MRDeviceConnectStateUpdatedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bpDataUpdatednoti:) name:MRRawdataReceivedNotification object:nil];
}


#pragma mark  -- device delegate
- (void)monitorStateUpdated {
    NSLog(@"monitorStateUpdated:%d", self.device.isMonitorOn);

}

- (void)monitorModeUpdated {
    NSLog(@"testBpViewController------monitorModeUpdated:%d", self.device.monitorMode);
    
    if (self.device.monitorMode != MRDeviceMonitorModeBloodPresure && self._view.progress > TestBPProgressTesting && self._view.progress < TestBPProgressFinish) {
        [self presentDisconncetAlert];
    }
}

/****
 
 test ....
 
 if  set  self.device.isOpenBloodNoti = YES , MRDeviceDelegate method ---> - (void)bpDataUpdated:(NSData *)data (invalid) use notification --->  notification name: (MRRawdataReceivedNotification)  see viewDidLoad----
 */

//- (void)bpDataUpdated:(NSData *)data {
//    [self bpDataWithReportEcg:data];
//}
/**
 *
 *
 */
#pragma mark  --- blood noti -----
-(void)bpDataUpdatednoti:(NSNotification *)noti {
    
    NSData * data = noti.object;
    [self bpDataWithReportEcg:data];

}

-(void)bpDataWithReportEcg:(NSData *)data {
    
    if (self.device.monitorMode != MRDeviceMonitorModeBloodPresure) {
        return;
    }
    [self.data appendData:data];
    int count = 0;
    int readyDuration = 10;
    if (data.length > 0) {
        count = (int)self.data.length / data.length; // Total length / packet data length
    }
    int duration = count / 10 - readyDuration; // Number of packets / one second 10 packets
    [self._view updateDuration:duration];
    
    if (self._view.progress == TestBPProgressTesting) {
        self._view.progress = TestBPProgressReady;
    }
    
    if (duration >= 0 && self._view.progress == TestBPProgressReady) {
        self._view.progress = TestBPProgressStart;
        return;
    }
    // Analyze every additional n pieces of data
    if (count % 10 == 0) {
        int time = [stringFromDate(self.start, @"HHmm") intValue];
        NSDate *start = [NSDate date];
        
        @weakify(self);
        [MRApi parseBPData:self.data time:time caliSBP:self._view.SBP caliDBP:self._view.DBP block:^(MRBPReport *report, NSError *error) {
            @strongify(self);
            
            NSDate *end = [NSDate date];
            NSTimeInterval interval = [end timeIntervalSinceDate:start];
            NSLog(@"parse bp end: %@, cost:%f-----report.flag-------%d", stringFromDate(end, @"HH:mm:ss.SSS"), interval,report.flag);
            
            if (self._view.progress == TestBPProgressStart) {
                self._view.ecg = report.ecg;
                [self._view startEcg];
            }
            
            BOOL finish = report.flag == 1;
            BOOL failure = report.flag == 2 || duration >= 60;  // failed or timeout
            if ((finish || failure) && self._view.progress == TestBPProgressStart ) {
//                NSLog(@"--------report.flag---%d------",report.flag);
                [self stop];
                self._view.progress = finish ? TestBPProgressFinish : TestBPProgressFailure;
                [self._view showReport:report];
            }
            
            if (failure) {
                
                [self._view.finishedButton setTitle:@"Continue" forState:UIControlStateNormal];
                self._view.helpButtonConstraint.constant = 45;
            }
            if (finish) {
                NSLog(@"start save bp report");
                
                [self.device setRawdataEnabled:NO]; // When blood pressure monitoring is turned on, [self. Device setrawdataenabled: Yes]; So  it can be set to no when leaving。
                
                [self saveReport:report] ;
                [self._view.finishedButton setTitle:@"Complete" forState:UIControlStateNormal];
                self._view.helpButtonConstraint.constant = 0;
                
            }
        }];
    }
}

// Please reconnect to check for real-time monitoring
- (void)connectStateUpdated:(NSNotification *)noti {
    
    if (self.device.connectState == MRDeviceStateConnected) {
      
    } else {
        [self presentDisconncetAlert];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
@end
