//
//  UncaughtExceptionHandler.h
//  UncaughtExceptions
//
//  Created by Matt Gallagher on 2010/05/25.
//  Copyright 2010 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (*exceptionHandler)(NSException *exception);
typedef void (*signalHandler)(int signal);
@interface UncaughtExceptionHandler : NSObject{
    BOOL dismissed;
}
@end

void InstallUncaughtExceptionHandler(bool useDefaulHandler);
void registerExceptionHandle(exceptionHandler ex_handler);
//void registerSignalHandler(signalHandler sig_handler);
