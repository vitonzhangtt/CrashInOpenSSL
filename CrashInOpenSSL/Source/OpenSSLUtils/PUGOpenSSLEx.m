//
//  PUGOpenSSLEx.m
//  putong
//
//  Created by zhangchong on 2018/11/12.
//  Copyright © 2018年 P1. All rights reserved.
//

#import "PUGOpenSSLEx.h"
#import <openssl/crypto.h>
#import <openssl/ssl.h>
#import <openssl/err.h>
#import <openssl/conf.h>
#import <pthread/pthread.h>

static pthread_mutex_t *ssl_mutex = NULL;

static void ssl_locking_cb(int mode, int type, const char* file, int line)
{
    if (mode & CRYPTO_LOCK)
        pthread_mutex_lock(&ssl_mutex[type]);
    else
        pthread_mutex_unlock(&ssl_mutex[type]);
}

static unsigned long ssl_id_cb(void)
{
    return (unsigned long)pthread_self();
}

int ssl_init(void)
{
    int i;
    
    printf("CRYPTO_num_locks(): %d\n", CRYPTO_num_locks());
    
    /* The number of lock we need is getting from CRYPTO_num_locks() */
    if ((ssl_mutex = malloc(sizeof(pthread_mutex_t) * CRYPTO_num_locks()))
        == NULL) {
        // printf("malloc() failed.\n");
        return -1;
    }
    
    /* Initialize the mutex. */
    for (i = 0; i < CRYPTO_num_locks(); i++) {
        pthread_mutex_init(&ssl_mutex[i], NULL);
    }
    
    /* Set up locking function */
    CRYPTO_set_locking_callback(ssl_locking_cb);
    CRYPTO_set_id_callback(ssl_id_cb);
    
    /* Initialize openssl library(libssl & libcrypto). */
    SSL_library_init();
    ERR_load_crypto_strings();
    SSL_load_error_strings();
    OpenSSL_add_all_algorithms();
    OPENSSL_config(NULL);
    
    return 0;
}

@implementation PUGOpenSSLEx

/**
 When OpenSSL v1.0.1 or v1.0.2 is used in the multithread environment,
 locking function and threadid function MUST be provided.
 If not, random crash will occur.
 */
+ (void)openSSLInitialization {
    ssl_init();
}

@end
