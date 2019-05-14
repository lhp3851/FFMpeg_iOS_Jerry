//
//  main.m
//  FFMpeg_iOS_Jerry
//
//  Created by Jerry on 29/03/2018.
//  Copyright © 2018 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


__attribute__((constructor)) void before_main() {
    printf("--- %s\n", __func__);
}

__attribute__((destructor)) void after_main() {
    printf("--- %s\n", __func__);
}

int main(int argc, char * argv[]) {
    printf("--- %s\n", __func__);
    
//    exit(0);
//    
//    printf("--- %s, exit ?\n", __func__);
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
