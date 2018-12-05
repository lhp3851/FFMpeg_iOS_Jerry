//
//  KKCryptTool.h
//  StarZone
//
//  Created by WS on 16/6/28.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKCryptTool : NSObject

/**
 *  md5加密
 *
 *  @param content 需要加密的内容
 *
 *  @return 加密后的32位值
 */
+ (NSString*)md5EncryptWithContent:(NSString*)content;


+ (NSString*)encryptWithUserId:(NSString*)userId time_stamp:(NSString*)time;


+ (NSString*)getEncryptCode;

@end
