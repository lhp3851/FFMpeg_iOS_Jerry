//
//  NSString+KKCountString.h
//  KKStarZone
//
//  Created by WS on 15/12/8.
//  Copyright © 2015年 kankan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DateTool.h"
#import "NSDate+Extension.h"

@interface NSString (KKCountString)

//根据数量返回 1.0w 格式的数据格式字符串
+ (NSString*)getCountStringWithCount:(NSInteger)count;

+ (NSString *)getPartStringWithNumber:(NSString *)num;

//根据时间戳返回 几分钟前..等格式的时间格式字符串
+ (NSString*)getTimeStringWithTimeStamp:(NSString*)stamp;

//根据时间字符串（特定） 返回时间格式字符串
+ (NSString*)getTimeStringWithString:(NSString*)timeStr;

//根据时间对象 返回时间格式字符串
+ (NSString*)getTimeStringWithDate:(NSDate*)date;

//根据时间（相对1970的秒数） 返回时间格式字符串（特定：环信时间显示规则）
+ (NSString *)timeDisplayRules:(NSTimeInterval)dis;

//根据日期  返回星期
+ (NSString *)getWeekDayFordate:(long long)data;

//获取设备ip地址
+ (NSString *)deviceIPAdress;

//根据时间戳/格式返回时间
+ (NSDate *)getTimeByDateFormater:(NSDateFormatter *)formater withTime:(NSString *)time;

+ (NSString *)getTimeStringWithTimeStamp:(NSString *)stamp dateFormatter:(NSString*)dateFormat;

+ (NSString *)getNormalTimeTextWithTimeStamp:(NSString *)stamp dateFormatter:(NSString*)dateFormat;
@end
