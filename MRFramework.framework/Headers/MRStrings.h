//
//  MRStrings.h
//  MegaRingBLE
//
//  Created by Superman on 2018/5/4.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import <Foundation/Foundation.h>



FOUNDATION_EXTERN NSString *const MegaRingName;
FOUNDATION_EXTERN NSString *const MegaRingDFUName;
FOUNDATION_EXTERN NSString *const MegaRingV2Name;
FOUNDATION_EXTERN NSString *const MegaRingV8Name;



FOUNDATION_EXTERN NSString *const BLELog;
FOUNDATION_EXTERN NSString *const BLELogReserve;
FOUNDATION_EXTERN NSString *const BLELogId;


FOUNDATION_EXTERN NSString *const BLENormalId;
FOUNDATION_EXTERN NSString *const BLENormalWriteId;
FOUNDATION_EXTERN NSString *const BLENormalWriteNoResponseId;
FOUNDATION_EXTERN NSString *const BLENormalIndicateId;
FOUNDATION_EXTERN NSString *const BLENormalNotifyId;
FOUNDATION_EXTERN NSString *const BLENormalReadId;


FOUNDATION_EXTERN NSString *const BLEDFUId;
FOUNDATION_EXTERN NSString *const BLEDFUWriteNotifyId;
FOUNDATION_EXTERN NSString *const BLEDFUWriteNoResponseId;
FOUNDATION_EXTERN NSString *const BLEDFUReadId;


FOUNDATION_EXTERN NSString *const BLELMNormalId;
FOUNDATION_EXTERN NSString *const BLELMReserve1;
FOUNDATION_EXTERN NSString *const BLELMReserve2;

FOUNDATION_EXTERN NSString *const MR_SVC_ROOT;
FOUNDATION_EXTERN NSString *const MR_CH_CTRL;
FOUNDATION_EXTERN NSString *const MR_CH_DATA;
FOUNDATION_EXTERN NSString *const MR_CH_INFO;

FOUNDATION_EXTERN NSString *const MR_SVC_LOG_ROOT;
FOUNDATION_EXTERN NSString *const MR_CH_LOG_CTRL;
FOUNDATION_EXTERN NSString *const MR_CH_LOG_DATA;

FOUNDATION_EXTERN NSString *const MR_SVC_DFU_UUID;
FOUNDATION_EXTERN NSString *const MR_CH_DFU_CTRL;
FOUNDATION_EXTERN NSString *const MR_CH_DFU_PACKET;
FOUNDATION_EXTERN NSString *const MR_CH_DFU_NOBONDS;
FOUNDATION_EXTERN NSString *const MR_CH_DFU_BONDS;


// keys in CB advertisementData
FOUNDATION_EXTERN NSString *const kCBAdvDataIsConnectable;
FOUNDATION_EXTERN NSString *const kCBAdvDataLocalName;
FOUNDATION_EXTERN NSString *const kCBAdvDataManufacturerData;
FOUNDATION_EXTERN NSString *const kCBAdvDataServiceUUIDs;






FOUNDATION_EXTERN NSErrorDomain const NSMRSDkErrorDomain;

FOUNDATION_EXTERN NSNotificationName const MRUpgradeStateUpdatedNotification;
FOUNDATION_EXTERN NSNotificationName const MRUpgradeProgressUpdatedNotification;

FOUNDATION_EXTERN NSNotificationName const MRDeviceDiscoveredNotification;
FOUNDATION_EXTERN NSNotificationName const MRDeviceConnectStateUpdatedNotification;
FOUNDATION_EXTERN NSNotificationName const MRDeviceUpdatedNotification;

FOUNDATION_EXTERN NSNotificationName const MRRingDataFinishedNotification;

FOUNDATION_EXTERN NSNotificationName const MRRingDataProgressNotification;

FOUNDATION_EXTERN NSNotificationName const MRRawdataReceivedNotification; //Bp data noti





