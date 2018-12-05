//
//  KKDownloadManager.m
//  StarZone
//
//  Created by TinySail on 16/7/19.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import "KKDownloadManager.h"
#import "KKZipArchive.h"

@implementation KKDownloadManager

static NSString *downloadCachePath;
static NSMutableDictionary *downloadCachePathCacheDic;

+ (void)initialize
{
    downloadCachePathCacheDic = [NSMutableDictionary dictionary];
    downloadCachePath = [kDATA_CACHE_PATH stringByAppendingPathComponent:@"downloadCache"];
    NSFileManager *filMgr = [NSFileManager defaultManager];
    if (![filMgr fileExistsAtPath:downloadCachePath isDirectory:nil]) {
        NSError *error;
        [filMgr createDirectoryAtPath:downloadCachePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            print(@"Couldn't create cache path");
        }
    }
}

+ (NSString *)generatingFileNameWithUrl:(NSString *)url
{
    NSURL *urlURL = [NSURL URLWithString:url];
    NSMutableString *fileName = [NSMutableString stringWithString:[urlURL.lastPathComponent stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *parameter = urlURL.query;
    if (fileName.length) {
        if (parameter.length) {
            [fileName appendString:[NSString stringWithFormat:@".%@", parameter]];
        }
    }else
        return nil;
    return fileName;
}

+ (BOOL)fileDownloadWithUrl:(NSString *)url filePath:(NSString **)filePath
{
    NSString *fileName = [self generatingFileNameWithUrl:url];
    NSMutableString *sFilePath = [downloadCachePathCacheDic valueForKey:fileName];
    if (!sFilePath.length) {
        sFilePath = [NSMutableString stringWithString:downloadCachePath];
        if (fileName.length)
            [sFilePath appendFormat:@"/%@", fileName];
    }
    *filePath = sFilePath;
        
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:sFilePath]) {
        return YES;
    }else
        return NO;
}

+ (NSURLSessionDownloadTask *)download:(NSString *)url filePath:(NSString *)filePath params:(NSDictionary *)params ignoreCached:(BOOL)ignore progress:(KKProgress)progress complate:(KKDownloadComplateBlock)complate
{
    __block NSString *defaultFilePath;
    __block NSString *utfUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __block BOOL downloaded = [self fileDownloadWithUrl:utfUrl filePath:&defaultFilePath];
    //Destinated file had be download
    if ((!ignore) && downloaded) {
        complate(defaultFilePath, YES, nil, NO);
        return nil;
    }
    
    static AFURLSessionManager *mrg;
    mrg = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    static AFHTTPRequestSerializer *requestSerializer;
    requestSerializer = [AFHTTPRequestSerializer serializer];
    requestSerializer.timeoutInterval = 15.0;
    
    
    NSError *serializationError = nil;
    
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"GET" URLString:utfUrl parameters:params error:&serializationError];
    
    if (serializationError) {
        if (complate) {
            complate(nil, NO, serializationError, NO);
        }
        return nil;
    }
    
    if (filePath.length) {
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        if ([fileURL isFileURL]) {
            defaultFilePath = filePath;
            NSFileManager *filMgr = [NSFileManager defaultManager];
            NSString *superPath = [filePath stringByDeletingLastPathComponent];
            if (![filMgr fileExistsAtPath:superPath isDirectory:nil]) {
                NSError *error;
                [filMgr createDirectoryAtPath:superPath withIntermediateDirectories:YES attributes:nil error:&error];
                if (error) {
                    print(@"Couldn't create dest path");
                }
            }
        }
    }
    
    NSURLSessionDownloadTask *task = [mrg downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        print(@"download progress:%0.2f%%", 100.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:defaultFilePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable ffilePath, NSError * _Nullable error) {
        if (error) {
            complate(nil, NO, error, NO);
        }else
        {
            NSString *fileName = [self generatingFileNameWithUrl:utfUrl];
            [downloadCachePathCacheDic setValue:defaultFilePath forKey:fileName];
            complate(defaultFilePath, YES, nil, !downloaded);
        }
    }];
    [task resume];
    return task;
}
@end
