//
//  NSString+DateTransform.m
//  Kaihuibao
//
//  Created by mac126 on 2019/4/8.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "NSString+DateTransform.h"

@implementation NSString (DateTransform)

// 转日期格式的方法 将拿到的NSDate转化为NSString
+ (NSString *)dateTranformTimeStrFromDate:(NSDate *)date withformat:(NSString *)formatStr {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setLocale:locale];
    [formatter setDateFormat:formatStr]; //    @"yyyy-MM-dd HH:mm:ss"
    return [formatter stringFromDate:date];
    
}

// 转日期格式的方法 将拿到的NSString转化为NSDate
+ (NSDate *)dateTranformDateFromTimeStr:(NSString *)dateStr withformat:(NSString *)formatStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
     NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
     [formatter setLocale:locale];
     [formatter setDateFormat:formatStr]; //  @"yyyy-MM-dd HH:mm:ss"
    return [formatter dateFromString:dateStr];
    
    
}

+ (NSString *)dateTranformTimeStrFromTimeStr:(NSString *)dateStr withFromformat:(NSString *)fromFormat  withToformat:(NSString *)toFormat {
    // 首先将将拿到的NSString转化为NSDate
    NSDate *tempDate = [self dateTranformDateFromTimeStr:dateStr withformat:fromFormat];
    // 将NSDate格式化为NSString 变为要求的格式
    NSString *timeStr = [self dateTranformTimeStrFromDate:tempDate withformat:toFormat];
    
    return timeStr;
}

+ (NSString *)dateTranformDayTimeStrFromTimeStr:(NSDate *)dateStr {
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
    
    if ([dateStr isToday]) {
        [outputFormatter setDateFormat:SIMLocalizedString(@"TimeTodayAndTime", nil)];
    }else if ([dateStr isTomorrow]){
        [outputFormatter setDateFormat:SIMLocalizedString(@"TimeTomorrowAndTime", nil)];
    }else if ([dateStr isAfterTomorrow]){
        [outputFormatter setDateFormat:SIMLocalizedString(@"TimeAfterTomorrowAndTime", nil)];
    }else {
        [outputFormatter setDateFormat:SIMLocalizedString(@"TimeYearANDdayAndTime", nil)];
    }
    NSLocale *locale2 = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [outputFormatter setLocale:locale2];
    
    return [outputFormatter stringFromDate:dateStr];
}

+ (NSString *)dateTranformDayStrFromTimeStr:(NSString *)dateStr {
    // 首先将将拿到的NSString转化为NSDate
    NSDate *inputDate = [self dateTranformDateFromTimeStr:dateStr withformat:@"yyyy-MM-dd HH:mm:ss"];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
    
    if ([inputDate isToday]) {
        [outputFormatter setDateFormat:SIMLocalizedString(@"TimeToday", nil)];
    }else if ([inputDate isTomorrow]) {
        [outputFormatter setDateFormat:SIMLocalizedString(@"TimeTomorrow", nil)];
    }else if ([inputDate isAfterTomorrow]) {
        [outputFormatter setDateFormat:SIMLocalizedString(@"TimeAfterTomorrow", nil)];
    }else {
        [outputFormatter setDateFormat:SIMLocalizedString(@"TimeYearANDday", nil)];
    }
    NSLocale *locale2 = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [outputFormatter setLocale:locale2];
    
    return [outputFormatter stringFromDate:inputDate];
}

// 将结束时间和开始时间比较转化为会议时长
+ (NSString *)dateTimeInervalToEndFromStart:(NSString *)startTime withEnd:(NSString *)endTime {
    NSDate* startDate = [NSString dateTranformDateFromTimeStr:startTime withformat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* stopDate = [NSString dateTranformDateFromTimeStr:endTime withformat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval time = [stopDate timeIntervalSinceDate:startDate];
    int hours = ((int)time)%(3600*24)/3600;
    int minutes = ((int)time)%(3600*24)%3600/60;
    NSString *timeString;
    if (hours == 0) {
        timeString = [NSString stringWithFormat:@"%d%@",minutes,SIMLocalizedString(@"TimeMinutes", nil)];
    }else {
        if (minutes==0) {
            timeString = [NSString stringWithFormat:@"%d %@",hours,SIMLocalizedString(@"TimeHour", nil)];
        }else {
            timeString = [NSString stringWithFormat:@"%d%@ %d%@",hours,SIMLocalizedString(@"TimeHour", nil),minutes,SIMLocalizedString(@"TimeMinutes", nil)];
        }
    }
    return timeString;
}




@end
