//
//  SIMNModel.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/3.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMNModel.h"

@implementation SIMNModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (void)setBtn_list:(NSArray *)btn_list {
    _btn_list = btn_list;
    NSMutableArray *all = @[].mutableCopy;
    for (id dic in _btn_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            SIMNModel_btnList *gp = [[SIMNModel_btnList alloc] initWithDictionary:dic];
            [all addObject:gp];
        }else {
            [all addObject:dic];
        }
    }
    _btn_list = all.copy;
}

@end

@implementation SIMNModel_btnList

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"serial"];
    }
    if ([key isEqualToString:@"name"]) {
        [self setValue:value forKey:@"titleName"];
    }
    if ([key isEqualToString:@"description"]) {
        [self setValue:value forKey:@"descriptionStr"];
    }
    if ([key isEqualToString:@"image"]) {
        [self setValue:value forKey:@"bannerPic"];
    }
}

@end

