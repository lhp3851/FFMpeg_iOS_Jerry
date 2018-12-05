//
//  KKKeyChainManager.h
//  StarZone
//
//  Created by TinySail on 16/7/4.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString *kKeyChainItemDefaultAccount = @"com.xiangchao.StarZone.Normal";
@interface KKKeyChainItem : NSObject
/**
 *  @author Sail
 *
 *  @brief 初始化 keyChainItem，如果对应于 account-service的key chain存在，返回已创建的，如不存在，创建一个新的
 *
 *  @param account 整个应用最好用同一个,默认为kKeyChainItemDefaultAccount
 *  @param service 标识，不可为空
 *
 *  @return
 */
- (instancetype)initWithAccount: (NSString *)account service:(NSString *) service;
- (void)setObject:   (id)inObject forKey:(id)key;
- ( id )objectForKey:(id)key;
/**
 *  @author Sail
 *
 *  @brief 删除keyChainItem
 */
- (void)resetKeychainItem;
@end

@interface KKKeyChainManager : NSObject
/**
 *  @author Sail
 *
 *  @brief 获取公用的key chain，不要reset该key chain
 *
 *  @return
 */
+ (KKKeyChainItem *)getUnityKeyChainItem;
/**
 *  @author Sail
 *
 *  @brief 获取设备uuid
 *
 *  @return
 */
+ (NSString *)getUUIDString;
@end
