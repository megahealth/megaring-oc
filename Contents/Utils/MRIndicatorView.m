//
//  MRIndicatorView.m
//  MegaRingBLE
//
//  Created by Superman on 2018/5/18.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "MRIndicatorView.h"

@implementation MRIndicatorView

+ (MRIndicatorView *)showIndicatorOnView:(UIView *)view {
    MRIndicatorView	*indicatorView = [[MRIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.frame = view.bounds;
    [view addSubview:indicatorView];
    [indicatorView startAnimating];
    return indicatorView;
}

+ (void)hideIndicatorOnView:(UIView *)view {
    for (MRIndicatorView *indicatorView in view.subviews) {
        if ([indicatorView isKindOfClass:[MRIndicatorView class]]) {
            [indicatorView stopAnimating];
            [indicatorView removeFromSuperview];
        }
    }
}





@end
