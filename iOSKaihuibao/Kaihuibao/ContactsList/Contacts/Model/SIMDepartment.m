//
//  SIMDepartment.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/8/3.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMDepartment.h"

@implementation SIMDepartment
-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}
//- (void)setMembers:(NSArray *)members {
//    _members = members;
//    NSMutableArray *membe = @[].mutableCopy;
//    for (id dic in _members) {
//        if ([dic isKindOfClass:[NSDictionary class]]) {
//            SIMDepartment_member *gp = [[SIMDepartment_member alloc] initWithDictionary:dic];
//            [membe addObject:gp];
//        }
//    }
//    _members = membe.copy;
//}
@end

@implementation SIMDepartment_member

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
