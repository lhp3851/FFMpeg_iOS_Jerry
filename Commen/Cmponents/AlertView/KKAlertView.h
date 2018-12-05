//
//  KKAlertView.h
//  StarZone
//
//  Created by TinySail on 16/2/23.
//  Copyright © 2016年 kankan. All rights reserved.
//
/**
 *  @brief block alertView
 *
 * 
 */
#import <UIKit/UIKit.h>
#import "KKBlockActionSheetDefine.h"
@interface KKAlertView : NSObject
@property (nonatomic, assign, readonly) NSUInteger buttonCount;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSInteger tag;
+ (instancetype)alertWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title;
- (void)addCancelButtonWithTitle:(NSString *) title block:(KKActionBlock) block;
- (void)addOtherButtonWithTitle:(NSString *) title block:(KKActionBlock) block;

- (void)show;
- (void)dismissWithClickedButtonIndex:(NSUInteger)index animated:(BOOL)animated;
@end
