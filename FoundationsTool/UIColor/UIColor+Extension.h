//
//  UIColor+Extension.h
//  KKStarZone
//
//  Created by TinySail on 15/11/18.
//  Copyright (c) 2015年 kankan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)
/**
 *  根据十六进制表示的RGB颜色值创建UIColor
 *
 *  @param value 十六进制RGB值
 *  @param alpha
 *
 *  @return 返回对应的UIColor
 */
+ (UIColor *)colorWithRGBValue:(NSUInteger)value alpha:(CGFloat)alpha;



@end
