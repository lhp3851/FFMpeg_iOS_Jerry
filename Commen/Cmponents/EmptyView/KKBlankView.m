//
//  KKBlankView.m
//  StarZone
//
//  Created by kankanliu on 2016/11/14.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import "KKBlankView.h"

#define kToolBarHeight 44
#define kNavigationBarHight 64

static  EmptyViewBlock block;


@implementation KKBlankView

+ (UIView*)blankViewWithFrame:(CGRect)frame  text:(NSString *)string imageName:(NSString *)imageName{
    UIImage *image = kIMAGE_NAME(imageName);
    UIView *lempty = [[UIView alloc]initWithFrame:frame];
    lempty.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGRect imageViewframe = CGRectMake((kSCREEN_WIDTH - image.size.width)*0.5, (kSCREEN_HEIGHT-kToolBarHeight-kNavigationBarHight-10)/2-image.size.width/2, image.size.width, image.size.height);
    imageView.frame = imageViewframe;
    imageView.center=CGPointMake(frame.size.width/2, (frame.size.height-image.size.height)/2+26);
    UILabel *promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+10, kSCREEN_WIDTH, 42)];
    promptLabel.textColor = RGBAlphaHex(0x333336, 0.5);
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.lineBreakMode = NSLineBreakByCharWrapping;
    promptLabel.numberOfLines = 0;
    promptLabel.font = [UIFont systemFontOfSize:13];
    promptLabel.text = string;
    [lempty addSubview:imageView];
    [lempty addSubview:promptLabel];
    return lempty;
}

+ (UIView*)blankViewWithFrame:(CGRect)frame  text:(NSString *)string imageName:(NSString *)imageName block:(void(^)(void))clickBlock{
    UIView *view=nil;
    if (clickBlock) {
        block=clickBlock;
        view= [KKBlankView blankViewWithFrame:frame text:nil imageName:imageName];
        CGRect btnFrame=CGRectMake(15, kSCREEN_HEIGHT/2-20, kSCREEN_WIDTH-30, kFitWithHeight(40));
        KKButton *button=[[KKButton alloc]initWithFrame:btnFrame title:string font:kSYSTEM_FONT(16) norTitlecolor:kNORMAL_TEXT_COLOR hlightTitlecolor:kSELETED_COLOR normalBackgroudColor:kNORMAL_COLOR HilighBackgroudColor:kHILIGHT_COLOR cornerRadius:btnFrame.size.height/2 borderWidth:0 borderColor:nil];
        [button addTarget:[KKBlankView class] action:@selector(emptyBlock:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    else{
        block=nil;
        view=[KKBlankView blankViewWithFrame:frame text:string imageName:imageName];
    }
    return view;
}

/**
 空视图时界面执行的block

 @param sender sender
 */
+(void)emptyBlock:(id)sender{
    if (block) {
        block();
    }
}


@end
