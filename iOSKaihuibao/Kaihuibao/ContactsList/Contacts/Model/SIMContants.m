//
//  SIMContants.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/26.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMContants.h"

@implementation SIMContants
-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    if ([key isEqualToString:@"username"]) {
//        [self setValue:value forKey:@"nickname"];
//    }
//    if ([key isEqualToString:@"id"]) {
//        [self setValue:value forKey:@"uid"];
//    }
}
@end
