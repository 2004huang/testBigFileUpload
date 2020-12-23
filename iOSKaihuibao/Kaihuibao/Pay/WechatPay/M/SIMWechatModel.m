//
//  SIMWechatModel.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/10.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMWechatModel.h"

@implementation SIMWechatModel

-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    //    NSLog(@"%@",key);
}

@end
