//
//  KKLoadingView.m
//  KKPromptLoadingView
//
//  Created by TinySail on 16/3/11.
//  Copyright © 2016年 kankan. All rights reserved.
//

#import "KKLoadingView.h"
#import <objc/runtime.h>
static char kLoadingViewKey;
#define kLoadingViewShowDelay 0.3

#define kLoadingAnimationCellInterval 0.5
#define kLoadingAnimationProgressInterval 0.8
@interface KKLoadingView ()
@property (nonatomic, strong) UIImageView *topLoadingView;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UIImageView *progressBar;
@property (nonatomic, strong) UIImageView *progressCapsuleView;
@property (nonatomic, assign) CGFloat capsulePadding;
@property (nonatomic, assign) CGFloat capsuleExtendX;
@property (nonatomic, strong) UIView *loadingView;
@end
static CGFloat kloadingWindowWidth;
static CGFloat kloadingWindowHeight;
@implementation KKLoadingView
- (UIView *)progressView
{
    if (!_progressView) {
        CGFloat progressW = 171.0 / 2.0;
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topLoadingView.frame) + 20.0, progressW, 11.0)];
        
        _progressBar = [[UIImageView alloc] initWithFrame:_progressView.bounds];
        _progressBar.image = [[UIImage imageNamed:@"loadingProgressBar"] stretchableImageWithLeftCapWidth:20.0 topCapHeight:0];
        [_progressView addSubview:_progressBar];
        
        CGFloat capsuleH = 6.5;
        CGFloat capsuleW = 71.0 / 2.0;
        _capsulePadding = 2.0;
        _progressCapsuleView = [[UIImageView alloc] initWithFrame:CGRectMake(_capsulePadding, (_progressBar.frame.size.height - capsuleH) / 2.0, capsuleW, capsuleH)];
        _capsuleExtendX = progressW - _capsulePadding * 2.0 - capsuleW;
        _progressCapsuleView.image = [UIImage imageNamed:@"loadingCapsule"];
        [_progressView addSubview:_progressCapsuleView];
        
    }
    return _progressView;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}
+(void)initialize
{
    kloadingWindowWidth = [UIScreen mainScreen].bounds.size.width;
    kloadingWindowHeight = [UIScreen mainScreen].bounds.size.height;
}
- (void)commonInit
{
    CGFloat viewW = 171.0 / 2.0;
    CGFloat viewH = 210.0 / 2.0 + 31.0;
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake((self.width - viewW) / 2.0, (self.height - viewH) / 2.0, viewW, viewH)];
    
    self.backgroundColor = [UIColor clearColor];
    [_loadingView addSubview:self.topLoadingView];
    [_loadingView addSubview:self.progressView];
}
- (UIImageView *)topLoadingView
{
    if (!_topLoadingView) {
        _topLoadingView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 171.0 / 2.0, 210.0 / 2.0)];
        _topLoadingView.animationImages = @[[UIImage imageNamed:@"loadingImage0"], [UIImage imageNamed:@"loadingImage1"]];
        _topLoadingView.animationDuration = kLoadingAnimationCellInterval;
        _topLoadingView.animationRepeatCount = 0;
    }
    return _topLoadingView;
}
- (void)beginAnimation
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(beginAnimationInternal) object:nil];
    [self performSelector:@selector(beginAnimationInternal) withObject:nil afterDelay:kLoadingViewShowDelay];
}
- (void)beginAnimationInternal
{
    [self addSubview:_loadingView];
    [self.topLoadingView startAnimating];//顶部动画开始
    
    [UIView animateWithDuration:kLoadingAnimationProgressInterval delay:0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        _progressCapsuleView.x +=  _capsuleExtendX;
    } completion:^(BOOL finished) {
    }];
}
- (void)endAnimation
{
    [self.topLoadingView stopAnimating];
    [_loadingView removeFromSuperview];
}
+ (NSMutableArray *)getLoadingViewArray
{
    NSMutableArray *arrayM = objc_getAssociatedObject(self, &kLoadingViewKey);
    if (!arrayM) {
        arrayM = [NSMutableArray array];
        objc_setAssociatedObject(self, &kLoadingViewKey, arrayM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return arrayM;
}

+ (BOOL)checkLoadingViewForView:(UIView *)view
{
    if (!view) view = kAPP_WINDOW;
    NSArray<UIView *> *subViews = view.subviews;
    for (UIView *subView in subViews) {
        if ([subView isKindOfClass:[self class]]) {
            return YES;
        }
    }
    return NO;
}

+ (KKLoadingView *)showLoadingViewToView:(UIView *)view
{
    return [self showLoadingViewToViewWithoutCovert:view];
}

+ (KKLoadingView *)showLoadingViewToViewWithoutCovert:(UIView *)view
{
    if (!view) view = kAPP_WINDOW;
    
    KKLoadingView *loadingView = [[self alloc] initWithFrame:view.bounds];
    loadingView.userInteractionEnabled = NO;
    
    if ( (![view isKindOfClass:[UIWindow class]]) && !view.viewController.automaticallyAdjustsScrollViewInsets) {
        loadingView.y = -64.0;
    }
    
    [view addSubview:loadingView];
    [loadingView beginAnimation];
    return loadingView;
}

+ (void)hideLoadingViews:(UIView *)view
{
    if (!view) view = kAPP_WINDOW;
    NSArray<UIView *> *subViews = view.subviews;
    for (UIView *subView in subViews) {
        if ([subView isKindOfClass:[self class]]) {
            [(KKLoadingView *)subView hideLoadingView];
        }
    }
}
- (void)hideLoadingView
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(beginAnimationInternal) object:nil];
    [self endAnimation];
    [self removeFromSuperview];
}
- (void)dealloc
{
    [self hideLoadingView];
}
@end
