//
//  NSString+KKCountString.m
//  KKStarZone
//
//  Created by WS on 15/12/8.
//  Copyright © 2015年 kankan. All rights reserved.
//

#import "NSString+KKCountString.h"
#include <ifaddrs.h>
#include <arpa/inet.h>


@implementation NSString (KKCountString)


+ (NSString *)getCountStringWithCount:(NSInteger)count{
    NSString *str = nil;
    if (count) { // 数字不为0
        if (count < 0) {
            str = @"0";
        }else if (count < 10000) { // 不足10000：直接显示数字，比如786、7986
            str = [NSString stringWithFormat:@"%lu", (unsigned long)count];
        } else { // 达到10000：显示xx.x万，不要有.0的情况
            double wan = count / 10000.0;
            str = [NSString stringWithFormat:@"%.1f万", wan];
            // 将字符串里面的.0去掉
            str = [str stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
    }else{
        str = [NSString stringWithFormat:@"0"];
    }
    return str;

}

+ (NSString *)getPartStringWithNumber:(NSString *)num
{

    if (num == nil) {
        return @"";
    }
    
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}
+ (NSString *)getTimeStringWithTimeStamp:(NSString *)stamp dateFormatter:(NSString*)dateFormat{
    NSDateFormatter *dateFormatter=[DateFormatter defaultDateFormatter];
    NSTimeInterval longStamp = stamp.doubleValue / 1000;
    //校对后的时间
    longStamp = longStamp - [KKTimer getOffsetBetweenServerAndLocaltime];
    NSTimeInterval adjustTimeInterVal=[dateFormatter.timeZone secondsFromGMT];
    NSTimeInterval secondInterVal = longStamp+adjustTimeInterVal;
    NSDate *nowData = [NSDate dateWithTimeIntervalSince1970:secondInterVal];
    
    return [self getTimeStringWithDate:nowData dateFormat:dateFormat];
}
+ (NSString *)getNormalTimeTextWithTimeStamp:(NSString *)stamp dateFormatter:(NSString*)dateFormat{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSTimeInterval longStamp = stamp.doubleValue / 1000;
    //校对后的时间
//    longStamp = longStamp - [KKTimer getOffsetBetweenServerAndLocaltime];
//    NSTimeInterval adjustTimeInterVal=[dateFormatter.timeZone secondsFromGMT];
    NSTimeInterval secondInterVal = longStamp;//+adjustTimeInterVal;
    NSDate *nowData = [NSDate dateWithTimeIntervalSince1970:secondInterVal];

    dateFormatter.dateFormat = dateFormat;
    return [dateFormatter stringFromDate:nowData];
}
+ (NSString *)getTimeStringWithTimeStamp:(NSString *)stamp{
    NSDateFormatter *dateFormatter=[DateFormatter defaultDateFormatter];
    NSTimeInterval longStamp = stamp.doubleValue / 1000;
    //校对后的时间
    longStamp = longStamp - [KKTimer getOffsetBetweenServerAndLocaltime];
    NSTimeInterval adjustTimeInterVal=[dateFormatter.timeZone secondsFromGMT];
    NSTimeInterval secondInterVal = longStamp+adjustTimeInterVal;
    NSDate *nowData = [NSDate dateWithTimeIntervalSince1970:secondInterVal];
    
    return [self getTimeStringWithDate:nowData];
}

+ (NSString*)getTimeStringWithString:(NSString*)timeStr{

    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.timeZone  = [NSTimeZone timeZoneWithName:@"UTC"];

    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *createDate;
    //HH:mm:ss检测
    NSArray *timeCom = [timeStr componentsSeparatedByString:@":"];
    NSInteger fillCount = 3 - timeCom.count;
    if (fillCount) {
        NSMutableString *fillTimeStr = [timeStr mutableCopy];
        for (NSInteger i = 1; i <= fillCount; i++) {
            [fillTimeStr appendString:@":00"];
        }
        createDate = [fmt dateFromString:fillTimeStr];
    }else
        createDate = [fmt dateFromString:timeStr];
    
    createDate = [createDate dateByAddingTimeInterval:-[KKTimer getOffsetBetweenServerAndLocaltime]];
    return [self getTimeStringWithDate:createDate];
}


+ (NSString*)getTimeStringWithDate:(NSDate*)date dateFormat:(NSString*)dateFormat{
    
    if (dateFormat == nil ||
        dateFormat.length == 0) {
        dateFormat = @"MM-dd HH:mm";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone  = [NSTimeZone timeZoneWithName:@"UTC"];
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [Calendar defaultCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDate *createDate = date;//目标时间
    NSDate *nowDate = [DateTool getLocaleDateFromUTCDate:[NSDate date]];// 当前时间
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:nowDate options:0];
    NSTimeInterval time=[nowDate timeIntervalSinceDate:date];
    
    int hours=((int)time)/3600;
    if ([createDate isThisYear]) {
        if ([createDate isThreeDaysAgo]) {
            return @"3天前";
        }else if([createDate isTwoDaysAgo]){
            return @"2天前";
        }else if ([createDate isYesterday] && hours >= 24) {
            return @"1天前";
        } else if (hours < 24) {
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%d小时前", (int)cmps.hour];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%d分钟前", (int)cmps.minute];
            } else {
                return @"刚刚";
            }
        } else{
            NSTimeInterval stamp = [createDate timeIntervalSince1970] + [KKTimer getOffsetBetweenServerAndLocaltime];
            NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:stamp];
            dateFormatter.dateFormat = dateFormat;
            return [dateFormatter stringFromDate:newDate];
        }
    } else { // 非今年
        NSTimeInterval stamp = [createDate timeIntervalSince1970] + [KKTimer getOffsetBetweenServerAndLocaltime];
        NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:stamp];
        dateFormatter.dateFormat = dateFormat;
        return [dateFormatter stringFromDate:newDate];
    }
}

+ (NSString*)getTimeStringWithDate:(NSDate*)date{
    return [self getTimeStringWithDate:date dateFormat:nil];
}

+ (NSString *)timeDisplayRules:(NSTimeInterval)dis {
    //本条消息时间
    NSDate *qazdate = [[NSDate alloc] initWithTimeIntervalSince1970:dis];
    //（当前时间）
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    //最终显示时间
    NSString *string = [formatter stringFromDate:qazdate];
    
    NSTimeInterval times = [currentDate timeIntervalSince1970] + 8 * 60 * 60;
    double index = (long long)times % (60 * 60 * 24);
    
    //本条信息与当前时间差
    NSTimeInterval spaceTime = [currentDate timeIntervalSinceDate:qazdate];
    float mistiming = (spaceTime - index) / (60 * 60 * 24);
    if (mistiming < 0) {
        
    } else if (mistiming >= 0 && mistiming < 1) {
        string = [NSString stringWithFormat:@"昨天 %@",string];
    } else if (mistiming >= 1 && mistiming < 6) {
        string = [NSString stringWithFormat:@"%@ %@",[self getWeekDayFordate:dis],string];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        //最终显示时间
        string = [formatter stringFromDate:qazdate];
    }
    return string;
    
}

//日期转化为星期
+ (NSString *)getWeekDayFordate:(long long)data
{
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:newDate];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}


+ (NSString *)deviceIPAdress {
    NSString *address = @"192.168.0.1";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);  
    
    return address;  
}

+(NSDate *)getTimeByDateFormater:(NSDateFormatter *)formater withTime:(NSString *)time{
    time = @"20110826134106";
    NSDateFormatter *formaters=[[NSDateFormatter alloc]init];
    [formaters setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] ];
    [formaters setDateFormat:@"yyyyMMddHHmmss"];
    NSDate* Date = [formaters dateFromString:time];
    return Date;
}

@end
