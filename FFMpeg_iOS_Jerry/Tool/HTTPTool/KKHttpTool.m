
//
//  KKHttpTool.m
//
#import <UIKit/UIKit.h>
#import "KKHttpTool.h"
#import "AFNetworking.h"
#import "KKAlertView.h"
#import "AppDelegate.h"
#import "KKDownloadManager.h"
#import "KKUploadManager.h"
#import "AFgzipRequestSerializer.h"
#import "KKCryptTool.h"
#import "NSDate+Extension.h"
#import "KKAccountModel.h"
#import "KKAccountManager.h"

#define kTimeOutInterval 15.0f
#define KKFileBoundary @"kankan"
#define KKNewLine @"\r\n"
#define KKEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]


@interface KKURLSession()
{
    NSURLSessionTask *_task;
}
@end
@implementation KKURLSession

- (void)cancel
{
    if (_task.state != NSURLSessionTaskStateCompleted) {
        [_task cancel];
    }
}
- (void)resume
{
    if (_task.state == NSURLSessionTaskStateSuspended) {
        [_task resume];
    }
}
- (void)suspend
{
    if (_task.state == NSURLSessionTaskStateRunning) {
        [_task suspend];
    }
}
@end

@interface KKHttpTool()<UIAlertViewDelegate> {
    
}
@end


@implementation KKHttpTool
//登录完成的block
typedef void(^loginProcessDone)(void);

static KKUReachability *internetRe;
//登录成功后重新发送请求
static KKHttpTool *httpTool;
static KKSUCCESS reSuccess;
static KKFAILURE reFailure;
static AFHTTPSessionManager *jsonRequestMgr;
static AFHTTPSessionManager *httpRequestMgr;
static AFHTTPSessionManager *securityMgr;
static AFHTTPSessionManager *jsonZipMgr;
+ (void)resetHttpRe
{
    httpTool = nil;
    reSuccess = nil;
    reFailure = nil;
}
+ (void)reachabilityChanged:(NSNotification *)noti
{
    KKUReachability *curReach = [noti object];
    NSParameterAssert([curReach isKindOfClass:[KKUReachability class]]);
    NSString *netStatus;
    NetworkStatus status = [curReach currentReachabilityStatus];
    switch (status) {
        case ReachableViaWWAN:
            netStatus = KKHttpToolNetWorkStatusWWAN;
            break;
        case ReachableViaWiFi:
            netStatus = KKHttpToolNetWorkStatusWiFi;
            break;
        case NotReachable:
            netStatus = KKHttpToolNetWorkStatusDisconnect;
            [KKStarPromptBox showPromptBoxWithWords:kNetWorkError];
            break;
            
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkStatusChangedNotification object:self userInfo:@{@"netStatus" : netStatus}];
}
+(void)initialize
{
    //配置检测网络状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kkukReachabilityChangedNotification object:nil];

    
    httpRequestMgr = [AFHTTPSessionManager manager];
    httpRequestMgr.responseSerializer=[AFJSONResponseSerializer serializer];
    //设置超时
    httpRequestMgr.requestSerializer.timeoutInterval = kTimeOutInterval;
    
    jsonRequestMgr = [AFHTTPSessionManager manager];
    jsonRequestMgr.responseSerializer = [AFJSONResponseSerializer serializer];
    jsonRequestMgr.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    //设置超时
    jsonRequestMgr.requestSerializer.timeoutInterval = kTimeOutInterval;
    
    jsonZipMgr = [AFHTTPSessionManager manager];

    jsonZipMgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    jsonZipMgr.requestSerializer = [AFgzipRequestSerializer serializerWithSerializer:[AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted]];


    //设置超时
    jsonZipMgr.requestSerializer.timeoutInterval = kTimeOutInterval;
    
    
    securityMgr = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = NO;
    securityMgr.securityPolicy = securityPolicy;
    //设置超时
    securityMgr.requestSerializer.timeoutInterval = kTimeOutInterval;
    
   
    
    //设置缓存
    NSString *cachePath = [kDATA_CACHE_PATH stringByAppendingPathComponent:@"httpcache"];
    NSFileManager *fileMGR = [NSFileManager defaultManager];
    if (![fileMGR fileExistsAtPath:cachePath]) {
        [fileMGR createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024 diskCapacity:40 * 1024 * 1024 diskPath:cachePath];
    [NSURLCache setSharedURLCache:URLCache];
}
+ (KKUReachability *)sharedReachability
{
    @synchronized(self) {
        if (!internetRe) {
            internetRe = [KKUReachability reachabilityForInternetConnection];
        }
    }
    return internetRe;
}
+ (NetworkStatus)currentNetStatus
{
    return [[self sharedReachability] currentReachabilityStatus];
}
+ (void)setHttpRequestHeaderFields:(NSDictionary *)fileds security:(BOOL)security
{
    if (security) {
        for (NSString *key in fileds) {
            NSString *value = [fileds valueForKey:key];
            [securityMgr.requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }else
    {
        for (NSString *key in fileds) {
            NSString *value = [fileds valueForKey:key];
            [httpRequestMgr.requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }
}
+ (void)clearCustomRequestHeaderWithKeys:(NSArray *)keys security:(BOOL)security
{
    if (security) {
        for (NSString *key in keys) {
            [securityMgr.requestSerializer setValue:nil forHTTPHeaderField:key];
        }
    }else
    {
        for (NSString *key in keys) {
            [httpRequestMgr.requestSerializer setValue:nil forHTTPHeaderField:key];
        }
    }
}
#pragma mark - base网络请求
//错误处理
+ (void)erroCode:(NSInteger)erroCode response:(id)response success:(KKSUCCESS)success failure:(KKFAILURE)failure
{
    
}


+ (NSURLSessionDataTask *)get:(NSString *)url params:(NSDictionary *)params success:(KKSUCCESS)success failure:(KKFAILURE)failure
{
    
    return [self get:url cachePolicy:NSURLRequestUseProtocolCachePolicy params:params success:success failure:failure];
    
}

+ (NSURLSessionDataTask *)get:(NSString *)url cachePolicy:(NSURLRequestCachePolicy)cachePolicy params:(NSDictionary *)params success:(KKSUCCESS)success failure:(KKFAILURE)failure
{
    if (httpRequestMgr.requestSerializer.cachePolicy != cachePolicy) {
        httpRequestMgr.requestSerializer.cachePolicy = cachePolicy;
    }
    
    return [httpRequestMgr GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSString *erroCode=[responseObject valueForKey:@"rtn"];
            
            [self erroCode:erroCode.integerValue response:responseObject success:success failure:failure];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        NSHTTPURLResponse *respone = (NSHTTPURLResponse *)task.response;
        if (respone.statusCode == errorServerException) {
            [self erroCode:errorServerException response:nil success:nil failure:nil];
        }
        if ([self currentNetStatus] == NotReachable) {
            [KKStarPromptBox showPromptBoxWithWords:kNetWorkError toView:nil];
        }
    }];
    
}

+ (NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params success:(KKSUCCESS)success failure:(KKFAILURE)failure
{
    return [self post:url cachePolicy:NSURLRequestUseProtocolCachePolicy paramType:KKPostParamTypeHttp params:params success:success failure:failure];
}

+ (NSURLSessionDataTask *)post:(NSString *)url paramType:(KKPostParamType)type params:(NSDictionary *)params success:(KKSUCCESS)success failure:(KKFAILURE)failure
{
    return [self post:url cachePolicy:NSURLRequestUseProtocolCachePolicy paramType:type params:params success:success failure:failure];
}

+ (NSURLSessionDataTask *)post:(NSString *)url cachePolicy:(NSURLRequestCachePolicy)cachePolicy paramType:(KKPostParamType)type params:(NSDictionary *)params success:(KKSUCCESS)success failure:(KKFAILURE)failure
{
    
    print(@"🐶🐶🐶post--%@", url);
    
    AFHTTPSessionManager *mgr;
    switch (type) {
        case KKPostParamTypeHttp:
            mgr = httpRequestMgr;
            break;
        case KKPostParamTypeJson:
            mgr = jsonRequestMgr;
            break;
        case KKPostParamTypeJsonZip:
            mgr = jsonZipMgr;
            break;
        default:
            break;
    }
    
    if (mgr.requestSerializer.cachePolicy != cachePolicy) {
        mgr.requestSerializer.cachePolicy = cachePolicy;
    }
    
    // 2.发送请求
    return [mgr POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            if ([mgr.responseSerializer isKindOfClass:[AFJSONResponseSerializer class]]) {
                NSString *erroCode=[responseObject valueForKey:@"rtn"];
                print(@"kkhttpTool:post 错误码%@",erroCode);
                [self erroCode:erroCode.integerValue response:responseObject success:success failure:failure];
            }else
            {
                success(responseObject);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        NSHTTPURLResponse *respone = (NSHTTPURLResponse *)task.response;
        if (respone.statusCode == errorServerException) {
            [self erroCode:errorServerException response:nil success:nil failure:nil];
        }
        if ([self currentNetStatus] == NotReachable) {
            [KKStarPromptBox showPromptBoxWithWords:kNetWorkError toView:nil];
        }
    }];
}

#pragma mark upload function
+ (NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params data:(NSData *)data fileName:(NSString *)fileName name:(NSString *)name mimeType:(NSString *)mimeType success:(KKSUCCESS)success failure:(KKFAILURE)failure{
    return [self post:url params:params data:data fileName:(NSString *)fileName name:(NSString *)name mimeType:mimeType progress:nil success:success failure:failure];
}
+ (NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params data:(NSData *)data fileName:(NSString *)fileName name:(NSString *)name mimeType:(NSString *)mimeType progress:(KKProgress)progress success:(KKSUCCESS)success failure:(KKFAILURE)failure
{
    if ([self currentNetStatus] == NotReachable) {
        if (failure) {
            NSError *err = [NSError errorWithDomain:@"localhost" code:kNonNet userInfo:nil];
            failure(err);
            [KKStarPromptBox showPromptBoxWithWords:kNetWorkError toView:nil];
        }
        return nil;
    }
    return [KKUploadManager post:url params:params data:data fileName:fileName name:name mimeType:mimeType progress:progress success:success failure:failure];
}


+ (NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params image:(UIImage *)image progress:(KKProgress)progress success:(KKSUCCESS)success failure:(KKFAILURE)failure
{
    NSMutableDictionary *cookiedParams = [NSMutableDictionary dictionaryWithDictionary:params];
    NSDictionary *cookieParams = [self getCookieParams];
    [cookiedParams addEntriesFromDictionary:cookieParams];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    return [self post:url params:cookiedParams data:data fileName:@"imageFile.jpg" name:@"Filedata" mimeType:@"image/jpeg" progress:progress success:success failure:failure];
}
+ (NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params image:(UIImage *)image success:(KKSUCCESS)success failure:(KKFAILURE)failure{
    
    return [self post:url params:params image:image progress:nil success:success failure:failure];
}
+ (NSURLSessionDataTask *)post:(NSString *)url video:(NSObject *)videoFile ignoreUploaded:(BOOL)ignore progress:(KKProgress)progress success:(KKSUCCESS)success failure:(KKFAILURE)failure
{
    if ([self currentNetStatus] == NotReachable) {
        if (failure) {
            NSError *err = [NSError errorWithDomain:@"localhost" code:kNonNet userInfo:nil];
            failure(err);
            [KKStarPromptBox showPromptBoxWithWords:kNetWorkError toView:nil];
        }
        return nil;
    }
    return [KKUploadManager post:url video:videoFile ignoreUploaded:ignore progress:progress success:success failure:failure];
}
#pragma mark - loginParam
+ (NSDictionary*)getCookieParams{
    
    NSString *userId = @"";
    NSString *sessionid =  @"";
    NSNumber *type = @1;
    NSNumber *clientoperationid = @([UIDevice currentDevice].userInterfaceIdiom);
    NSString *timeStamp = [[NSDate date] timestamp];
    
    NSString *code = [KKCryptTool encryptWithUserId:userId time_stamp:timeStamp];
    NSDictionary *cookieParams = @{@"verify_userid" : userId,
                                   @"clientoperationid" : clientoperationid,
                                   @"verify_sessionid" : sessionid,
                                   @"verify_type":type,
                                   @"mxkjCode":code};
    return cookieParams;
}

//普通请求的时候校验登录状态
+ (NSMutableDictionary *)requestWith:(NSDictionary *)params cookied:(BOOL)enabled failure:(KKFAILURE)failure{
    NSMutableDictionary *cookiedParams = [NSMutableDictionary dictionaryWithDictionary:params];
    if (enabled) {
        if (![KKAccountModel sharedKKAccountModel].sessionId) {
            if (failure) {
                NSError *err = [NSError errorWithDomain:@"localhost" code:errorAccountNotExist userInfo:nil];
                failure(err);
                
            }
            [self knickedOut];
            return nil;
        }
        NSDictionary *cookieParams = [self getCookieParams];
        [cookiedParams addEntriesFromDictionary:cookieParams];
    }
    return cookiedParams;
}

//下载的时候校验登录状态
+ (NSMutableDictionary *)downloadWith:(NSDictionary *)params cookied:(BOOL)enabled complate:(KKDownloadComplateBlock)complate{
    NSMutableDictionary *cookiedParams = [NSMutableDictionary dictionaryWithDictionary:params];
    if (enabled) {
        if (![KKAccountModel sharedKKAccountModel].sessionId) {
            if (complate) {
                NSError *err = [NSError errorWithDomain:@"localhost" code:errorAccountNotExist userInfo:nil];
                complate(nil, NO, err, NO);
            }
            [self knickedOut];
            return nil;
        }
        NSDictionary *cookieParams = [self getCookieParams];
        [cookiedParams addEntriesFromDictionary:cookieParams];
    }
    return cookiedParams;
}

+ (NSURLSessionDataTask *)get:(NSString *)url params:(NSDictionary *)params cookied:(BOOL)enabled success:(KKSUCCESS)success failure:(KKFAILURE)failure
{
    return [self get:url params:params cookied:enabled cachePolicy:NSURLRequestUseProtocolCachePolicy success:success failure:failure];
}

+ (NSURLSessionDataTask *)get:(NSString *)url params:(NSDictionary *)params cookied:(BOOL)enabled cachePolicy:(NSURLRequestCachePolicy)cachePolicy success:(KKSUCCESS)success failure:(KKFAILURE)failure
{
    NSMutableDictionary *cookiedParams = [self requestWith:params cookied:enabled failure:failure];
    
    return [self get:url cachePolicy:cachePolicy params:cookiedParams success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
+ (NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params cookied:(BOOL)enabled success:(KKSUCCESS)success failure:(KKFAILURE)failure
{
    return [self post:url paramType:KKPostParamTypeHttp params:params cookied:enabled cachePolicy:NSURLRequestUseProtocolCachePolicy success:success failure:failure];
}

+ (NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params cookied:(BOOL)enabled cachePolicy:(NSURLRequestCachePolicy)cachePolicy success:(KKSUCCESS)success failure:(KKFAILURE)failure
{
    return [self post:url paramType:KKPostParamTypeHttp params:params cookied:enabled cachePolicy:cachePolicy success:success failure:failure];
}

+ (NSURLSessionDataTask *)post:(NSString *)url paramType:(KKPostParamType)type params:(NSDictionary *)params cookied:(BOOL)enabled success:(KKSUCCESS)success failure:(KKFAILURE)failure
{
    return [self post:url paramType:type params:params cookied:enabled cachePolicy:NSURLRequestUseProtocolCachePolicy success:success failure:failure];
}

+ (NSURLSessionDataTask *)post:(NSString *)url paramType:(KKPostParamType)type params:(NSDictionary *)params cookied:(BOOL)enabled cachePolicy:(NSURLRequestCachePolicy)cachePolicy success:(KKSUCCESS)success failure:(KKFAILURE)failure
{
    NSMutableDictionary *cookiedParams = [self requestWith:params cookied:enabled failure:failure];
    
    return [self post:url cachePolicy:cachePolicy paramType:type params:cookiedParams success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark download
+ (KKURLSession *)download:(NSString *)url filePath:(NSString *)filePath params:(NSDictionary *)params cookied:(BOOL)cookied ignoreCached:(BOOL)ignore progress:(KKProgress)progress complate:(KKDownloadComplateBlock)complate
{
    
    KKURLSession *downloadSession = [[KKURLSession alloc] init];
    NSMutableDictionary *cookiedParams = [self downloadWith:params cookied:cookied complate:complate];
    NSURLSessionDownloadTask *task = [KKDownloadManager download:url filePath:filePath params:cookiedParams ignoreCached:ignore progress:progress complate:complate];
    if (task) {
        [downloadSession setValue:task forKey:@"_task"];
    }
    return downloadSession;
}

#pragma mark security
+ (NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params cookied:(BOOL)enabled security:(BOOL)security success:(KKSUCCESS)success failure:(KKFAILURE)failure
{
    print(@"c--post--%@", url);
    if ([self currentNetStatus] == NotReachable) {
        if (failure) {
            NSError *err = [NSError errorWithDomain:@"localhost" code:kNonNet userInfo:nil];
            failure(err);
            [KKStarPromptBox showPromptBoxWithWords:kNetWorkError toView:nil];
        }
        return nil;
    }
    NSMutableDictionary *cookiedParams = [self requestWith:params cookied:enabled failure:failure];
    
    // 2.发送请求
    return [securityMgr POST:url parameters:cookiedParams progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSString *erroCode=[responseObject valueForKey:@"rtn"];
            [self erroCode:erroCode.integerValue response:responseObject success:success failure:failure];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        NSHTTPURLResponse *respone = (NSHTTPURLResponse *)task.response;
        if (respone.statusCode == errorServerException) {
            [self erroCode:errorServerException response:nil success:nil failure:nil];
        }
        
    }];
}


#pragma mark - other unity function
+(KKNetWorkStateType)getNetWorkStates{
    KKNetWorkStateType state = 0;
    switch ([self currentNetStatus]) {
        case NotReachable:
        {
            state = KKNetWorkStateTypeNone;
        }
            break;
        case ReachableViaWiFi:
        {
            state = KKNetWorkStateTypeWIFI;
        }
            break;
        case ReachableViaWWAN:
        {
            state = KKNetWorkStateTypeWWAN;
        }
            break;
            
        default:
            break;
    }
    //根据状态选择
    return state;
}
static KKAlertView *gloubleAlert;
+ (void)blackPrompt{
    NSString *message = @"因不当操作,已被管理员拉黑,申诉可发邮件至kk_fansmanager@kankan.com";
    gloubleAlert = [[KKAlertView alloc]init];
    gloubleAlert.message = message;
    [gloubleAlert addCancelButtonWithTitle:@"确定" block:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.54*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [gloubleAlert show];
    });
}
+ (void)bannerPrompt{
    NSString *message = @"因不当言论，已被管理员禁言，稍后自动恢复。申诉可发送邮件至kk_fansmanager@kankan.com";
    gloubleAlert = [[KKAlertView alloc]init];
    gloubleAlert.message = message;
    [gloubleAlert addCancelButtonWithTitle:@"确定" block:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.54*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [gloubleAlert show];
    });
}
- (void)loginDelegate
{
    if (self.isPost) {
        [KKHttpTool post:_url params:_param cookied:YES success:reSuccess failure:reFailure];
    }
    else
        [KKHttpTool get:_url params:_param cookied:YES success:reSuccess failure:reFailure];
    [KKHttpTool resetHttpRe];
}

-(void)loginBackByUser
{
    if (reFailure) {
        NSError *err = [NSError errorWithDomain:@"localhost" code:kNolog userInfo:nil];
        reFailure(err);
        [KKHttpTool resetHttpRe];
    }
}

+(void)knickAlertViewShowWith:(int)errorCode{
    NSNotification* notification =[NSNotification notificationWithName:KLogOutNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];//被挤掉时的通知
    NSString * errorMsg = [KKErrorTool errorWith:errorCode];
    [KKAccountManager logoutWithTips:errorMsg];
}

/**
 *  被踢掉了
 */
+(void)knickedOut{
    NSNotification* notification =[NSNotification notificationWithName:KLogOutNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];//被挤掉时的通知
    [KKAccountManager logout];
}

@end
