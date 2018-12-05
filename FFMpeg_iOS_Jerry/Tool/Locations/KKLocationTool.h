//
//  KKLocationServer.h
//  StarZone
//
//  Created by TinySail on 16/12/12.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LocationRequestBlock) (NSString *location);

@interface KKLocationTool : NSObject
+ (KKLocationTool *)sharedInstance;

/**
 添加请求

 @param block      位置回调
 @param continus   是否持续的获取
 @param identifier 标识，必传
 */
- (void)getCurrentLocation:(LocationRequestBlock)block continus:(BOOL)continus identifier:(nonnull NSString *)identifier;

/**
 取消请求

 @param identifier 标识
 */
- (void)stopUpdatingLocation:(nonnull NSString *)identifier;

/**
 停止定位服务，全局停止
 */
- (void)stop;
@end
