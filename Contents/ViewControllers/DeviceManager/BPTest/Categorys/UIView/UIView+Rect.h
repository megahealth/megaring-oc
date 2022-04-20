//
//  UIView+Rect.h
//  BHealth
//
//  Created by zghilbert on 16/5/17.
//  Copyright © 2016年 maxmoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIView (Rect)

// 获取居中 rect
CGRect hCenterFrame(UIView *view);
CGRect centerFrame(UIView *view);

// 关联
CGRect hRelaFrame(UIView *view, CGFloat hSpace);
CGRect vRelaFrame(UIView *view, CGFloat vSpace);
CGRect relaFrame(UIView *view, CGFloat hOffset, CGFloat vOffset);

// 平移
- (void)move:(CGPoint)offset;

- (void)moveToHCenter;

- (void)moveToVCenter;

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

// 缩放
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

@end
