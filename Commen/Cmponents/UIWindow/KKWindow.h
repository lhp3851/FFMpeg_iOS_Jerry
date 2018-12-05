//
//  KKWindow.h
//  FFMpeg_iOS_Jerry
//
//  Created by lhp3851 on 2018/12/4.
//  Copyright © 2018 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kTOP_WINDOW      [[UIApplication sharedApplication].windows lastObject] //当前window
#define kKEY_WINDOW      [UIApplication sharedApplication].keyWindow
#define kAPP_WINDOW      [[UIApplication sharedApplication].delegate performSelector:@selector(window)]

@interface KKWindow : UIWindow

@end

NS_ASSUME_NONNULL_END
