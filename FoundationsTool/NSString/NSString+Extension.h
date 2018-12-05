//
//  NSString+Extension.h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define NUMBERS @"0123456789\n"


@interface NSString (Extension)
/**
 *  根据字体计算最合适的尺寸
 *
 *  @param font 字体
 *  @param size 尺寸
 *
 *  @return 最合适的尺寸
 */
- (CGSize)resizeWithFont:(UIFont *)font adjustSize:(CGSize)size;

/**
 *  根据字体计算最合适的尺寸
 *
 *  @param font 字体
 *  @param size 尺寸
 *  @param lineSpace 行高
 *
 *  @return 最合适的尺寸
 */
- (CGSize)resizeWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace adjustSize:(CGSize)size;

/**
 *  获取文字尺寸
 *
 *  @param textFont <#textFont description#>
 *
 *  @return <#return value description#>
 */
- (CGSize)getTextSizeWithtextFont:(UIFont*)textFont;

- (CGSize)getTextSizeWithTextFont:(UIFont*)font maxWidth:(CGFloat)width maxLine:(NSInteger)line;

- (CGSize)getTextSizeWithTextFont:(UIFont*)font maxWidth:(CGFloat)width  lineSpace:(CGFloat)lineSpace;

/**
 *  判断字符串是否为空 （nil 与 '' 与 NSNull 与 空白字符）
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
+(BOOL)isBlank:(NSString *)string;

/**
 *  从字符串转化成 NSDate
 *
 *  @param format <#format description#>
 *
 *  @return <#return value description#>
 */
-(NSDate *)transToNSDate:(NSString*)format;

/**
 *  判断是否为有效邮箱
 *
 *  @param email 邮箱地址
 *
 *  @return 是否有效
 */
+ (BOOL) validateEmail:(NSString *)email;
/**
 *  判断是否为有效手机
 *
 *  @param mobile 手机号码
 *
 *  @return 是否有效
 */
+ (BOOL) validateMobile:(NSString *)mobile;



/**
 *  是否包含特殊字符
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 *  仅限数字
 */
-(BOOL)isHasSpecimalWord:(NSString *)string;

-(BOOL)isNumber:(NSString *)string;

/**
 *  校验身高
 *
 *  @param height <#height description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)validateHeight:(NSString *)height;

/**
 *  校验体重
 *
 *  @param weight <#weight description#>
 *
 *  @return <#return value description#>
 */
- (BOOL) validateWeight:(NSString *)weight;

/**
 *  格式化电话号码
 *
 *  @param cellPhone 电话号码
 *
 *  @return 格式化后的电话号码
 */
-(NSString *)formatCellphone:(NSString *)cellPhone;

/**
 视频时长

 @param duration 实数的视频时长
 @return 格式化的视频时长
 */
+ (NSString *)getDurationStringByDurationNumber:(CGFloat)duration;



/**
 *  校验绑定 密码合法性
 *
 *  @param weight pass description
 *
 *  @return 密码是否有效
 */
- (BOOL) validatePassword:(NSString *)pass;

/**
 * 计算昵称长度 中英文处理方式有区别
 *
 */
-(int)calNickNameLength;

/** 截取字符串至指定长度(包含中文和英文字符混合的处理) */
- (NSString *)substringToLength:(int)length;

+(NSString *) htmlEntityDecode:(NSString *) string;

//URLEncode
+(NSString*)encodeToURLString:(NSString*)unencodedString;
//URLDEcode
+(NSString *)decodeURLString:(NSString*)encodedString;

/** 去除字符串中的空格 */
- (NSString *)deleteSpace;
/**
 *  去除字符串首尾空格
 *
 */
- (NSString *)deleteHeadAndTrialSpaceOfString;

/**
 *  将字符串格式化为指定格式 1477234 -> 1,477,234
 *
 */
- (NSString *)formatToDecimalString;

/**
 *  将url中的参数值取出来
 *
 */
+(NSString *)getUrlParams:(NSString *)url key:(NSString *)key;

@end

@interface NSAttributedString (Extension)
/**
 *  根据字体计算最合适的尺寸
 *
 *  @param font 字体
 *  @param size 尺寸
 *
 *  @return 最合适的尺寸
 */
- (CGSize)resizeWithAdjustSize:(CGSize)size;
@end
