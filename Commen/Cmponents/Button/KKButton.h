//
//  KKButton.h
//  StarZone
//
//  Created by lhp3851 on 16/2/13.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"

@interface KKButton : UIButton
/**
 *  性别单选框
 *
 *  @param Frame         Frame
 *  @param selectedImage selected Image
 *  @param normalImage   normal Image
 *  @param selector      button selector
 *
 *  @return 性别单选框
 */
-(instancetype)initWithFrame:(CGRect)Frame SelectedImage:(NSString *)selectedImage NormalImage:(NSString *)normalImage;


/**
 *Created by lfsong on  16/2/13.
 *
 *  UIButton 简单封装
 *
 *  @param frame         frame
 *  @param title         button text
 *  @param font          button text font
 *  @param norcolor      buttonTitile nor color
 *  @param hightcolor    buttonHightTitle color
 *
 *  @return KKButton
 */
-(instancetype)initWithFrame:(CGRect)frame  title:(NSString *)title font:(UIFont *)font norcolor:(UIColor *)norcolor lightcolor:(UIColor *)hightcolor;

/**
 *
 *  UIButton 圆角、背景图
 *
 *  @param frame                frame
 *  @param title                title
 *  @param font                 title font
 *  @param norcolor             titile Normal color
 *  @param hightcolor           title  Hight color
 *  @param normalBackgroudColor normalBackgroudColor
 *  @param HilighBackgroudColor HilighBackgroudColor
 *  @param cornerRadius         cornerRadius
 *  @param borderWidth          borderWidth
 *  @param borderColor          borderColor
 *
 *  @return UIButton
 */
-(instancetype)initWithFrame:(CGRect)frame  title:(NSString *)title font:(UIFont *)font norTitlecolor:(UIColor *)norcolor hlightTitlecolor:(UIColor *)hightcolor normalBackgroudColor:(UIColor *)normalBackgroudColor HilighBackgroudColor:(UIColor *)HilighBackgroudColor cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

-(instancetype)initWithFrame:(CGRect)frame leftFont:(UIFont *)leftFont rightFont:(UIFont *)rightFont leftColor:(UIColor *)leftColor rightColor:(UIColor *)rightColor;

-(instancetype)initWithFrame:(CGRect)frame leftFont:(UIFont *)leftFont rightFont:(UIFont *)rightFont leftColor:(UIColor *)leftColor rightColor:(UIColor *)rightColor isCenter:(BOOL)isCenter;

//考虑一个设置edgeInset的

//设置图片在button中的位置
-(void)setImageRectForBounds:(CGRect)rect;

//设置title在button中的位置
-(void)setTitleRectForBounds:(CGRect)rect;

-(void)setText:(NSString *)leftTitle rightTitle:(NSString *)rightTitle;
@end


@interface KKStarCustomButton : UIButton

@end

