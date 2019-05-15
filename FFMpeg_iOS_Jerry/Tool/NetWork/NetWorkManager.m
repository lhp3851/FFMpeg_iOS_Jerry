//
//  NetWorkManager.m
//  FBSnapshotTestCase
//
//  Created by sumian on 2019/5/14.
//

#import "NetWorkManager.h"

@implementation NetWorkManager

+ (instancetype)shareInstance{
    static NetWorkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [NetWorkManager new];
    });
    return manager;
}

@end
