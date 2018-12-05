//
//  KKErrorTool.h
//  FFMpeg_iOS_Jerry
//
//  Created by lhp3851 on 2018/12/4.
//  Copyright © 2018 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    errorSuccessed,             //操作成功
    errorFaild,                 //操作失败
    errorServerException,       //服务器内部错误
    errorParamIllegal,          //参数不合法
    errorAccountNotExist,       //用户不存在
} KKErrorStatusCode;



@interface KKErrorTool : NSError

+ (NSString *) errorWith:(KKErrorStatusCode)code;

@end

NS_ASSUME_NONNULL_END
