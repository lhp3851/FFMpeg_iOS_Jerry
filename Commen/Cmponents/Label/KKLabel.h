//
//  KKLabel.h
//  StarZone
//
//  Created by 宋林峰 on 16/2/16.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKLabel : UILabel


/**
 *  lable 简单封装
 *
 *  @param frame         frame
 *  @param text          label text
 *  其它属性为默认值
 *
 *  @return KKLabel
 */
-(instancetype)initWithFrame:(CGRect)frame text:(NSString *)text;

/**
 *  lable 简单封装
 *
 *  @param frame         frame
 *  @param text          label text
 *  @param color         label text color
 *  @param font          label text font
 *  @param alignment     alignment
 *
 *  @return KKLabel
 */
-(instancetype)initWithFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)color font:(UIFont *)font alignment:(NSTextAlignment)alignment;


/**
 * 对label中的特殊文字改变颜色
 *
 *  @param text         改变颜色的文本
 *  @param color        改变的颜色
 *
 */
-(void)exterinWithText:(NSString *)text color:(UIColor *)color;


/**
 *  设置行高,注在赋值后进行设置，此处不设为属性，当改变text时，重新设置
 *
 *  @param lineSpace 行高
 */
-(void)setLineSpace:(CGFloat)lineSpace;

//计算高度
- (CGSize)boundingRectWithSize:(CGSize)size;

/**
 *  获取NSAttributedString
 *
 *  @param text
 *  @param font
 *  @param color
 *  @param lineSpace
 *  @param image     插入的图片
 *  @param imagePos  图片插入的位置
 *
 *  @return NSAttributedString
 */
+(NSAttributedString*)attriStringWith:(NSString *)text font:(UIFont *)font color:(UIColor *)color lineSpace:(CGFloat)lineSpace image:(UIImage *)image imagePos:(NSInteger)imagePos;

/**
 *  在已有NSAttributedString中加入特殊属性
 *
 *  @param text
 *  @param color
 *
 *  @return NSAttributedString
 */
+(NSAttributedString*)attriStringWith:(NSAttributedString *)textAttri Text:(NSString *)text color:(UIColor *)color;

@end
