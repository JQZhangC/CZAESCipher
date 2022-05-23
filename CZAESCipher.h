//
//  CZAESCipher.h
//  CZAESCipher
//
//  Created by CZ on 2022/5/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZAESCipher : NSObject

/// AES 加密算法
/// 支持多种长度秘钥
/// 支持常见的 ECB 和 CBC 加密模式
/// @param plainText 明文
/// @param secretKey 秘钥，长度仅支持 16 位、24 位和 32 位
/// @param iv 初始向量，长度固定 16 位，长度 0 则使用 ECB 模式
/// @return 返回 base64 编码格式的密文
+ (nullable NSString *)encrypt:(NSString *)plainText
                     secretKey:(NSString *)secretKey
                            iv:(nullable NSString *)iv;


/// AES 解密算法
/// 支持多种长度秘钥
/// 支持常见的 ECB 和 CBC 加密模式
/// @param cipherText 密文，base64 编码格式的密文
/// @param secretKey 秘钥，长度仅支持 16 位、24 位和 32 位
/// @param iv 初始向量，长度固定 16 位，长度 0 则使用 ECB 模式
/// @return 返回明文
+ (nullable NSString *)decrypt:(NSString *)cipherText
                     secretKey:(NSString *)secretKey
                            iv:(nullable NSString *)iv;
@end

NS_ASSUME_NONNULL_END
