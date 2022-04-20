//
//  IBCustomButton.h
//  MegaSport
//
//  Created by Superman on 2017/11/27.
//  Copyright © 2017年 Superman. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE


@interface IBCustomButton : UIButton

@property (nonatomic, assign) IBInspectable CGFloat  cornerRadius;

@property (nonatomic, assign) IBInspectable BOOL     rounded;

@property (nonatomic, assign) IBInspectable CGFloat  bordWidth;

@property (nonatomic, assign) IBInspectable UIColor *bordColor;



@property (nonatomic, assign) IBInspectable CGFloat  fontSize4;

@property (nonatomic, assign) IBInspectable CGFloat  fontSize5;

@property (nonatomic, assign) IBInspectable CGFloat  fontSize6;

@property (nonatomic, assign) IBInspectable CGFloat  fontSize6p;

@property (nonatomic, assign) IBInspectable CGFloat  fontSizeX;



@property (nonatomic, strong) IBInspectable UIColor	*normalBackgroundColor;

@property (nonatomic, strong) IBInspectable UIColor	*highlightedBackgroundColor;

@property (nonatomic, strong) IBInspectable UIColor	*selectedBackgroundColor;

@property (nonatomic, strong) IBInspectable UIColor	*disabledBackgroundColor;

@property (nonatomic, strong) IBInspectable UIColor	*highlightedSelectedBgColor;

@property (nonatomic, copy) IBInspectable NSString	*highlightedSelectedTitle;

@property (nonatomic, copy) IBInspectable UIColor	*highlightedSelectedTextColor;



@end
