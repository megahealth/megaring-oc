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

@interface MRDataParser : NSObject

+ (void)parseData:(NSData *)data block:(void (^)(MRReport *report))block;





@end
