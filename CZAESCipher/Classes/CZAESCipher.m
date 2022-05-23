//
//  CZAESCipher.m
//  CZAESCipher
//
//  Created by CZ on 2022/5/23.
//  Copyright © 2022 CZ. All rights reserved.
//

#import "CZAESCipher.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation CZAESCipher

+ (NSString *)encrypt:(NSString *)plainText secretKey:(NSString *)secretKey iv:(NSString *)iv {
    // 验证数据合法性
    BOOL legal = [self legalWithPlaintext:plainText secretKey:secretKey iv:iv];
    if (!legal) {
        return nil;
    }
    
    NSInteger secretKeyLength = [secretKey length];
    NSInteger ivLength = [iv length];

    // 这一步是非必须的，可以直接使用 secretKeyLength 作为 keylength
    size_t keyLength = [self _keyLengthWithSecretKeyLength:secretKeyLength];
    const void *ivPionter;
    
    // 如果初始向量有设定，那么使用 CBC 模式，否则使用 ECB 模式
    CCOptions options = (ivLength > 0) ? kCCOptionPKCS7Padding : kCCOptionPKCS7Padding | kCCOptionECBMode;
    
    
    char keyPointer[keyLength+1];
    bzero(keyPointer, sizeof(keyPointer));
    [secretKey getCString:keyPointer maxLength:sizeof(keyPointer) encoding:NSUTF8StringEncoding];
    
    if (ivLength > 0) {
        char ivPtr[kCCBlockSizeAES128 + 1];
        bzero(ivPtr, sizeof(ivPtr));
        [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
        ivPionter = ivPtr;
    }
    
    NSData *plainData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger plainDataLength = [plainData length];
    
    size_t bufferSize = plainDataLength + keyLength;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    

    CCCryptorStatus encryptStatus = CCCrypt(kCCEncrypt,
                                            kCCAlgorithmAES,
                                            options,
                                            keyPointer,
                                            keyLength, // 这里这个值才是指定 128 192 256 的关键
                                            ivPionter,
                                            [plainData bytes],
                                            plainDataLength,
                                            buffer, bufferSize,
                                            &numBytesEncrypted);
    
    if (encryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        NSString *resultString = [resultData base64EncodedStringWithOptions:0];
        return resultString;
    }
    free(buffer);
    return nil;
}

+ (NSString *)decrypt:(NSString *)cipherText secretKey:(NSString *)secretKey iv:(NSString *)iv {
    // 验证数据合法性
    BOOL legal = [self legalWithPlaintext:cipherText secretKey:secretKey iv:iv];
    if (!legal) {
        return nil;
    }
    
    NSInteger secretKeyLength = [secretKey length];
    NSInteger ivLength = [iv length];
    
    // 这一步是非必须的，可以直接使用 secretKeyLength 作为 keylength
    size_t keyLength = [self _keyLengthWithSecretKeyLength:secretKeyLength];
    
    // 如果初始向量有设定，那么使用 CBC 模式，否则使用 ECB 模式
    CCOptions options = (ivLength > 0) ? kCCOptionPKCS7Padding : kCCOptionPKCS7Padding | kCCOptionECBMode;
    
    const void *ivBytes;
    if (ivLength > 0) {
        ivBytes = [[iv dataUsingEncoding:NSUTF8StringEncoding] bytes];
    }
    
    NSData *cipherData = [[NSData alloc] initWithBase64EncodedString:cipherText options:0];
    NSUInteger cipherDataLength = cipherData.length;
    
    char keyPointer[secretKeyLength + 1];
    memset(keyPointer, 0, sizeof(keyPointer));
    [secretKey getCString:keyPointer maxLength:sizeof(keyPointer) encoding:NSUTF8StringEncoding];
    
    size_t decryptSize = cipherDataLength + secretKeyLength;
    void *decryptedBytes = malloc(decryptSize);
    size_t actualOutSize = 0;
    

    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES,
                                          options,
                                          keyPointer,
                                          keyLength,
                                          ivBytes,
                                          [cipherData bytes],
                                          cipherDataLength,
                                          decryptedBytes,
                                          decryptSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:decryptedBytes length:actualOutSize];
        NSString *resultString = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        return resultString;
    }
    free(decryptedBytes);
    return nil;
}

#pragma mark - Privare Method

+ (BOOL)legalWithPlaintext:(NSString *)plaintext secretKey:(NSString *)secretKey iv:(NSString *)iv {
    if (nil == plaintext || nil == secretKey) {
        NSAssert(false, @"CZAESCipher: 内容或者秘钥不能为空...");
        return NO;
    }
    
    NSInteger secretKeyLength = [secretKey length];
    NSSet *secretKeyLengthSet = [self _secretKeyLengthSet];
    if (![secretKeyLengthSet containsObject:@(secretKeyLength)]) {
        NSAssert(false, @"CZAESCipher: 秘钥长度必须为 16、24 或者 32 位...");
        return NO;
    }
    
    NSInteger ivLength = [iv length];
    if (ivLength > 0 && ivLength != kCCBlockSizeAES128) {
        NSAssert(false, @"CZAESCipher: 初始向量必须为 0 或 16 长度的字符串...");
        return NO;
    }
    return YES;
}

+ (size_t)_keyLengthWithSecretKeyLength:(NSInteger)length {
    switch (length) {
        case 16:
            return kCCKeySizeAES128;
            break;
        case 24:
            return kCCKeySizeAES192;
            break;
        case 32:
            return kCCKeySizeAES256;
            break;
        default:
            return kCCKeySizeAES128;
            break;
    }
}

/// 秘钥长度必须为 16、24 或者 32 位
+ (NSSet *)_secretKeyLengthSet {
    static NSSet *set;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        set = [NSSet setWithObjects:@(16), @(24), @(32), nil];
    });
    return set;
}
@end
