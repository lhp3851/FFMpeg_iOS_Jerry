//
//  KKTextView.h
//  StarZone
//
//  Created by 宋林峰 on 16/2/17.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKTextView : UITextView

@property(nonatomic, strong)NSString *placeholder;  //方便灵活设置
@property(nonatomic, strong)UIColor *placeholderColor; //黑认为kSMALL_TEXT_COLOR
@property(nonatomic, strong)UIColor *textCountColor;  //数字颜色 默认为kSMALL_TEXT_COLOR
@property(nonatomic, assign)CGPoint textCountOffsetPonit; //默认为（0，0），在左下角位置

/**
 *  UITextView 封装
 *
 *  @param frame         frame
 *  @param text          text
 *  @param placeholder   placeholder
 *  @param textMaxCount     输入的最大个数，-1为不限个数，
 *
 *  @return KKTextField
 */
-(instancetype)initWithFrame:(CGRect)frame text:(NSString *)text placeholder:(NSString *)placeholder textMaxCount:(NSInteger)textMaxCount;


/**
 *  note,如果是延后添加父类view，则调用此函数，否则placeholder不能显示
 *
 */
-(void)showIn:(UIView *)view;

@end
