//
//  openssl_cryptoimp.cpp
//  xlexternal
//
//  Created by liujincai on 14-4-8.
//  Copyright (c) 2014年 xunlei. All rights reserved.
//

#include "openssl_cryptoimp.h"

#include <stdio.h>
#include <string.h>
#include "openssl/md5.h"
#include "openssl/rsa.h"
#include "openssl/sha.h"
#include "openssl/evp.h"
#include "openssl/bio.h"
#include "openssl/ossl_typ.h"
#include "openssl/buffer.h"
#include "openssl/aes.h"
#include "xlutil_hex.h"
#include "openssl_crypto_x_impl.h"
#include "cipher.h"

namespace xlexternal {

    OpenSSLCrypto::OpenSSLCrypto(){

    }

    std::string OpenSSLCrypto::md5(const std::string& content){
        MD5_CTX c;
        MD5_Init(&c);
        unsigned char md5[17]={0};
        MD5_Update(&c, content.data(), content.length());
        MD5_Final(md5,&c);

        char hexmd5[33] = {0};
        for(int i = 0; i < 16; i++)
            ::snprintf(&hexmd5[2 * i], 3, "%02x", md5[i]);

        std::string result(hexmd5);
        return result;
    }

    std::string OpenSSLCrypto::md5(const std::string& content, bool bHex){
        MD5_CTX c;
        MD5_Init(&c);
        unsigned char md5[17]={0};
        MD5_Update(&c, content.data(), content.length());
        MD5_Final(md5,&c);

        std::string result((char*)md5, 16);

        if (bHex) {
            char hexmd5[33] = {0};
            for(int i = 0; i < 16; i++)
                ::snprintf(&hexmd5[2 * i], 3, "%02x", md5[i]);

            result.assign(hexmd5);
        }

        return result;
    }

    std::string OpenSSLCrypto::rsaEncode(const std::string& content,
                                         const std::string& hexModule){

        BIGNUM* bnM = BN_new();
        BIGNUM* bnE = BN_new();

        BN_hex2bn(&bnM, hexModule.data());
        BN_set_word(bnE, RSA_F4);

        RSA* rsa = RSA_new();
        rsa->e = bnE;
        rsa->n = bnM;

        size_t curSrcPos = 0;

        const unsigned char* srcData =(const unsigned char*) (content.c_str());
        size_t srcLen = content.size();

        int flen = RSA_size(rsa);

        unsigned char* outData = new unsigned char[flen];
        unsigned char* encData = new unsigned char[flen];
        size_t outLen = flen;
        bzero(outData, outLen);

        while(curSrcPos < srcLen ){
            int remain = srcLen - curSrcPos;
            if(remain > flen){
                remain = flen;
            }
            bzero(encData, flen);
            memcpy(encData, srcData + curSrcPos, remain);
            curSrcPos += remain;

            if(outLen < curSrcPos){
                unsigned char* outOld = outData;
                outData = new unsigned char[outLen + flen];
                bzero(outData, outLen + flen);
                memcpy(outData, outOld, outLen);

                outLen += flen;
                delete[] outOld;
            }

            int ret = RSA_public_encrypt(flen, encData,
                                     outData + outLen - flen,
                                     rsa,  RSA_NO_PADDING);
            if ( ret < 0 ){
                outData[0] = '\0';
                outLen = 0;
                break;
            }
        }

        std::string result(xlcommon::XlUtilHex::convertBytesToHex((unsigned char*)outData, outLen));

        delete[] outData;
        delete[] encData;

        BN_free(bnE);
        BN_free(bnM);

        rsa->n = NULL;
        rsa->e = NULL;

        RSA_free(rsa);

        return result;
    }
    
    std::string OpenSSLCrypto::sha1(const std::string &content){
        unsigned char *shad = new unsigned char[SHA_DIGEST_LENGTH];
        SHA1((const unsigned char *)content.c_str(), content.length(),shad);
        std::string result = "";
        int i;
        for (i = 0; i < SHA_DIGEST_LENGTH; i++)
        {
            char buf[10];
            snprintf(buf, sizeof(buf), "%02x", shad[i]);
            result += buf;
        }
        delete []shad;
        return result;
    }

    void OpenSSLCrypto::base64(const std::string &content,std::string &base64Content)
    {
        BIO * bio, *b64;
        BUF_MEM *bptr;
        b64 = BIO_new(BIO_f_base64());
        bio = BIO_new(BIO_s_mem());
        b64 = BIO_push(b64, bio);//将bio加到b64的后面, 返回b64,其实BIO_push的作用是将bio加到链条的尾部

        BIO_write(b64, content.data(), content.size());
        BIO_flush(b64);
        BIO_get_mem_ptr(b64, &bptr); //会将BIO_C_GET_BUF_MEM_PTR操作传递给bio

        char *base64_buf = (char *)malloc(bptr->length+2);
        if (base64_buf == NULL)
            return;
        memcpy(base64_buf, bptr->data, bptr->length);
        base64_buf[bptr->length] = '\0';
        base64Content.assign(base64_buf);
        free(base64_buf);
        BIO_free_all(b64);
    }

    std::string OpenSSLCrypto::decodeBase64(const std::string &base64Content){
        BIO * b64 = NULL;
        BIO * bmem = NULL;
        int length = base64Content.size();
        char * input = (char*)base64Content.data();
        char * buffer = (char *)malloc(length+1);
        memset(buffer, 0, length+1);

        b64 = BIO_new(BIO_f_base64());
        BIO_set_flags(b64, BIO_FLAGS_BASE64_NO_NL);

        bmem = BIO_new_mem_buf(input, length);
        bmem = BIO_push(b64, bmem);
        int outlen = BIO_read(bmem, buffer, length);
        std::string content;
        BIO_free_all(b64);
        content.assign(buffer, outlen);
        free(buffer);
        return content;
    }

    const std::string salt = "12345678";

    std::string OpenSSLCrypto::encodeAES( const std::string& password, const std::string& data ) {

        Cipher cipher;
        std::string ciphertext = cipher.encrypt(data, password, salt);
        return ciphertext;
    }

    std::string OpenSSLCrypto::decodeAES( const std::string& password, const std::string& strData )
    {
        Cipher cipher;
        std::string decoded = cipher.decrypt(strData, password, salt);
        return decoded;
    }


    std::string OpenSSLCrypto::aesDecrypt(const unsigned char *key, int bits, const std::string &data){
        AES_KEY aesKey;
        AES_set_decrypt_key(key, bits, &aesKey);

        if ( data.size() % AES_BLOCK_SIZE != 0 ){
            //@todo error
            return "";
        }
        int nInLen = (int)data.size();
        unsigned char* pCurInData = (unsigned char*)data.data();
        int nDecryptedLen = 0;
        unsigned char* decryptedBuffer = new unsigned char[nInLen+1];
        memset(decryptedBuffer, 0, nInLen+1);
        unsigned char* pCurOutData = decryptedBuffer;
        while ( nDecryptedLen < nInLen ){
            AES_decrypt(pCurInData, pCurOutData, &aesKey);
            nDecryptedLen += AES_BLOCK_SIZE;
            pCurInData += AES_BLOCK_SIZE;
            pCurOutData += AES_BLOCK_SIZE;
        }

        //padding
        unsigned char padval = *(pCurOutData-1);
        memset(pCurOutData-padval, 0, padval);
        nDecryptedLen -= padval;

        std::string res;
        res.assign((char*)decryptedBuffer, nDecryptedLen);
        delete[] decryptedBuffer;
        return res;
    }

    std::string OpenSSLCrypto::aesEncrypt(const unsigned char *key, int bits, const std::string &data){
        AES_KEY aesKey;
        AES_set_encrypt_key(key, bits, &aesKey);
        int nEncdedLen = 0;
        unsigned char* pCurInData = (unsigned char*)data.data();
        int nInLen = (int)data.length();
        unsigned char aesBuf[16];
        unsigned char* encryptedBuffer = new unsigned char[nInLen+16+1];
        memset(encryptedBuffer, 0, nInLen+16+1);
        unsigned char* pCurOutData = encryptedBuffer;
        int remain = 0;
        while ( nEncdedLen < nInLen ){
            remain = nInLen - nEncdedLen;
            if ( remain < AES_BLOCK_SIZE ){
                memcpy(aesBuf, pCurInData, remain);
                unsigned char padval = AES_BLOCK_SIZE - remain;
                memset(aesBuf+remain, padval, AES_BLOCK_SIZE - remain);
            }else{
                memcpy(aesBuf, pCurInData, AES_BLOCK_SIZE);
            }
            AES_encrypt(aesBuf, pCurOutData, &aesKey);
            nEncdedLen += AES_BLOCK_SIZE;
            pCurInData += AES_BLOCK_SIZE;
            pCurOutData += AES_BLOCK_SIZE;
        }
        if ( remain == AES_BLOCK_SIZE ){
            memset(aesBuf, AES_BLOCK_SIZE, AES_BLOCK_SIZE);
            AES_encrypt(aesBuf, pCurOutData, &aesKey);
            nEncdedLen += AES_BLOCK_SIZE;
        }
        std::string ret;
        ret.assign((char*)encryptedBuffer, nEncdedLen);
        delete [] encryptedBuffer;

        return ret;
    }
}
