//
//  UIView+Property.m
//  BHealth
//
//  Created by zghilbert on 16/5/17.
//  Copyright © 2016年 maxmoo. All rights reserved.
//

#import "UIView+Property.h"

@implementation UIView (Property)

#pragma mark -- basic property

- (CGPoint)origin {return self.frame.origin;}
- (void)setOrigin:(CGPoint)newOrigin {self.x = newOrigin.x; self.y = newOrigin.y;}

- (CGSize)size {return self.frame.size;}
- (void)setSize:(CGSize)newSize {self.width = newSize.width; self.height = newSize.height;}

- (CGFloat)x {return self.origin.x;}
- (void)setX:(CGFloat)newX {self.frame = CGRectMake(newX, self.y, self.width + self.x - newX, self.height);}

- (CGFloat)y {return self.origin.y;}
- (void)setY:(CGFloat)newY {self.frame = CGRectMake(self.x, newY, self.width, self.height + self.y - newY);}

- (CGFloat)width {return self.size.width;}
- (void)setWidth:(CGFloat)newWidth {self.frame = CGRectMake(self.x, self.y, newWidth, self.height);}

- (CGFloat)height {return self.size.height;}
- (void)setHeight:(CGFloat)newHeight {self.frame = CGRectMake(self.x, self.y, self.width, newHeight);}


#pragma mark -- other peoperty

- (CGFloat)centralX {return self.center.x;}
- (void)setCentralX:(CGFloat)newCentralX {self.center = CGPointMake(newCentralX, self.centralY);}

- (CGFloat)centralY {return self.center.y;}
- (void)setCentralY:(CGFloat)newCentralY {self.center = CGPointMake(self.centralX, newCentralY);}

- (CGFloat)top {return self.y;}
- (void)setTop:(CGFloat)newTop {self.frame = CGRectMake(self.x, newTop, self.width, self.height);}

- (CGFloat)left {return self.x;}
- (void)setLeft:(CGFloat)newLeft {self.frame = CGRectMake(newLeft, self.y, self.width, self.height);}

- (CGFloat)right {return self.x + self.width;}
- (void)setRight:(CGFloat)newRight {self.frame = CGRectMake(newRight - self.width, self.y, self.width, self.height);}

- (CGFloat)bottom {return self.y + self.height;}
- (void)setBottom:(CGFloat)newBottom {self.frame = CGRectMake(self.x, newBottom - self.height, self.width, self.height);}

- (CGPoint)topLeft {return CGPointMake(self.left, self.top);}
- (void)setTopLeft:(CGPoint)topLeft {self.left = topLeft.x; self.top = topLeft.y;}

- (CGPoint)topRight {return CGPointMake(self.right, self.top);}
- (void)setTopRight:(CGPoint)topRight {self.right = topRight.x; self.top = topRight.y;}

- (CGPoint)bottomLeft {return CGPointMake(self.left, self.bottom);}
- (void)setBottomLeft:(CGPoint)bottomLeft {self.left = bottomLeft.x; self.bottom = bottomLeft.y;}

- (CGPoint)bottomRight {return CGPointMake(self.right, self.bottom);}
- (void)setBottomRight:(CGPoint)bottomRight {self.right = bottomRight.x; self.bottom = bottomRight.y;}





@end
