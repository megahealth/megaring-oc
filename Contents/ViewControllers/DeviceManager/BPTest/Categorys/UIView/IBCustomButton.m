//
//  IBCustomButton.m
//  MegaSport
//
//  Created by Superman on 2017/11/27.
//  Copyright © 2017年 Superman. All rights reserved.
//

#import "IBCustomButton.h"
#import "UIViewExt.h"

@implementation IBCustomButton

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


- (void)setFontSize4:(CGFloat)fontSize4 {
    if (IS_IPHONE_4_OR_LESS) {
        self.titleLabel.font = [UIFont fontWithName:self.titleLabel.font.fontName size:fontSize4];
    }
}

- (void)setFontSize5:(CGFloat)fontSize5 {
    if (IS_IPHONE_5_SAMESIZE) {
        self.titleLabel.font = [UIFont fontWithName:self.titleLabel.font.fontName size:fontSize5];
    }
}

- (void)setFontSize6:(CGFloat)fontSize6 {
    if (IS_IPHONE_6_SAMESIZE) {
        self.titleLabel.font = [UIFont fontWithName:self.titleLabel.font.fontName size:fontSize6];
    }
}

- (void)setFontSize6p:(CGFloat)fontSize6p {
    if (IS_IPHONE_6P_SAMESIZE) {
        self.titleLabel.font = [UIFont fontWithName:self.titleLabel.font.fontName size:fontSize6p];
    }
}

- (void)setFontSizeX:(CGFloat)fontSizeX {
    if (IS_IPHONE_X_SAMESIZE) {
        self.titleLabel.font = [UIFont fontWithName:self.titleLabel.font.fontName size:fontSizeX];
    }
}



- (void)setNormalBackgroundColor:(UIColor *)normalBackgroundColor {
    [self setBackgroundImage:[UIImage imageWithColor:normalBackgroundColor] forState:UIControlStateNormal];
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor {
    [self setBackgroundImage:[UIImage imageWithColor:highlightedBackgroundColor] forState:UIControlStateHighlighted];
}

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor {
    [self setBackgroundImage:[UIImage imageWithColor:selectedBackgroundColor] forState:UIControlStateSelected];
}

- (void)setDisabledBackgroundColor:(UIColor *)disabledBackgroundColor {
    [self setBackgroundImage:[UIImage imageWithColor:disabledBackgroundColor] forState:UIControlStateDisabled];
}

- (void)setHighlightedSelectedBgColor:(UIColor *)highlightedSelectedBgColor {
    [self setBackgroundImage:[UIImage imageWithColor:highlightedSelectedBgColor] forState:UIControlStateHighlighted | UIControlStateSelected];
}

- (void)setHighlightedSelectedTitle:(NSString *)highlightedSelectedTitle {
    [self setTitle:highlightedSelectedTitle forState:UIControlStateHighlighted | UIControlStateSelected];
}

- (void)setHighlightedSelectedTextColor:(UIColor *)highlightedSelectedTextColor {
    [self setTitleColor:highlightedSelectedTextColor forState:UIControlStateHighlighted | UIControlStateSelected];
}




@end
