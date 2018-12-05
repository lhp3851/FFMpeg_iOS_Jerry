//
//  KKUploadManager.m
//  StarZone
//
//  Created by TinySail on 16/9/12.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import "KKUploadManager.h"

#define kTimeOutInterval 15.0f

@implementation KKUploadManager

static AFHTTPSessionManager *uploadMgr;

+ (void)initialize
{
    uploadMgr = [AFHTTPSessionManager manager];
    uploadMgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置超时
    uploadMgr.requestSerializer.timeoutInterval = kTimeOutInterval;
}
+ (NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params data:(NSData *)data fileName:(NSString *)fileName name:(NSString *)name mimeType:(NSString *)mimeType progress:(KKProgress)progress success:(KKSUCCESS)success failure:(KKFAILURE)failure
{
    return [uploadMgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
