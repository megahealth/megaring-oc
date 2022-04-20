//
//  UIViewExt.h
//  BHealth
//
//  Created by zghilbert on 16/5/17.
//  Copyright © 2016年 maxmoo. All rights reserved.
//

#ifndef UIViewExt_h
#define UIViewExt_h

#import "UIView+Property.h"

#import "UIView+Rect.h"

#import "UIView+View.h"

#import "UIView+Location.h"

#import "UIView+Animations.h"

#import "UIColor+Extension.h"
#import "UIImage+Extension.h"




#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SCREEN_MAX_LENGTH   (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH   (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))




#define IS_IPHONE_4_OR_LESS        SCREEN_MAX_LENGTH < 568.0
#define IS_IPHONE_5_SAMESIZE       SCREEN_MAX_LENGTH == 568.0
#define IS_IPHONE_6_SAMESIZE       SCREEN_MAX_LENGTH == 667.0
#define IS_IPHONE_6P_SAMESIZE      SCREEN_MAX_LENGTH == 736.0
#define IS_IPHONE_X_SAMESIZE       SCREEN_MAX_LENGTH == 812.0


#endif /* UIViewExt_h */
