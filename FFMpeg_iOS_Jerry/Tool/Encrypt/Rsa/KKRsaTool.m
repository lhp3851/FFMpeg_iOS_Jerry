//
//  KKRsaTool.m
//  StarZone
//
//  Created by WS on 16/6/28.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import "KKRsaTool.h"
#import "OpenSSLRSAWrapper.h"

@implementation KKRsaTool


- (void)encryptAndDecryptTest{
    
    OpenSSLRSAWrapper *wrapper = [OpenSSLRSAWrapper shareInstance];
    [wrapper generateRSAKeyPairWithKeySize:1024];
    [wrapper exportRSAKeys];
    
    NSString *pub_key = wrapper.publicKeyBase64;
    NSString *private_key = wrapper.privateKeyBase64;
    NSString *plainText = @"OpenSSLRSAWrapper+is+simple+and+useful.";
    NSData *encryptData = [wrapper encryptRSAKeyWithType:KeyTypePublic paddingType:RSA_PADDING_TYPE_PKCS1 plainText:plainText usingEncoding:NSUTF8StringEncoding];
    unsigned long flen = encryptData.length;
    unsigned char from[flen];
    bzero(from, sizeof(from));
    memcpy(from, [encryptData bytes], [encryptData length]);
    
    NSString *encryptText = [self convertBytesToHexWithData:from len:flen];
    NSString *decryptString = [wrapper decryptRSAKeyWithType:KeyTypePrivate paddingType:RSA_PADDING_TYPE_PKCS1 plainTextData:encryptData usingEncoding:NSUTF8StringEncoding];
    NSLog(@"pub_key:%@ \n private_key:%@ \n plainText:%@ \n decryptPlainText:%@ \n encryptText:%@",pub_key,private_key,plainText,decryptString,encryptText);
}

- (NSString*)encryptWithContent:(NSString*)content{
    OpenSSLRSAWrapper *wrapper = [OpenSSLRSAWrapper shareInstance];
    [wrapper importRSAKeyWithType:KeyTypePublic];
    NSData *encryptData = [[OpenSSLRSAWrapper shareInstance] encryptRSAKeyWithType:KeyTypePublic paddingType:RSA_PADDING_TYPE_PKCS1 plainText:content usingEncoding:NSUTF8StringEncoding];
    unsigned long flen = encryptData.length;
    unsigned char from[flen];
    bzero(from, sizeof(from));
    memcpy(from, [encryptData bytes], [encryptData length]);
    
   return [self convertBytesToHexWithData:from len:flen];

}



- (NSString*)convertBytesToHexWithData:(unsigned char *)data len:(unsigned long)len{
    
    static const char HEX_CHARS[] = {
        '0', '1', '2', '3', '4', '5', '6', '7',
        '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
    
    
    if ( len <= 0 || data == NULL ){
        return @"";
    }
    
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    for ( int i = 0; i < len; i++){
        int high = (data[i] & 0xF0) >> 4;
        int low = data[i] & 0xF;
        [result appendFormat:@"%c%c",HEX_CHARS[high],HEX_CHARS[low]];
    }
    
    return result;
}


@end
