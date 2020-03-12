//
//  MRIndicatorView.h
//  MegaRingBLE
//
//  Created by Superman on 2018/5/18.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRIndicatorView : UIActivityIndicatorView

+ (MRIndicatorView *)showIndicatorOnView:(UIView *)view;

+ (void)hideIndicatorOnView:(UIView *)view;


@end
