//
//  DateTool.h
//  adapteTableviewHight
//
//  Created by lhp3851 on 16/6/14.
//  Copyright © 2016年 ZizTourabc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKTimer.h"

@interface DateTool : NSObject
//转化成系统时间,本地时间为GMT
+ (NSDate *)getLocaleDateFromUTCDate:(NSDate *)date;

//通过日期获取日期
+(NSDate *)getDateFromString:(NSString *)timeString;
//通过时间戳获取日期
+(NSDate *)getDateFromTimeStamp:(NSString *)timeStamp;
//通过时间间隔获取日期
+(NSDate *)getDateFromTimeInterval:(NSTimeInterval)timeInterval;

/**-----------------------------获取字符串时间--------------------------------**/
//根据时间字符串获取本地标准时间
+(NSString *)friendTimeFromString:(NSString *)timeString;
//根据时间戳获取本地标准时间
+(NSString *)friendTimeFromStamp:(NSString *)timeStamp;
//根据时间间隔获取本地标准时间
+(NSString *)friendTimeFromInterVal:(NSTimeInterval)timeInterVal;
/**-----------------------------时间组成成员--------------------------------**/

//通过时间字符串获取时间组成成员
+(NSDateComponents *)getDateComponnentWithString:(NSString *)string;
+(NSDateComponents *)getDateComponnentWithDate  :(NSDate *)date;
@end


@interface DateFormatter <__covariant ObjectType>: NSDateFormatter
+(void)dateFormatterInfo;

+( NSDateFormatter *)defaultDateFormatter;
@end

@interface TimeZone : NSTimeZone

+(void)timeZoneInfo;//timeZoneInfo

+(NSTimeZone *)defaultTimeZone;
@end

@interface TimeLocale : NSLocale
+(void)timeLocalInfo;

+(NSLocale *)defaultTimeLocal;
@end

@interface Date : NSDate
+(void)dateInfo;

+(NSDate *)curruntDate;
@end

@interface Calendar : NSCalendar
+(void)calendarIfo;

+(NSCalendar *)defaultCalendar;
@end
