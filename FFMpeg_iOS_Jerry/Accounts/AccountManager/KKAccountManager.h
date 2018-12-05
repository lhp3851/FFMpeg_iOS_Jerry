//
//  KKAccountManager.h
//  FFMpeg_iOS_Jerry
//
//  Created by lhp3851 on 2018/12/4.
//  Copyright © 2018 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKAccountManager : NSObject

+(void)logout;

+(void)logoutWithTips:(NSString *)tips;

@end

NS_ASSUME_NONNULL_END
