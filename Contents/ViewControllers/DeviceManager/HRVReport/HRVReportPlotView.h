//
//  HRVReportPlotView.h
//  BHealth
//
//  Created by Ulric on 19/11/2021.
//  Copyright © 2021 zhaoguan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HRVReportPlotView : UIView

- (void)strokeWithData:(NSArray *)dataArr maxX:(int)maxX maxY:(int)maxY;

@end

NS_ASSUME_NONNULL_END
