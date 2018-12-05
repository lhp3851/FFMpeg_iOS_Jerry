//
//  KKImageView.m
//  StarZone
//
//  Created by lhp3851 on 16/2/17.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import "KKImageView.h"

#define PER_COUNT   (18)

@interface KKImageView ()
{
    size_t index;
    size_t count;
    NSTimer *timer;
}
@property(nonatomic,copy)void (^finish)(void);
@property(nonatomic, assign)NSInteger repeatCount;
@property(nonatomic, strong)NSMutableArray *imageFiles;
@property (nonatomic, strong)dispatch_queue_t animationQueue;
@property(nonatomic, assign)BOOL isFinish;
@end

@implementation KKImageView

-(id)initWithCenter:(CGPoint)center imageFiles:(NSArray *)imageFiles duration:(NSInteger)duration
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.center = center;
        self.animationQueue = dispatch_queue_create("animationQueue", DISPATCH_QUEUE_SERIAL);
        self.imageFiles = [NSMutableArray arrayWithCapacity:0];
        [self refreshImageFiles:imageFiles duration:duration];
    }
    return self;
}

-(void)refreshImageFiles:(NSArray *)imageFiles duration:(NSInteger)duration
{
    count = imageFiles.count;
    [self.imageFiles removeAllObjects];
    [self.imageFiles addObjectsFromArray:imageFiles];
    if (count<=0) {
        return;
    }
    if (duration == 0) {
        self.repeatCount = 1;
    }
    else if(duration < 0 )
    {
        self.repeatCount = -1;
    }
    else
    {
        NSInteger pixs = duration * PER_COUNT;
        self.repeatCount = (pixs + count -1)/count;
    }
    
    index = 0;
    //lastImage
    self.image = nil;
    __weak typeof(self) _weakSelf = self;
    dispatch_async(self.animationQueue, ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[_weakSelf.imageFiles lastObject]] scale:2];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGPoint center = _weakSelf.center;
                CGFloat width = kFitWithWidth(image.size.width);
                CGFloat height = kFitWithWidth(image.size.height);
                _weakSelf.frame = CGRectMake(center.x-width/2, center.y-height/2, width, height);
                _weakSelf.image = image;
            });
        }
    });
    
    return;
}


-(void)showInView:(UIView *)view atIndex:(NSInteger)atIndex finish:(void (^)(void))finish
{
    self.finish =finish;
    if (count <=0) {
        [self dismissAnimation:NO];
        return;
    }
    if (view ==nil) {
        view = kTOP_WINDOW;
    }
    if (atIndex >= view.subviews.count) {
        atIndex = view.subviews.count-1;
    }
   // [view insertSubview:self atIndex:atIndex];
    [view addSubview:self];
    self.alpha = 1.0f;
    [self startAnimating];
    
    [timer invalidate];
    timer = nil;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f/PER_COUNT target:self selector:@selector(play) userInfo:nil repeats:YES];
    [timer fire];
}

-(void)play
{
    if (count <=0) {
        [self dismissAnimation:NO];
        return;
    }
    index ++;
    if (_repeatCount<0) {
        index = index%count;
    }
    else
    {
        if (index/count >= _repeatCount) {
            [self dismiss];
            return;
        }
    }
    __weak typeof(self) _weakSelf = self;
    dispatch_async(self.animationQueue, ^{
        if (count <= _weakSelf.imageFiles.count) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[_weakSelf.imageFiles objectAtIndex:index%count]] scale:2];
            dispatch_async(dispatch_get_main_queue(), ^{
                _weakSelf.layer.contents = (__bridge id)image.CGImage;
            });
            
        }
    });
  //  CFRelease(ref);
}

-(void)dismiss
{
    [self dismissAnimation:YES];
}

-(void)dismissAnimation:(BOOL)animation
{
    [timer invalidate];
    timer = nil;
    [self stopAnimating];
    [self.imageFiles removeAllObjects];
    __weak typeof(self) _weakSelf = self;
    if (animation) {
        self.isFinish = NO;
        [UIView animateWithDuration:0.15f animations:^{
            _weakSelf.alpha = 0.3f;
        } completion:^(BOOL finished) {
            if (_weakSelf.isFinish == NO) {
                _weakSelf.image = nil;
                _weakSelf.isFinish = YES;
                [_weakSelf removeFromSuperview];
                if (_weakSelf.finish) {
                    _weakSelf.finish();
                }
                _weakSelf.finish = nil;
            }
        }];
    }
    else
    {
        self.isFinish = YES;
        [self.layer removeAllAnimations];
        self.alpha = 0.3f;
        self.image = nil;
        [self removeFromSuperview];
        self.finish = nil;
    }
}


@end
