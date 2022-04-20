//
//  TestBPView.h
//  BHealth
//
//  Created by cheng cheng on 3/6/2021.
//  Copyright © 2021 zhaoguan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IBCustomButton.h"

typedef NS_ENUM(NSInteger, TestBPProgress) {
    TestBPProgressAttention = 0x00,
    TestBPProgressEditBP    = 0x10,
    TestBPProgressTesting   = 0x20,
    TestBPProgressReady     = 0x21,
    TestBPProgressStart     = 0x22,
    TestBPProgressFinish    = 0x23,
    TestBPProgressFailure   = 0x24,
    TestBPProgressResTips   = 0x25,
};

@class MRBPReport;


@interface TestBPView : UIView


@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet IBCustomButton *finishedButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *helpButtonConstraint;


@property (nonatomic, assign) TestBPProgress progress;

@property (nonatomic, assign) BOOL skipEditBP;

@property (nonatomic, assign) int SBP;
@property (nonatomic, assign) int DBP;
@property (nonatomic, assign) BOOL hasHBP;

- (void)updateStartTime:(NSDate *)start;

- (void)updateDuration:(int)duration;

- (void)updateLivePR:(int)pr;

- (void)showReport:(MRBPReport *)report;

- (void)showDebugInfo:(MRBPReport *)report;

@property (nonatomic, strong) NSArray *ecg;

- (void)startEcg;

- (void)stopEcg;

@property (nonatomic, assign) BOOL ecgOngoing;



@end
