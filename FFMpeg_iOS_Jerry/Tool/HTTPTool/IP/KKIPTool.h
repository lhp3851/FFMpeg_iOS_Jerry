//
//  KKIPTool.h
//  FFMpeg_iOS_Jerry
//
//  Created by lhp3851 on 2018/12/6.
//  Copyright © 2018 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>
#import <ifaddrs.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKIPTool : NSObject
singleton_interface(KKIPTool)

    
//获取设备IP地址
-(NSString *)getLocalIPAddresses;
    
- (NSDictionary *)getIPAddresses;
    
-(NSString *)getIPAdddress;
    
-(NSString *)getRemoteIPAdddress;
    
@end

NS_ASSUME_NONNULL_END
