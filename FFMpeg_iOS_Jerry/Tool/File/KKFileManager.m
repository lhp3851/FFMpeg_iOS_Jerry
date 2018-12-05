//
//  FileOperationManager.m
//  StarZone
//
//  Created by lhp3851 on 16/2/14.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import "KKFileManager.h"

#define localPath @""


@implementation KKFileManager

//获取沙盒根路径
+(NSString *)getSandBoxPath{
    //1.获取沙盒根目录
    NSString *directory = NSHomeDirectory();
    return directory;
}
//获取Document路径
+(NSString *)getSandBoxDocumentPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}
//获取tem路径
+(NSString *)getSandBoxtemPath{
    NSString *tmp = NSTemporaryDirectory();
    return tmp;
}

//获取Library路径
+(NSString *)getSandBoxLibraryPath{
    NSArray *pathes = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [pathes objectAtIndex:0];
    return path;
}
//获取Caches路径
+(NSString *)getSandBoxCachesPath{
    NSArray *pathes = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [pathes objectAtIndex:0];
    return path;
}
//获取Preference路径
+(NSString *)getSandBoxPreferencePath{
    NSArray *pathes = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES);
    NSString *path = [pathes objectAtIndex:0];
    return path;
}
//得到文件的绝对路径
+(NSString *)absolutePath:(NSString *)relativePath{
    NSString *path=[NSString stringWithFormat:@"%@/%@",[self getSandBoxPath],relativePath];
    return path;
}

+(UIImage *)imageWithPath:(nonnull NSString *)path{
    if ([NSString isBlank:path]) {//空路径，表示没图片
        return nil;
    }
    NSString *pathCopy=path;
    path=[[NSBundle mainBundle] pathForResource:path ofType:@"png" inDirectory:@""];
    if (path==nil)
    {
        UIImage *image = nil;
        if (kSCREEN_WIDTH>375) {//iPhone6 p
            path=[NSString stringWithFormat:@"%@@3x",pathCopy];
            image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:@"png" inDirectory:@""]];
        }
        if (image==nil) {
            path=[NSString stringWithFormat:@"%@@2x",pathCopy];
            image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:@"png" inDirectory:@""]];
        }
        if (image==nil) {
            image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pathCopy ofType:@"png" inDirectory:@""]];
        }
        return image;
    }
    else{
        UIImage *image=[UIImage imageWithContentsOfFile:path];
        return image;
    }
}


+(NSArray *)imagesWithPath:(NSString *)path
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    UIImage *image = nil;
    NSInteger index = 1;
    do {
        NSString *imagePath = [NSString stringWithFormat:@"%@%00004ld", path,(long)index];
        image = [self imageWithPath:imagePath];
        if (image==nil) {
            break;
        }
        [array addObject:image];
        index++;
    } while (image);
    return array;
}

+ (NSData *)fileWithPath:(NSString *)path{
    return nil;
}

+(UIImage *)imagePersonDefault:(NSInteger)widthHeight
{
    NSString *name = @"woman";
    name = [NSString stringWithFormat:@"%@%ld-%ld",name, (long)widthHeight, (long)widthHeight];
    UIImage *image = [self imageWithPath:name];
    return image;
}

+(UIImage *)imageVipLevelWith:(NSInteger)vipLevel
{
    NSString *imageName = [NSString stringWithFormat:@"VIP.%ld", vipLevel];
    return kIMAGE_NAME(imageName);
}

+ (BOOL)createDiskPathWithPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        return [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    }else
        return YES;
}


+(void)deleteFile:(NSString *)filePath {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!blHave) {
        NSLog(@"File [%@] dont exist!", filePath);
        return ;
    }else {
        BOOL blDele= [fileManager removeItemAtPath:filePath error:nil];
        if (blDele) {
            NSLog(@"Delete [%@] success", filePath);
        }else {
            NSLog(@"Delete [%@] Fail", filePath);
        }
    }
}
+ (NSUInteger)getPathSize:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *subPaths = [fileManager subpathsOfDirectoryAtPath:path error:nil];
    NSUInteger totalSize = 0;
    for (NSString *subPath in subPaths) {
        NSString *absolutePath = [path stringByAppendingPathComponent:subPath];
        if ([fileManager fileExistsAtPath:absolutePath isDirectory:false]) {//文件
            totalSize += [fileManager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
    }
    return totalSize;
}

#pragma mark + 保存图片至沙盒
+ (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPath atomically:YES];
}
#pragma mark + 偏好设置
+ (void)kkDRemoveValueForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    [defaults removeObjectForKey:key];
}

+ (void)kkDSetString:(NSString *)value forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    [defaults setValue:value forKey:key];
    [defaults synchronize];
}
+ (void)kkDSetObject:(id)value forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    if (value) {
        [defaults setObject:value forKey:key];
    }
    else
        [defaults setNilValueForKey:key];
    [defaults synchronize];
}
+ (void)kkDSetValue:(id)value forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    [defaults setValue:value forKey:key];
    [defaults synchronize];
}
+ (void)kkDSetBool:(BOOL)value forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    [defaults setBool:value forKey:key];
    [defaults synchronize];
}
+ (void)kkDSetInteger:(NSInteger)value forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    [defaults setInteger:value forKey:key];
    [defaults synchronize];
}
+ (void)kkDSetFloat:(float)value forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    [defaults setFloat:value forKey:key];
    [defaults synchronize];
}
+ (void)kkDSetDouble:(double)value forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    [defaults setDouble:value forKey:key];
    [defaults synchronize];
}

+ (NSString *)kkDGetStringForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    return [defaults stringForKey:key] ? [defaults stringForKey:key] : @"";
}
+ (id)kkDGetObjectForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    return [defaults objectForKey:key];
}
+ (id)kkDgetValueForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    return [defaults valueForKey:key];
}
+ (BOOL)kkDGetBoolForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    return [defaults boolForKey:key];
}
+ (NSInteger)kkDGetIntegerForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    return [defaults integerForKey:key];
}
+ (float)kkDGetFloatForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    return [defaults floatForKey:key];
}
+ (double)kkDGetDoubleForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    return [defaults doubleForKey:key];
}
@end
