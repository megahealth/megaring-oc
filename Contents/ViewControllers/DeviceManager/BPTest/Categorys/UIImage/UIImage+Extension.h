//
//  UIImage+Extension.h
//  CCCategories
//
//  Created by maxmoo on 16/3/21.
//  Copyright © 2016年 maxmoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+(UIImage *)imageWithColor:(UIColor *)aColor;
+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;

- (UIImage *) imageWithTintColor:(UIColor *)tintColor;

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;

+ (instancetype)imageWithView:(__kindof UIView *)view;

// 压缩图片限制大小
- (UIImage *)compressQualityWithMaxLength:(NSInteger)maxLength;

- (NSData *)imageData;

@end
