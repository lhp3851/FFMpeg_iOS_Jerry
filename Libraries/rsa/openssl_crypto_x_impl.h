//
//  openssl_crypto_x.h
//  xlexternal
//
//  Created by lixianpeng on 14-4-18.
//  Copyright (c) 2014年 xunlei. All rights reserved.
//

#ifndef __openssl_crypto_x_impl__
#define __openssl_crypto_x_impl__

#include "xlcrypto.h"

#include "openssl/aes.h"
#include "openssl/sha.h"

namespace xlexternal {
    
class OpenSSLCryptoAES : public XlCryptoAES
{
public:
    OpenSSLCryptoAES(void);
    virtual ~OpenSSLCryptoAES(void);
    
    /**
     * @override
     * 设置密钥并初始化AES加解密器
     * @param bits 密钥的长度(128, 192, 256 bits)
     * @param userKey 密钥(128, 192, 256 bits 对应userKey的字节分别16，24，32)
     * @param enc 是否为加密
     */
    int init(const int bits, const unsigned char * userKey, bool enc);
    
    /**
     * @override
     * 加密数据块
     * @param input 输入数据块，必须为16字节长度
     * @param output 输入数据块,必须为16字节长度
     */
    void encrypt(unsigned char *input, unsigned char *output);
    
    /**
     * @override
     * 解密数据块
     * @param input 输入数据块，必须为16字节长度
     * @param output 输入数据块,必须为16字节长度
     */
    void decrypt(unsigned char *input, unsigned char *output);
    
    /**
     * 加密数据，返回加密后的密文数据
     */
    std::string encodeAES( const std::string& password, const std::string& data );
    /**
     * 解密数据，返回解密后的原文数据
     */
    std::string decodeAES( const std::string& password, const std::string& strData );
    
private:
    AES_KEY* m_pAES_KEY;
};
    
    
    class OpenSSLCryptoSHA : public XlCryptoSHA
    {
    public:
        OpenSSLCryptoSHA();
        virtual ~OpenSSLCryptoSHA();
        
        /**
         * 初始化SHA
         * @param sha 算法类型(1, 224, 256, 384, 512)
         */
        virtual int     init(const int sha);
        
        /**
         * SHA计算过程
         * @param data 数据
         * @param len 数据长度
         */
        virtual int    update(const void *data, size_t len);
        
        /**
         * SHA计算结果输出
         * @param md 熵
         */
        virtual int    final(unsigned char *md);
        
    private:
        XlCryptoSHA*   m_pSHA;
    };
    
    class OpenSSLCryptoSHA1 : public XlCryptoSHA
    {
    public:
        OpenSSLCryptoSHA1();
        virtual ~OpenSSLCryptoSHA1();
        
        /**
         * 初始化SHA
         * @param sha 算法类型(1, 224, 256, 384, 512)
         */
        virtual int     init(const int sha);
        
        /**
         * SHA计算过程
         * @param data 数据
         * @param len 数据长度
         */
        virtual int    update(const void *data, size_t len);
        
        /**
         * SHA计算结果输出
         * @param md 熵
         */
        virtual int    final(unsigned char *md);
        
    private:
        SHA_CTX*    m_pCTX;
    };
    
    class OpenSSLCryptoSHA256 : public XlCryptoSHA
    {
    public:
        OpenSSLCryptoSHA256();
        virtual ~OpenSSLCryptoSHA256();
        
        /**
         * 初始化SHA
         * @param sha 算法类型(1, 224, 256, 384, 512)
         */
        virtual int     init(const int sha);
        
        /**
         * SHA计算过程
         * @param data 数据
         * @param len 数据长度
         */
        virtual int    update(const void *data, size_t len);
        
        /**
         * SHA计算结果输出
         * @param md 熵
         */
        virtual int    final(unsigned char *md);
        
    protected:
        SHA256_CTX*    m_pCTX;
    };
    
    class OpenSSLCryptoSHA512 : public XlCryptoSHA
    {
    public:
        OpenSSLCryptoSHA512();
        virtual ~OpenSSLCryptoSHA512();
        
        /**
         * 初始化SHA
         * @param sha 算法类型(1, 224, 256, 384, 512)
         */
        virtual int     init(const int sha);
        
        /**
         * SHA计算过程
         * @param data 数据
         * @param len 数据长度
         */
        virtual int    update(const void *data, size_t len);
        
        /**
         * SHA计算结果输出
         * @param md 熵
         */
        virtual int    final(unsigned char *md);
        
    protected:
        SHA512_CTX*    m_pCTX;
    };
    
} /* namespace xlexternal */

#endif /* defined(openssl_crypto_x_impl__h) */
