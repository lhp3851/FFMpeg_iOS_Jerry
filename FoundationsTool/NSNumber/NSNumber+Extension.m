//
//  NSNumber+Extension.m
//  StarZone
//
//  Created by TinySail on 16/6/17.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import "NSNumber+Extension.h"

@implementation NSNumber (Extension)
+ (NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to
{
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}
@end
