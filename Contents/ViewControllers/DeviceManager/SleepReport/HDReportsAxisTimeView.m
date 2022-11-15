//
//  HDReportsAxisTimeView.m
//  BHealth
//
//  Created by Superman on 19/04/2019.
//  Copyright © 2019 zhaoguan. All rights reserved.
//

#import "HDReportsAxisTimeView.h"

@implementation HDReportsAxisTimeView

- (void)addTimeStringWithStart:(int)start end:(int)end format:(NSString *)format {
    int duration = end - start;
    BOOL showIntermediate = duration >= 5*60; //Intermediate time scale for display of more than five minutes (时长在五分钟以上的显示中间时间刻度)
    double step = duration * 1.0 / 5;
    for (UILabel *lab in self.subviews) {
        if ([lab isKindOfClass:[UILabel class]]) {
            double time = start + step * lab.tag;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
            NSString *string = localizedStringFromDate(date, format);
            if ((lab.tag > 0 && lab.tag < 5) && showIntermediate == NO) {
                string = @"";
            }
            lab.text = string;
//            NSLog(@"--time--:%f, tag:%ld", time, (long)lab.tag);
        }
    }
}


@end
