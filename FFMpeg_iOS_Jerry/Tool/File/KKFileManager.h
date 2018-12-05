//
//  FileOperationManager.h
//  StarZone
//
//  Created by lhp3851 on 16/2/14.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKFileManager : NSObject
/**
 *   根据路径获取图片文件
 */
+(UIImage *)imageWithPath:(NSString *)path;

//获取多张个图片
+(NSArray *)imagesWithPath:(NSString *)path;

//获取默认头像，widthHeight宽高60， 90， 120，150
+(UIImage *)imagePersonDefault:(NSInteger)widthHeight;

//获取vip等级图标。
+(UIImage *)imageVipLevelWith:(NSInteger)vipLevel;

//获取文件数据
+(NSData *)fileWithPath:(NSString *)path;

//获取沙盒根路径
+(NSString *)getSandBoxPath;
//获取Document路径
+(NSString *)getSandBoxDocumentPath;
//获取tem路径
+(NSString *)getSandBoxtemPath;
//获取Library路径
+(NSString *)getSandBoxLibraryPath;
//获取Caches路径
+(NSString *)getSandBoxCachesPath;
//获取Preference路径
+(NSString *)getSandBoxPreferencePath;

//删除文件
+(void)deleteFile:(NSString *)filePath;
//保存图片
+ (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName;


/**
 *  创建文件夹
 *
 *  @param path 路径
 *
 *  @return 是否创建成功
 */
+ (BOOL)createDiskPathWithPath:(NSString *)path;
/**
 *  @brief 获取文件/文件夹的大小
 *
 *  @param path 路径
 *
 *  @return 大小，单位b
 */
+ (NSUInteger)getPathSize:(NSString *)path;
/**
 *  @brief 偏好设置接口
 */

+ (void)kkDRemoveValueForKey:(NSString *)key;

+ (void)kkDSetString:(NSString *)value forKey:(NSString *)key;
/**
 *  @brief 设置偏好设置
 *
 *  @param value 自定义对象
 *  @param key
 */
+ (void)kkDSetObject:(id)value forKey:(NSString *)key;
/**
 *  @brief
 *
 *  @param value 系统对象
 *  @param key
 */
+ (void)kkDSetValue:(id)value forKey:(NSString *)key;
+ (void)kkDSetBool:(BOOL)value forKey:(NSString *)key;
+ (void)kkDSetInteger:(NSInteger)value forKey:(NSString *)key;
+ (void)kkDSetFloat:(float)value forKey:(NSString *)key;
+ (void)kkDSetDouble:(double)value forKey:(NSString *)key;
/**
 *  @brief 获取偏好设置
 *
 *  @param key key
 *
 *  @return 返回字符串值，如果为空则返回@""
 */
+ (NSString *)kkDGetStringForKey:(NSString *)key;
/**
 *  @brief
 *
 *  @param key
 *
 *  @return 返回自定义对象
 */
+ (id)kkDGetObjectForKey:(NSString *)key;
/**
 *  @brief
 *
 *  @param key
 *
 *  @return 返回系统对象
 */
+ (id)kkDgetValueForKey:(NSString *)key;
+ (BOOL)kkDGetBoolForKey:(NSString *)key;
+ (NSInteger)kkDGetIntegerForKey:(NSString *)key;
+ (float)kkDGetFloatForKey:(NSString *)key;
+ (double)kkDGetDoubleForKey:(NSString *)key;
@end
