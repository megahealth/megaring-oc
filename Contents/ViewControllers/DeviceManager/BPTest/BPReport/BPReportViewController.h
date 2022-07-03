//
//  BPReportViewController.h
//  BHealth
//
//  Created by Ulric on 15/11/2021.
//  Copyright © 2021 zhaoguan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MRBPReport;

@interface BPReportViewController : UIViewController

@property (nonatomic ,assign)int parseTime;

- (instancetype)initWithReport:(MRBPReport *)report;

@end

NS_ASSUME_NONNULL_END
