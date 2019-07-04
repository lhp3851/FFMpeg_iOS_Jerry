//
//  SessionManager.m
//  sm_ios_base
//
//  Created by sumian on 2019/5/14.
//

#import "SessionManager.h"

@interface SessionManager ()

@property (readwrite, nonatomic, strong) NSURLSession *session;
@property (readwrite, nonatomic, strong) NSOperationQueue *operationQueue;

@end



@implementation SessionManager

- (NSURLSessionConfiguration *)sessionConfiguration{
    if (!_sessionConfiguration) {
        _sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _sessionConfiguration.timeoutIntervalForRequest = 15;
        if (@available(iOS 11.0, *)) {
            _sessionConfiguration.waitsForConnectivity = true;
        } else {
            // Fallback on earlier versions
        }
    }
    return _sessionConfiguration;
}

- (NSURLSession *)session {
    @synchronized (self) {
        if (!_session) {
            _session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration delegate:self delegateQueue:self.operationQueue];
        }
    }
    return _session;
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration{
    self =  [super init];
    if (!self) {
        return nil;
    }
    
    if (!configuration) {
        configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    
    self.sessionConfiguration = configuration;
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    
    return self;
}

- (void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location {
    
}


#pragma mark NSCopying Protocol
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    if ([super init]) {
        
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [[self class] new];
}

@end
