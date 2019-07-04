//
//  NetWorkManager.h
//  FBSnapshotTestCase
//
//  Created by sumian on 2019/5/14.
//

#import <Foundation/Foundation.h>
#import "Reachaility/Reachability.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CompletionHandler)(id response,NSError *error);

@interface NetWorkManager : NSObject

+(instancetype)shareInstance;

@property(nonatomic,strong)Reachability *reachAbility;


#pragma mark get 请求
- (NSURLSessionDataTask *)getWithURL:(NSString *)url andParameters:(NSDictionary *)parameters complete:(CompletionHandler)completion;

#pragma mark post 请求


#pragma mark 下载


#pragma mark 上传


#pragma mark 缓存管理


#pragma mark cookie管理

@end

NS_ASSUME_NONNULL_END
