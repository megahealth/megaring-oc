//
//  UIView+View.h
//  BHealth
//
//  Created by zghilbert on 16/5/17.
//  Copyright © 2016年 maxmoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIView (View)

@property (nonatomic, strong, readonly) UIViewController    *viewController;

// 批量 添加/删除 子视图
- (void)removeAllSubviews;
- (void)addSubviewsInArray:(NSArray *)subviews;

+ (instancetype)viewWithFrame:(CGRect)frame
                      bgColor:(UIColor *)color
                       corner:(CGFloat)cornerRadius;

+ (instancetype)viewWithFrame:(CGRect)frame
                      bgImage:(NSString *)image
                       corner:(CGFloat)cornerRadius;

 // 复制一份当前的 tabBar
+ (UIView *)duplicateTabBar;

- (UIView *)findFirstResponder;

- (UIImage *)imageFromView;



@end
