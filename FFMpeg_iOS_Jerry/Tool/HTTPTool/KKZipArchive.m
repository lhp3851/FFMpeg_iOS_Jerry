//
//  KKZipArchive.m
//  StarZone
//
//  Created by Fluman on 16/7/18.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import "KKZipArchive.h"
#import "SSZipArchive.h"

@implementation KKZipArchive

+(void)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination completionHandler:(void (^)(NSString *path, BOOL succeeded, NSError *error))completionHandler
{
    if (path.length<=0 || destination.length<=0) {
        if (completionHandler) {
            completionHandler(path, NO, nil);
        }
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //过遮目标文件
        NSString *tmpPath = [destination stringByAppendingString:@"_tmp"];
        //解压开始
        BOOL result = [SSZipArchive unzipFileAtPath:path toDestination:tmpPath progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
            
        } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nonnull error) {
            
        }];
        print(@"KKZipArchive result = %d", result);
        if (result) {
            [KKFileManager deleteFile:destination];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSError *error;
            result = [fileManager moveItemAtPath:tmpPath toPath:destination error:&error];
            if (!result) {
                print(@"Unable to move file: %@", [error localizedDescription]);
            }
        }
        
        if (completionHandler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(path, result, nil);
            });
        }
    });
}

@end
