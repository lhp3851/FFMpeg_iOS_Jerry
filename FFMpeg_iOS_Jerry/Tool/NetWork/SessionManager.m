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

@end
