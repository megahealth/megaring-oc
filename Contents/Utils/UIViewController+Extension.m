//
//  UIViewController+Extension.m
//  MegaSport
//
//  Created by Superman on 2017/11/28.
//  Copyright © 2017年 Superman. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

@dynamic backTitle;

- (void)setBackTitle:(NSString *)title {
    title = title ?: @"";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
}

- (NSString *)backTitle {
    return self.navigationItem.backBarButtonItem.title;
}

+ (instancetype)currentViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}



@end
