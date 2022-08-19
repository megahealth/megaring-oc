//
//  MRApi.h
//  MegaRingBLE
//
//  Created by Superman on 2018/5/18.
//  Copyright © 2018年 Superman. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MRFramework/MRDefines.h>
#import <MRFramework/NSDate+CXExtendedDate.h>

@class MRReport;
@class MRBPReport;
@class MRDailyReport;


#ifdef DEBUG
#    define PMRLog(FORMAT, ...)    [MRApi PMRLogWithString:[NSString stringWithFormat:FORMAT, ##__VA_ARGS__]]
#else
#    define PMRLog(FORMAT, ...)
#endif
//
#    define QMRLog(FORMAT, ...)    [MRApi QMRLogWithString:[NSString stringWithFormat:@"%@ %s-%d "FORMAT@"\n", stringFromDate([NSDate date], @"[yyyy-MM-dd HH:mm:ss.SSS]"), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]]  // use log 

static NSString *const kArchivedLogFileNameFormat = @"yyMMddHHmmss";

static NSFileHandle *_fileHandler = nil; //fileHandle

FOUNDATION_EXPORT NSString *const kMRCentralStateUpdatedNotification;
FOUNDATION_EXPORT NSNotificationName const MRDeviceConnectStateUpdatedNotification;
FOUNDATION_EXTERN NSNotificationName const MRUpgradeStateUpdatedNotification;
FOUNDATION_EXTERN NSNotificationName const MRUpgradeProgressUpdatedNotification;

FOUNDATION_EXTERN NSNotificationName const MRRawdataReceivedNotification; // During blood pressure monitoring

FOUNDATION_EXTERN NSNotificationName const MRRingDataFinishedNotification;

FOUNDATION_EXTERN NSNotificationName const MRRingDataProgressNotification;



FOUNDATION_EXTERN int kMRAlgorithmVersion;

FOUNDATION_EXTERN NSString *kMRFrameworkVersion;


@interface MRApi : NSObject

/**
 Parameter Description:
 
 @required: appId
 @required: appKey
 
 completion -> return: (isValid)  isValid == 1 (valid) isValid == 0 (error)
 
 error: 
 
 
 
 */


+ (void)setUpWithAppId:(NSString *)appId appKey:(NSString *)appKey completion:(void(^)(BOOL isValid,NSError * error))completion;

/**
    @Optional   pathName: path name.   --> mark path name （It's best for different users to use different file names） define  "MegaLog"
 
    @Optional   pathSize: The maximum file size.  define 500000  -- > 500K
 
    @Optional   tempLogFileName example---> mega_log.txt  default: mega_log.txt.
 
    @Optional : isTempLogFile YES -> return tempLogFile  NO -> return  null
 
 //log的path --  example  /var/mobile/Containers/Data/Application/C47ACCFD-410C-411C-AEE1-B867624F01E5/Documents/MegaLog/mega_log.txt
 // /var/mobile/Containers/Data/Application/A5514E0D-C6D6-4C65-B254-99E5FC7140D4/Documents/MegaLog/211222175149.txt"
 
 */

+ (void)setLogsPathName:(NSString *)pathName tempLogFileName:(NSString *)tempLogFileName pathSize:(unsigned long long)pathSize noTempLogFile:(BOOL)isTempLogFile;

/**
 isEnabled : is open log ?    define : NO .
 */
+ (void)setMRLogEnabled:(BOOL)isEnabled;
+ (void)PMRLogWithString:(NSString *)logStr; //debug ..

+ (void)QMRLogWithString:(NSString *)logStr;  //logs write...
+ (void)deleteLog:(NSString *)filename; // delete log
+ (void)switchToNewLog;       // Switch to a new log
+ (NSArray *)getLogsForUpload; // get logs path



// parse data to report;
+ (void)parseMonitorData:(NSData *)data completion:(void (^)(MRReport *report, NSError *error))completion;
//parse BP data to report;
+ (void)parseBPData:(NSData *)data time:(int)time caliSBP:(double)caliSBP caliDBP:(double)caliDBP block:(void (^)(MRBPReport *report, NSError *error))completion;
//parse Daily data
+ (NSArray<MRDailyReport *> *)parseDaily:(NSData *)data;

+ (void)setDataUploadEnabled:(BOOL)isEnabled;

@end
