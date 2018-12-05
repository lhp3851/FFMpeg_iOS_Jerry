//
//  HookUtility.h
//  adapteTableviewHight
//
//  Created by lhp3851 on 16/5/20.
//  Copyright © 2016年 ZizTourabc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface HookUtility : NSObject
+ (void)swizzlingInClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;
@end
