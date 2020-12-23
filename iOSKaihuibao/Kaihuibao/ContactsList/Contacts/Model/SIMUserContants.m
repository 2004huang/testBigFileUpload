//
//  SIMUserContants.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/7/10.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMUserContants.h"

@implementation SIMUserContants
-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"username"]) {
        [self setValue:value forKey:@"nickname"];
    }
}

- (void)setGroup:(NSArray *)group {
    _group = group;
    NSMutableArray *groups = @[].mutableCopy;
    for (id dic in _group) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            SIMUserContants_group *gp = [[SIMUserContants_group alloc] initWithDictionary:dic];
            [groups addObject:gp];
        }
    }
    _group = groups.copy;
}
@end

@implementation SIMUserContants_group

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

@end
