//
//  IBCustomView.h
//  MegaRingSDKDemo
//
//  Created by Superman on 2018/3/8.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE


@interface IBCustomView : UIView

@property (nonatomic, assign) IBInspectable CGFloat  cornerRadius;

@property (nonatomic, assign) IBInspectable BOOL     rounded;

@property (nonatomic, assign) IBInspectable CGFloat  bordWidth;

@property (nonatomic, strong) IBInspectable UIColor *bordColor;



@end
