//
//  KKCryptTool.m
//  StarZone
//
//  Created by WS on 16/6/28.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#include <openssl/md5.h>
#include <openssl/aes.h>
#import "KKCryptTool.h"
#import "NSData+CommonCrypto.h"
#import "NSData+Base64.h"
#import "KKAccountModel.h"
#import "NSDate+Extension.h"

#define kSeparator @""
#define kProjectName @"StarZone2016"
#define kAES_Key @"wryqlaiqjkvhxwcm"

@implementation KKCryptTool

+ (NSString*)md5EncryptWithContent:(NSString*)content{
    
    const char *data = [content cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char md[16];
    NSMutableString *result = [NSMutableString stringWithCapacity:32];
    MD5((const unsigned char*)data,strlen(data),md);
    for (int i = 0; i < 16; i++){
        [result appendFormat:@"%2.2x",md[i]];
    }
    return [result copy];
    
}
+(NSString*)encryptText:(NSString*)text {
    CCCryptorStatus status = kCCSuccess;
    NSData* result = [[text dataUsingEncoding:NSUTF8StringEncoding]
                      dataEncryptedUsingAlgorithm:kCCAlgorithmAES128
                      key:kAES_Key
                      initializationVector:nil   // ECB加密不会用到iv
                      options:(kCCOptionPKCS7Padding|kCCOptionECBMode)
                      error:&status];
    if (status != kCCSuccess) {
        return nil;
    }
    
    NSString *resultStr = [result base64EncodedString];
    return resultStr;
}
+ (NSString *)aesEncryptWithContent:(NSString*)content{
    
    AES_KEY key;
    
    const char *aesKey = [kAES_Key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *data = [content cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned long len = (strlen(data)+15)/16 * 16;
    const char outData[len];
    AES_set_encrypt_key((const unsigned char *)aesKey ,128,&key);
    
    AES_ecb_encrypt((const unsigned char *)data, (unsigned char *)outData, &key, AES_ENCRYPT);
    
//    NSData *ooutData = [NSData dataWithBytes:outData length:len * sizeof(char)];
//    return [ooutData base64EncodedString];
    NSMutableString *result = [NSMutableString stringWithCapacity:16];
    for (int i = 0; i < len; i++){
        [result appendFormat:@"%2.2x",outData[i]];
    }
    return [result copy];
}


+ (NSString*)encryptWithUserId:(NSString*)userId time_stamp:(NSString*)time{
    NSString *content = [NSString stringWithFormat:@"%@%@%@%@%@",userId,kSeparator,time,kSeparator,kProjectName];
    content = [NSString stringWithFormat:@"%@_%@",[self md5EncryptWithContent:content],time];
    content = [NSString encodeToURLString:[self encryptText:content]];
    return content;
}

+ (NSString *)getEncryptCode{
    NSString *userId = [KKAccountModel sharedKKAccountModel].userId ? [KKAccountModel sharedKKAccountModel].userId : @"";
    NSString *timeStamp = [[NSDate date] timestamp];
    NSString *code = [KKCryptTool encryptWithUserId:userId time_stamp:timeStamp];
    return code;
}




@end
