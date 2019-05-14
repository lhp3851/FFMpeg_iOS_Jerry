//
//  ViewController.m
//  FFMpeg_iOS_Jerry
//
//  Created by Jerry on 29/03/2018.
//  Copyright © 2018 Jerry. All rights reserved.
//

#import "ViewController.h"
#import "KKIPTool.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *IP = KKIPTool.sharedKKIPTool.getLocalIPAddresses;
    print(@"IP地址：%@",IP);
    
    NSString *remoteIp = KKIPTool.sharedKKIPTool.getIPAdddress;
    
    print(@"远程IP地址：%@-%@",remoteIp,KKIPTool.sharedKKIPTool.getIPAddresses);
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
