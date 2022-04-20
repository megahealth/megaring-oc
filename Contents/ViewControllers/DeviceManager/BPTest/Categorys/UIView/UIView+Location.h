//
//  UIView+Location.h
//  BHealth
//
//  Created by zghilbert on 16/5/17.
//  Copyright © 2016年 maxmoo. All rights reserved.
//




// 控件位置 UIVIew (UIViewLocation)
typedef enum {
    UIViewLocationLeft = 0,
    UIViewLocationRight,
    UIViewLocationTop,
    UIViewLocationBottom,
    UIViewLocationCenter,
    UIViewLocationTopLeft,
    UIViewLocationTopRight,
    UIViewLocationTopCenter,
    UIViewLocationBottomLeft,
    UIViewLocationBottomRight,
    UIViewLocationBottomCenter,
    UIViewLocationLeftCenter,
    UIViewLocationRightCenter,
} UIViewLocation;

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIView (Location)
@property (nonatomic, assign) UIViewLocation location;

@end
