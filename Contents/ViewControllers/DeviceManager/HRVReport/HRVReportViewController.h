//
//  HRVReportViewController.h
//  BHealth
//
//  Created by Ulric on 17/11/2021.
//  Copyright © 2021 zhaoguan. All rights reserved.
//

//#import "BHBaseViewController.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class MRReport;

@interface HRVReportViewController : UIViewController

- (instancetype)initWithReport:(MRReport *)report;

@end

NS_ASSUME_NONNULL_END
