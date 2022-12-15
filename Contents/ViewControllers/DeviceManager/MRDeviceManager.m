//
//  MRDeviceManager.m
//  MegaRingBLE
//
//  Created by feiyang cai on 2022/12/15.
//  Copyright © 2022 Superman. All rights reserved.
//

#import "MRDeviceManager.h"

@implementation MRDeviceManager

+(instancetype)sharedDeviceManager {
    
    static MRDeviceManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL]init];
    });
    return instance;
}

+(id)allocWithZone:(struct _NSZone *)zone {
    
    return [self sharedDeviceManager];
    
}
-(id)copyWithZone:(NSZone *)zone {
    return self;
}
@end
