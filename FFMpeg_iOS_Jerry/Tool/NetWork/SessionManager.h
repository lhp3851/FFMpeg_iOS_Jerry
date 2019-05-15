//
//  SessionManager.h
//  sm_ios_base
//
//  Created by sumian on 2019/5/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SessionManager : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate, NSSecureCoding, NSCopying>

/**
 The session configuration.
 */
@property (readwrite, nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;

- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration;

@end

NS_ASSUME_NONNULL_END
