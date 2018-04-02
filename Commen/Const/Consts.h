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
#define kWINDOW_WIDTH        (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height))
#define kWINDOW_HEIGHT       (MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height))

//日期相关的宏
#define kDAY_TIME_INTERVAL 86400






//常量
static NSString *kKKNetworkStatusChangedNotification = @"kKKNetworkStatusChangedNotification";
static NSString *kTongMengNetWorkError               = @"网络错误，请检查您的网络设置";
static NSString *kTongMengServerError                = @"服务器无法连接";
static NSString *kTongMengEmptyData                  = @"空空如也，啥都木有~";
static NSString *kTongMengNoSearchData               = @"没有搜索到相关数据~";



#endif /* Consts_h */
