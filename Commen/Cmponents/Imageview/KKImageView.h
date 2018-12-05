//
//  KKImageView.h
//  StarZone
//
//  Created by lhp3851 on 16/2/17.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKImageView : UIImageView

/**
 *  创建gif动画
 *
 *  @param frame frame
 *  @param imageFiles 图片数组(图片路径)，(频率为1/18)
 *  @param duration 持续时长 -1为无限制，
 *  @return
 */
-(id)initWithCenter:(CGPoint)center imageFiles:(NSArray *)imageFiles duration:(NSInteger)duration;

/**
 *  设置动效名
 *
 *  @param imageFiles 图片数组(图片路径)
 */
-(void)refreshImageFiles:(NSArray *)imageFiles duration:(NSInteger)duration;

/**
 *  显示动画
 *
 *  @param view     父类view,
 *  @param finish   动画完成
 */
-(void)showInView:(UIView *)view atIndex:(NSInteger)atIndex finish:(void (^)(void))finish;

/**
 *  消除gif动画
 */
-(void)dismissAnimation:(BOOL)animation;


@end
