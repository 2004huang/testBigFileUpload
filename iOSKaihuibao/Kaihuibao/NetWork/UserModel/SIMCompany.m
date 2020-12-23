//
//  SIMCompany.m
//  Kaihuibao
//
//  Created by 王小琪 on 2019/4/1.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMCompany.h"

@implementation SIMCompany
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"company_id":@"company_id",
             @"company_name":@"company_name",
             @"company_conf":@"company_conf",
             @"normal_password":@"normal_password",
             @"is_owner":@"is_owner",
             @"role":@"role",
             @"is_pay":@"is_pay",
             };
}
@end
