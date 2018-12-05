//
//  NSDate+Extension.m


#import "NSDate+Extension.h"
#import "KKTimer.h"
#import "DateTool.h"
@interface NSDate ()
/*
 *  清空时分秒，保留年月日
 */
@property (nonatomic,strong,readonly) NSDate *ymdDate;

@end
@implementation NSDate (Extension)

/**-----------------------------转化成系统时间,本地时间为GMT--------------------------------**/
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

/**
 *  根据服务器时间字符串返回NSDate对象
 */
+ (NSDate*)getTimeDataWithTimeString:(NSString*)timeStr{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
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
    return createDate;
}


/*
 *  时间戳
 */
- (NSString *)timestamp{
    
    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%.0f",timeInterval];
    
    return [timeString copy];
}
+ (NSDate *)getTimeStringWithTimeStamp:(NSString *)stamp{
    long long longStamp = (long long)([stamp longLongValue]+28800000) / 1000;
    return [NSDate dateWithTimeIntervalSince1970:longStamp];
}
/*
 *  时间成分
 */
- (NSDateComponents *)components{
    
    //创建日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    //定义成分
    NSCalendarUnit unit=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:unit fromDate:self];
}
/*
 *  是否是今年
 */
- (BOOL)isThisYear{
    
    //取出给定时间的components
    NSDateComponents *dateComponents=self.components;
    
    //取出当前时间的components
    NSDateComponents *nowComponents=[NSDate date].components;
    
    //直接对比年成分是否一致即可
    BOOL res = dateComponents.year==nowComponents.year;
    
    return res;
}
/*
 *  是否是今天
 */
- (BOOL)isToday{
    //差值为0天
    return [self calWithValue:0];
}
/*
 *  是否是昨天
 */
- (BOOL)isYesToday{
    //差值为1天
    return [self calWithValue:1];
}
- (BOOL)isYesterday{
    //差值为1天
    return [self calWithValue:1];
}
- (BOOL)isTwoDaysAgo
{
    return [self calWithValue:2];
}
- (BOOL)isThreeDaysAgo
{
    return [self calWithValue:3];
}
- (BOOL)isSomeDaysAgo:(NSUInteger)days
{
    return [self calWithValue:days];
}
- (BOOL)calWithValue:(NSInteger)value{
    
    //得到给定时间的处理后的时间的components
    NSDateComponents *dateComponents=self.ymdDate.components;
    
    //得到当前时间的处理后的时间的components
    NSDateComponents *nowComponents=[NSDate date].ymdDate.components;//[DateTool getLocaleDateFromUTCDate:]
    
    //比较
    BOOL res=dateComponents.year==nowComponents.year && dateComponents.month==nowComponents.month && (dateComponents.day + value)==nowComponents.day;
    
    return res;
}
/*
 *  清空时分秒，保留年月日
 */
- (NSDate *)ymdDate{
    
    //定义fmt
    NSDateFormatter *fmt=[[NSDateFormatter alloc] init];
    fmt.timeZone  = [NSTimeZone timeZoneWithName:@"UTC"];
    //设置格式:去除时分秒
    fmt.dateFormat=@"yyyy-MM-dd";
    
    //得到字符串格式的时间
    NSString *dateString=[fmt stringFromDate:self];
    
    //再转为date
    NSDate *date=[fmt dateFromString:dateString];
    
    
    return date;
}
/**
 *  判断现在是否为晚上
 */
+ (BOOL)isNight
{
    struct tm *calenda;
    time_t currentTime;
    currentTime = time(NULL);
    calenda = localtime(&currentTime);
    int hour = calenda->tm_hour;
    if (hour >= 18) {
        return YES;
    }
    else
        return NO;
}
/**
 *  根据日期获得星座
 *
 *  @return return value description
 */
- (NSString *)getAstroWithDate {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit;
    comps = [calendar components:unitFlags fromDate:self];
    
    int m = (int)[comps month];
    int d = (int)[comps day];
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSMutableString *result;
    
    if (m < 1|| m>12||d < 1||d > 31){
        return @"错误日期格式!";
    }
    if(m==2 && d>29)
    {
        return @"错误日期格式!!";
    }else if(m==4 || m==6 || m==9 || m==11) {
        if (d>30) {
            return @"错误日期格式!!!";
        }
    }
    
    result=[NSMutableString stringWithFormat:@"%@",
            [astroString substringWithRange:NSMakeRange(m*2-(d <
                                                             [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    [result appendString:@"座"];
    return   (NSString *)result;
}

- (NSDate *)localizeDate
{
    NSTimeInterval  timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMT];
    return [self dateByAddingTimeInterval:timeZoneOffset];
}
/**
 *  两个时间比较
 *
 *  @param unit     成分单元
 *  @param fromDate 起点时间
 *  @param toDate   终点时间
 *
 *  @return 时间成分对象
 */
+ (NSDateComponents *)dateComponents:(NSCalendarUnit)unit fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    //创建日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    //直接计算
    NSDateComponents *components = [calendar components:unit fromDate:fromDate toDate:toDate options:0];
    return components;
}
- (BOOL)isTodayWithOffset:(NSTimeInterval)timeOffset
{
    //得到给定时间的处理后的时间的components
    NSDateComponents *dateComponents=self.ymdDate.components;
    
    //得到当前时间的处理后的时间的components
    NSDateComponents *nowComponents=[[NSDate date] dateByAddingTimeInterval:timeOffset].ymdDate.components;
    //比较
    BOOL res=dateComponents.year==nowComponents.year && dateComponents.month==nowComponents.month && dateComponents.day==nowComponents.day;
    
    return res;
}

- (CGFloat)someDaysAgo
{
    NSDate *targetYmdDate = self;
    NSTimeInterval timeToLenth = [KKTimer timeLengthToTime:[targetYmdDate timeIntervalSince1970]*1000];
    CGFloat dayInterval = timeToLenth / 3600.0 / 24.0;
    return dayInterval;
}

+ (NSInteger)daysIntervalFromNow:(NSString *)date
{
    return 1;
}
- (NSString *)transToDateString:(NSString*)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    formatter.dateFormat = format;
    return[formatter stringFromDate:self];
}
@end
