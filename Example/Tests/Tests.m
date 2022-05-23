//
//  CZAESCipherTests.m
//  CZAESCipherTests
//
//  Created by CZ on 05/23/2022.
//  Copyright (c) 2022 CZ. All rights reserved.
//

@import XCTest;
#import "CZAESCipher.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

static NSString *const kSecretKey = @"1234567812345678";
static NSString *const kInitialVector = @"8765432187654321";
- (void)testExample
{
    // 使用时建议在封装一层，不要直接暴露 kSecretKey 和 kInitialVector
    NSString *plainText = @"123456";
    NSString *cipherText = [CZAESCipher encrypt:plainText secretKey:kSecretKey iv:kInitialVector];
    
    NSString *result = [CZAESCipher decrypt:cipherText secretKey:kSecretKey iv:kInitialVector];
    
    NSLog(@"%@", cipherText);
    NSLog(@"%@", result);
}

@end

