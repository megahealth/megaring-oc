//
//  MRReport.h
//  MRFramework
//
//  Created by Superman on 21/02/2019.
//  Copyright © 2019 Superman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MRFramework/MRDefines.h>


@interface MRSpo2Event : NSObject

@property (assign) int startTime;
@property (assign) int duration;

@end

@interface MRReport : NSObject

@property (nonatomic, copy) NSString *platform;     // iOS
@property (nonatomic, assign) int algVer;           // version of algorithm
@property (nonatomic, strong) NSData *data;

@property (nonatomic, assign) int version;			// 数据格式版本 (version of data format)
@property (nonatomic, assign) MRDeviceMonitorMode reportType;
@property (nonatomic, assign) MRMonitorStopType stopType;
@property (nonatomic, copy) NSString *hwVersion;    // hardware of device
@property (nonatomic, copy) NSString *swVersion;    // sofeware of device
@property (nonatomic, copy) NSString *btVersion;    // bootloader of device
@property (nonatomic, copy) NSString *sn;           // sn of device
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) int steps;            // only for Exercise monitor


@property (nonatomic, assign) int handonDuration;	// 上手时长 (duration of on hand)
@property (nonatomic, assign) int startTime;		// 算法得出的监测开启时间 (timestamp of start by algorithm)
@property (nonatomic, assign) int duration;			// 监测时长 (monitor duration)

@property (nonatomic, strong) NSArray <NSNumber *>*spArr;		// 血氧饱和度数组, 每秒一个值 (SpO2 value every second)
@property (nonatomic, strong) NSArray <NSNumber *>*prArr;		// 脉率数组, 每秒一个值 (PR value every second)
@property (nonatomic, strong) NSArray *handoffArr;	// 离手数组, 子数组包含每次离手的始末时间

@property (nonatomic, copy) NSString *errInfo;		// 错误信息

@property (nonatomic, assign) int originStart;		// 监测原始开启时间 (timestamp of start in origin data)
@property (nonatomic, assign) int originEnd;		// 监测原始结束时间 (timestamp of end in origin data)

@property (nonatomic, assign) int maxPr;			// 最大脉率
@property (nonatomic, assign) int minPr;			// 最小脉率
@property (nonatomic, assign) int avgPr;			// 平均脉率
@property (nonatomic, assign) float minSp;			// 最小血氧
@property (nonatomic, assign) float avgSp;			// 平均血氧

@property (nonatomic, assign) int durationUnder100; // 血氧饱和度低于100%的时长 (total seconds of SpO2 value below 95%)
@property (nonatomic, assign) int durationUnder95;
@property (nonatomic, assign) int durationUnder90;
@property (nonatomic, assign) int durationUnder85;
@property (nonatomic, assign) int durationUnder80;
@property (nonatomic, assign) int durationUnder75;
@property (nonatomic, assign) int durationUnder70;
@property (nonatomic, assign) int durationUnder65;
@property (nonatomic, assign) int durationUnder60;

@property (nonatomic, assign) float percentUnder100; // 血氧饱和度低于100%的时长占比 (percent of duration that SpO2 value below 95%)
@property (nonatomic, assign) float percentUnder95;
@property (nonatomic, assign) float percentUnder90;
@property (nonatomic, assign) float percentUnder85;
@property (nonatomic, assign) float percentUnder80;
@property (nonatomic, assign) float percentUnder75;
@property (nonatomic, assign) float percentUnder70;
@property (nonatomic, assign) float percentUnder65;
@property (nonatomic, assign) float percentUnder60;


// sleep stages

@property (nonatomic, strong) NSArray *stageArr;    // 分期数组 (sleep stages in minutes)
@property (nonatomic, assign) int wakeMins;         // 清醒分钟 (total minutes of awake)
@property (nonatomic, assign) int remMins;          // 眼动分钟 (total minutes of rapid eye movement)
@property (nonatomic, assign) int lightMins;        // 浅睡分钟 (total minutes of light sleep)
@property (nonatomic, assign) int deepMins;         // 深睡分钟 (total minutes of deep sleep)

@property (nonatomic, assign) int fallSleepMins;    // 入睡等待时长 (Waiting time for sleeping)
@property (nonatomic, assign) int wakeInSleepMins;  // 入睡后觉醒时长 (Duration of awakening after falling asleep)


// ODI3 result
@property (nonatomic, assign) int odCount;			// 氧减次数 (oxygen desaturation count)
@property (nonatomic, assign) int maxOdDuration;	// 最长氧减时间, 该指标当前未使用
@property (nonatomic, assign) float odIndex;        // 氧减指数 (oxygen desaturation index)
@property (nonatomic, assign) float odIndexW;       // 氧减指数 对整晚数据，不做分期的统计(Oxygen subtraction index: the data of the whole night will not be counted by stages)

// ODI4 result
@property (nonatomic, assign) int od4Count;            // 氧减次数 (oxygen desaturation count)
@property (nonatomic, assign) int maxOd4Duration;    // 最长氧减时间, 该指标当前未使用
@property (nonatomic, assign) float od4Index;        // 氧减指数 (oxygen desaturation index)
@property (nonatomic, assign) float od4IndexW;       // 氧减指数 对整晚数据，不做分期的统计


// ODI3 result

@property (nonatomic, assign) int ODI3Less100Cnt;   // 血氧低于100高于95的事件个数(Number of events with blood oxygen lower than 100 and higher than 95)
@property (nonatomic, assign) int ODI3Less95Cnt;    // 血氧低于95高于90的事件个数(Number of events with blood oxygen lower than 95 and higher than 90) ....
@property (nonatomic, assign) int ODI3Less90Cnt;
@property (nonatomic, assign) int ODI3Less85Cnt;
@property (nonatomic, assign) int ODI3Less80Cnt;
@property (nonatomic, assign) int ODI3Less75Cnt;
@property (nonatomic, assign) int ODI3Less70Cnt;
@property (nonatomic, assign) int ODI3Less65Cnt;
@property (nonatomic, assign) int ODI3Less60Cnt;    // 血氧低于60的事件个数 (Number of events with blood oxygen lower than 60)

@property (nonatomic, assign) float ODI3Less100Percent; // 血氧低于100高于95的事件占比(Proportion of events with blood oxygen lower than 100 and higher than 95)
@property (nonatomic, assign) float ODI3Less95Percent;  // 血氧低于95高于90的事件占比(Proportion of events with blood oxygen lower than 95 and higher than 90)
@property (nonatomic, assign) float ODI3Less90Percent;
@property (nonatomic, assign) float ODI3Less85Percent;
@property (nonatomic, assign) float ODI3Less80Percent;
@property (nonatomic, assign) float ODI3Less75Percent;
@property (nonatomic, assign) float ODI3Less70Percent;
@property (nonatomic, assign) float ODI3Less65Percent;
@property (nonatomic, assign) float ODI3Less60Percent;  // 血氧低于60的事件占比(Proportion of events with blood oxygen lower than 60)

@property (nonatomic, assign) int ODI3Less10sCnt;       // 时间少于10秒的事件个数(Number of events with time less than 10 seconds)
@property (nonatomic, assign) int ODI3Less20sCnt;       // 时间少于20秒大于10秒的事件个数(Number of events with time less than 20 seconds and more than 10 seconds)
@property (nonatomic, assign) int ODI3Less30sCnt;
@property (nonatomic, assign) int ODI3Less40sCnt;
@property (nonatomic, assign) int ODI3Less50sCnt;
@property (nonatomic, assign) int ODI3Less60sCnt;
@property (nonatomic, assign) int ODI3Longer60sCnt;     // 时间大于60秒的事件个数(Number of events with time greater than 60 seconds)

@property (nonatomic, assign) float ODI3Less10sPercent; // 时间少于10秒的事件占比(Proportion of events with time less than 10 seconds)
@property (nonatomic, assign) float ODI3Less20sPercent; // 时间少于20秒大于10秒的事件占比(Proportion of events with time less than 20 seconds and more than 10 seconds)
@property (nonatomic, assign) float ODI3Less30sPercent;
@property (nonatomic, assign) float ODI3Less40sPercent;
@property (nonatomic, assign) float ODI3Less50sPercent;
@property (nonatomic, assign) float ODI3Less60sPercent;
@property (nonatomic, assign) float ODI3Longer60sPercent;   // 时间大于60秒的事件占比(Proportion of events with time greater than 60 seconds)


// ODI4 result --- as  oid3...

@property (nonatomic, assign) int ODI4Less100Cnt;
@property (nonatomic, assign) int ODI4Less95Cnt;
@property (nonatomic, assign) int ODI4Less90Cnt;
@property (nonatomic, assign) int ODI4Less85Cnt;
@property (nonatomic, assign) int ODI4Less80Cnt;
@property (nonatomic, assign) int ODI4Less75Cnt;
@property (nonatomic, assign) int ODI4Less70Cnt;
@property (nonatomic, assign) int ODI4Less65Cnt;
@property (nonatomic, assign) int ODI4Less60Cnt;

@property (nonatomic, assign) float ODI4Less100Percent;
@property (nonatomic, assign) float ODI4Less95Percent;
@property (nonatomic, assign) float ODI4Less90Percent;
@property (nonatomic, assign) float ODI4Less85Percent;
@property (nonatomic, assign) float ODI4Less80Percent;
@property (nonatomic, assign) float ODI4Less75Percent;
@property (nonatomic, assign) float ODI4Less70Percent;
@property (nonatomic, assign) float ODI4Less65Percent;
@property (nonatomic, assign) float ODI4Less60Percent;

@property (nonatomic, assign) int ODI4Less10sCnt;
@property (nonatomic, assign) int ODI4Less20sCnt;
@property (nonatomic, assign) int ODI4Less30sCnt;
@property (nonatomic, assign) int ODI4Less40sCnt;
@property (nonatomic, assign) int ODI4Less50sCnt;
@property (nonatomic, assign) int ODI4Less60sCnt;
@property (nonatomic, assign) int ODI4Longer60sCnt;

@property (nonatomic, assign) float ODI4Less10sPercent;
@property (nonatomic, assign) float ODI4Less20sPercent;
@property (nonatomic, assign) float ODI4Less30sPercent;
@property (nonatomic, assign) float ODI4Less40sPercent;
@property (nonatomic, assign) float ODI4Less50sPercent;
@property (nonatomic, assign) float ODI4Less60sPercent;
@property (nonatomic, assign) float ODI4Longer60sPercent;

///
/// 氧减事件随时间的分布 (Distribution of oxygen reduction events with time)
///
@property (nonatomic, strong) NSArray <MRSpo2Event *> *spo2Events3;
@property (nonatomic, strong) NSArray <MRSpo2Event *> *spo2Events4;




/// blood pressure

@property (nonatomic, assign) double SBP; //SBP
@property (nonatomic, assign) double DBP; //DBP



/// HRV data

@property (nonatomic, assign) int heartBeat; //分析的心搏数 Heart beat number
@property (nonatomic, assign) float meanBpm; // 平均心率  Average heart rate
@property (nonatomic, assign) int maxRRInterval; //最大的RR间隔 Maximum RR interval
@property (nonatomic, assign) int maxRRTime; // 最大RR间隔发生时间 Maximum RR interval occurrence time
@property (nonatomic, assign) int maxHRTime; // 最快心率发生时间 Maximum heart rate occurrence time
@property (nonatomic, assign) int minHRTime; // 最慢心率发生时间  Occurrence time of slowest heart rate
@property (nonatomic, assign) int tBeat; //心动过速博数 Tachycardia wave number
@property (nonatomic, assign) float tBeatProportion; //心动过速占比 Proportion of tachycardia
@property (nonatomic, assign) int bBeat; //心动过缓博数 Bradycardia number
@property (nonatomic, assign) float bBeatProportion; //心动过缓占比 Proportion of bradycardia

// hrv-----
@property (nonatomic, assign) double SDNN; // 
@property (nonatomic, assign) double SDANN;
@property (nonatomic, assign) double RMSSD;
@property (nonatomic, assign) int NN50;
@property (nonatomic, assign) double pNN50;
@property (nonatomic, assign) double tIdx;  //三角指数 Triangle index
@property (nonatomic, assign) double hfp;
@property (nonatomic, assign) double lfp;
@property (nonatomic, assign) double vlfp;
@property (nonatomic, assign) double lhfr;

@property (nonatomic, strong) NSArray *histArr; // 直方图数组  Histogram array
@property (nonatomic, strong) NSArray *hrvArr; //心率数组 Heart rate array
@property (nonatomic, strong) NSArray *freqArr;  //频率数组 Frequency array
@property (nonatomic, strong) NSArray *rrArr; // 心率曲线 Heart rate curve

@property (nonatomic, assign) BOOL durationValid;

@property (nonatomic, strong) NSArray * tempArr;

@end

