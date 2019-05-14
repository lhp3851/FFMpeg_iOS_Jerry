//
//  KKHttpTool.h


#import <Foundation/Foundation.h>
#import "kkuReachability/KKUReachability.h"
#import "AFNetworking.h"
#import "KKErrorTool.h"


#define kSeesionF 11
#define kNolog 800
#define kNonNet -1009

typedef NS_ENUM(NSInteger ,KKNetWorkStateType) {
    KKNetWorkStateTypeNone = 0,
    KKNetWorkStateTypeWIFI,
    KKNetWorkStateTypeWWAN,
};

typedef enum {
    KKPostParamTypeHttp,
    KKPostParamTypeJson,
    KKPostParamTypeJsonZip
} KKPostParamType;

typedef enum {
    KKHttpRequestMethodPOST,
    KKHttpRequestMethodGET
} KKHttpRequestMethod;

static NSString *KKHttpToolNetWorkStatusDisconnect = @"Disconnect";
static NSString *KKHttpToolNetWorkStatusWiFi = @"WiFi";
static NSString *KKHttpToolNetWorkStatusWWAN = @"WWAN";
//#import "AppDelegate.h"
typedef void (^KKSUCCESS)(id object);
typedef void (^KKFAILURE)(NSError *error);
typedef void (^KKProgress) (NSProgress *progress);
typedef void (^KKDownloadComplateBlock) (NSString *filePath, BOOL success, NSError *error, BOOL update);//filepath, success, error if failure ,update
@interface KKURLSession : NSObject
- (void)cancel;
- (void)suspend;
- (void)resume;
@end


@interface KKHttpTool : NSObject
/**
 *  @brief 设置请求头
 *
 *  @param fileds 字段
 */
+ (void)setHttpRequestHeaderFields:(NSDictionary *)fileds security:(BOOL)security;
/**
 *  @brief 清除自定义header
 *
 *  @param keys
 *  @param security
 */
+ (void)clearCustomRequestHeaderWithKeys:(NSArray *)keys security:(BOOL)security;
/********网络请求类******/
/**
 *  get请求
 *
 *  @param url     请求地址
 *  @param params  请求参数
 *  @param success 请求成功
 *  @param failure 请求失败
 */
+ (NSURLSessionDataTask *)get:(NSString *)url
                       params:(NSDictionary *)params
                      success:(KKSUCCESS)success
                      failure:(KKFAILURE)failure;
/**
 *  get请求--带cookie
 *
 *  @param url     请求地址
 *  @param params  请求参数
 *  @param success 请求成功
 *  @param failure 请求失败
 *  @param enabled 是否使用cookied
 */
+ (NSURLSessionDataTask *)get:(NSString *)url
                       params:(NSDictionary *)params
                      cookied:(BOOL)enabled
                      success:(KKSUCCESS)success
                      failure:(KKFAILURE)failure;
/**
 *  @author Sail
 *
 *  @brief
 *
 *  @param url
 *  @param params
 *  @param enabled
 *  @param cachePolicy 缓存策略，需要服务器支持，其它不带此参数的接口默认为NSURLRequestUseProtocolCachePolicy
 *  @param success
 *  @param failure
 *
 *  @return
 */
+ (NSURLSessionDataTask *)get:(NSString *)url
                       params:(NSDictionary *)params
                      cookied:(BOOL)enabled
                  cachePolicy:(NSURLRequestCachePolicy)cachePolicy
                      success:(KKSUCCESS)success
                      failure:(KKFAILURE)failure;

/**
 *  post请求
 *
 *  @param url     请求地址
 *  @param params  请求参数
 *  @param success 请求成功
 *  @param failure 请求失败
 */
+ (NSURLSessionDataTask *)post:(NSString *)url
                        params:(NSDictionary *)params
                       success:(KKSUCCESS)success
                       failure:(KKFAILURE)failure;
/**
 *  @author Sail
 *
 *  @brief post请求
 *
 *  @param url
 *  @param type    参数封装类型
 *  @param params
 *  @param success
 *  @param failure
 *
 *  @return
 */
+ (NSURLSessionDataTask *)post:(NSString *)url
                     paramType:(KKPostParamType)type
                        params:(NSDictionary *)params
                       success:(KKSUCCESS)success
                       failure:(KKFAILURE)failure;
/**
 *  post请求--带cookie
 *
 *  @param url     请求地址
 *  @param params  请求参数
 *  @param success 请求成功
 *  @param failure 请求失败
 *  @param enabled 是否使用cookied
 */
+ (NSURLSessionDataTask *)post:(NSString *)url
                        params:(NSDictionary *)params
                       cookied:(BOOL)enabled
                       success:(KKSUCCESS)success
                       failure:(KKFAILURE)failure;

+ (NSURLSessionDataTask *)post:(NSString *)url
                        params:(NSDictionary *)params
                       cookied:(BOOL)enabled
                   cachePolicy:(NSURLRequestCachePolicy)cachePolicy
                       success:(KKSUCCESS)success
                       failure:(KKFAILURE)failure;
/**
 *  @author Sail
 *
 *  @brief post请求--带cookie
 *
 *  @param url
 *  @param type    参数封装类型
 *  @param params
 *  @param enabled
 *  @param success
 *  @param failure
 *
 *  @return
 */
+ (NSURLSessionDataTask *)post:(NSString *)url
                     paramType:(KKPostParamType)type
                        params:(NSDictionary *)params
                       cookied:(BOOL)enabled
                       success:(KKSUCCESS)success
                       failure:(KKFAILURE)failure;
/**
 *  @author Sail
 *
 *  @brief post请求--带cookie
 *
 *  @param url
 *  @param type    参数封装类型
 *  @param params
 *  @param enabled
 *  @param cachePolicy  缓存策略，需要服务器支持，其它不带此参数的接口默认为NSURLRequestUseProtocolCachePolicy
 *  @param success
 *  @param failure
 *
 *  @return
 */
+ (NSURLSessionDataTask *)post:(NSString *)url
                     paramType:(KKPostParamType)type
                        params:(NSDictionary *)params
                       cookied:(BOOL)enabled
                   cachePolicy:(NSURLRequestCachePolicy)cachePolicy
                       success:(KKSUCCESS)success
                       failure:(KKFAILURE)failure;

/**
 *  post请求--带cookie, https
 *
 *  @param url     请求地址
 *  @param params  请求参数
 *  @param success 请求成功
 *  @param failure 请求失败
 *  @param enabled 是否使用cookied
 *  @param security 是否使用https
 */
+ (NSURLSessionDataTask *)post:(NSString *)url
                        params:(NSDictionary *)params
                       cookied:(BOOL)enabled
                      security:(BOOL)security
                       success:(KKSUCCESS)success
                       failure:(KKFAILURE)failure;
/*********文件上传类***********/
/**
 *  @author Sail
 *
 *  @brief 上传文件，小文件，不分片上传
 *
 *  @param url
 *  @param params
 *  @param data  数据
 *  @param fileName
 *  @param name
 *  @param mimeType
 *  @param success
 *  @param failure
 *
 *  @return
 */
+ (NSURLSessionDataTask *)post:(NSString *)url
                        params:(NSDictionary *)params
                         data:(NSData *)data
                      fileName:(NSString *)fileName
                          name:(NSString *)name
                      mimeType:(NSString *)mimeType
                       success:(KKSUCCESS)success
                       failure:(KKFAILURE)failure;


+ (NSURLSessionDataTask *)post:(NSString *)url
                        params:(NSDictionary *)params
                          data:(NSData *)data
                      fileName:(NSString *)fileName
                          name:(NSString *)name
                      mimeType:(NSString *)mimeType
                      progress:(KKProgress)progress
                       success:(KKSUCCESS)success
                       failure:(KKFAILURE)failure;
/**
 *  @author Sail
 *
 *  @brief 上传图片
 *
 *  @param url
 *  @param params
 *  @param image
 *  @param success
 *  @param failure
 *
 *  @return
 */
+ (NSURLSessionDataTask *)post:(NSString *)url
                        params:(NSDictionary *)params
                         image:(UIImage *)image
                       success:(KKSUCCESS)success
                       failure:(KKFAILURE)failure;

+ (NSURLSessionDataTask *)post:(NSString *)url
                        params:(NSDictionary *)params
                         image:(UIImage *)image
                      progress:(KKProgress)progress
                       success:(KKSUCCESS)success
                       failure:(KKFAILURE)failure;

+ (NSURLSessionDataTask *)post:(NSString *)url
                         video:(NSObject *)videoFile
                ignoreUploaded:(BOOL)ignore
                      progress:(KKProgress)progress
                       success:(KKSUCCESS)success
                       failure:(KKFAILURE)failure;


/************下载文件****************/
/**
 *  @author Sail
 *
 *  @brief 下载文件
 *
 *  @param url
 *  @param filePath 文件完整目录，如果不传，则为默认的缓存目录
 *  @param params
 *  @param cookied
 *  @param ignore   是否忽略缓存
 *  @param progress 进度，在子线程，如需刷UI，自行回主线程
 *  @param complate 完成的block
 *
 *  @return 下载任务
 */
+ (KKURLSession *)download:(NSString *)url
                  filePath:(NSString *)filePath
                    params:(NSDictionary *)params
                   cookied:(BOOL)cookied
              ignoreCached:(BOOL)ignore
                  progress:(KKProgress)progress
                  complate:(KKDownloadComplateBlock)complate;
/************其它方法****************/
/**
 *  当前的网络状态
 *
 *  @return 网络状态
 */
+ (KKNetworkStatus)currentNetStatus;
+ (KKUReachability *)sharedReachability;
+ (void)resetHttpRe;

/**
 *  获取当前网路状态
 *
 *  @return 当前网络状态
 */
+(KKNetWorkStateType)getNetWorkStates;

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSDictionary *param;
@property (nonatomic, assign, getter=isPost) BOOL post;
@end
