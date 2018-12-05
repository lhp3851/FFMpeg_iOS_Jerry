//
//  xlcrypto.h
//  xlexternal
//
//  Created by liujincai on 14-4-8.
//  Copyright (c) 2014年 xunlei. All rights reserved.
//

#ifndef xlexternal_xlcrypto_h
#define xlexternal_xlcrypto_h

#include <string>

namespace xlexternal {
    
    class XlCrypto{
    public:
        
        virtual ~XlCrypto(){}
        
        /**
         * md5
         * @param content 要进行MD5的数据.
         * @param 返回MD5后的熵(十六进制的字符串).
         */
        virtual std::string md5(const std::string& content) = 0;
        
        /**
         * md5
         * @param content 要进行MD5的数据.
         * @param bHex 结果是否转成十六进制字符串.
         * @param 返回MD5后的熵(16字节的二进制数据/32字节的十六进制的字符串).
         */
        virtual std::string md5(const std::string& content, bool bHex) = 0;
        
        virtual std::string rsaEncode(const std::string& content,
                                      const std::string& hexModule) = 0;
        /**
         * SHA1
         * @param content 要进行SHA1的数据.
         */
        virtual std::string sha1(const std::string &content) = 0;
        
        /**
         * base64
         * @param content 要进行base64的数据.
         * @param base64Content 进行base64后的数据；
         */
        virtual void base64(const std::string &content,std::string &base64Content) = 0;
        
        /**
         * decodebase64
         * @param base64Content base64数据.
         * @return decodebase64后的数据；
         */
        virtual std::string decodeBase64(const std::string &base64Content) = 0;
        
        /**
         * 加密数据，返回加密后的密文数据, 其实不是aes, aes256+base64
         */
        virtual std::string encodeAES( const std::string& password, const std::string& data ) = 0;
        /**
         * 解密数据，返回解密后的原文数据 其实不是aes, aes256+base64
         */
        virtual std::string decodeAES( const std::string& password, const std::string& strData ) = 0;
        
        
        /**
         * @param bits 密钥的长度(128, 192, 256 bits)
         * @param userKey 密钥(128, 192, 256 bits 对应userKey的字节分别16，24，32)
         * aes default padding 加密，返回加密后的密文数据
         */
        virtual std::string aesEncrypt( const unsigned char * key, int bits,
                                       const std::string& data ) = 0;
        
        /**
         * @param bits 密钥的长度(128, 192, 256 bits)
         * @param userKey 密钥(128, 192, 256 bits 对应userKey的字节分别16，24，32)
         * aes default padding 解密
         */
        virtual std::string aesDecrypt( const unsigned char * key, int bits,
                                       const std::string& data ) = 0;
    
    };
    
    class XlCryptoAES
    {
    public:
        virtual ~XlCryptoAES(){}
        
        /**
         * 设置密钥并初始化AES加解密器
         * @param bits 密钥的长度(128, 192, 256 bits)
         * @param userKey 密钥(128, 192, 256 bits 对应userKey的字节分别16，24，32)
         * @param enc 是否为加密
         */
        virtual int     init(const int bits, const unsigned char * userKey, bool enc) = 0;
        
        /**
         * 加密数据块
         * @param input 输入数据块，必须为16字节长度
         * @param output 输入数据块,必须为16字节长度
         */
        virtual void    encrypt(unsigned char *input, unsigned char *output) = 0;
        
        /**
         * 解密数据块
         * @param input 输入数据块，必须为16字节长度
         * @param output 输入数据块,必须为16字节长度
         */
        virtual void    decrypt(unsigned char *input, unsigned char *output) = 0;
    };
    
    class XlCryptoSHA
    {
    public:
        virtual ~XlCryptoSHA(){}
        
        /**
         * 初始化SHA
         * @param sha 算法类型(1, 224, 256, 384, 512)
         */
        virtual int     init(const int sha) = 0;
        
        /**
         * SHA计算过程
         * @param data 数据
         * @param len 数据长度
         */
        virtual int    update(const void *data, size_t len) = 0;
        
        /**
         * SHA计算结果输出
         * @param md 熵
         */
        virtual int    final(unsigned char *md) = 0;
    };
}

#endif
