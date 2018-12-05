//
//  KKTimer.m
//  StarZone
//
//  Created by 熊梦飞 on 16/2/17.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import "KKTimer.h"

#define PER_VAL   (0.3f)

@interface KKTimerInfo : NSObject

@property(nonatomic, strong)NSString *name;  //timer名称
@property(nonatomic, strong)NSString *userMark;  //用户标识
@property(nonatomic, assign)NSTimeInterval interval;  //时间间隔
@property(nonatomic, assign)NSTimeInterval lastTime; //上一次的计数时间
@property(nonatomic, assign)NSTimeInterval end;     //结束时间,服务器时间，-1为无限制执行

-(id)initWithName:(NSString *)name userMark:(id)userMark timeInterval:(NSTimeInterval)timerInterval now:(NSTimeInterval)now end:(NSTimeInterval)end;

@end

@implementation KKTimerInfo

-(id)initWithName:(NSString *)name userMark:(id)userMark timeInterval:(NSTimeInterval)timerInterval now:(NSTimeInterval)now end:(NSTimeInterval)end
{
    if (self = [super init]) {
        self.name = name;
        self.userMark = userMark;
        self.interval = timerInterval;
        self.lastTime = now;
        self.end = end;
    }
    return self;
}
@end

static KKTimer *timer; //全局不释放

//******************************************************************
//******************************************************************

@interface KKTimer ()

@property(nonatomic, strong)NSTimer *timer;
@property(nonatomic, strong)NSMutableArray *timerArray;
@property(nonatomic, assign)NSTimeInterval explicTime;
@property (nonatomic, strong)dispatch_queue_t timerQueue;

@end

@implementation KKTimer

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

-(id)init
{
    if (self = [super init]) {
        self.timerQueue = dispatch_queue_create("timerQueue", DISPATCH_QUEUE_SERIAL);
        self.timerArray = [NSMutableArray arrayWithCapacity:0];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(viewBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(viewBecomeTerminate)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        [self viewBecomeActive];
        self.explicTime = [NSDate timeIntervalSinceReferenceDate];
    }
    return self;
}

-(void)viewBecomeActive
{
    NSTimeInterval t = [NSDate timeIntervalSinceReferenceDate];
    if (t-self.explicTime>3) {
        [self getServerTime];
    }
}

-(void)viewBecomeTerminate
{
    self.explicTime = [NSDate timeIntervalSinceReferenceDate];
}

-(void)getServerTime
{
    NSString *url = @"[AbsoluntRequestUrl reqestWithStarService:KKUser_ServerTime]";
    __block NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    __weak __typeof(self)weakSelf = self;
    [KKHttpTool get:url params:nil cookied:NO success:^(id json) {
        NSNumber *retCode=json[@"rtn"];
        if (retCode.integerValue==0) {
            NSTimeInterval serverTime = [json[@"data"][@"currentTime"] longLongValue];
            NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
            NSTimeInterval loalTime = (startTime + endTime)/2.0f;
            weakSelf.offsetBetweenServerAndLocaltime = serverTime/1000.0f - loalTime;
        } else {
            
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)insetTimerName:(NSString *)name userMark:(id)userMark timeInterval:(NSTimeInterval)timerInterval endTime:(NSTimeInterval)endTime
{
    NSTimeInterval timeLength = -1;
    if (endTime>0) {
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970] + _offsetBetweenServerAndLocaltime;
        timeLength = endTime/1000 - now;
        if (timeLength<0) {
            return;
        }
    }
    [self insetTimerName:name userMark:userMark timeInterval:timerInterval timeLength:timeLength];
}

-(void)insetTimerName:(NSString *)name userMark:(id)userMark timeInterval:(NSTimeInterval)timerInterval timeLength:(NSTimeInterval)timeLength
{
    NSTimeInterval end = timeLength;
    
    NSDate *date = [NSDate date];
    NSTimeInterval now = [date timeIntervalSince1970] + _offsetBetweenServerAndLocaltime;
    if (timeLength>0) {
        end = now + timeLength;
    }
//    
//    NSString *user = userMark.length<=0 ? name : userMark;
    dispatch_suspend(_timerQueue);
    KKTimerInfo *timerInfo = [[KKTimerInfo alloc] initWithName:name userMark:userMark timeInterval:timerInterval now:now end:end];
    
    if (_timerArray == nil) {
        self.timerArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    [self removeTimerName:timerInfo.name userMark:timerInfo.userMark];
    [_timerArray addObject:timerInfo];
    
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:PER_VAL target:self selector:@selector(timerCrile:) userInfo:nil repeats:YES];
    }
    dispatch_resume(_timerQueue);
}


-(void)removeTimerName:(NSString *)name userMark:(id)userMark
{
    dispatch_suspend(_timerQueue);
    if (userMark) {
        for (KKTimerInfo *info in _timerArray) {
            if ([info.name isEqualToString:name] && [info.userMark isEqual:userMark]) {
                [_timerArray removeObject:info];
                break;
            }
        }
    }
    else //删除所有name的数据
    {
        for (int i=0; i<_timerArray.count; i++) {
            KKTimerInfo *info = _timerArray[i];
            if ([info.name isEqualToString:name]) {
                [_timerArray removeObject:info];
                i--;
            }
        }
    }
    if (_timerArray.count<=0) {
        [_timer invalidate];
        _timer = nil;
    }
    dispatch_resume(_timerQueue);
}

-(BOOL)checkIsRunWith:(NSString *)name userMark:(id)userMark
{
//        NSString *user = userMark.length<=0 ? name : userMark;
    BOOL isResult = NO;
    dispatch_suspend(_timerQueue);
    if (userMark) {
        for (KKTimerInfo *info in _timerArray) {
            if ([info.name isEqualToString:name] && [info.userMark isEqual:userMark]) {
                isResult = YES;
                break;
            }
        }
    }
    else
    {
        for (KKTimerInfo *info in _timerArray) {
            if ([info.name isEqualToString:name]) {
                isResult = YES;
                break;
            }
        }
    }
    dispatch_resume(_timerQueue);
    return isResult;
}


-(void)timerCrile:(NSTimer *)timer
{
    NSDate *date = [NSDate date];
    NSTimeInterval now = [date timeIntervalSince1970] + _offsetBetweenServerAndLocaltime;
    
    dispatch_async(_timerQueue, ^{
        for (int i=0; i<_timerArray.count; i++) {
            KKTimerInfo *info = [_timerArray objectAtIndex:i];
            
            //无限
            if (info.end<0) {
                if ((now - info.lastTime) < info.interval) {
                    continue;
                }
            }
            else
            {
                if (info.end > now && (now - info.lastTime) < info.interval) {
                    continue;
                }
            }
            info.lastTime = now;
            //            KKLog(@"----%f",info.end - info.lastTime);
            NSInteger leftTime = (NSInteger)(info.end - info.lastTime + 0.5f); //四舍五入
            leftTime = MAX(0, leftTime);
            
            NSDictionary *dic = nil;
            if (info.userMark) {
                dic =  @{KEY_USER: info.userMark, KEY_TIME: [NSNumber numberWithInteger:leftTime]};
            }
            else
            {
                dic = @{KEY_TIME: [NSNumber numberWithInteger:leftTime]};
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                NSNotification* notification =[NSNotification notificationWithName:info.name object:dic];
                [[NSNotificationCenter defaultCenter]postNotification:notification];
            });
            
            if (leftTime==0 && info.end>0) {
                [_timerArray removeObject:info];
                i--;
            }
        }
        if (_timerArray.count<=0) {
            [_timer invalidate];
            _timer = nil;
        }
    });
}

-(NSTimeInterval)timeLengthToTime:(NSTimeInterval)time
{
    if (timer==nil) {
        timer = [[KKTimer alloc] init];
    }
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970] + _offsetBetweenServerAndLocaltime;
    NSTimeInterval timeLength = time/1000.0f - now;
    return timeLength;
}

-(void)setServerTime:(NSTimeInterval)serverTime
{
    NSTimeInterval loalTime = [[NSDate date] timeIntervalSince1970];
    self.offsetBetweenServerAndLocaltime = serverTime/1000.0f - loalTime;
}


+(void)timerInitialize
{
    if (timer==nil) {
        timer = [[KKTimer alloc] init];
    }
}

+(void)setServerTime:(NSTimeInterval)severTime
{
    if (timer==nil) {
        timer = [[KKTimer alloc] init];
    }
    [timer setServerTime:severTime];
}

+(void)insetTimerName:(NSString *)name userMark:(id)userMark timeInterval:(NSTimeInterval)timerInterval timeLength:(NSTimeInterval)timeLength
{
    if (timer==nil) {
        timer = [[KKTimer alloc] init];
    }
    [timer insetTimerName:name userMark:userMark timeInterval:timerInterval timeLength:timeLength];
}

+(void)insetTimerName:(NSString *)name userMark:(id)userMark timeInterval:(NSTimeInterval)timerInterval endTime:(NSTimeInterval)endTime
{
    if (timer==nil) {
        timer = [[KKTimer alloc] init];
    }
    [timer insetTimerName:name userMark:userMark timeInterval:timerInterval endTime:endTime];
}

+(void)removeTimerName:(NSString *)name userMark:(id)userMark
{
    if (timer==nil) {
        timer = [[KKTimer alloc] init];
    }
    [timer removeTimerName:name userMark:userMark];
}

+(BOOL)checkIsRunWith:(NSString *)name userMark:(id)userMark
{
    if (timer==nil) {
        timer = [[KKTimer alloc] init];
    }
    return [timer checkIsRunWith:name userMark:userMark];
}

+(void)setOffsetBetweenServerAndLocaltime:(NSTimeInterval)offsetBetweenServerAndLocaltime
{
    if (timer==nil) {
        timer = [[KKTimer alloc] init];
    }
    timer.offsetBetweenServerAndLocaltime = offsetBetweenServerAndLocaltime;
}

+(NSTimeInterval)getOffsetBetweenServerAndLocaltime
{
    if (timer==nil) {
        timer = [[KKTimer alloc] init];
    }
    return timer.offsetBetweenServerAndLocaltime;
}

+(NSTimeInterval)timeLengthToTime:(NSTimeInterval)time
{
    if (timer==nil) {
        timer = [[KKTimer alloc] init];
    }
    return [timer timeLengthToTime:time];
}

@end















