//
//  openssl_cryptoimp.h
//  xlexternal
//
//  Created by liujincai on 14-4-8.
//  Copyright (c) 2014年 xunlei. All rights reserved.
//

#ifndef __xlexternal__openssl_cryptoimp__
#define __xlexternal__openssl_cryptoimp__

#include "xlcrypto.h"

namespace xlexternal {
    
    class OpenSSLCryptoAES;
    
    class OpenSSLCrypto : public XlCrypto{
    public:
        OpenSSLCrypto();
        
        /**
         @override
         */
        std::string md5(const std::string& content);
        
        /**
         @override
         */
        std::string md5(const std::string& content, bool bHex);
        
        /**
         @override
         */
        std::string rsaEncode(const std::string& content,
                              const std::string& hexModule);
        /**
         @override
         */
        std::string sha1(const std::string &content);
        /**
         @override
         */
        void base64(const std::string &content,std::string &base64Content);
        /**
         *@override
         */
        std::string decodeBase64(const std::string &base64Content);
        
        /**
         * 加密数据，返回加密后的密文数据
         */
        std::string encodeAES( const std::string& password, const std::string& data );
        /**
         * 解密数据，返回解密后的原文数据
         */
        std::string decodeAES( const std::string& password, const std::string& strData );
        
        /**
         * @override
         */
        std::string aesEncrypt( const unsigned char * key, int bits,
                               const std::string& data );
        
        std::string aesDecrypt( const unsigned char * key, int bits,
                               const std::string& data );
        
    private:        
      
        
        
    };
    
}

#endif /* defined(__xlexternal__openssl_cryptoimp__) */
