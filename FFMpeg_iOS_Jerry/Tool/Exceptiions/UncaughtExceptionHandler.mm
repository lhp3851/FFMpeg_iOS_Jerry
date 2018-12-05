//
//  UncaughtExceptionHandler.m
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

#import "UncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#define KK_MAX_HANDLER_COUNT 5
//http://www.cocoachina.com/newbie/tutorial/2012/0829/4672.html
NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey           = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey        = @"UncaughtExceptionHandlerAddressesKey";

volatile int32_t UncaughtExceptionCount = 0;
const    int32_t UncaughtExceptionMaximum = 31;

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 0;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 12;

static NSUncaughtExceptionHandler *umHandler = NULL;

static bool USE_DEFAULT_HANDLER_CONTROL = false;
static exceptionHandler EXCH_A[KK_MAX_HANDLER_COUNT];
static int CURRENT_EXCH_COUNT = 0;
static signalHandler SIGH_A[KK_MAX_HANDLER_COUNT];
static int CURRENT_SIGH_COUNT = 0;

@implementation UncaughtExceptionHandler

/**
 查看堆栈信息

 @return 字符串化的堆栈信息列表
 */
+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (
         i = UncaughtExceptionHandlerSkipAddressCount;
         i < UncaughtExceptionHandlerSkipAddressCount + UncaughtExceptionHandlerReportAddressCount;
         i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex
{
    if (anIndex == 0)
    {
        dismissed = YES;
    }else if (anIndex==1) {
        NSLog(@"ssssssss");
    }
}

- (void)validateAndSaveCriticalApplicationData
{
    
}

/**
 处理异常的交互 ， OC格式

 @param exception 异常
 */
- (void)handleException:(NSException *)exception
{
    [self validateAndSaveCriticalApplicationData];
    
    UIAlertView *alert =
    [[[UIAlertView alloc]
      initWithTitle:NSLocalizedString(@"抱歉，程序出现了异常", nil)
      message:[NSString stringWithFormat:NSLocalizedString(
                                                           @"如果点击继续，程序有可能会出现其他的问题，建议您还是点击退出按钮并重新打开\n\n"
                                                           @"异常原因如下:\n%@\n%@", nil),
               [exception reason],
               [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]]
      delegate:self
      cancelButtonTitle:NSLocalizedString(@"退出", nil)
      otherButtonTitles:NSLocalizedString(@"继续", nil), nil]
     autorelease];
    [alert show];
    print(@"%@,%@",[exception reason],[[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]);
    CFRunLoopRef runLoop  = CFRunLoopGetCurrent();
    CFArrayRef   allModes = CFRunLoopCopyAllModes(runLoop);
    
    while (!dismissed)
    {
        for (NSString *mode in (NSArray *)allModes)
        {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    
    CFRelease(allModes);
    
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL,  SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE,  SIG_DFL);
    signal(SIGBUS,  SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName])
    {
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
    }
    else
    {
        [exception raise];
    }
}

@end

/**
 异常处理 ， C格式

 @param exception 异常
 */
void HandleException(NSException *exception)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    for (int i = 0; i < CURRENT_EXCH_COUNT; i++) {
        exceptionHandler handler = EXCH_A[i];
        handler(exception);
    }
    
    if (USE_DEFAULT_HANDLER_CONTROL) {
        NSArray *callStack = [UncaughtExceptionHandler backtrace];
        NSMutableDictionary *userInfo =
        [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
        [userInfo
         setObject:callStack
         forKey:UncaughtExceptionHandlerAddressesKey];
        
        [[[[UncaughtExceptionHandler alloc] init] autorelease]
         performSelectorOnMainThread:@selector(handleException:)
                          withObject:[NSException exceptionWithName:[exception name]
                              reason:[exception reason]
                            userInfo:userInfo]
                       waitUntilDone:YES];
    }
    if (umHandler) {//处理友盟捕获的的异常
        umHandler(exception);
    }
}

/**
 信号量处理

 @param signal 信号量
 */
void SignalHandler(int signal)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    
    for (int i = 0; i < CURRENT_SIGH_COUNT; i++) {
        signalHandler handler = SIGH_A[i];
        handler(signal);
    }
    
    if (USE_DEFAULT_HANDLER_CONTROL) {
        NSMutableDictionary *userInfo =
        [NSMutableDictionary
         dictionaryWithObject:[NSNumber numberWithInt:signal]
         forKey:UncaughtExceptionHandlerSignalKey];
        
        NSArray *callStack = [UncaughtExceptionHandler backtrace];
        [userInfo
         setObject:callStack
         forKey:UncaughtExceptionHandlerAddressesKey];
        
        [[[[UncaughtExceptionHandler alloc] init] autorelease]
         performSelectorOnMainThread:@selector(handleException:)
                          withObject:[NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
                              reason:[NSString stringWithFormat:NSLocalizedString(@"Signal %d was raised.", nil),signal]
                            userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:signal]
                              forKey:UncaughtExceptionHandlerSignalKey]]
                       waitUntilDone:YES];
    }
}

void InstallUncaughtExceptionHandler(bool useDefaulHandler)
{
#if defined(DEBUG)
    USE_DEFAULT_HANDLER_CONTROL = useDefaulHandler;
#else
    USE_DEFAULT_HANDLER_CONTROL = false;
#endif
    CURRENT_SIGH_COUNT = 0;
    CURRENT_EXCH_COUNT = 0;
    umHandler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&HandleException);
    signal(SIGABRT, SignalHandler);
    signal(SIGILL,  SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE,  SignalHandler);
    signal(SIGBUS,  SignalHandler);
    signal(SIGPIPE, SignalHandler);
}

void registerExceptionHandle(exceptionHandler ex_handler)
{
    if (CURRENT_EXCH_COUNT < KK_MAX_HANDLER_COUNT) {
        EXCH_A[CURRENT_EXCH_COUNT] = ex_handler;
        CURRENT_EXCH_COUNT += 1;
    }
}

void registerSignalHandler(signalHandler sig_handler)
{
    if (CURRENT_SIGH_COUNT < KK_MAX_HANDLER_COUNT) {
        SIGH_A[CURRENT_SIGH_COUNT] = sig_handler;
        CURRENT_SIGH_COUNT += 1;
    }
}
