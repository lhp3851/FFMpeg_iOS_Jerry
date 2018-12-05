//
//  KKAccountModel.h
//  FFMpeg_iOS_Jerry
//
//  Created by lhp3851 on 2018/12/4.
//  Copyright © 2018 Jerry. All rights reserved.
//

#import "KKBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKAccountModel : KKBaseModel
singleton_interface(KKAccountModel);

//用户ID
@property (nonatomic,strong) NSString *userId;

//登录状态
@property (nonatomic,strong) NSString *sessionId;

@end

NS_ASSUME_NONNULL_END
