//
//  DateTool.m
//  adapteTableviewHight
//
//  Created by lhp3851 on 16/6/14.
//  Copyright © 2016年 ZizTourabc. All rights reserved.
//

#import "DateTool.h"
#import "NSDate+Category.h"
#import "NSDate+Extension.h"

@implementation DateTool
/**-----------------------------把date转化成系统时间,本地时间为GMT--------------------------------**/
+ (NSDate *)getLocaleDateFromUTCDate:(NSDate *)date
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [TimeZone defaultTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
    return  destinationDateNow;
}
/**-----------------------------获取日期--------------------------------**/
//通过日期获取本地标准的日期
+(NSDate *)getDateFromString:(NSString *)timeString{
    NSDateFormatter *dateFormatter=[DateFormatter defaultDateFormatter];
    NSDate *orignalDate=[dateFormatter dateFromString:timeString];
    NSDate *systemDate=[self getLocaleDateFromUTCDate:orignalDate];
    return systemDate;
}
//通过时间戳获取本地标准的日期
+(NSDate *)getDateFromTimeStamp:(NSString *)timeStamp{
    NSDateFormatter *dateFormatter=[DateFormatter defaultDateFormatter];
    NSTimeInterval adjustTimeInterVal=[dateFormatter.timeZone secondsFromGMT];
    NSTimeInterval secondInterVal = timeStamp.doubleValue/ 1000+adjustTimeInterVal;
    NSDate *orignalDate=[NSDate dateWithTimeIntervalSince1970:secondInterVal];
    return orignalDate;
}
//通过时间间隔获取本地标准的日期
+(NSDate *)getDateFromTimeInterval:(NSTimeInterval)timeInterval{
    NSTimeInterval secondInterVal = timeInterval/ 1000;
    NSDate *orignalDate=[NSDate dateWithTimeIntervalSince1970:secondInterVal];
    NSDate *systemDate=[self getLocaleDateFromUTCDate:orignalDate];
    return systemDate;
}
/**-----------------------------获取字符串时间--------------------------------**/
//根据时间字符串获取本地标准的时间
+(NSString *)friendTimeFromString:(NSString *)timeString{
    NSDateFormatter *dateFormatter=[DateFormatter defaultDateFormatter];
    NSDate *orignalDate=[dateFormatter dateFromString:timeString];
    NSDate *systemDate=[self getLocaleDateFromUTCDate:orignalDate];
    NSString *stringTime=[dateFormatter stringFromDate:systemDate];
    return stringTime;
}
//根据时间戳获取本地标准时间
+(NSString *)friendTimeFromStamp:(NSString *)timeStamp{//毫秒
    NSTimeInterval secondInterVal = timeStamp.doubleValue/ 1000;
    NSDateFormatter *dateFormatter=[DateFormatter defaultDateFormatter];
    NSDate *orignalDate=[NSDate dateWithTimeIntervalSince1970:secondInterVal];
    NSDate *systemDate=[self getLocaleDateFromUTCDate:orignalDate];
    NSString *stringTime=[dateFormatter stringFromDate:systemDate];
    return stringTime;
}
//根据时间间隔获取本地标准时间
+(NSString *)friendTimeFromInterVal:(NSTimeInterval)timeInterVal{//毫秒
    NSTimeInterval secondInterVal = timeInterVal/ 1000;
    NSDateFormatter *dateFormatter=[DateFormatter defaultDateFormatter];
    NSDate *orignalDate=[NSDate dateWithTimeIntervalSince1970:secondInterVal];
    NSDate *systemDate=[self getLocaleDateFromUTCDate:orignalDate];
    NSString *stringTime=[dateFormatter stringFromDate:systemDate];
    return stringTime;
}

/**-----------------------------通过时间字符串获取时间组成成员--------------------------------**/
+(NSDateComponents *)getDateComponnentWithString:(NSString *)string{
    NSDateFormatter *defaultDateFormatter=[DateFormatter defaultDateFormatter];
    NSCalendar *currentCalendar=[Calendar defaultCalendar];
    NSDate *currentDate        =[defaultDateFormatter dateFromString:string];
    NSDate *systemDate         =[self getLocaleDateFromUTCDate:currentDate];
    NSDateComponents *calendarComponents=[currentCalendar components:(NSCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay|NSCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekdayOrdinal|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekOfYear| NSCalendarUnitQuarter|NSCalendarUnitYearForWeekOfYear|NSCalendarUnitNanosecond|NSCalendarUnitCalendar|NSCalendarUnitTimeZone) fromDate:systemDate];
    return calendarComponents;
}

+(NSDateComponents *)getDateComponnentWithDate:(NSDate *)date{
    NSCalendar *currentCalendar=[Calendar defaultCalendar];
    NSDateComponents *calendarComponents=[currentCalendar components:(NSCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay|NSCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekdayOrdinal|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekOfYear| NSCalendarUnitQuarter|NSCalendarUnitYearForWeekOfYear|NSCalendarUnitNanosecond|NSCalendarUnitCalendar|NSCalendarUnitTimeZone) fromDate:date];
    return calendarComponents;
}

/**-----------------------------通过日期获取友好时间--------------------------------**/
+ (NSString*)getTimeStringWithDate:(NSDate*)date{
    NSDateFormatter *dateFormatter = [DateFormatter defaultDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    dateFormatter.locale = [TimeLocale defaultTimeLocal];
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [Calendar defaultCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDate *createDate = date;//目标时间
    NSDate *nowDate = [NSDate date];// 当前时间
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
            dateFormatter.dateFormat = @"MM-dd HH:mm";
            return [dateFormatter stringFromDate:newDate];
        }
    } else { // 非今年
        NSTimeInterval stamp = [createDate timeIntervalSince1970] + [KKTimer getOffsetBetweenServerAndLocaltime];
        NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:stamp];
        dateFormatter.dateFormat = @"MM-dd HH:mm";
        return [dateFormatter stringFromDate:newDate];
    }
}


@end

#pragma mark DefaultDateFormatter
@implementation DateFormatter
+(void)dateFormatterInfo{
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSDate *date = [NSDate date];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    NSLog(@"Formatted date string for locale :%@, %@", [[dateFormatter locale] localeIdentifier], formattedDateString);
    //en_US, June 14, 2016<--NSDateFormatterBehavior10_4|NSDateFormatterBehaviorDefault
    //NSDateFormatterBehaviorDefault (TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IPHONE))
}


+(NSDateFormatter *)defaultDateFormatter{
    if (self) {
        //NSDateFormatterNoStyle     = kCFDateFormatterNoStyle,
        //NSDateFormatterShortStyle  = kCFDateFormatterShortStyle,//“11/23/37” or “3:30pm”
        //NSDateFormatterMediumStyle = kCFDateFormatterMediumStyle,//"Nov 23, 1937"
        //NSDateFormatterLongStyle   = kCFDateFormatterLongStyle,//"November 23, 1937” or “3:30:32pm"
        //NSDateFormatterFullStyle   = kCFDateFormatterFullStyle//“Tuesday, April 12, 1952 AD” or “3:30:42pm PST”
        NSDateFormatter *dateFormatter=[NSDateFormatter new];
        dateFormatter.locale    =[TimeLocale defaultTimeLocal];
        dateFormatter.timeZone  =[TimeZone defaultTimeZone];
        dateFormatter.calendar  =[Calendar defaultCalendar];
        dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss z EEEE";//yyyy-MM-dd HH:mm:ss z EEEE
        return dateFormatter;
    }
    return nil;
}
@end

@implementation TimeZone
+(void)timeZoneInfo{
    NSLog(@"当前iOS系统已知的时区名称：%@",[NSTimeZone knownTimeZoneNames]);
    
    NSLog(@"abbreviationDictionary:%@",[NSTimeZone abbreviationDictionary]);
    
    NSLog(@"systemTimeZone:%@",[NSTimeZone systemTimeZone]);
    
    NSLog(@"defaultTimeZone:%@",[NSTimeZone defaultTimeZone]);
    
    NSLog(@"localTimeZone:%@",[NSTimeZone localTimeZone]);
    
    NSLog(@"timeZoneDataVersion:%@",[NSTimeZone timeZoneDataVersion]);
    
    NSLog(@"systemTimeZone secondsFromGMT:%ld and daylightSavingTimeOffset:%f",[NSTimeZone systemTimeZone].secondsFromGMT,[NSTimeZone systemTimeZone].daylightSavingTimeOffset);
    
    NSLog(@"systemTimeZone daylightSavingTime:%d",[NSTimeZone systemTimeZone].daylightSavingTime);
    
    NSLog(@"systemTimeZone description:%@",[NSTimeZone systemTimeZone].description);
    
    NSLog(@"systemTimeZone data and name:%@,%@",[NSTimeZone systemTimeZone].data,[NSTimeZone systemTimeZone].name);
}

+(NSTimeZone *)defaultTimeZone{
    return [NSTimeZone systemTimeZone];
}
@end

@implementation TimeLocale
+(void)timeLocalInfo{
    NSLocale *currentLoacle=[NSLocale currentLocale];
    NSLog(@"currentLocale:%@",currentLoacle);
    
    NSLog(@"autoupdatingCurrentLocale:%@",[NSLocale autoupdatingCurrentLocale]);
    
    NSLog(@"systemLocale:%@",[NSLocale systemLocale]);
    
    NSLog(@"systemLocale localeIdentifier:%@",[NSLocale systemLocale].localeIdentifier);
    
    NSLog(@"availableLocaleIdentifiers:%@",[NSLocale availableLocaleIdentifiers]);
    
    NSLog(@"ISOLanguageCodes:%@",[NSLocale ISOLanguageCodes]);
    
    NSLog(@"ISOCountryCodes:%@",[NSLocale ISOCountryCodes]);
    
    NSLog(@"ISOCurrencyCodes:%@",[NSLocale ISOCurrencyCodes]);
    
    NSLog(@"commonISOCurrencyCodes:%@",[NSLocale commonISOCurrencyCodes]);
    
    NSLog(@"local preferredLanguages:%@  and preferredLocalizations:%@ localizedInfoDictionary:%@",[NSLocale preferredLanguages],[[NSBundle mainBundle] preferredLocalizations],[[NSBundle mainBundle] localizedInfoDictionary]);
    
    NSLog(@"NSLocale:description:%@",[NSLocale description]);
    
}

+(NSLocale *)defaultTimeLocal{
    return [NSLocale autoupdatingCurrentLocale];//实时更新的
}
@end

@implementation Date

+(void)dateInfo{
    NSDate *currentDate=[self curruntDate];
    NSLog(@"date timeIntervalSinceNow:%f",currentDate.timeIntervalSinceNow);

    NSLog(@"date timeIntervalSinceReferenceDate:%f",currentDate.timeIntervalSinceReferenceDate);

    NSLog(@"date timeIntervalSince1970:%f",currentDate.timeIntervalSince1970);
    
    NSLog(@"date description:%@",currentDate.description);
    
    NSLog(@"date distantPast:%@",[NSDate distantPast]);

    NSLog(@"date distantPast:%@",[NSDate distantFuture]);
}

+(NSDate *)curruntDate{
    return  [self getLocaleDateFromUTCDate:[NSDate date]];
}

@end


@implementation Calendar
+(void)calendarIfo{
    NSCalendar *defaultCalendar=[self defaultCalendar];
    NSLog(@"currentCalendar:%@",[NSCalendar currentCalendar]);
    
    NSLog(@"autoupdatingCurrentCalendar:%@",[NSCalendar autoupdatingCurrentCalendar]);
    
    NSLog(@"calendar Identifier:%@",defaultCalendar.calendarIdentifier);
    
    NSLog(@"calendar locale:%@",defaultCalendar.locale);
    
    NSLog(@"calendar timeZone:%@",defaultCalendar.timeZone);
    
    NSLog(@"calendar firstWeekday:%lui",(unsigned long)defaultCalendar.firstWeekday);
    
    NSLog(@"calendar minimumDaysInFirstWeek:%lui",(unsigned long)defaultCalendar.minimumDaysInFirstWeek);
    
    NSLog(@"calendar eraSymbols：%@,calendar longEraSymbols：%@",defaultCalendar.eraSymbols,defaultCalendar.longEraSymbols);
    
    NSLog(@"calendar monthSymbols:%@\n,calendar shortMonthSymbols:%@\n,calendar veryShortMonthSymbols:%@\n,calendar standaloneMonthSymbols:%@\n,calendar shortStandaloneMonthSymbols:%@\n,calendar veryShortStandaloneMonthSymbols:%@",defaultCalendar.monthSymbols,defaultCalendar.shortMonthSymbols,defaultCalendar.veryShortMonthSymbols,defaultCalendar.standaloneMonthSymbols,defaultCalendar.shortStandaloneMonthSymbols,defaultCalendar.veryShortStandaloneMonthSymbols);

    NSLog(@"calendar weekdaySymbols:%@",defaultCalendar.weekdaySymbols);
    
    NSLog(@"calendar quarterSymbols:%@",defaultCalendar.quarterSymbols);
    
    NSLog(@"calendar PMSymbol:%@",defaultCalendar.PMSymbol);
    
    NSLog(@"calendar AMSymbol:%@",defaultCalendar.AMSymbol);
    
}

+(NSCalendar *)defaultCalendar{
    return [NSCalendar autoupdatingCurrentCalendar];
}

@end

