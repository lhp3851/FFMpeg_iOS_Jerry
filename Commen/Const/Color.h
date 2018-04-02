//
//  Color.h
//  FFMpeg_iOS_Jerry
//
//  Created by Jerry on 30/03/2018.
//  Copyright © 2018 Jerry. All rights reserved.
//

#ifndef Color_h
#define Color_h

//十六进制颜色宏 参数格式为：0xFFFFFF，建议少用，一般颜色在下面都有相应的宏代表
#define RGBHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

#define RGBAlphaHex(rgbValue,alha) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:alha]
//参数格式为：222,222,222
#define RGB(r, g, b)    [UIColor colorWithRed:(r) / 255.f green:(g) / 255.f blue:(b) / 255.f alpha:1.f]
#define RGBa(r, g, b,a) [UIColor colorWithRed:(r) / 255.f green:(g) / 255.f blue:(b) / 255.f alpha:a]


#endif /* Color_h */
