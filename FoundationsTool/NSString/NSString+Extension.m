//
//  NSString+Extension.m

#import "NSString+Extension.h"
@implementation NSAttributedString (Extension)
- (CGSize)resizeWithAdjustSize:(CGSize)size
{
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
}
@end
@implementation NSString (Extension)
- (CGSize)resizeWithFont:(UIFont *)font adjustSize:(CGSize)size
{
    //注意：这里的字体要和控件的字体保持一致
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    //处理有换行时的宽，
    NSString *text = self;
    if (size.width > 10000) {
        NSArray *texts = [text componentsSeparatedByString:@"\r\n"];
        if (texts.count == 1) {
            texts = [text componentsSeparatedByString:@"\r"];
        }
        if (texts.count == 1) {
            texts = [text componentsSeparatedByString:@"\n"];
        }
        if (texts.count == 1) {
            texts = [text componentsSeparatedByString:@"\f"];
        }
        if (texts.count>0) {
            text = texts[0];
            for (int i=1; i<texts.count; i++) {
                NSString *str = [texts objectAtIndex:i];
                if (str.length>text.length) {
                    text = str;
                }
            }
        }
    }
    CGRect reFrame = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    return reFrame.size;
}

- (CGSize)resizeWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace adjustSize:(CGSize)size
{
    //注意：这里的字体要和控件的字体保持一致
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    attrs[NSParagraphStyleAttributeName] = paragraphStyle;
    //处理有换行时的宽，
    NSString *text = self;
    if (size.width > 10000) {
        NSArray *texts = [text componentsSeparatedByString:@"\r\n"];
        if (texts.count == 1) {
            texts = [text componentsSeparatedByString:@"\r"];
        }
        if (texts.count == 1) {
            texts = [text componentsSeparatedByString:@"\n"];
        }
        if (texts.count == 1) {
            texts = [text componentsSeparatedByString:@"\f"];
        }
        if (texts.count>0) {
            text = texts[0];
            for (int i=1; i<texts.count; i++) {
                NSString *str = [texts objectAtIndex:i];
                if (str.length>text.length) {
                    text = str;
                }
            }
        }
    }
    CGRect reFrame = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    return reFrame.size;
}

- (CGSize)getTextSizeWithtextFont:(UIFont*)textFont{
    return [self boundingRectWithSize:CGSizeMake(NSIntegerMax, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: textFont} context:nil].size;
}

- (CGSize)getTextSizeWithTextFont:(UIFont*)font maxWidth:(CGFloat)width maxLine:(NSInteger)line{
    CGFloat originalHeight = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName:font} context:nil].size.height;
    if (line == 0) {
        return CGSizeMake(width, originalHeight);
    }
    CGFloat lineHeight = [@"标" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName:font} context:nil].size.height;
    CGFloat maxHeight = originalHeight > (line + 0.5) * lineHeight ? lineHeight * (line + 0.1) : originalHeight;
    return CGSizeMake(width, maxHeight);
    
}

- (CGSize)getTextSizeWithTextFont:(UIFont*)font maxWidth:(CGFloat)width  lineSpace:(CGFloat)lineSpace;
{
    NSMutableDictionary *titleAttrs = [NSMutableDictionary dictionary];
    titleAttrs[NSFontAttributeName] = font;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.lineSpacing = 3;
    titleAttrs[NSParagraphStyleAttributeName] = paragraphStyle;
    NSAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:self attributes:titleAttrs];
    CGSize contentSize = [attributedText boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    return contentSize;
}
- (CGSize)resizeWithAttr:(UIFont *)font adjustSize:(CGSize)size
{
    //注意：这里的字体要和控件的字体保持一致
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    
    CGRect reFrame = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    return reFrame.size;
}


+(BOOL)isBlank:(NSString *)string{
    if (string == nil || string == NULL||[string isEqualToString:@"(null)"]) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }

    if ( ( [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)
        ) {
        return YES;
    }
    
    return NO;
}

/**
 *  将日期字符串转为 NSDate类型
 *
 *  @param format <#format description#>
 *
 *  @return <#return value description#>
 */
- (NSDate *)transToNSDate:(NSString*)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setLocale:[TimeLocale defaultTimeLocal]];//[NSLocale currentLocale]
    formatter.timeZone  = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setDateFormat:format];
    NSDate *date=[formatter dateFromString:self];
    return date;
}

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    NSString * phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

/**
 *  是否包含特殊字符
 *
 *  @param string <#string description#>
 *
 *  @return return value description
 */
-(BOOL)isHasSpecimalWord:(NSString *)string {
    NSString *regex = @"^.*[&#%￥/\\^\\$\\^'\\:`\\-\\+\\|\\]\\[\\{\\}\\<\\>=\\*].*$";
    NSPredicate *specialTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [specialTest evaluateWithObject:string];
    
}
-(BOOL)isNumber:(NSString *)string{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if(!basicTest)
    {
        return NO;
    }
    return YES;
}

- (BOOL)validateHeight:(NSString *)height {
    NSString *regex = @"^[0-9]*$";
    NSPredicate *heightTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [heightTest evaluateWithObject:height];
}

- (BOOL) validateWeight:(NSString *)weight {
    NSString *regex = @"^[0-9]*$";
    NSPredicate *weightTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [weightTest evaluateWithObject:weight];
}


-(NSString *)formatCellphone:(NSString *)cellPhone{
    NSMutableString *string=[NSMutableString stringWithString:cellPhone];
    if (cellPhone.length<=11&&cellPhone.length>7) {
        [string insertString:@" " atIndex:3];
        [string insertString:@" " atIndex:8];
    }
    else if (cellPhone.length<=7&&cellPhone.length>3){
        [string insertString:@" " atIndex:3];
    }
    else{
        
    }
    NSLog(@"格式化的电话号码：%@",string);
    return string;
}

/**
 @return 格式化的视频时长
 */
+ (NSString *)getDurationStringByDurationNumber:(CGFloat)duration
{
    NSString *durationString;
    short minite = duration / 60;
    short second = (short)duration % 60;
    short hour = minite / 60;
    minite = minite % 60;
    if (hour) {
        durationString = [NSString stringWithFormat:@"%02d:%02d:%02d",hour , minite, second];
    }
    else
        durationString = [NSString stringWithFormat:@"%02d:%02d", minite, second];
    return durationString;
}

- (BOOL) validatePassword:(NSString *)pass {
    NSString *regex = @"^.{6,16}$";
    NSPredicate *passTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [passTest evaluateWithObject:pass];
}

- (int)calNickNameLength {
    int length = 0;
    if (self.length > 0) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSUInteger number = [[NSString stringWithString:self] lengthOfBytesUsingEncoding:enc];
        return (int)number;
    }
    return length;
}

- (NSString *)substringToLength:(int)length {
    int total = 0;
    NSMutableString *string = [NSMutableString string];
    
    if (self.length > 0) {
        for (int i = 0; i < self.length; i++) {
            NSRange range=NSMakeRange(i,1);
            NSString *subString=[self substringWithRange:range];
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSUInteger number = [[NSString stringWithString:subString] lengthOfBytesUsingEncoding:enc];
            total += number;
            if (total > length ) {
                return string;
            }
            
            [string appendString:subString];
        }
    }
    return string;
}


+(NSString *) htmlEntityDecode:(NSString *) string{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    return string;

}


//URLEncode
+(NSString*)encodeToURLString:(NSString*)unencodedString{
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                     (CFStringRef)unencodedString,
                                                                             NULL,
                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                          kCFStringEncodingUTF8));
    
    return encodedString;
}

//URLDEcode
+(NSString *)decodeURLString:(NSString*)encodedString
{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                 (__bridge CFStringRef)encodedString,
                                                           CFSTR(""),
    CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

- (NSString *)deleteSpace {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)deleteHeadAndTrialSpaceOfString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)formatToDecimalString {
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc]init];
    numFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    return [numFormatter stringFromNumber:@(self.integerValue)];
}


+(NSString *)getUrlParams:(NSString *)url key:(NSString *)key
{
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",key];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        return tagValue;
    }
    return @"";
}

@end

