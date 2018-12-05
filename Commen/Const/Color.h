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



#define KKCLEAR_COLOR              [UIColor clearColor]//透明色
#define kDEEP_COLOR                RGBHex(0xf5f4f9) //深色背景
#define kBACKGROUND_COLOR          RGBHex(0xffffff) //白色背景
#define kNORMAL_TEXT_COLOR         RGBHex(0x333336) //标题栏文字、正文标题、正文文本、评论、个人资料一些设置、登录界面等
#define kSMALL_TEXT_COLOR          [RGBHex(0x333336) colorWithAlphaComponent:0.5] //时间、查看数、粉丝数、点赞数颜色
#define kTEXT_VIEW_TEXT_COLOR       [RGBHex(0x333336) colorWithAlphaComponent:0.4] //textView 文字颜色
#define kSELETED_COLOR              RGBHex(0xf74d4d) //被选中颜色
#define kNORMAL_COLOR               RGBHex(0xffd00c) //普通button的颜色
#define kHILIGHT_COLOR              RGBHex(0xfbc300) //高亮button的颜色

#endif /* Color_h */
