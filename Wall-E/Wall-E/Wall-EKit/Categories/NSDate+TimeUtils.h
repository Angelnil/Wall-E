//
//  NSDate+TimeUtils.h
//  Wall-E
//
//  Created by Angle_Yan on 15/6/3.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TimeUtils)

#define DateFormat1 @"yyyy-MM-dd hh:mm:ss"      //the naming is not good
#define DateFormat2 @"yyyy-MM-dd hh:mm:ss:SSS"
#define DateFormat3 @"yyyy-MM-dd-hh-mm-ss-SSS"
#define DateFormat4 @"h-mm"
#define DateFormat5 @"yyyy-MM-dd a H:mm:ss"
#define DateFormat6 @"yyyy-MM-dd HH:mm"
#define DateFormat7 @"M月d日 H:mm"
#define DataWithYear_Mouth_Day @"yyyy-MM-dd"

//当前时间转化成
+ (NSString *)fullTimeStringNowWithFormater:(NSString *)formater;

//将 NSDate 时间转化成 NSString 类型
+ (NSString *)timeStringFromDate:(NSDate *)date withFormat:(NSString *)format;

//将 NSString 类型的时间转出 NSDate 类型
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;


+ (NSString *)timestamp;

+ (NSString *)friendTimeStringForDate:(NSDate *)date;
+ (NSString *)friendTimeStringForTimestamp:(NSTimeInterval)timestamp;
+ (NSString *)friendTimeStringFromNormalTimeString:(NSString *)timeString;   //DateFormat6

+ (NSString *)dayHourMinuteTimeStringForTimestamp:(NSTimeInterval)timestamp;
+ (NSString *)dayHourMinuteTimeStringFromNormalTimeString:(NSString *)timeString;   //DateFormat6

+ (NSString *)fullTimeStringNow;
+ (NSString *)fullTimeStringForDate:(NSDate *)date;
+ (NSString *)chineseTimeStringForTimestamp:(NSTimeInterval)timestamp;
/**根据日期得到月份*/
+ (NSString *)chineseTimeStringForDate:(NSDate *)date;

+ (NSString *)convertString:(NSString *)string fromFormat:(NSString *)oldFormat toFormat:(NSString *)newFormat;

+ (NSString *)timeStringFromTimeStamp:(NSString *)timestamp withFormat:(NSString *)format;
/** 根据日期得到星座 */
+ (NSString *)constellationFromDate:(NSDate *)date;
/** 根据dateString得到星期几 */
+ (NSString *)weekDayForDateString:(NSString *)dateString withFormat:(NSString *)format;
/** 根据日期得到星期几 */
+ (NSString *)weekDayForDate:(NSDate *)date;

+ (NSDate *)beginningOfDay:(NSDate *)date;
+ (NSDate *)beginningOfNextDay:(NSDate *)date;
+ (NSDate *)endOfDay:(NSDate *)date;

/** 几天以前，如果大于一个星期，就显示年月日 */
+ (NSString *)daysBeforeForDataString:(NSString *)dateString;

@end
