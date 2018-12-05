//
//  KKActionSheet.h
//  StarZone
//
//  Created by 熊梦飞 on 16/2/17.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKBlockActionSheetDefine.h"
@interface KKActionSheet : NSObject
@property (nonatomic, assign, readonly) NSUInteger buttonCount;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger tag;
+ (instancetype)sheetWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title;
/**
 *  @brief 添加取消按钮，为了兼容iOS7,务必最后添加该标题
 *
 *  @param title 标题
 *  @param block block
 */
- (void)addCancelButtonWithTitle:(NSString *) title block:(KKActionBlock) block;
- (void)addDestructiveButtonWithTitle:(NSString *) title block:(KKActionBlock) block;
- (void)addOtherButtonWithTitle:(NSString *) title block:(KKActionBlock) block;

- (void)showInView:(UIView *)view;
- (void)dismissWithClickedButtonIndex:(NSInteger)index animated:(BOOL)animated;
@end
