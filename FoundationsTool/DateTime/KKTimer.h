//
//  KKTimer.h
//  StarZone
//
//  Created by 宋林峰 on 16/2/17.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_USER   @"userMark"
#define KEY_TIME   @"leftTime"

/**
 *  定义timer定时器控件
 *  设置思路：
 *    1、一个系统timer进行循环检测,检测时间为0.1秒；
 *    2、每一个定时触发以通知的形式发送
 *    3、每一个要实现定时器的对像，都要实成对通知的接收，通知的消息包括userMark和剩余时间
 *    格式为 @{KEY_USER: userMark, KEY_TIME: [NSNumber numberWithInteger:leftTime]}
 *  ex:
     {
            [KKTimer insetTimerName:@"testTimer" userMark:nil timeInterval:1.0f timeLength:10.0f];
     
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(testTimer:) name:@"testTimer" object:nil];
     }
     - (void)testTimer:(NSNotification*)notification {
         NSDictionary *dic = [notification object];
         NSString *usermark = [dic objectForKey:KEY_USER];
         NSNumber *number = [dic objectForKey:KEY_TIME];
 
         if ([number integerValue] == 0) {
             [KKTimer removeTimerName:@"testTimer" userMark:nil];
         }
     }
 */
@interface KKTimer : NSObject

@property(nonatomic, assign)NSTimeInterval offsetBetweenServerAndLocaltime;  //当前服务器与本地时间差


/**
 *  加入定时器处理
 *  @param name      为定时器名称，（也是通知的名字）
 *  @param userMark   用户的标识
 *  @param timerInterval  时间间隔
 *  @param timeLength     时间长度,小于0，表示无限循环
 *
 *  @return 
 }
 */
-(void)insetTimerName:(NSString *)name userMark:(id)userMark timeInterval:(NSTimeInterval)timerInterval timeLength:(NSTimeInterval)timeLength;

/**
 *  加入定时器处理
 *  @param name      为定时器名称，（也是通知的名字）
 *  @param userMark   用户的标识
 *  @param timerInterval  时间间隔
 *  @param endTime     结束时间，时间为服务器时间 毫秒,小于0，表示无限循环
 *
 *  @return
 }
 */
-(void)insetTimerName:(NSString *)name userMark:(id)userMark timeInterval:(NSTimeInterval)timerInterval endTime:(NSTimeInterval)endTime;


/**
 *  移除定时器处理
 *  @param name      为定时器名称，（也是通知的名字）
 *  @param userMark   用户的标识，当userMark为空时，删除所有name下的timer
 *
 *  @return
 }
 */
-(void)removeTimerName:(NSString *)name userMark:(id)userMark;

/**
 *  判断当前的timer是否正在运行
 *
 *  @param name     定时器名
 *  @param userMark 用户标识
 *
 *  @return BOOL
 */
-(BOOL)checkIsRunWith:(NSString *)name userMark:(id)userMark;

/**
 *  获取时间长度，从当前到这个时间的长度
 *
 *  @param time 服务器时间, 毫秒
 *
 *  @return 时间长度，从当前到time的时间长度
 */
-(NSTimeInterval)timeLengthToTime:(NSTimeInterval)time;


//**************************************************************************************************
//**************************************************************************************************
//**************************************************************************************************

+(void)timerInitialize;

/**
 *  设置服务器时间，用于计数offsetBetweenServerAndLocaltime
 *
 *  @param severTime 服务器当前时间
 */
+(void)setServerTime:(NSTimeInterval)severTime;

+(void)insetTimerName:(NSString *)name userMark:(id)userMark timeInterval:(NSTimeInterval)timerInterval timeLength:(NSTimeInterval)timeLength;

+(void)insetTimerName:(NSString *)name userMark:(id)userMark timeInterval:(NSTimeInterval)timerInterval endTime:(NSTimeInterval)endTime;

+(void)removeTimerName:(NSString *)name userMark:(id)userMark;

+(BOOL)checkIsRunWith:(NSString *)name userMark:(id)userMark;

+(void)setOffsetBetweenServerAndLocaltime:(NSTimeInterval)offsetBetweenServerAndLocaltime;
/**
 *  获得当前时间差
 *
 *  @param offsetBetweenServerAndLocaltime = serverTime/1000.0f - loalTime
 */
+(NSTimeInterval)getOffsetBetweenServerAndLocaltime;

+(NSTimeInterval)timeLengthToTime:(NSTimeInterval)time;

@end
