//
//  hex_util.h
//  xlcommon
//
//  Created by liujincai on 14-4-8.
//  Copyright (c) 2014年 xunlei. All rights reserved.
//

#ifndef xlcommon_hex_util_h
#define xlcommon_hex_util_h

#include <string>

namespace xlcommon {
    
    
    class XlUtilHex{
    public:
        /**
         将byte转换成十六进制字符串
         */
        static std::string convertBytesToHex(unsigned char* data, int len);
    };
    
}

#endif
