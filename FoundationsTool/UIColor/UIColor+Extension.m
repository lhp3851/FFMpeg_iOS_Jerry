//
//  UIColor+Extension.m
//  KKStarZone
//
//  Created by TinySail on 15/11/18.
//  Copyright (c) 2015年 kankan. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)
+ (UIColor *)colorWithRGBValue:(NSUInteger)value alpha:(CGFloat)alpha
{
    CGFloat rValue = (value >> 16) / 255.0;
    CGFloat gValue = ((value >> 8) % 0x100) / 255.0;
    CGFloat bValue = (value % 0x100) / 255.0;
    return [UIColor colorWithRed:rValue green:gValue blue:bValue alpha:alpha];
}
@end
