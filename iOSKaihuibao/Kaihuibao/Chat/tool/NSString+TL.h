//
//  NSString+WB.h
//  WhichBank
//
//  Created by h1r0 on 15/9/8.
//  Copyright (c) 2015年 lettai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (TL)

- (NSString *) pinyin;
- (NSString *) pinyinInitial;


+ (NSString *)md5To32bit:(NSString *)str;

@end
