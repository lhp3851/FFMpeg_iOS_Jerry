//
//  NSDate+Extension.h

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
/*
 *  时间戳
 */
@property (nonatomic,copy,readonly) NSString *timestamp;
/*
 *  时间成分
 */
@property (nonatomic,strong,readonly) NSDateComponents *components;
/*
 *  是否是今年   withLocalize会将日期转换成当地时间后再比较
 */
@property (nonatomic,assign,readonly) BOOL isThisYear;
/*
 *  是否是今天
 */
@property (nonatomic,assign,readonly) BOOL isToday;
/*
 *  是否是昨天
 */
@property (nonatomic,assign,readonly) BOOL isYesToday;
/**-----------------------------转化成系统时间,本地时间为GMT--------------------------------**/
+ (NSDate *)getLocaleDateFromUTCDate:(NSDate *)date;

/**
 *  根据时间戳获取时间对象
 *
 *  @param stamp 时间戳字符串
 *
 *  @return 时间对象
 */
+ (NSDate *)getTimeStringWithTimeStamp:(NSString *)stamp;

/**
 *  根据服务器时间字符串返回NSDate对象
 *
 *  @param timeStr 服务器时间字符串
 *
 *  @return NSDate对象
 */

+ (NSDate*)getTimeDataWithTimeString:(NSString*)timeStr;
/**
 *  两个时间比较
 *
 *  @param unit     成分单元
 *  @param fromDate 起点时间
 *  @param toDate   终点时间
 *
 *  @return 时间成分对象
 */
+(NSDateComponents *)dateComponents:(NSCalendarUnit)unit fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
/**
 *  @brief 本地时区化时间
 *
 *  @return 本地时间
 */
- (NSDate *)localizeDate;
/**
 *  判断现在是否为晚上
 */
+ (BOOL)isNight;

/**
 * 根据日期算星座 返回
 */
- (NSString *)getAstroWithDate;
/**
 *  @brief 带时间偏差的判断，列如已每天上午4点为下一天的时间点，则可以调用 [youDate isTodayWithOffset: - 4 * 3600]
 *
 *  @param timeOffset 时间偏差，单位为秒
 *
 *  @return 是否
 */
- (BOOL)isTodayWithOffset:(NSTimeInterval)timeOffset;
- (BOOL)isYesterday;  //昨天
- (BOOL)isTwoDaysAgo; //两天前
- (BOOL)isThreeDaysAgo; //三天前
- (BOOL)isSomeDaysAgo:(NSUInteger)days; //days天前

+ (NSInteger)daysIntervalFromNow:(NSString *)date;
/**
 *  @brief 指定日期和当前日期的差
 *
 *  @return 相差的天数，比当前日期早的话为负
 */
- (CGFloat)someDaysAgo;
/**
 *  根据日期格式 将 NSDate类型 转为 YYYY-MM-DD 等格式字符串
 *
 *  @param formatter <#formatter description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)transToDateString:(NSString*)format;
@end
