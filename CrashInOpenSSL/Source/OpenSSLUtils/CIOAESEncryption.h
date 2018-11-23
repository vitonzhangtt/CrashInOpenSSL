//
//  AESEncryption.h
//  CrashInOpenSSL
//
//  Created by zhangchong on 2018/11/21.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CIOAESEncryption : NSObject

+ (NSData *)encryptData:(NSData *)data
                    key:(const unsigned char *)key
          initialVector:(const unsigned char *)initialVector;

+ (NSData *)decryptData:(NSData *)data
                    key:(const unsigned char *)key
          initialVector:(const unsigned char *)initialVector;

@end
