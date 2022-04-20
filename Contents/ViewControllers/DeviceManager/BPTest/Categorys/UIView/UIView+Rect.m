//
//  UIView+Rect.m
//  BHealth
//
//  Created by zghilbert on 16/5/17.
//  Copyright © 2016年 maxmoo. All rights reserved.
//

#import "UIView+Rect.h"
#import "UIViewExt.h"

@implementation UIView (Rect)

CGRect hCenterFrame(UIView *view) {
    return CGRectMake((SCREEN_WIDTH - view.width) / 2, view.y, view.width, view.height);
}

CGRect centerFrame(UIView *view) {
    return CGRectMake((SCREEN_WIDTH - view.width) / 2, (SCREEN_HEIGHT - view.height) / 2, view.width, view.height);
}

CGRect hRelaFrame(UIView *view, CGFloat hSpace) {
    return CGRectMake(view.right + hSpace, view.top, view.width, view.height);
}

CGRect vRelaFrame(UIView *view, CGFloat vSpace) {
    return CGRectMake(view.left, view.bottom + vSpace, view.width, view.height);
}

CGRect relaFrame(UIView *view, CGFloat hOffset, CGFloat vOffset) {
    return CGRectMake(view.left + hOffset, view.top + vOffset, view.width, view.height);
}

- (void)move:(CGPoint)offset {self.left += offset.x; self.top += offset.y;}

- (void)moveToHCenter {self.left = (SCREEN_WIDTH - self.width) / 2;}

- (void)moveToVCenter {self.left = (SCREEN_HEIGHT - self.height) / 2;}

CGPoint CGRectGetCenter(CGRect rect) {
    CGPoint pt;
    pt.x = CGRectGetMidX(rect);
    pt.y = CGRectGetMidY(rect);
    return pt;
}

CGRect CGRectMoveToCenter(CGRect rect, CGPoint center) {
    CGRect newrect = CGRectZero;
    newrect.origin.x = center.x - CGRectGetMidX(rect);
    newrect.origin.y = center.y - CGRectGetMidY(rect);
    newrect.size = rect.size;
    return newrect;
}

- (void) scaleBy: (CGFloat) scaleFactor {
    CGRect newframe = self.frame;
    newframe.size.width *= scaleFactor;
    newframe.size.height *= scaleFactor;
    self.frame = newframe;
}

- (void) fitInSize: (CGSize) aSize {
    CGFloat scale;
    CGRect newframe = self.frame;
    if (newframe.size.height && (newframe.size.height > aSize.height)) {
        scale = aSize.height / newframe.size.height;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    if (newframe.size.width && (newframe.size.width >= aSize.width)) {
        scale = aSize.width / newframe.size.width;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    self.frame = newframe;	
}
@end
