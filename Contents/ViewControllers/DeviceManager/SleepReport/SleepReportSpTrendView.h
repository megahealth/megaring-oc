//
//  SleepReportSpTrendView.h
//  BHealth
//
//  Created by cheng cheng on 23/3/2020.
//  Copyright © 2020 zhaoguan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SleepReportSpTrendView : UIView

/*
 * monitor length, compared with dataArr.length
 */

@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) double min;

- (void)strokeWithData:(NSArray *)dataArr top:(double)top bottom:(double)bottom;

@property (nonatomic, assign) int drawStep;
@property (nonatomic, assign) double maxValueInPicture;
@property (nonatomic, assign) double minValueInPicture;

- (void)calculateStatisticalValueWithData:(NSArray *)dataArr;

- (void)strokeAlertLineAtVerticalPosition:(CGFloat)position;



@end


