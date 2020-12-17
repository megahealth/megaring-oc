//
//  MRApi.h
//  MegaRingBLE
//
//  Created by Superman on 2018/5/18.
//  Copyright © 2018年 Superman. All rights reserved.
//


#ifdef DEBUG
#    define MRLog(FORMAT, ...)    NSLog(@"#MRLog# "FORMAT, ##__VA_ARGS__)
#else
#    define MRLog(FORMAT, ...)
#endif



#import <Foundation/Foundation.h>
#import "MRDefines.h"




@class MRReport;


FOUNDATION_EXPORT NSString *const kMRCentralStateUpdatedNotification;
FOUNDATION_EXTERN NSNotificationName const MRUpgradeStateUpdatedNotification;
FOUNDATION_EXTERN NSNotificationName const MRUpgradeProgressUpdatedNotification;

FOUNDATION_EXTERN int kMRAlgorithmVersion;


@interface MRApi : NSObject


+ (void)setUpWithAppId:(NSString *)appId appKey:(NSString *)appKey;

+ (void)setMRLogEnabled:(BOOL)isEnabled;

// parse data to report;
+ (void)parseMonitorData:(NSData *)data mode:(MRDeviceMonitorMode)mode completion:(void (^)(MRReport *report, NSError *error))completion;

+ (void)setDataUploadEnabled:(BOOL)isEnabled;





@end
