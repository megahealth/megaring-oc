//
//  MRDefaultView.m
//  MegaRingBLE
//
//  Created by Superman on 2018/5/21.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "MRDefaultView.h"

@implementation MRDefaultView

+ (instancetype)defaultView {
    static MRDefaultView	*defaultView = nil;
    if (nil == defaultView) {
        NSArray	*nibContentts = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
        defaultView = [nibContentts firstObject];
        defaultView.frame = [UIScreen mainScreen].bounds;
    }
    return defaultView;
}

+ (void)showDefaultViewHidden:(BOOL)isHidden {
    UIWindow	*window = [UIApplication sharedApplication].keyWindow;
    if (isHidden) {
        [[self defaultView] removeFromSuperview];
    } else {
        [window addSubview:[self defaultView]];
    }
}










@end
