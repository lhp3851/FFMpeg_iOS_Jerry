//
//  NSNumber+Extension.h
//  StarZone
//
//  Created by TinySail on 16/6/17.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Extension)
/**
 *  @author Sail
 *
 *  @brief 获取[from to]之间的随机数
 *
 *  @param from
 *  @param to
 *
 *  @return 随机数
 */
+ (NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to;
@end
