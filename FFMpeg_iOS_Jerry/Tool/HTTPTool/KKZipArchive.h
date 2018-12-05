//
//  KKZipArchive.h
//  StarZone
//
//  Created by Fluman on 16/7/18.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKZipArchive : NSObject

/**
 *  解压zip文件，内部异步处理
 *  path 解压文件地址
 *  destination 解压目的地址
 *  completionHandler 解压完成处理
 */
+(void)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination completionHandler:(void (^)(NSString *path, BOOL succeeded, NSError *error))completionHandler;

@end
