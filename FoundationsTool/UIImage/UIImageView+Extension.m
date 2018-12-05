//
//  UIImageView+Extension.m
//  StarZone
//
//  Created by WS on 16/4/25.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)
@dynamic visibleModeTop;
- (void)setVisibleModeTop:(BOOL)visibleModeTop{
    if (visibleModeTop) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Method fromMethod = class_getInstanceMethod(self.class, @selector(setImage:));
            Method toMethod = class_getInstanceMethod(self.class, @selector(setVisibleImage:));
            if (class_addMethod([self class], @selector(setImage:), method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
                class_replaceMethod(self.class,@selector(setVisibleImage:),method_getImplementation(fromMethod),method_getTypeEncoding(fromMethod));
            }else{
                method_exchangeImplementations(fromMethod, toMethod);
            }
        });
    }
}

- (void)setVisibleImage:(UIImage*)image{
    
    CGFloat scale = image.size.height / image.size.width;
    CGFloat viewScale = self.height / self.width;
    CGFloat minScale = 1.0;
    if (scale > minScale && scale > viewScale) {
        CGImageRef coreImage = image.CGImage;
        CGFloat visibleW = CGImageGetWidth(coreImage);
        CGFloat visibleH = visibleW;
        UIImage *newImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(coreImage, CGRectMake(0, 0, visibleW, visibleH))];
        [self setVisibleImage:newImage];
    }else{
        [self setVisibleImage:image];
    }
}


@end
