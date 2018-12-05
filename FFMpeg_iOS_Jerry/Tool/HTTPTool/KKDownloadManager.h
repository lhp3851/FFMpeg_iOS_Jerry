//
//  KKDownloadManager.h
//  StarZone
//
//  Created by TinySail on 16/7/19.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKDownloadManager : NSObject
+ (NSURLSessionDownloadTask *)download:(NSString *)url
                              filePath:(NSString *)filePath
                                params:(NSDictionary *)params
                          ignoreCached:(BOOL)ignore
                              progress:(KKProgress)progress
                              complate:(KKDownloadComplateBlock)complate;
@end
