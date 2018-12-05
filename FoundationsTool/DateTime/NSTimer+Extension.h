//
//  NSTimer+Extension.h
//  StarZone
//
//  Created by WS on 16/5/8.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Extension)
- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
@end
