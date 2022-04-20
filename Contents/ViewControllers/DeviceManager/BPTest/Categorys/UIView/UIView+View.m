//
//  UIView+View.m
//  BHealth
//
//  Created by zghilbert on 16/5/17.
//  Copyright © 2016年 maxmoo. All rights reserved.
//

#import "UIView+View.h"
#import "UIView+Property.h"
#import "UIImage+Extension.h"
@implementation UIView (View)

- (UIViewController *)viewController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

+ (instancetype)viewWithFrame:(CGRect)frame
                      bgColor:(UIColor *)color
                       corner:(CGFloat)cornerRadius {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    if (color) {view.backgroundColor = color;}
    view.clipsToBounds = YES;
    view.layer.cornerRadius = cornerRadius;
    return view;
}

+ (instancetype)viewWithFrame:(CGRect)frame
                      bgImage:(NSString *)imageName
                       corner:(CGFloat)cornerRadius {
    UIView *view = [UIView viewWithFrame:frame bgColor:nil corner:cornerRadius];
    UIImage *image = [UIImage imageNamed:imageName];
    if (image) {view.layer.contents = (id)image.CGImage;}
    return view;
}

//+ (UIView *)duplicateTabBar {
//    UIView *tabBarCopy = [[UIView alloc] initWithFrame:APPDELEGATE.currentVC.navigationController.tabBarController.tabBar.frame];
////    tabBarCopy.top = tabBarCopy.top-64;
//
//    UIVisualEffectView *backEffectView = [MBTools effectViewWithFrame:tabBarCopy.bounds];
//    [tabBarCopy addSubview:backEffectView];
//
//    tabBarCopy.right = tabBarCopy.left;
//    for (UIView *view in APPDELEGATE.currentVC.navigationController.tabBarController.tabBar.subviews) {
//        if (view.subviews.count >= 2) {
//            UIView *copyView = [[UIView alloc] initWithFrame:view.frame];
//            UIImageView *imageView = (UIImageView *)view.subviews[0];
//            UIImageView *copyImageView = [[UIImageView alloc] initWithFrame:imageView.frame];
//            copyImageView.image = imageView.image;
//            UILabel *label = (UILabel *)view.subviews[1];
//            UILabel *copyLabel = [UILabel labelWithFrame:label.frame text:label.text font:label.font alignment:label.textAlignment bgColor:label.backgroundColor tColor:label.textColor corner:0];
//            [copyView addSubviewsInArray:@[copyImageView, copyLabel]];
//            [tabBarCopy addSubview:copyView];
//        } else if (view.subviews.count == 1) {
//            UIView *copyView = [[UIView alloc] initWithFrame:view.frame];
//            UIView *subview = (UIView *)view.subviews[0];
//             // 颜色没有获取到, 当前白色透明最接近
//            UIView *copySubview = [UIView viewWithFrame:subview.frame bgColor:RGBACOLOR(255, 255, 255, 0.35) corner:0];
//            [copyView addSubview:copySubview];
//            [tabBarCopy addSubview:copyView];
//        } else if (view.subviews.count == 0) {
//            UIImageView *imageView = (UIImageView *)view;
//             // 颜色没有获取到, 当前 LIGHT_GRAY 最接近
//            UIView *copyView = [UIView viewWithFrame:imageView.frame bgColor:LIGHT_GRAY corner:0];
//            [tabBarCopy addSubview:copyView];
//        }
//    }
//    return tabBarCopy;
//}

- (void)removeAllSubviews{
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

- (void)addSubviewsInArray:(NSArray *)subviews {
    for (UIView *view in subviews) {
        [self addSubview:view];
    }
}

- (UIView *)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subview in self.subviews) {
        UIView *firstResponder = [subview findFirstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    return nil;
}

- (UIImage *)imageFromView {
    if (self.width * self.height <= 0) {
        return nil;
    }
    
    UIImage *image = [UIImage imageWithView:self];
    return image;
}


@end
