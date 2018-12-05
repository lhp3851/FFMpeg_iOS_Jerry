//
//  KKLabel.m
//  StarZone
//
//  Created by 熊梦飞 on 16/2/16.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import "KKLabel.h"

@implementation KKLabel


-(instancetype)initWithFrame:(CGRect)frame text:(NSString *)text
{
    return [self initWithFrame:frame text:text color:kTEXT_VIEW_TEXT_COLOR font:[KKFitTool fitWithTextHeight:13.0f] alignment:NSTextAlignmentLeft];
}

-(instancetype)initWithFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)color font:(UIFont *)font alignment:(NSTextAlignment)alignment
{
    if (self = [super initWithFrame:frame]) {
        self.font = font;
        self.textColor = color;
        self.backgroundColor = KKCLEAR_COLOR;
        self.textAlignment = alignment;
        self.text = text;
    }
    return self;
}


-(void)exterinWithText:(NSString *)text color:(UIColor *)color
{
    if (text.length<=0) {
        return;
    }
    
    //注：ios6不能进行换行，所以只有ios7之后进行处理
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        NSRange rang = [self.text rangeOfString:text options:NSCaseInsensitiveSearch];
        if (rang.location != NSNotFound) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString: self.attributedText];
            [attributedString addAttribute: NSForegroundColorAttributeName value:color range: rang];
            NSString *str = [self.text substringFromIndex:rang.location+rang.length];
            while (str.length>0) {
                NSRange r = [str rangeOfString:text];
                if (!(r.location != NSNotFound && r.length>0)) {
                    break;
                }
                rang.location = rang.location + rang.length + r.location;
                [attributedString addAttribute: NSForegroundColorAttributeName value:color range: rang];
                str = [str substringFromIndex:r.location+r.length];
            }
            [self setAttributedText:attributedString];
        }
    }

}


-(void)setLineSpace:(CGFloat)lineSpace
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString: self.attributedText];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.text length])];
    self.attributedText = attributedString;
}

- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    
    return retSize;
}


+(NSAttributedString*)attriStringWith:(NSString *)text font:(UIFont *)font color:(UIColor *)color lineSpace:(CGFloat)lineSpace image:(UIImage *)image imagePos:(NSInteger)imagePos
{
    NSMutableDictionary *attirDic = [[NSMutableDictionary alloc] init];
    if (font) {
        [attirDic addEntriesFromDictionary:@{NSFontAttributeName : font}];
    }
    if (color) {
        [attirDic addEntriesFromDictionary:@{NSForegroundColorAttributeName : color}];
    }
    if (lineSpace>0.5) {
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpace];
        [attirDic addEntriesFromDictionary:@{NSParagraphStyleAttributeName : paragraphStyle}];
    }
    
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attirDic];
    
    NSString *startText = nil;
    NSString *endText = nil;
    if (image == nil) {
        imagePos = 0;
        startText = text;
    }
    else if (imagePos<0) {
        imagePos = 0;
        startText = text;
    }
    else if (imagePos>text.length) {
        imagePos = text.length;
        endText = text;
    }
    else
    {
        startText = [text substringToIndex:imagePos];
        endText = [text substringFromIndex:imagePos];
    }
    
    if (startText.length>0) {
        NSAttributedString *txtAttr = [[NSAttributedString alloc] initWithString:startText attributes:attirDic];
        [contentStr appendAttributedString:txtAttr];
    }
    
    if (image) {
        NSTextAttachment* attachment = [[NSTextAttachment alloc] init];
        attachment.image = image;
       // NSLog(@"%lf, %lf, %lf", image.size.width, image.size.height, font.lineHeight);
        CGFloat offset = 0.5f;
        attachment.bounds = CGRectMake(0, (image.size.height - font.lineHeight)/2 + offset, image.size.width, image.size.height);
        NSAttributedString* emotionAttr = [NSAttributedString attributedStringWithAttachment:attachment];
        [contentStr appendAttributedString:emotionAttr];
    }
    
    if (endText.length>0) {
        NSAttributedString *txtAttr = [[NSAttributedString alloc] initWithString:endText attributes:attirDic];
        [contentStr appendAttributedString:txtAttr];
    }
    
    return contentStr;
}

+(NSAttributedString*)attriStringWith:(NSAttributedString *)textAttri Text:(NSString *)text color:(UIColor *)color
{
    if (text.length<=0 || [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        return textAttri;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString: textAttri];
    NSRange rang = [textAttri.string rangeOfString:text options:NSCaseInsensitiveSearch];
    if (rang.location != NSNotFound) {
        
        [attributedString addAttribute: NSForegroundColorAttributeName value:color range: rang];
        NSString *str = [textAttri.string substringFromIndex:rang.location+rang.length];
        while (str.length>0) {
            NSRange r = [str rangeOfString:text];
            if (!(r.location != NSNotFound && r.length>0)) {
                break;
            }
            rang.location = rang.location + rang.length + r.location;
            [attributedString addAttribute: NSForegroundColorAttributeName value:color range: rang];
            str = [str substringFromIndex:r.location+r.length];
        }
    }
    return attributedString;
}

@end
