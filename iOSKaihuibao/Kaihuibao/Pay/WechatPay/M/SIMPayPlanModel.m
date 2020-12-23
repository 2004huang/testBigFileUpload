
//
//  SIMPayPlanModel.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/11.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMPayPlanModel.h"

@implementation SIMPayPlanModel
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
- (void)setPricePlan:(NSArray *)PricePlan {
    _PricePlan = PricePlan;
    NSMutableArray *all = @[].mutableCopy;
    for (id dic in _PricePlan) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            SIMPayPlanModel_PricePlan *gp = [[SIMPayPlanModel_PricePlan alloc] initWithDictionary:dic];
            [all addObject:gp];
        }
    }
    _PricePlan = all.copy;

}
//- (void)setPricePlan:(NSDictionary *)PricePlan {
//    _PricePlan = PricePlan;
//    SIMPayPlanModel_PricePlan *gp = [[SIMPayPlanModel_PricePlan alloc] initWithDictionary:PricePlan];
//}

@end
@implementation SIMPayPlanModel_PricePlan
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

