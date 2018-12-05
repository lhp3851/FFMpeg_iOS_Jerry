//
//  KKFitTool.m
//  KKStarZone
//
//  Created by WS on 15/12/28.
//  Copyright © 2015年 kankan. All rights reserved.
//

#import "KKFitTool.h"

@implementation KKFitTool

+(CGFloat)fitWithWidth:(CGFloat)width{
//    if (kSCREEN_HEIGHT <= 568)
//    {
//        return width;
//        
//    }
    return (kSCREEN_WIDTH/375.0f)*width;
    
}
+(CGFloat)fitWithHeight:(CGFloat)height{
    if (kSCREEN_HEIGHT <568)
    {
        return height;
        
    }
    return (kSCREEN_HEIGHT/667.0f)*height;
    
}
+(CGSize)fitWithSize:(CGSize)size{
    CGFloat width = [self fitWithWidth:size.width];
    CGFloat height = [self fitWithHeight:size.height];
    return CGSizeMake(width, height);
}

+(CGPoint)fitWithPoint:(CGPoint)point{
    if (kSCREEN_HEIGHT == 736) {
        CGFloat x = [self fitWithWidth:point.x];
        CGFloat y = [self fitWithHeight:point.y];
        return CGPointMake(x, y);
    }else{
        return point;
    }
}

+(CGRect)fitWithRect:(CGRect)frame{
    CGSize size = [self fitWithSize:frame.size];
    CGPoint point = frame.origin;
    return (CGRect){point,size};
}

+(UIFont*)fitWithFont:(CGFloat)fontSize{
    UIFont *font=[UIFont systemFontOfSize:[self fitWithHeight:fontSize]];
    return font;
}

+(UIFont*)fitWithTextHeight:(CGFloat)height{
    UIFont *newFont = [UIFont systemFontOfSize:[self fitWithTextSize:height]];
    return newFont;


}

+ (CGFloat)fitWithTextSize:(CGFloat)size
{
//    CGFloat inch;
//    if (kSCREEN_HEIGHT == 736) {
//        inch = 5.5;
//    }else if(kSCREEN_HEIGHT == 667){
//        inch = 4.7;
//    }else if(kSCREEN_HEIGHT == 568){
//        inch = 4.0;
//    }else{
//        inch = 3.5;
//    }
//    CGFloat pt = (size * 5.5)/sqrt((kSCREEN_HEIGHT / 72.0) * (kSCREEN_HEIGHT / 72.0) + (kSCREEN_WIDTH / 72.0) * (kSCREEN_WIDTH / 72.0));
    if (kSCREEN_HEIGHT == 736) {
        CGFloat pt = size / 375.0 * kSCREEN_WIDTH;
        return pt;
    }else{
        return size;
    }
}
@end
