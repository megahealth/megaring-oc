//
//  IBCustomView.m
//  MegaRingSDKDemo
//
//  Created by Superman on 2018/3/8.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "IBCustomView.h"

@implementation IBCustomView

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (void)setRounded:(BOOL)rounded {
    if (rounded) {
        self.layer.cornerRadius = self.frame.size.width / 2;
    }
}

- (void)setBordWidth:(CGFloat)bordWidth {
    self.layer.borderWidth = bordWidth;
}

- (void)setBordColor:(UIColor *)bordColor {
    self.layer.borderColor = bordColor.CGColor;
}


@end
