//
//  KKRsaTool.h
//  StarZone
//
//  Created by WS on 16/6/28.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKRsaTool : NSObject


/**
 *  rsa加密
 *
 *  @param content 需要被加密的内容
 *
 *  @return 加密后的16进制字符串
 */
- (NSString*)encryptWithContent:(NSString*)content;

@end
