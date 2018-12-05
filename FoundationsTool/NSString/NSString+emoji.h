//
//  NSString+emoji.h
//  emoji
//
//  Created by TinySail on 16/1/14.
//  Copyright © 2016年 kankan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (emoji)
/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)hexStringFromString:(NSString *)string;
- (NSString *)toHexString;
+ (NSString *)stringFromHexString:(NSString *)hexString;
- (NSString *)toOriginalString;
/**
 *  编码包含emoji表情的字符串
 *
 *  @param text 包含emoji表情的字符
 *
 *  @return 编码后的字符串
 */
+ (NSString *)translateTextToEmojiCodeString:(NSString *)text;
/**
 *  解码包含emoji表情的字符串
 *
 *  @param text 包含emoji表情的编码字符
 *
 *  @return 解码后的字符串
 */
+ (NSString *)translateTextToEmojiString:(NSString *)text;
/**
 *  是否为emoji字符
 */
- (BOOL)isEmoji;
- (NSString *)iSEmojiWithReturnCodeString;
+ (NSDictionary *)emojiAliases;
+ (NSDictionary *)emojiCodeDict;
/**
 *  是否包含emoji表情
 *
 *  @return
 */
- (BOOL)containsEmoji;
/**
 *  删除emoji表情
 *
 *  @return
 */
- (NSString *)deleteEmojiString;
/** 字符串中包含的表情个数 */
- (int)emojiStringCount;

/**
 * 将包含HTML转义符的字符串变成真实的意义
 */
@end
