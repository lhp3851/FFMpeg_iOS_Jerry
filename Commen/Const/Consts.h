//
//  Consts.h
//  FFMpeg_iOS_Jerry
//
//  Created by Jerry on 30/03/2018.
//  Copyright © 2018 Jerry. All rights reserved.
//

#ifndef Consts_h
#define Consts_h

//屏幕尺寸
#define kSCREEN_WIDTH        (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height))
#define kSCREEN_HEIGHT       (MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height))

//日期相关的宏
#define kDAY_TIME_INTERVAL 86400

//获取图片
#define kIMAGE_NAME(imageName) [KKFileManager imageWithPath:imageName]

//路径
#define kSYSTEM_CACHE_PATH    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]//系统缓存目录
#define kDATA_CACHE_PATH      [kSYSTEM_CACHE_PATH stringByAppendingPathComponent:@"com.xiangchao.StarZone"]//数据缓存根目录
#define kDOCUMENT_PATH        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]
#define kUPLOAD_CACHE_PATH    [kDOCUMENT_PATH  stringByAppendingPathComponent:@"uploadImageCache"]
#define kEXPORT_VEDIO_PATH    [kDOCUMENT_PATH  stringByAppendingPathComponent:@"media/video/ExportVideoData"]
#define kCOMPRESS_VEDIO_PATH  [kDOCUMENT_PATH  stringByAppendingPathComponent:@"media/video/CompressionVideoField"]
#define kMEDIA_CAHCE_PATH     [kDATA_CACHE_PATH stringByAppendingPathComponent:@"media/video"]//视频配置目录
#define kMEDIA_BUFFER_PATH    [kDOCUMENT_PATH  stringByAppendingPathComponent:@"media/buffer"]//视频缓存目录




//通知名字
static NSString *kNetworkStatusChangedNotification  = @"NetworkStatusChangedNotification";
static NSString *KLogOutNotification                = @"KLogOutNotification";

//常量
static NSString *kNetWorkError                      = @"网络错误，请检查您的网络设置";
static NSString *kServerError                       = @"服务器无法连接";
static NSString *kEmptyData                         = @"空空如也，啥都木有~";
static NSString *kNoSearchData                      = @"没有搜索到相关数据~";



#endif /* Consts_h */
