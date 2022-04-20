//
//  UIColor+Extension.m
//  CCCategories
//
//  Created by maxmoo on 16/3/21.
//  Copyright © 2016年 maxmoo. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

- (CGColorSpaceModel)colorSpaceModel {
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (BOOL)canProvideRGBComponents {
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelRGB:
        case kCGColorSpaceModelMonochrome:
            return YES;
        default:
            return NO;
    }
}

- (CGFloat)red {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -red");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[0];
}

- (CGFloat)green {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -green");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
    return c[1];
}

- (CGFloat)blue {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -blue");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
    return c[2];
}

- (CGFloat)white {
    NSAssert(self.colorSpaceModel == kCGColorSpaceModelMonochrome, @"Must be a Monochrome color to use -white");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[0];
}

- (CGFloat)alpha {
    return CGColorGetAlpha(self.CGColor);
}

+ (UIColor *)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b{
    
    return [UIColor colorWithR:r G:g B:b A:1.0];
}

+ (UIColor *)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a{
    
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
}

+ (UIColor *)randomColor {
    return [UIColor colorWithRed:(arc4random()%256)/256.f
                           green:(arc4random()%256)/256.f
                            blue:(arc4random()%256)/256.f
                           alpha:1.0f];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

// Returns a UIColor by scanning the string for a hex number and passing that to +[UIColor colorWithRGBHex:]
// Skips any leading whitespace and ignores any trailing characters
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [UIColor colorWithRGBHex:hexNum];
}
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert andAlpha:(CGFloat)alpha{
    UIColor *color = [UIColor colorWithHexString:stringToConvert];
    return [UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:alpha];
}

UIColor *rgbaColor(NSInteger r, NSInteger g, NSInteger b, CGFloat a)
{
    return [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a*1.f];
}

UIColor *rgbColor(NSInteger r, NSInteger g, NSInteger b)
{
    return rgbaColor(r, g, b, 1);
}

UIColor *hexColor(long hexValue)
{
    NSInteger r = (hexValue & 0xFF0000) >> 16;
    NSInteger g = (hexValue & 0x00FF00) >> 8;
    NSInteger b = (hexValue & 0x0000FF);
    return rgbaColor(r, g, b, 1);
}

UIColor *hexAColor(long hexValue)
{
    NSInteger r = (hexValue & 0xFF000000) >> 24;
    NSInteger g = (hexValue & 0x00FF0000) >> 16;
    NSInteger b = (hexValue & 0x0000FF00) >> 8;
    float a = (hexValue & 0x000000FF) / 255.f;
    return rgbaColor(r, g, b, a);
}

UIColor *hexColorS(NSString *hexColor)
{
    unsigned int color[3];
    for (int i=0; i<hexColor.length; i+=2) {
        [[NSScanner scannerWithString:[hexColor substringWithRange:NSMakeRange(i, 2)]] scanHexInt:&color[i/2]];
    }
    return rgbaColor(color[0], color[1], color[2], 1);
}

UIColor *randomColor()
{
    return rgbColor(arc4random()%256, arc4random()%256, arc4random()%256);
}

@end
