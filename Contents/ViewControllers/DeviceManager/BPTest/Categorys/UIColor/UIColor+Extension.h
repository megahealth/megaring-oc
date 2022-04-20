//
//  UIColor+Extension.h
//  CCCategories
//
//  Created by maxmoo on 16/3/21.
//  Copyright © 2016年 maxmoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

@property (nonatomic, readonly) CGColorSpaceModel colorSpaceModel;
@property (nonatomic, readonly) BOOL canProvideRGBComponents;
@property (nonatomic, readonly) CGFloat red; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat green; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat blue; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat white; // Only valid if colorSpaceModel == kCGColorSpaceModelMonochrome
@property (nonatomic, readonly) CGFloat alpha;

+ (UIColor *)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b;
+ (UIColor *)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a;

+ (UIColor *)randomColor;
+ (UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert andAlpha:(CGFloat)alpha;

// color    r g b ∈ [0, 255], a ∈ [0, 1]
UIColor *rgbaColor(NSInteger r, NSInteger g, NSInteger b, CGFloat a);
UIColor *rgbColor(NSInteger r, NSInteger g, NSInteger b);
UIColor *hexAColor(long hexValue);
UIColor *hexColor(long hexValue);
UIColor *hexColorS(NSString *hexColor);
UIColor *randomColor(void);

@end
