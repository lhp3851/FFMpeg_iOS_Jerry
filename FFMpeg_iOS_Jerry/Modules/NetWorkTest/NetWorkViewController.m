//
//  NetWorkViewController.m
//  sm_ios_base_Example
//
//  Created by sumian on 2019/5/14.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#import "NetWorkViewController.h"

@interface NetWorkViewController ()

@end

@implementation NetWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViewes];
    [self requestDatas];
}

- (void)setUpViewes{
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:true completion:^{
        NSLog(@"dismiss ok");
    }];
}


- (void)requestDatas{
    NSString *urlString = @"http://httpbin.org/get";
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *sharedSession = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"data=%@,respone:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],response);
        } else {
            NSLog(@"error=%@",error);
        }
    }];
    [dataTask resume];
}


@end
