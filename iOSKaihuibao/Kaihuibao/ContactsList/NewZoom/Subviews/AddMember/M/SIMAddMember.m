//
//  SIMAddMember.m
//  Kaihuibao
//
//  Created by mac126 on 2019/7/8.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMAddMember.h"

@implementation SIMAddMember
-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"pid"];
    }
    if ([key isEqualToString:@"rid"]) {
        [self setValue:value forKey:@"pid"];
    }
}
@end
