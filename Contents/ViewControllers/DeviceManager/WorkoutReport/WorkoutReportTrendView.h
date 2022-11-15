//
//  WorkoutReportTrendView.h
//  BHealth
//
//  Created by cheng cheng on 20/3/2020.
//  Copyright © 2020 zhaoguan. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface WorkoutReportTrendView : UIView


/*
 * monitor length, compared with dataArr.length
 */
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger max;
@property (nonatomic, assign) NSInteger min;

- (void)strokeWithData:(NSArray *)dataArr top:(double)top bottom:(double)bottom;

@property (nonatomic, assign) int drawStep;
@property (nonatomic, assign) int maxValueInPicture;
@property (nonatomic, assign) int minValueInPicture;

- (void)calculateStatisticalValueWithData:(NSArray *)dataArr;

@end


