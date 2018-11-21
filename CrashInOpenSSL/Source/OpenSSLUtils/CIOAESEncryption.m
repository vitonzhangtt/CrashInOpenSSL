//
//  AESEncryption.m
//  CrashInOpenSSL
//
//  Created by zhangchong on 2018/11/21.
//  Copyright © 2018年 zhangchong. All rights reserved.
//

#import "CIOAESEncryption.h"
#import <CommonCrypto/CommonCrypto.h>
#import <openssl/sha.h>
#import <openssl/evp.h>

@implementation CIOAESEncryption

+ (NSData *)encryptData:(NSData *)data
                    key:(const unsigned char *)key {
    
    NSData *result = nil;
    
    // generate initailization vector.
    char initialVector[kCCBlockSizeAES128];
    for (NSUInteger i = 0; i < kCCBlockSizeAES128; i++) {
        initialVector[i] = arc4random();
    }
    
    int dataSize = (int32_t)[data length]/sizeof(unsigned char);
//    size_t bufferSize = dataSize + kCCBlockSizeAES128 * 2;
    size_t bufferSize = dataSize + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    int encryptedSize = 0;
    
    /**
     ERR_load_crypto_strings() registers the error strings for all libcrypto functions.
     */
//    ERR_load_crypto_strings();
    
    /**
     */
//    OpenSSL_add_all_algorithms();
    
    /**
     OPENSSL_config() configures OpenSSL using the standard `openssl.cnf` and reads from the
     application section appname. If appname is NULL then the default section, openssl_conf,
     will be used. Errors are silently ignored. Multiple calls have no effect.
     */
//    OPENSSL_config(NULL);
    
    EVP_CIPHER_CTX *ctx;
    int cryptoLength = 0;
    
    /**
     EVP_CIPHER_CTX_new() creates a cipher context.
     */
    if (!(ctx = EVP_CIPHER_CTX_new())) {
        goto CLEAN_OpenSSL_Library;
    }
    
    /**
     int EVP_EncryptInit_ex(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type,
     ENGINE *impl, const unsigned char *key, const unsigned char *iv);
     
     EVP_EncryptInit_ex() sets up cipher context ctx for encryption with cipher type from ENGINE impl.
     ctx: must be created before calling this function.
     type: is normally supplied by a function such as EVP_aes_256_cbc().
     If impl is NULL then the default implementation is used.
     key: is the symmetric key to use and iv is the IV to use (if necessary), the actual number of bytes
     used for the key and IV depends on the cipher.
     */
    if (1 != EVP_EncryptInit_ex(ctx, EVP_aes_256_cbc(), NULL, key,
                                (const unsigned char *)initialVector)) {
        goto CLEAN_OpenSSL_Library;
    } else {
        /**
         EVP_CIPHER_CTX_set_padding() enables or disables padding.
         This function should be called after the context is set up for encryption or decryption with
         EVP_EncryptInit_ex(), EVP_DecryptInit_ex() or EVP_CipherInit_ex().
         
         By default encryption operations are padded using standard block padding and
         the padding is checked and removed when decrypting.
         If the pad parameter is zero then no padding is performed, the total amount of data
         encrypted or decrypted must then be a multiple of the block size or an error will occur.
         */
        EVP_CIPHER_CTX_set_padding(ctx, 1);
    }
    
    /**
     int EVP_EncryptUpdate(EVP_CIPHER_CTX *ctx, unsigned char *out,
     int *outl, const unsigned char *in, int inl);
     
     EVP_EncryptUpdate() encrypts inl bytes from the buffer in and
     writes the encrypted version to out.
     This function can be called multiple times to encrypt successive blocks of data.
     The amount of data written depends on the block alignment of the
     encrypted data: as a result the amount of data written may be
     anything from zero bytes to (inl + cipher_block_size - 1) so out should contain sufficient room.
     The actual number of bytes written is placed in outl.
     
     It also checks if in and out are partially overlapping, and if they are 0 is returned to indicate failure.
     */
    if (1 != EVP_EncryptUpdate(ctx, buffer, &cryptoLength, [data bytes], dataSize)) {
        goto CLEAN_OpenSSL_Library;
    }
    encryptedSize = cryptoLength;
    
    /**
     int EVP_EncryptFinal_ex(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl);
     If padding is enabled (the default) then EVP_EncryptFinal_ex() encrypts the "final" data,
     that is any data that remains in a partial block.
     It uses standard block padding (aka PKCS padding) as described in the NOTES section, below.
     
     The encrypted final data is written to out which should have sufficient space for one cipher block.
     The number of bytes written is placed in outl.
     After this function is called the encryption operation is finished and
     no further calls to EVP_EncryptUpdate() should be made.
     
     If padding is disabled then EVP_EncryptFinal_ex() will not encrypt any more data and
     it will return an error if any data remains in a partial block: that is if the total data length
     is not a multiple of the block size.
     */
    if (1 != EVP_EncryptFinal_ex(ctx, buffer + cryptoLength, &cryptoLength)) {
        goto CLEAN_OpenSSL_Library;
    }
    encryptedSize += cryptoLength;
    result = [NSData dataWithBytesNoCopy:buffer length:encryptedSize];
    
CLEAN_OpenSSL_Library:
    if (ctx) {
        /**
         void EVP_CIPHER_CTX_free(EVP_CIPHER_CTX *ctx);
         EVP_CIPHER_CTX_free() clears all information from a cipher context
         and free up any allocated memory associate with it, including ctx itself.
         This function should be called after all operations using a cipher are complete
         so sensitive information does not remain in memory.
         */
        EVP_CIPHER_CTX_free(ctx);
    }
    
    /**
     void EVP_cleanup(void);
     
     In versions prior to 1.1.0 EVP_cleanup() removed all ciphers and digests from the table.
     It no longer has any effect in OpenSSL 1.1.0.
     
     The OpenSSL_add_all_algorithms(), OpenSSL_add_all_ciphers(), OpenSSL_add_all_digests(), and EVP_cleanup(),
     functions were deprecated in OpenSSL 1.1.0 by OPENSSL_init_crypto().
     
     A typical application will call OpenSSL_add_all_algorithms() initially and EVP_cleanup() before exiting.
     */
//    EVP_cleanup();
    
    /**
     void ERR_free_strings(void);
     In versions of OpenSSL prior to 1.1.0 ERR_free_strings() freed all previously loaded error strings.
     However from OpenSSL 1.1.0 it does nothing.
     
     The ERR_load_crypto_strings(), SSL_load_error_strings(), and ERR_free_strings() functions
     were deprecated in OpenSSL 1.1.0 by OPENSSL_init_crypto() and OPENSSL_init_ssl().
     */
//    ERR_free_strings();
    
    /**
     void CONF_modules_free(void);
     CONF_modules_free() closes down and frees up all memory allocated by all configuration modules.
     
     Normally in versions of OpenSSL prior to 1.1.0 applications will only call
     CONF_modules_free() at application exit to tidy up any configuration performed.
     
     From 1.1.0 CONF_modules_free() is deprecated and no explicit CONF cleanup is required at all.
     For more information see OPENSSL_init_crypto.
     
     CONF_modules_free() was deprecated in OpenSSL 1.1.0.
     */
//    CONF_modules_free();
    
    return result;
}

+ (NSData *)decryptData:(NSData *)data
                    key:(const unsigned char *)key {
    
    NSData *result = nil;
    
    return result;
}


@end
