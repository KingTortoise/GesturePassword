//
//  NSString+AES256.m
//  XYZ_iOS
//
//  Created by ruikaiqiang on 16/1/21.
//  Copyright © 2016年 焦点科技. All rights reserved.
//

#import "NSString+AES128.h"
#import "NSData+AES128.h"
#import "GTMBase64.h"

#define AESKEY @"sW6vjQKhKA9mXqjF"

@implementation NSString (AES128)

- (NSString *)entryptAESBase64
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [[GTMBase64 stringByWebSafeEncodingData:[data encryptWithKey:AESKEY] padded:YES] stringByReplacingOccurrencesOfString:@"=" withString:@""];
}

- (NSString *)deentryptAESBase64
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *deBase64 = [GTMBase64 webSafeDecodeData:data];
    NSData *deData = [deBase64 decryptWithKey:AESKEY];
    return [[NSString alloc] initWithData:deData  encoding:NSUTF8StringEncoding];
}

@end
