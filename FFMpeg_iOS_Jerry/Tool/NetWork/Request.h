//
//  Request.h
//  sm_ios_base
//
//  Created by sumian on 2019/5/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Request : NSObject

@property(nonatomic,strong)NSURL *url;

@property(nonatomic,strong)NSString *urlString;

/**
 超时时间
 */
@property(nonatomic,assign)NSTimeInterval interval;

- (instancetype)initWithURL:(NSURL *)url;

- (instancetype)initWithString:(NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
