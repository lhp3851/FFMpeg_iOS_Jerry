//
//  hex_util.cpp
//  xlcommon
//
//  Created by liujincai on 14-4-8.
//  Copyright (c) 2014年 xunlei. All rights reserved.
//

#include "xlutil_hex.h"

namespace xlcommon {
    
    static const char HEX_CHARS[] = {
        '0', '1', '2', '3', '4', '5', '6', '7',
        '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
    
    std::string XlUtilHex::convertBytesToHex(unsigned char *data, int len){
        
        if ( len <= 0 || data == NULL ){
            return "";
        }
        
        std::string result;
        for ( int i = 0; i < len; i++){
            int high = (data[i] & 0xF0) >> 4;
            int low = data[i] & 0xF;
            result.append(1, HEX_CHARS[high]);
            result.append(1, HEX_CHARS[low]);
        }
        
        return result;
        
    }
}