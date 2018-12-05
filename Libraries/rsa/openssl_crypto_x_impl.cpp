//
//  openssl_crypto_x.cpp
//  xlexternal
//
//  Created by lixianpeng on 14-4-18.
//  Copyright (c) 2014年 xunlei. All rights reserved.
//

#include "openssl_crypto_x_impl.h"

#include "openssl/aes.h"

namespace xlexternal {

OpenSSLCryptoAES::OpenSSLCryptoAES(void):m_pAES_KEY(NULL)
{
    
}

OpenSSLCryptoAES::~OpenSSLCryptoAES(void)
{
    if (m_pAES_KEY) {
        delete m_pAES_KEY;
        m_pAES_KEY = NULL;
    }
}

int OpenSSLCryptoAES::init(const int bits, const unsigned char * userKey, bool enc)
{
    int iret = 0;
    if (m_pAES_KEY) {
        delete m_pAES_KEY;
        m_pAES_KEY = NULL;
    }
    m_pAES_KEY = new AES_KEY;
    if (enc) {
        iret = AES_set_encrypt_key(userKey, bits, m_pAES_KEY);
    }else{
        iret = AES_set_decrypt_key(userKey, bits, m_pAES_KEY);
    }
    return iret;
}

void OpenSSLCryptoAES::encrypt(unsigned char *input, unsigned char *output)
{
    AES_ecb_encrypt(input, output, m_pAES_KEY, AES_ENCRYPT);
}

void OpenSSLCryptoAES::decrypt(unsigned char *input, unsigned char *output)
{
    AES_ecb_encrypt(input, output, m_pAES_KEY, AES_DECRYPT);
}

    
    OpenSSLCryptoSHA::OpenSSLCryptoSHA()
    {
        m_pSHA = NULL;
    }
    
    OpenSSLCryptoSHA::~OpenSSLCryptoSHA()
    {
        if (m_pSHA)
            delete m_pSHA;
        m_pSHA = NULL;
    }
    
    int OpenSSLCryptoSHA::init(const int sha)
    {
        int result = -1;
        
        if (m_pSHA)
            delete m_pSHA;
        m_pSHA = NULL;

        
        //1, 224, 256, 384, 512
        switch (sha) {
            case 1:{
                m_pSHA = new OpenSSLCryptoSHA1();
            }
                break;
            case 224:
            case 256:{
                m_pSHA = new OpenSSLCryptoSHA256();
            }
                break;
            case 384:
            case 512:{
                m_pSHA = new OpenSSLCryptoSHA512();
            }
                break;
            default:
                break;
        }
        if (m_pSHA) {
            m_pSHA->init(sha);
            result = 0;
        }
        return result;
    }
    

    int OpenSSLCryptoSHA::update(const void *data, size_t len)
    {
        if (m_pSHA) {
            return m_pSHA->update(data, len);
        }else
            return -1;
    }

    int OpenSSLCryptoSHA::final(unsigned char *md)
    {
        if (m_pSHA) {
            return m_pSHA->final(md);
        }else
            return -1;
    }
    
    OpenSSLCryptoSHA1::OpenSSLCryptoSHA1()
    {
        m_pCTX = NULL;
    }
    
    OpenSSLCryptoSHA1::~OpenSSLCryptoSHA1()
    {
        if (m_pCTX)
            delete m_pCTX;
        m_pCTX = NULL;
    }
    
    int OpenSSLCryptoSHA1::init(const int sha)
    {
        if (NULL == m_pCTX)
            m_pCTX = new SHA_CTX;
        
        return SHA1_Init(m_pCTX);
    }
    
    int OpenSSLCryptoSHA1::update(const void *data, size_t len)
    {
        return SHA1_Update(m_pCTX, data, len);
    }
    
    int OpenSSLCryptoSHA1::final(unsigned char *md)
    {
        return SHA1_Final(md, m_pCTX);
    }

    OpenSSLCryptoSHA256::OpenSSLCryptoSHA256()
    {
        m_pCTX = NULL;
    }
    
    OpenSSLCryptoSHA256::~OpenSSLCryptoSHA256()
    {
        if (m_pCTX)
            delete m_pCTX;
        m_pCTX = NULL;
    }
    
    int OpenSSLCryptoSHA256::init(const int sha)
    {
        if (NULL == m_pCTX)
            m_pCTX = new SHA256_CTX;
        return SHA256_Init(m_pCTX);
    }
    
    int OpenSSLCryptoSHA256::update(const void *data, size_t len)
    {
        return SHA256_Update(m_pCTX, data, len);
    }
    
    int OpenSSLCryptoSHA256::final(unsigned char *md)
    {
        return SHA256_Final(md, m_pCTX);
    }
    OpenSSLCryptoSHA512::OpenSSLCryptoSHA512()
    {
        m_pCTX = NULL;
    }
    
    OpenSSLCryptoSHA512::~OpenSSLCryptoSHA512()
    {
        if (m_pCTX)
            delete m_pCTX;
        m_pCTX = NULL;
    }
    
    int OpenSSLCryptoSHA512::init(const int sha)
    {
        if (NULL == m_pCTX)
            m_pCTX = new SHA512_CTX;
        
        return SHA512_Init(m_pCTX);
    }
    
    int OpenSSLCryptoSHA512::update(const void *data, size_t len)
    {
        return SHA512_Update(m_pCTX, data, len);
    }
    
    int OpenSSLCryptoSHA512::final(unsigned char *md)
    {
        return SHA512_Final(md, m_pCTX);
    }
} /* namespace xlexternal */