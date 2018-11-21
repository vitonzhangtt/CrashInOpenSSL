//
//  PUGOpenSSLEx.h
//  putong
//
//  Created by zhangchong on 2018/11/12.
//  Copyright © 2018年 P1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PUGOpenSSLEx : NSObject

/**
 Initialize the OpenSSL library and set the necessary callback function:
 locking-function and thread_id-function.
 This method MUST be called before any other call to OpenSSL.
 */
+ (void)openSSLInitialization;

@end
