//
//  CIOWorkerThread.m
//  CrashInOpenSSL
//
//  Created by zhangchong on 2018/11/21.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

#import "CIOWorkerThread.h"
#import "CIOAESEncryption.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation CIOWorkerThread

- (void)start {
    [super start];
}

- (void)main {
    
    NSString *keyText = [NSString stringWithFormat:@"vitonzhangtt %@", self.name];
    NSData *key = [keyText dataUsingEncoding:NSUTF8StringEncoding];
    NSString *text = [NSString stringWithFormat:@"hello,world: %p", [NSThread currentThread]];
    NSData *rawData = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger length = [rawData length];
    
    NSLog(@"FUNCTION:%s LINE:%@ Thread:%p length:%lu",
          __FUNCTION__, @(__LINE__), [NSThread currentThread], length);
    
    while (true) {
        
        // generate the initialization vector for aes.
        unsigned char initialVector[kCCBlockSizeAES128];
        for (NSUInteger i = 0; i < kCCBlockSizeAES128; i++) {
            initialVector[i] = arc4random();
        }
        
        // encrypt
        NSData *encrytedData = [CIOAESEncryption encryptData:rawData
                                                         key:[key bytes]
                                               initialVector:initialVector];
        NSLog(@"ThreadPointer:%p ThreadName: %@|encrytedData length: %lu",
              [NSThread currentThread], self.name, [encrytedData length]);
        
        // decrypt
        NSData *decryptedData = [CIOAESEncryption decryptData:encrytedData
                                                          key:[key bytes]
                                                initialVector:initialVector];
        NSString *decryptedText = [[NSString alloc] initWithData:decryptedData
                                                        encoding:NSUTF8StringEncoding];
        NSLog(@"ThreadPointer:%p ThreadName: %@|decryptedText: %@",
              [NSThread currentThread], self.name, decryptedText);
        
        // take a nap
        [NSThread sleepForTimeInterval:0.01];
    }
    
}

@end
