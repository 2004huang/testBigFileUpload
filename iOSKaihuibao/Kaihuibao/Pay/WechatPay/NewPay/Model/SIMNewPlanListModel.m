//
//  SIMNewPlanListModel.m
//  Kaihuibao
//
//  Created by mac126 on 2019/5/24.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMNewPlanListModel.h"

@implementation SIMNewPlanListModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        [self setValue:value forKey:@"descriptionStr"];
    }
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"pid"];
    }
    if ([key isEqualToString:@"button_text"]) {
        [self setValue:value forKey:@"buttonText"];
    }
}
@end
@implementation SIMNewPlanDetailModel
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
//    if ([key isEqualToString:@"mode_image"]) {
//        [self setValue:value forKey:@"image"];
//    }
}
- (void)setInfo_array:(NSArray *)info_array {
    _info_array = info_array;
    NSMutableArray *groups = @[].mutableCopy;
    for (id dic in _info_array) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            SIMNewPlanDetailInfo *gp = [[SIMNewPlanDetailInfo alloc] initWithDictionary:dic];
            [groups addObject:gp];
        }
    }
    _info_array = groups.copy;
}

- (void)setInfo:(NSArray *)info {
    _info = info;
    NSMutableArray *groups = @[].mutableCopy;
    for (id dic in _info) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            SIMNewPlanDetailInfo *gp = [[SIMNewPlanDetailInfo alloc] initWithDictionary:dic];
            [groups addObject:gp];
        }
    }
    _info = groups.copy;
}
- (void)setOptionList:(NSArray *)optionList {
    _optionList = optionList;
    NSMutableArray *lists = @[].mutableCopy;
    for (id dic in _optionList) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            SIMOptionList *gp = [[SIMOptionList alloc] initWithDictionary:dic];
            [lists addObject:gp];
        }
    }
    _optionList = lists.copy;
}

@end
@implementation SIMOptionList
-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

}
- (void)setInfo:(NSArray *)info {
    _info = info;
    NSMutableArray *groups = @[].mutableCopy;
    for (id dic in _info) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            SIMNewPlanDetailInfo *gp = [[SIMNewPlanDetailInfo alloc] initWithDictionary:dic];
            [groups addObject:gp];
        }
    }
    _info = groups.copy;
}
@end

@implementation SIMNewPlanDetailInfo
-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end


@implementation SIMNewPlanCurrentModel
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
}
@end
