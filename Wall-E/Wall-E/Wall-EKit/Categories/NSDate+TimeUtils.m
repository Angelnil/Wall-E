//
//  NSDate+TimeUtils.m
//  Wall-E
//
//  Created by Angle_Yan on 15/6/3.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import "NSDate+TimeUtils.h"

@implementation NSDate (TimeUtils)

//将当前时间转成 NSString 类型
+ (NSString *)fullTimeStringNowWithFormater:(NSString *)formater {
    return [[self dateFormaterWithFormat:formater] stringFromDate:[NSDate date]];
}


//将某个时间转化成 NSString 类型
+ (NSString *)timeStringFromDate:(NSDate *)date withFormat:(NSString *)format {
    return [[self dateFormaterWithFormat:format] stringFromDate:date];
}


+ (NSString *)timestamp {
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}


+ (NSString *)friendTimeStringForDate:(NSDate *)date {
    NSString *friendTimeString = @"";
    NSDate *currentDate = [NSDate date];
    NSString *currentYear = [[self dateFormaterWithFormat:@"YYYY"] stringFromDate:currentDate];
    NSString *currentDay = [[self dateFormaterWithFormat:@"dd"] stringFromDate:currentDate];
    if ( ! [currentYear isEqualToString:[[self dateFormaterWithFormat:@"YYYY"] stringFromDate:date]]) {
        return [[self dateFormaterWithFormat:@"M月d日"] stringFromDate:date];
    } else {
        NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:date];
        if (timeInterval < 60) {
            //1分钟以内
            return @"刚刚";
        } else if (timeInterval < 3600) {
            //1小时以内 60分钟
            return [NSString stringWithFormat:@"%.0f分钟前", timeInterval / 60];
        } else if (timeInterval < 86400) {
            //24小时以内
            if ([currentDay isEqualToString:[[self dateFormaterWithFormat:@"dd"] stringFromDate:date]]) {
                return [[self dateFormaterWithFormat:@"H:mm"] stringFromDate:date];
            } else {
                return @"昨天";
            }
        } else {
            return [[self dateFormaterWithFormat:@"M月d日"] stringFromDate:date];
        }
    }
    return friendTimeString;
}

+ (NSString *)friendTimeStringForTimestamp:(NSTimeInterval)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return [self friendTimeStringForDate:date];
}

+ (NSString *)friendTimeStringFromNormalTimeString:(NSString *)timeString {
    NSDate *theDate = [self dateFromString:timeString withFormat:DateFormat6];
    if (theDate) {
        return [self friendTimeStringForDate:theDate];
    }
    else {
        return timeString;
    }
}

+ (NSString *)dayHourMinuteTimeStringForTimestamp:(NSTimeInterval)timestamp {
    NSDate *theDate           = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *theYear         = [[self dateFormaterWithFormat:@"YYYY"] stringFromDate:theDate];
    NSString *theMonthDay     = [[self dateFormaterWithFormat:@"M-dd"] stringFromDate:theDate];
    NSDate *currentDate       = [NSDate date];
    NSString *currentYear     = [[self dateFormaterWithFormat:@"YYYY"] stringFromDate:currentDate];
    NSString *currentMonthDay = [[self dateFormaterWithFormat:@"M-dd"] stringFromDate:currentDate];
    
    if ( ! [currentYear isEqualToString:theYear]) {
        return @"去年";
    }
    else {
        if ( ! [currentMonthDay isEqualToString:theMonthDay]) {
            NSInteger dayInterval = [[[self dateFormaterWithFormat:@"d"] stringFromDate:currentDate] integerValue] - [[[self dateFormaterWithFormat:@"d"] stringFromDate:theDate] integerValue];
            if (dayInterval == 1) {
                return @"昨天";
            }
            else if (dayInterval == 2) {
                return @"前天";
            }
            else {
                return [[self dateFormaterWithFormat:@"M月d日"] stringFromDate:theDate];
            }
        }
        else {
            return [[self dateFormaterWithFormat:@"今天 H:mm"] stringFromDate:theDate];
        }
    }
}

+ (NSString *)dayHourMinuteTimeStringFromNormalTimeString:(NSString *)timeString {
    NSDate *theDate = [self dateFromString:timeString withFormat:DateFormat6];
    if (theDate) {
        return [self dayHourMinuteTimeStringForTimestamp:[theDate timeIntervalSince1970]];
    }
    else {
        return timeString;
    }
}

+ (NSString *)fullTimeStringNow {
    return [self fullTimeStringForDate:[NSDate date]];
}


+ (NSString *)fullTimeStringForDate:(NSDate *)date {
    return [[self dateFormaterWithFormat:DateFormat5] stringFromDate:date];
}

+ (NSString *)chineseTimeStringForTimestamp:(NSTimeInterval)timestamp {
    return [self chineseTimeStringForDate:[NSDate dateWithTimeIntervalSince1970:timestamp]];
}

//返回中文的月份“一。二等”
+ (NSString *)chineseTimeStringForDate:(NSDate *)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM"];
    int i_month=0;
    NSString *theMonth = [dateFormat stringFromDate:date];
    if([[theMonth substringToIndex:0] isEqualToString:@"0"]){
        i_month = [[theMonth substringFromIndex:1] intValue];
    }
    else{
        i_month = [theMonth intValue];
    }
    
    if (i_month == 1) {
        return @"一";
    }
    else if (i_month == 2) {
        return @"二";
    }
    else if (i_month == 3) {
        return @"三";
    }
    else if (i_month == 4) {
        return @"四";
    }
    else if (i_month == 5) {
        return @"五";
    }
    else if (i_month == 6) {
        return @"六";
    }
    else if (i_month == 7) {
        return @"七";
    }
    else if (i_month == 8) {
        return @"八";
    }
    else if (i_month == 9) {
        return @"九";
    }
    else if (i_month == 10) {
        return @"十";
    }
    else if (i_month == 11) {
        return @"十一";
    }
    else if (i_month == 12) {
        return @"十二";
    }
    else {
        return @"";
    }
}

+ (NSString *)convertString:(NSString *)string fromFormat:(NSString *)oldFormat toFormat:(NSString *)newFormat {
    NSDate *date = [self dateFromString:string withFormat:oldFormat];
    return [[self dateFormaterWithFormat:newFormat] stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    return [[self dateFormaterWithFormat:format] dateFromString:string];
}

+ (NSString *)timeStringFromTimeStamp:(NSString *)timestamp withFormat:(NSString *)format {
    return [[self dateFormaterWithFormat:format] stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timestamp longLongValue]]];
}

//根据日期的星座
+ (NSString *)constellationFromDate:(NSDate *)date {
    NSString *retStr=@"";
    //获取月份
    int i_month=0;
    NSString *theMonth = [[self dateFormaterWithFormat:@"MM"] stringFromDate:date];
    if([[theMonth substringToIndex:0] isEqualToString:@"0"]){
        i_month = [[theMonth substringFromIndex:1] intValue];
    }
    else{
        i_month = [theMonth intValue];
    }
    //获取日期
    int i_day=0;
    NSString *theDay = [[self dateFormaterWithFormat:@"dd"] stringFromDate:date];
    if([[theDay substringToIndex:0] isEqualToString:@"0"]){
        i_day = [[theDay substringFromIndex:1] intValue];
    }
    else{
        i_day = [theDay intValue];
    }
    /*
     摩羯座 12月22日------01月19日
     水瓶座 01月20日------02月18日
     双鱼座 02月19日------03月20日
     白羊座 03月21日------04月19日
     金牛座 04月20日------05月20日
     双子座 05月21日------06月21日
     巨蟹座 06月22日------07月22日
     狮子座 07月23日------08月22日
     处女座 08月23日------09月22日
     天秤座 09月23日------10月23日
     天蝎座 10月24日------11月21日
     射手座 11月22日------12月21日
     */
    switch (i_month) {
        case 1:
            if(i_day>=20 && i_day<=31){
                retStr=@"水瓶座";
            }
            if(i_day>=1 && i_day<=19){
                retStr=@"摩羯座";
            }
            break;
        case 2:
            if(i_day>=1 && i_day<=18){
                retStr=@"水瓶座";
            }
            if(i_day>=19 && i_day<=31){
                retStr=@"双鱼座";
            }
            break;
        case 3:
            if(i_day>=1 && i_day<=20){
                retStr=@"双鱼座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"白羊座";
            }
            break;
        case 4:
            if(i_day>=1 && i_day<=19){
                retStr=@"白羊座";
            }
            if(i_day>=20 && i_day<=31){
                retStr=@"金牛座";
            }
            break;
        case 5:
            if(i_day>=1 && i_day<=20){
                retStr=@"金牛座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"双子座";
            }
            break;
        case 6:
            if(i_day>=1 && i_day<=21){
                retStr=@"双子座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"巨蟹座";
            }
            break;
        case 7:
            if(i_day>=1 && i_day<=22){
                retStr=@"巨蟹座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"狮子座";
            }
            break;
        case 8:
            if(i_day>=1 && i_day<=22){
                retStr=@"狮子座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"处女座";
            }
            break;
        case 9:
            if(i_day>=1 && i_day<=22){
                retStr=@"处女座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"天秤座";
            }
            break;
        case 10:
            if(i_day>=1 && i_day<=23){
                retStr=@"天秤座";
            }
            if(i_day>=24 && i_day<=31){
                retStr=@"天蝎座";
            }
            break;
        case 11:
            if(i_day>=1 && i_day<=21){
                retStr=@"天蝎座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"射手座";
            }
            break;
        case 12:
            if(i_day>=1 && i_day<=21){
                retStr=@"射手座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"摩羯座";
            }
            break;
    }
    return retStr;
}


#pragma mark - private metholds

+ (NSDateFormatter *)dateFormaterWithFormat:(NSString *)formatString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    return dateFormatter;
}

+ (NSString *)weekDayForDateString:(NSString *)dateString withFormat:(NSString *)format{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:dateString];
    return [self weekDayForDate:date];
}

+ (NSString *)weekDayForDate:(NSDate *)date{
    
    NSString *weekDay = @"";
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"EEEE"];
    NSString *newDateString = [outputFormatter stringFromDate:date];
    if ([newDateString isEqualToString:@"Monday"] || [newDateString isEqualToString:@"星期一"]) {
        weekDay = @"周一";
    }else if ([newDateString isEqualToString:@"Tuesday"] || [newDateString isEqualToString:@"星期二"]){
        weekDay = @"周二";
    }else if ([newDateString isEqualToString:@"Wednesday"] || [newDateString isEqualToString:@"星期三"]){
        weekDay = @"周三";
    }else if ([newDateString isEqualToString:@"Thursday"] || [newDateString isEqualToString:@"星期四"]){
        weekDay = @"周四";
    }else if ([newDateString isEqualToString:@"Friday"] || [newDateString isEqualToString:@"星期五"]){
        weekDay = @"周五";
    }else if ([newDateString isEqualToString:@"Saturday"] || [newDateString isEqualToString:@"星期六"]){
        weekDay = @"周六";
    }else if ([newDateString isEqualToString:@"Sunday"] || [newDateString isEqualToString:@"星期日"]) {
        weekDay = @"周日";
    } else {
        weekDay = @"错误";
    }
    return weekDay;
}

+ (NSDate *)beginningOfDay:(NSDate *)date {
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:date];
    [parts setHour:0];
    [parts setMinute:0];
    [parts setSecond:0];
    return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

+ (NSDate *)beginningOfNextDay:(NSDate *)date{
    
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:date];
    [parts setDay:parts.day+1];
    [parts setHour:0];
    [parts setMinute:0];
    [parts setSecond:0];
    return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

+ (NSDate *)endOfDay:(NSDate *)date {
    
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:date];
    [parts setHour:23];
    [parts setMinute:59];
    [parts setSecond:59];
    return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

+ (NSString *)daysBeforeForDataString:(NSString *)dateString;
{
    NSString *weekDay = @"";
    NSString *string;
    string = [[dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:19];
    if (!string) {
        return @"错误";
    }
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
    NSDate *date = [inputFormatter dateFromString:string];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date];
    NSInteger daysBefore = (timeInterval+8*3600)/3600/24;//天数
    if (daysBefore <= 0) {
        weekDay = [NSString stringWithFormat:@"%ld小时前",(long)daysBefore];
    } else if (daysBefore <= 7 ) {
        weekDay = [NSString stringWithFormat:@"%ld天前",(long)daysBefore];
    } else {
        weekDay = [NSString stringWithFormat:@"%@",[dateString substringToIndex:10]];
    }
    return weekDay;
}

@end
