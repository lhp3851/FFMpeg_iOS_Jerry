//
//  KKIPTool.m
//  FFMpeg_iOS_Jerry
//
//  Created by lhp3851 on 2018/12/6.
//  Copyright © 2018 Jerry. All rights reserved.
//

#import "KKIPTool.h"
#include <string.h>


#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation KKIPTool
singleton_implementation(KKIPTool)

//获取设备IP地址
-(NSString *)getLocalIPAddresses
    {
        int sockfd = socket(AF_INET,SOCK_DGRAM, 0);
        
        if (sockfd < 0) return nil;
        
        NSMutableArray *ips = [NSMutableArray array];
        
        int BUFFERSIZE =4096;
        
        struct ifconf ifc;
        
        char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
        
        struct ifreq *ifr, ifrcopy;
        
        ifc.ifc_len = BUFFERSIZE;
        
        ifc.ifc_buf = buffer;
        
        if (ioctl(sockfd,SIOCGIFADDR, &ifc) >= 0){
            
            for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
                
                ifr = (struct ifreq *)ptr;
                
                int len =sizeof(struct sockaddr);
                
                if (ifr->ifr_addr.sa_len > len) {
                    len = ifr->ifr_addr.sa_len;
                }
                
                ptr += sizeof(ifr->ifr_name) + len;
                
                if (ifr->ifr_addr.sa_family !=AF_INET) continue;
                
                if ((cptr = (char *)strchr(ifr->ifr_name,':')) != NULL) *cptr =0;
                
                if (strncmp(lastname, ifr->ifr_name,IFNAMSIZ) == 0)continue;
                
                memcpy(lastname, ifr->ifr_name,IFNAMSIZ);
                
                ifrcopy = *ifr;
                
                ioctl(sockfd,SIOCGIFFLAGS, &ifrcopy);
                
                if ((ifrcopy.ifr_flags &IFF_UP) == 0)continue;
                
                printf("网络名称：%s，地址：%s\n",ifr->ifr_name,inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr));
                
                if (strncmp(ifr->ifr_name,"en0",16) == 0) {
                    
                    NSString *ip = [NSString stringWithFormat:@"%s",inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
                    
                    [ips addObject:ip];
                }
                
            }
        }
        close(sockfd);
        
        return ips.lastObject;
    }

    //获取所有相关IP信息
- (NSDictionary *)getIPAddresses
    {
        NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
        
        // retrieve the current interfaces - returns 0 on success
        struct ifaddrs *interfaces;
        if(!getifaddrs(&interfaces)) {
            // Loop through linked list of interfaces
            struct ifaddrs *interface;
            for(interface=interfaces; interface; interface=interface->ifa_next) {
                if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                    continue; // deeply nested code harder to read
                }
                const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
                char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
                if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                    NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                    NSString *type;
                    if(addr->sin_family == AF_INET) {
                        if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                            type = IP_ADDR_IPv4;
                        }
                    } else {
                        const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                        if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                            type = IP_ADDR_IPv6;
                        }
                    }
                    if(type) {
                        NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                        addresses[key] = [NSString stringWithUTF8String:addrBuf];
                    }
                }
            }
            // Free memory
            freeifaddrs(interfaces);
        }
        return [addresses count] ? addresses : nil;
    }
    
    
-(NSString *)getIPAdddress{
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://ifconfig.me/ip"];
    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    return ip;
}
    
-(NSString *)getRemoteIPAdddress{
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://ipof.in/json"];
    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    return ip;
}
    
@end
