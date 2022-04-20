//
//  UIView+Animations.m
//  BHealth
//
//  Created by zghilbert on 16/5/17.
//  Copyright © 2016年 maxmoo. All rights reserved.
//

#import "UIView+Animations.h"

@implementation UIView (Animations)

- (void)setDefaultAnimation:(CFTimeInterval)duration {
    CATransition *transition = [CATransition animation];
    transition.duration = duration * 1.f;
    [self.layer addAnimation:transition forKey:nil];
}

- (CATransition *)moveInFromBottom {
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    return transition;
}


@end
