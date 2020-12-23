//
//  CCUser.m
//  Kaihuibao
//
//  Created by Ferris on 2017/3/29.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "CCUser.h"

@implementation CCUser
-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    //    NSLog(@"%@",key);
}
//- (void)setCompany_list:(NSArray *)company_list {
//    _company_list = company_list;
//    NSMutableArray *inArrM = @[].mutableCopy;
//    for (id dic in _company_list) {
//        if ([dic isKindOfClass:[NSDictionary class]]) {
//            CCUser_companylist *gp = [[CCUser_companylist alloc] initWithDictionary:dic];
//            [inArrM addObject:gp];
//        }
//    }
//    _company_list = inArrM.copy;
//}
//+ (NSValueTransformer *)dataJSONTransformer{
//    return [MTLJSONAdapter arrayTransformerWithModelClass:CCUser_companylist.class];
//}
//+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
//        return [NSString stringWithFormat:@"%@",value];
//    }];
//}
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"uid":@"uid",
             @"username":@"username",
             @"nickname":@"nickname",
             @"mobile":@"mobile",
             @"email":@"email",
             @"gender":@"gender",
             @"avatar":@"avatar",
             @"position":@"position",
             @"introduction":@"introduction",
             @"status":@"status",
             @"self_conf":@"self_conf",
             @"conf_name":@"conf_name",
             @"userSig":@"userSig",
             @"company_serial":@"company_serial",
             
//             @"company_count":@"company_count",
//             @"currentcompany":@"currentcompany",
             };
}


@end


//@implementation CCUser_companylist
//
//- (instancetype)initWithDictionary:(NSDictionary *)dic{
//    self = [super init];
//    if (self) {
//        [self setValuesForKeysWithDictionary:dic];
//    }
//    return self;
//}
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    
//}
//+(NSDictionary *)JSONKeyPathsByPropertyKey
//{
//    return @{
//             @"company_id":@"company_id",
//             @"company_name":@"company_name",
//             @"company_conf":@"company_conf",
//             @"normal_password":@"normal_password",
//             @"is_owner":@"is_owner",
//             @"role":@"role",
//             @"is_pay":@"is_pay",
//             };
//}
//@end
