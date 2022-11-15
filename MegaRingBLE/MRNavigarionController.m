//
//  MRNavigarionController.m
//  MegaRingBLE
//
//  Created by Superman on 2018/5/4.
//  Copyright © 2018年 Superman. All rights reserved.
//




#import "MRNavigarionController.h"
#import "MRHomeViewController.h"




@interface MRNavigarionController ()

@end

@implementation MRNavigarionController

#pragma mark -
#pragma mark Life Cycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    MRHomeViewController	*rootVC = [[MRHomeViewController alloc] init];
    if (self = [super initWithRootViewController:rootVC]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.11 green:0.64 blue:1 alpha:1]];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
}


@end
