//
//  MRReport.h
//  MRFramework
//
//  Created by Superman on 21/02/2019.
//  Copyright © 2019 Superman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRDefines.h"


@interface MRReport : NSObject

@property (nonatomic, assign) MRDeviceMonitorMode reportType;


@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) int version;			// 数据格式版本 (version of data format)
@property (nonatomic, assign) int handonDuration;	// 上手时长 (duration of on hand)
@property (nonatomic, assign) int startTime;		// 算法得出的监测开启时间 (timestamp of start by algorithm)
@property (nonatomic, assign) int duration;			// 监测时长 (monitor duration)

@property (nonatomic, strong) NSArray *spArr;		// 血氧饱和度数组, 每秒一个值 (SpO2 value every second)
@property (nonatomic, strong) NSArray *prArr;		// 脉率数组, 每秒一个值 (PR value every second)
@property (nonatomic, strong) NSArray *handoffArr;	// 离手数组, 子数组包含每次离手的始末时间

@property (nonatomic, copy) NSString *errInfo;		// 错误信息

@property (nonatomic, assign) int originStart;		// 监测原始开启时间 (timestamp of start in origin data)
@property (nonatomic, assign) int originEnd;		// 监测原始结束时间 (timestamp of end in origin data)

@property (nonatomic, assign) int maxPr;			// 最大脉率
@property (nonatomic, assign) int minPr;			// 最小脉率
@property (nonatomic, assign) int avgPr;			// 平均脉率
@property (nonatomic, assign) float minSp;			// 最小血氧
@property (nonatomic, assign) float avgSp;			// 平均血氧

@property (nonatomic, assign) int durationUnder95;	// 血氧饱和度低于95%的时长 (total seconds of SpO2 value below 95%)
@property (nonatomic, assign) int durationUnder90;
@property (nonatomic, assign) int durationUnder85;
@property (nonatomic, assign) int durationUnder80;
@property (nonatomic, assign) int durationUnder70;
@property (nonatomic, assign) int durationUnder60;

@property (nonatomic, assign) float percentUnder95;	// 血氧饱和度低于95%的时长占比 (percent of duration that SpO2 value below 95%)
@property (nonatomic, assign) float percentUnder90;
@property (nonatomic, assign) float percentUnder85;
@property (nonatomic, assign) float percentUnder80;
@property (nonatomic, assign) float percentUnder70;
@property (nonatomic, assign) float percentUnder60;

// Oxygen Desaturation
@property (nonatomic, assign) int odCount;			// 氧减次数 (oxygen desaturation count)
@property (nonatomic, assign) float odIndex;       	// 氧减指数 (oxygen desaturation index)
@property (nonatomic, assign) int maxOdDuration;	// 最长氧减时间, 该指标当前未使用

@property (nonatomic, strong) NSArray *stageArr;	// 分期数组 (sleep stages in minutes)
@property (nonatomic, assign) int wakeMins;			// 清醒分钟 (total minutes of awake)
@property (nonatomic, assign) int remMins;         	// 眼动分钟 (total minutes of rapid eye movement)
@property (nonatomic, assign) int lightMins;       	// 浅睡分钟 (total minutes of light sleep)
@property (nonatomic, assign) int deepMins;        	// 深睡分钟 (total minutes of deep sleep)
@property (nonatomic, assign) int handOffMins;      // 离手分钟 (total minutes of invalid values)

@property (nonatomic, assign) int steps;            // only for Exercise monitor






@end

