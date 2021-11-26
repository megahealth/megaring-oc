//
//  MRDataParser.h
//  MegaRingSDK
//
//  Created by Superman on 2018/5/15.
//  Copyright © 2018年 Superman. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "MRDefines.h"


@class MRReport;
@class MRBPReport;
@class MRDailyReport;

@interface MRDataParser : NSObject

+ (void)parseData:(NSData *)data block:(void (^)(MRReport *report))block;


+ (void)parseBPData:(NSData *)data time:(int)time caliSBP:(double)caliSBP caliDBP:(double)caliDBP block:(void (^)(MRBPReport *report))block;


+ (NSArray<MRDailyReport *> *)parseDaily:(NSData *)data;

@end
