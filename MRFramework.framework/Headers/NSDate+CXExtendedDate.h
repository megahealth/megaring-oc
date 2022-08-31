//
//  NSDate+CXExtendedDate.h
//  TestOC
//
//  Created by Superman on 2018/2/7.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 * fmt
 * default is @"yyyy-MM-dd HH:mm:ss", 可通过连写限制输出位数;
 * Y,y	年份, YY 或 yy 输出年份后两位, 大小写交替时会重复输出;
 * M	月份, MMM 缩写 Feb, MMMM 全写 February, MMMMM 首字母 F;
 * D	年的第几天, d 月的第几天, 大小写交替时会重复输出;
 * H	24小时制, h 12小时制;
 * m	分钟;
 * s	秒;
 * S	精确度, 最高到毫秒 SSS;
 */
NSDateFormatter *dateFormatter(NSString *format);

NSDate *dateFromString(NSString *string, NSString *format);

NSString *stringFromDate(NSDate *date, NSString *format);

NSString *localizedStringFromDate(NSDate *date, NSString *format);


/*
 * calendar
 * 设定一周的起始点和第一周的最少天数, 以此划分某月(年)的开始若干天所在周是属于那一月(年);
 * weekOfMonth, weekOfYear 有可能为 0, 即所在周不属于所在月或所在年;
 */
NSCalendar *defaultCalendar(void);

NSDateComponents *compnnentsOfDate(NSDate *date);



@interface NSDate (CXExtendedDate)

@property (nonatomic, assign, readonly) NSInteger era;                  // 世纪
@property (nonatomic, assign, readonly) NSInteger year;                 // 年
@property (nonatomic, assign, readonly) NSInteger month;                // 月
@property (nonatomic, assign, readonly) NSInteger day;                  // 日
@property (nonatomic, assign, readonly) NSInteger hour;                 // 时
@property (nonatomic, assign, readonly) NSInteger minute;               // 分
@property (nonatomic, assign, readonly) NSInteger second;               // 秒
@property (nonatomic, assign, readonly) NSInteger weekDay;              // 星期几, Sun:1, Mon:2, Tue:3 ...
@property (nonatomic, assign, readonly) NSInteger weekOfMonth;          // 所在本月第几周, 0,1,2..., 1 日位于第 0 周, 数值与 firstWeekday 有关
@property (nonatomic, assign, readonly) NSInteger weekOfYear;
@property (nonatomic, assign, readonly) NSInteger weekdayOrdinal;       // 所在本月第几个 7 天中, 或者说是本月的第几个星期 * , 1,2,3...
@property (nonatomic, assign, readonly) NSInteger quarter;              // 几刻钟, 1,2,3,4
@property (nonatomic, assign, readonly) NSInteger yearForWeekOfYear;    // 所在周属于哪一年, 呼应 weekOfYear, 数值与 minimumDaysInFirstWeek 和 firstWeekday 有关



@property (nonatomic, strong, readonly) NSDate *startOfDay;         	// 当天的 0时0分0秒
@property (nonatomic, strong, readonly) NSDate *startOfWeek;        	// 当周首天的 0时0分0秒
@property (nonatomic, strong, readonly) NSDate *startOfMonth;       	// 当月首天的 0时0分0秒
@property (nonatomic, strong, readonly) NSDate *startOfYear;        	// 当年首天的 0时0分0秒

@property (nonatomic, strong, readonly) NSDate *startOfNextDay;     	// 下一天的 0时0分0秒
@property (nonatomic, strong, readonly) NSDate *startOfNextWeek;    	// 下一周首天的 0时0分0秒
@property (nonatomic, strong, readonly) NSDate *startOfNextMonth;   	// 下一月首天的 0时0分0秒
@property (nonatomic, strong, readonly) NSDate *startOfNextYear;    	// 下一年首天的 0时0分0秒

- (BOOL)isSameDay:(NSDate *)aDate;
- (BOOL)isSameWeek:(NSDate *)aDate;
- (BOOL)isSameMonth:(NSDate *)aDate;
- (BOOL)isSameYear:(NSDate *)aDate;


@property (nonatomic, assign, readonly) BOOL isToday;               	// 是否今天
@property (nonatomic, assign, readonly) BOOL isYesterday;           	// 是否昨天
@property (nonatomic, assign, readonly) BOOL isTomorrow;            	// 是否明天
@property (nonatomic, assign, readonly) BOOL isWeekend;             	// 是否周六或周日, 与 firstWeekday 无关
@property (nonatomic, assign, readonly) BOOL isToweek;              	// 是否本周, 与 firstWeekday 有关
@property (nonatomic, assign, readonly) BOOL isTomonth;             	// 是否本月
@property (nonatomic, assign, readonly) BOOL isToyear;              	// 是否今年




@end
