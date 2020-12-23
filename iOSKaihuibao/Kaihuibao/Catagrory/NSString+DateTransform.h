//
//  NSString+DateTransform.h
//  Kaihuibao
//
//  Created by mac126 on 2019/4/8.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DateTransform)

/**
 转日期格式的方法 将拿到的NSDate转化为NSString

 @param date 需要转化的NSDate
 @param formatStr 传入需要的格式formatter
 @return 转化为NSString
 */
+ (NSString *)dateTranformTimeStrFromDate:(NSDate *)date withformat:(NSString *)formatStr;

/**
 转日期格式的方法 将拿到的NSString转化为NSDate

 @param dateStr 需要转化的字符串日期
 @param formatStr 传入需要的格式formatter
 @return 转化为NSDate
 */
+ (NSDate *)dateTranformDateFromTimeStr:(NSString *)dateStr withformat:(NSString *)formatStr;


/**
 将一个指定格式的日期字符串转化为指定格式的输出显示字符串

 @param dateStr 需要转化的时间字符串
 @param fromFormat 转化之前的格式format
 @param toFormat 想要转化成为的格式format
 @return 转化后的日期字符串
 */
+ (NSString *)dateTranformTimeStrFromTimeStr:(NSString *)dateStr withFromformat:(NSString *)fromFormat  withToformat:(NSString *)toFormat;


/**
 将标准日期格式yyyy-MM-dd HH:mm:ss字符串 转化为 今天HH:mm、明天HH:mm、后天HH:mm、年月日HH:mm的输出显示格式

 @param dateStr 标准日期格式yyyy-MM-dd HH:mm:ss字符串
 @return 今天HH:mm、明天HH:mm、后天HH:mm、年月日HH:mm
 */
+ (NSString *)dateTranformDayTimeStrFromTimeStr:(NSDate *)dateStr;


/**
 将标准日期格式yyyy-MM-dd HH:mm:ss字符串 转化为 今天、明天、后天、年月日的输出显示格式

 @param dateStr 标准日期格式yyyy-MM-dd HH:mm:ss字符串
 @return 今天、明天、后天、年月日
 */
+ (NSString *)dateTranformDayStrFromTimeStr:(NSString *)dateStr;


/**
 将结束时间和开始时间比较转化为会议时长

 @param startTime 会议开始时间
 @param endTime 会议结束时间
 @return 计算最后的时间差格式化的字符串 几时几分
 */
+ (NSString *)dateTimeInervalToEndFromStart:(NSString *)startTime withEnd:(NSString *)endTime;
@end

NS_ASSUME_NONNULL_END
