//
//  UIView+Location.m
//  BHealth
//
//  Created by zghilbert on 16/5/17.
//  Copyright © 2016年 maxmoo. All rights reserved.
//

#import "UIView+Location.h"
#import "UIViewExt.h"
@implementation UIView (Location)

- (UIViewLocation)location {return self.location;}

- (void)setLocation:(UIViewLocation)newLocation {
    if (newLocation == UIViewLocationCenter ||newLocation == UIViewLocationLeftCenter ||newLocation == UIViewLocationRightCenter ||newLocation == UIViewLocationTopCenter ||newLocation == UIViewLocationBottomCenter) {
        self.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
    }
    
    if (newLocation == UIViewLocationLeft ||newLocation == UIViewLocationLeftCenter ||newLocation == UIViewLocationTopLeft ||newLocation == UIViewLocationBottomLeft) {
        self.left = 0;
    }
    
    if (newLocation == UIViewLocationTop ||newLocation == UIViewLocationTopCenter ||newLocation == UIViewLocationTopLeft ||newLocation == UIViewLocationTopRight) {
        self.top = 0;
    }
    
    if (newLocation == UIViewLocationRight ||newLocation == UIViewLocationRightCenter ||newLocation == UIViewLocationTopRight ||newLocation == UIViewLocationBottomRight) {
        self.right = SCREEN_WIDTH;
    }
    
    if (newLocation == UIViewLocationBottom ||newLocation == UIViewLocationBottomCenter ||newLocation == UIViewLocationBottomLeft ||newLocation == UIViewLocationBottomRight) {
        self.bottom = SCREEN_HEIGHT;
    }
}

@end
