//
//  KKUploadManager.h
//  StarZone
//
//  Created by TinySail on 16/9/12.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKUploadManager : NSObject
+ (NSURLSessionDataTask *)post:(NSString *)url
                        params:(NSDictionary *)params
                          data:(NSData *)data
                      fileName:(NSString *)fileName
                          name:(NSString *)name
                      mimeType:(NSString *)mimeType
                      progress:(KKProgress)progress
                       success:(KKSUCCESS)success
                       failure:(KKFAILURE)failure;
+ (NSURLSessionDataTask *)post:(NSString *)url
                         video:(NSObject *)videoFile
                ignoreUploaded:(BOOL)ignore
                      progress:(KKProgress)progress
                       success:(KKSUCCESS)success
                       failure:(KKFAILURE)failure;
@end
