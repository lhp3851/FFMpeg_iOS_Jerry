//
//  NSTimer+Extension.m
//  StarZone
//
//  Created by WS on 16/5/8.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import "NSTimer+Extension.h"

@implementation NSTimer (Extension)

-(void)pauseTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}


-(void)resumeTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
