//
//  KKAlertView.m
//  StarZone
//
//  Created by TinySail on 16/2/23.
//  Copyright © 2016年 kankan. All rights reserved.
//

#import "KKAlertView.h"
@interface KKAlertView ()<UIAlertViewDelegate>
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) NSMutableArray *blocks;
@end
@implementation KKAlertView
static NSMutableArray *alertViews;
+ (void)initialize
{
    alertViews = [NSMutableArray array];
}
+ (instancetype)alertWithTitle:(NSString *)title
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
        _alertView = [[UIAlertView alloc] init];
        _blocks = [NSMutableArray array];
        _buttonCount = 0;
        _tag = 0;
    }
    return self;
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    _alertView.title = title;
}
- (void)setMessage:(NSString *)message
{
    _message = message;
    _alertView.message = message;
}
#pragma mark - 添加方法
- (void)addCancelButtonWithTitle:(NSString *) title block:(KKActionBlock) block
{
    [self addOtherButtonWithTitle:title block:block];
    [_alertView setCancelButtonIndex:_buttonCount - 1];
}
- (void)addOtherButtonWithTitle:(NSString *) title block:(KKActionBlock) block
{
    [_alertView addButtonWithTitle:title];
    _buttonCount ++;
    [self.blocks addObject:block ? [block copy] : [NSNull null]];
}
- (void)show
{
    [_alertView show];
    _alertView.delegate = self;
    [alertViews addObject:self];
}
- (void)dismissWithClickedButtonIndex:(NSUInteger)index animated:(BOOL)animated
{
    [_alertView dismissWithClickedButtonIndex:index animated:animated];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    _alertView = nil;
    id block = _blocks[buttonIndex];
    if (![block isKindOfClass:[NSNull class]]) {
        ((KKActionBlock)block)();
    }
    [alertViews removeObject:self];
}
@end
