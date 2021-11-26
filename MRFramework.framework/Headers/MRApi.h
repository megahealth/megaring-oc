//
//  MRApi.h
//  MegaRingBLE
//
//  Created by Superman on 2018/5/18.
//  Copyright © 2018年 Superman. All rights reserved.
//


#    define MRLog(FORMAT, ...)    NSLog(@"#MRLog# "FORMAT, ##__VA_ARGS__)




#import <Foundation/Foundation.h>
#import "MRDefines.h"




@class MRReport;
@class MRBPReport;
@class MRDailyReport;


FOUNDATION_EXPORT NSString *const kMRCentralStateUpdatedNotification;
FOUNDATION_EXPORT NSNotificationName const MRDeviceConnectStateUpdatedNotification;
FOUNDATION_EXTERN NSNotificationName const MRUpgradeStateUpdatedNotification;
FOUNDATION_EXTERN NSNotificationName const MRUpgradeProgressUpdatedNotification;

FOUNDATION_EXTERN int kMRAlgorithmVersion;

FOUNDATION_EXTERN NSString *kMRFrameworkVersion;


@interface MRApi : NSObject


+ (void)setUpWithAppId:(NSString *)appId appKey:(NSString *)appKey;

+ (void)setMRLogEnabled:(BOOL)isEnabled;

// parse data to report;
+ (void)parseMonitorData:(NSData *)data completion:(void (^)(MRReport *report, NSError *error))completion;

+ (void)parseBPData:(NSData *)data time:(int)time caliSBP:(double)caliSBP caliDBP:(double)caliDBP block:(void (^)(MRBPReport *report, NSError *error))completion;

+ (NSArray<MRDailyReport *> *)parseDaily:(NSData *)data;

+ (void)setDataUploadEnabled:(BOOL)isEnabled;





@end
