//
//  KKButton.m
//  StarZone
//
//  Created by lhp3851 on 16/2/13.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import "KKButton.h"
#import "KKFileManager.h"

@interface KKButton ()

@property(nonatomic, assign)CGRect imageRect;
@property(nonatomic, assign)CGRect titleRect;

@end

@implementation KKButton

-(instancetype)initWithFrame:(CGRect)Frame SelectedImage:(NSString *)selectedImage NormalImage:(NSString *)normalImage{
    KKButton *checkbox = [KKButton buttonWithType:UIButtonTypeCustom];
    [checkbox setFrame:Frame];
    
    [checkbox setImage:[KKFileManager imageWithPath:normalImage] forState:UIControlStateNormal];
    [checkbox setImage:[KKFileManager imageWithPath:selectedImage] forState:UIControlStateSelected];
    return checkbox;
}


-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font norcolor:(UIColor *)norcolor lightcolor:(UIColor *)hightcolor
{
    if (self = [super initWithFrame:frame]) {
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = font;
        [self setTitleColor:norcolor forState:UIControlStateNormal];
        [self setTitleColor:hightcolor forState:UIControlStateHighlighted];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame  title:(NSString *)title font:(UIFont *)font norTitlecolor:(UIColor *)norcolor hlightTitlecolor:(UIColor *)hightcolor normalBackgroudColor:(UIColor *)normalBackgroudColor HilighBackgroudColor:(UIColor *)HilighBackgroudColor cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    if (self = [super initWithFrame:frame]) {
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = font;
        [self setTitleColor:norcolor forState:UIControlStateNormal];
        if (hightcolor) {
            [self setTitleColor:hightcolor forState:UIControlStateHighlighted];
        }
        [self setBackgroundColor:normalBackgroudColor];
        if (HilighBackgroudColor) {
            [self setBackgroundImage:[UIImage imageWithColor:HilighBackgroudColor] forState:UIControlStateHighlighted];
        }
        self.layer.cornerRadius=cornerRadius;
        self.layer.masksToBounds=YES;
        self.layer.borderColor=borderColor.CGColor;
        self.layer.borderWidth=borderWidth;
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame leftFont:(UIFont *)leftFont rightFont:(UIFont *)rightFont leftColor:(UIColor *)leftColor rightColor:(UIColor *)rightColor
{
    return [self initWithFrame:frame leftFont:leftFont rightFont:rightFont leftColor:leftColor rightColor:rightColor isCenter:NO];
}

-(instancetype)initWithFrame:(CGRect)frame leftFont:(UIFont *)leftFont rightFont:(UIFont *)rightFont leftColor:(UIColor *)leftColor rightColor:(UIColor *)rightColor isCenter:(BOOL)isCenter
{
    self = [super initWithFrame:frame];
    if (self) {
        KKLabel *leftLabel = [[KKLabel alloc]initWithFrame:CGRectMake(0, 0, self.width/2, self.height) text:@"" color:leftColor font:leftFont alignment:NSTextAlignmentCenter];
        [leftLabel setTag:55555];
        
        if (!isCenter) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2, (frame.size.height-24)/2, 1, 24)];
            [line setBackgroundColor:[kNORMAL_TEXT_COLOR colorWithAlphaComponent:.1f]];
            line.tag = 77777;
            [self addSubview:line];
        }
        
        KKLabel *rightLabel = [[KKLabel alloc]initWithFrame:CGRectMake(self.width/2, 0, self.width/2, self.height) text:@"" color:rightColor font:rightFont alignment:NSTextAlignmentCenter];
        [rightLabel setTag:66666];
        [self addSubview:leftLabel];
        [self addSubview:rightLabel];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    KKLabel *leftLabel = [self viewWithTag:55555];
    KKLabel *rightLabel = [self viewWithTag:66666];
    UIView *line = [self viewWithTag:77777];
    if (leftLabel && rightLabel) {
        if (line == nil) {
            CGFloat leftW = [leftLabel.text resizeWithFont:leftLabel.font adjustSize:CGSizeMake(MAXFLOAT, 20)].width;
            CGFloat rightW = [rightLabel.text resizeWithFont:rightLabel.font adjustSize:CGSizeMake(MAXFLOAT, 20)].width;
            
            CGFloat x_offset = (frame.size.width - (leftW + rightW ))/2;
            leftLabel.x = x_offset;
            leftLabel.width = leftW;
            
            rightLabel.x = x_offset + leftW;
            rightLabel.width = rightW;
        }
        else
        {
            leftLabel.x = 0;
            leftLabel.width = frame.size.width/2;
            
            rightLabel.x = frame.size.width/2;
            rightLabel.width = frame.size.width/2;
        }
    }
}

-(void)setText:(NSString *)leftTitle rightTitle:(NSString *)rightTitle
{
    KKLabel *leftLabel = [self viewWithTag:55555];
    KKLabel *rightLabel = [self viewWithTag:66666];
    [leftLabel setText:leftTitle];
    [rightLabel setText:rightTitle];
    
    UIView *line = [self viewWithTag:77777];
    if (leftLabel && rightLabel) {
        if (line == nil) {
            CGFloat leftW = [leftLabel.text resizeWithFont:leftLabel.font adjustSize:CGSizeMake(MAXFLOAT, 20)].width;
            CGFloat rightW = [rightLabel.text resizeWithFont:rightLabel.font adjustSize:CGSizeMake(MAXFLOAT, 20)].width;
            
            CGFloat x_offset = (self.frame.size.width - (leftW + rightW ))/2;
            leftLabel.x = x_offset;
            leftLabel.width = leftW;
            
            rightLabel.x = x_offset + leftW;
            rightLabel.width = rightW;
        }
        else
        {
            leftLabel.x = 0;
            leftLabel.width = self.frame.size.width/2;
            
            rightLabel.x = self.frame.size.width/2;
            rightLabel.width = self.frame.size.width/2;
        }
    }
 }

//设置图片在button中的位置
-(void)setImageRectForBounds:(CGRect)rect
{
    self.imageRect = rect;
}

//设置title在button中的位置
-(void)setTitleRectForBounds:(CGRect)rect
{
    self.titleRect = rect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    if (CGRectIsEmpty(_titleRect)) {
        return [super titleRectForContentRect:contentRect];
    }
    else
    {
        CGFloat width = [self.titleLabel.text resizeWithFont:self.titleLabel.font adjustSize:CGSizeMake(MAXFLOAT, self.height)].width;
        CGRect rect = CGRectMake(CGRectGetMidX(_titleRect) - width/2, _titleRect.origin.y, width, _titleRect.size.height);
        return rect;
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    if (CGRectIsEmpty(_imageRect)) {
        return [super imageRectForContentRect:contentRect];
    }
    else
    {
        return _imageRect;
    }
}

@end



@implementation KKStarCustomButton

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"star_icon_push_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"star_icon_push_up"] forState:UIControlStateSelected];
        [self setTitleColor:kNORMAL_TEXT_COLOR forState:UIControlStateNormal];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGPoint point = self.titleLabel.center;
    point.x = self.bounds.size.width/2;
    self.titleLabel.center = point;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame)+3;
    // [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.width*0.95, 0, 0)];
}

-(void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    [self sizeToFit];
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self sizeToFit];
}

@end

