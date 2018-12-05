//
//  KKLoadingView.h
//  KKPromptLoadingView
//
//  Created by TinySail on 16/3/11.
//  Copyright © 2016年 kankan. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface KKLoadingView : UIView
/**
 *  @brief 显示loading
 *
 *  @param view 父视图  =nil 默认加在topWindow
 *
 *  @return loadingView
 */
+ (KKLoadingView *)showLoadingViewToView:(UIView *)view;

//不阻塞UI的小星人
+ (KKLoadingView *)showLoadingViewToViewWithoutCovert:(UIView *)view;

+ (BOOL)checkLoadingViewForView:(UIView *)view;

/**
 *  @brief 隐藏所有loading
 *
 *  @param view  父视图 =nil时  默认移除topWindow上的
 */
+ (void)hideLoadingViews:(UIView *)view;
- (void)hideLoadingView;
@end
