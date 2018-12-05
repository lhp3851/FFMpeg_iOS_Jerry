//
//  KKStarPromptBox.m
//  KKStarZone
//
//  Created by TinySail on 16/1/12.
//  Copyright © 2016年 kankan. All rights reserved.
//

#import "KKStarPromptBox.h"
#import "UIColor+Extension.h"

#define kPromptBoxCornerRadius 10.0
#define kPromptWordFontSize 15.0
#define kPromptWordMargin   10.0
#define kPromptBoxBackGroundColor [UIColor colorWithRGBValue:0x000000 alpha:0.7]
#ifndef kTopWindow
#define kTopWindow [[UIApplication sharedApplication].windows lastObject]
#endif
@interface KKStarPromptBox ()
@end

static BOOL isPrompting=NO;

@implementation KKStarPromptBox
+ (void)showPromptBoxWithWords:(NSString *)words
{
    [self showPromptBoxWithWords:words toView:nil];
}
+ (void)showPromptBoxWithWords:(NSString *)words toView:(UIView *)view
{
    [self showPromptBoxWithWords:words icon:nil toView:view];
}
+ (void)showPromptBoxWithWords:(NSString *)words icon:(UIImage *)icon
{
    [self showPromptBoxWithWords:words icon:icon toView:nil];
}
+ (void)showPromptBoxWithWords:(NSString *)words icon:(UIImage *)icon toView:(UIView *)view
{
    if (!words.length) return;
    if (![[NSThread currentThread] isMainThread]) {
        return;
    }
    isPrompting=YES;
    if (view == nil) view = kAPP_WINDOW;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    [self rotateHud:hud];
    
    hud.detailsLabelText = words;
    hud.detailsLabelFont = [KKFitTool fitWithTextHeight:kPromptWordFontSize];
    hud.detailsLabelColor = [UIColor whiteColor];
    hud.color = kPromptBoxBackGroundColor;
    hud.cornerRadius = kPromptBoxCornerRadius;
    hud.margin = [KKFitTool fitWithWidth:kPromptWordMargin];
    // 设置图片
    //    hud.customView = [[UIImageView alloc] initWithImage:icon];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:kPromptBoxRemainTime];
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kPromptBoxRemainTime*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
       isPrompting=NO;
   });
}

+ (void)rotateHud:(MBProgressHUD *)hud
{
    UIInterfaceOrientation interfaceO = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat rotateAngle = 0;
    switch (interfaceO) {
        case UIInterfaceOrientationLandscapeRight:
            rotateAngle = M_PI_2;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotateAngle = -M_PI_2;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            rotateAngle = M_PI;
            break;
        default:
            break;
    }
    if (rotateAngle != 0) {
        hud.transform = CGAffineTransformMakeRotation(rotateAngle);
    }
}

+ (KKStarPromptBox *)showPrompttingBoxWithWords:(NSString *)words
{
    return [self showPrompttingBoxWithWords:words toView:nil];
}
+ (KKStarPromptBox *)showPrompttingBoxWithWords:(NSString *)words toView:(UIView *)view
{
    //if (!words.length) return nil;
    if (![[NSThread currentThread] isMainThread]) {
        return nil;
    }
    if (view == nil) view = kAPP_WINDOW;
    isPrompting=YES;
    // 快速显示一个提示信息
    KKStarPromptBox *hud = [KKStarPromptBox showHUDAddedTo:view animated:YES];
    [self rotateHud:hud];
    hud.labelText = words;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    //    hud.dimBackground = YES;
    hud.color = kPromptBoxBackGroundColor;
    hud.margin = [KKFitTool fitWithWidth:kPromptWordMargin];
    //    hud.activityIndicatorColor = [UIColor redColor];
    return hud;
}

- (void)hidePrompttingBox
{
    [self hide:YES];
    isPrompting=NO;
}

+ (void)hidePrompttingBoxs
{
    [self hidePrompttingBoxsForView:nil];
    isPrompting=NO;
}

+ (void)hidePrompttingBoxsForView:(UIView *)view
{
    if (view == nil) view = kAPP_WINDOW;
    [self hideAllHUDsForView:view animated:YES];
    isPrompting=NO;
}

+ (BOOL)isPrompting{
    return isPrompting;
}

@end
