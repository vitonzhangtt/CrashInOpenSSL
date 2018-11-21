//
//  CIOWorkerThread.m
//  CrashInOpenSSL
//
//  Created by zhangchong on 2018/11/21.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

#import "CIOWorkerThread.h"
#import "CIOAESEncryption.h"

@implementation CIOWorkerThread

- (void)start {
    [super start];
//    NSLog(@"FUNCTION:%s LINE:%@ Thread:%p", __FUNCTION__, @(__LINE__), [NSThread currentThread]);
}

- (void)main {
    /**
     thread body.
     */
    unsigned char key[] = "vitonzhangtt";
    unsigned char buffer[] = "hello,world";
    NSUInteger length = sizeof(buffer)/sizeof(char);
    NSLog(@"FUNCTION:%s LINE:%@ Thread:%p length:%lu",
          __FUNCTION__, @(__LINE__), [NSThread currentThread], length);
    NSData *rawData = [NSData dataWithBytes:buffer length:length];
    
    while (true) {
        [CIOAESEncryption encryptData:rawData key:key];
        [NSThread sleepForTimeInterval:0.01];
    }
    
}

@end
