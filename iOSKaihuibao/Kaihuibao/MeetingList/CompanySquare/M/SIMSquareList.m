//
//  SIMSquareList.m
//  Kaihuibao
//
//  Created by mac126 on 2018/8/16.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMSquareList.h"

@implementation SIMSquareList
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
- (void)setShop_list:(NSArray *)shop_list {
    _shop_list = shop_list;
    NSMutableArray *all = @[].mutableCopy;
    for (id dic in _shop_list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            SIMSquareList_goodlist *gp = [[SIMSquareList_goodlist alloc] initWithDictionary:dic];
            [all addObject:gp];
        }
    }
    _shop_list = all.copy;
}

@end

@implementation SIMSquareList_goodlist

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}
- (void)setMyvideos:(NSArray *)myvideos {
    _myvideos = myvideos;
    NSMutableArray *all = @[].mutableCopy;
    for (id dic in _myvideos) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            SIMSquareList_goodlist_myvideos *gp = [[SIMSquareList_goodlist_myvideos alloc] initWithDictionary:dic];
            [all addObject:gp];
        }
    }
    _myvideos = all.copy;
}

@end

@implementation SIMSquareList_goodlist_myvideos
-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}
@end
