//
//  KKActionSheet.m
//  StarZone
//
//  Created by 熊梦飞 on 16/2/17.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import "KKActionSheet.h"
@interface KKActionSheet ()<UIActionSheetDelegate>
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) NSMutableArray *blocks;
@end
@implementation KKActionSheet
static NSMutableArray *actionSheetViews;
+ (void)initialize
{
    actionSheetViews = [NSMutableArray array];
}
+ (instancetype)sheetWithTitle:(NSString *)title
{
    return [[self alloc] initWithTitle:title];
}
- (instancetype)initWithTitle:(NSString *)title
{
    if (self = [self init]) {
        self.title = title;
    }
    return self;
}
- (instancetype)init
{
    if (self = [super init]) {
        _actionSheet = [[UIActionSheet alloc] init];
        _blocks = [NSMutableArray array];
        _buttonCount = 0;
        _tag = 0;
    }
    return self;
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    _actionSheet.title = title;
}
#pragma mark - 添加方法
- (void)addCancelButtonWithTitle:(NSString *) title block:(KKActionBlock) block
{
    [self addOtherButtonWithTitle:title block:block];
    [_actionSheet setCancelButtonIndex:_buttonCount - 1];
}
- (void)addDestructiveButtonWithTitle:(NSString *) title block:(KKActionBlock) block
{
    [self addOtherButtonWithTitle:title block:block];
    [_actionSheet setDestructiveButtonIndex:_buttonCount - 1];
}
- (void)addOtherButtonWithTitle:(NSString *) title block:(KKActionBlock) block
{
    [_actionSheet addButtonWithTitle:title];
    _buttonCount ++;
    [self.blocks addObject:block ? [block copy] : [NSNull null]];
}
- (void)showInView:(UIView *)view
{
    [_actionSheet showInView:view];
    _actionSheet.delegate = self;
    [actionSheetViews addObject:self];
}
- (void)dismissWithClickedButtonIndex:(NSInteger)index animated:(BOOL)animated
{
    [_actionSheet dismissWithClickedButtonIndex:index animated:animated];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    _actionSheet = nil;
    id block = _blocks[buttonIndex];
    if (![block isKindOfClass:[NSNull class]]) {
        ((KKActionBlock)block)();
    }
    [actionSheetViews removeObject:self];
}
@end
