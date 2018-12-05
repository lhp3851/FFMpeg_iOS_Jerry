//
//  KKStarPromptBox.h
//  KKStarZone
//
//  Created by TinySail on 16/1/12.
//  Copyright © 2016年 kankan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#define kPromptBoxRemainTime 1.5
@interface KKStarPromptBox : MBProgressHUD
/*==================================*/
/*       自动隐藏的提示框              */
/* @param words 提示语               */
/* @param view 父视图，默认为keyWindow */
/* @param icon 提示图片，默认没有      */
/*==================================*/
+ (void)showPromptBoxWithWords:(NSString *)words;
+ (void)showPromptBoxWithWords:(NSString *)words toView:(UIView *)view;
+ (void)showPromptBoxWithWords:(NSString *)words icon:(UIImage *)icon;
+ (void)showPromptBoxWithWords:(NSString *)words icon:(UIImage *)icon toView:(UIView *)view;
/*==================================*/
/*       手动隐藏的提示框---带菊花的    */
/* @param words 提示语               */
/* @param view 父视图，默认为keyWindow */
/* @param icon 提示图片，默认没有      */
/*==================================*/
+ (KKStarPromptBox *)showPrompttingBoxWithWords:(NSString *)words;
+ (KKStarPromptBox *)showPrompttingBoxWithWords:(NSString *)words toView:(UIView *)view;
/**
 *  隐藏单个提示框
 */
- (void)hidePrompttingBox;
/**
 *  隐藏keyWindow上所有的提示框
 */
+ (void)hidePrompttingBoxs;
/**
 *  隐藏view上所有的提示框
 *
 *  @param view 父视图
 */
+ (void)hidePrompttingBoxsForView:(UIView *)view;


/**
 是否正在显示

 @return 显示的状态
 */
+ (BOOL)isPrompting;
@end
