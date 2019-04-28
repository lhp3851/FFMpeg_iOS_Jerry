//
//  ViewController.m
//  FFMpeg_iOS_Jerry
//
//  Created by Jerry on 29/03/2018.
//  Copyright © 2018 Jerry. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    dispatch_queue_t q = dispatch_queue_create("dantesx", DISPATCH_QUEUE_CONCURRENT);
    void (^task)(void) = ^ {
        // 1. 用户登录，必须要第一个执行
        dispatch_sync(q, ^{
            NSLog(@"用户登录 %@", [NSThread currentThread]);
        });
        // 2. 扣费
        dispatch_async(q, ^{
            NSLog(@"扣费 %@", [NSThread currentThread]);
        });
        // 3. 下载
        dispatch_async(q, ^{
            NSLog(@"下载 %@", [NSThread currentThread]);
        });
    };
    NSLog(@"前 %@", [NSThread currentThread]);
    dispatch_async(q, task);
    NSLog(@"后 %@", [NSThread currentThread]);
    NSLog(@"董铂然 come here");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        printf("sdsfdsffs");
    });
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
