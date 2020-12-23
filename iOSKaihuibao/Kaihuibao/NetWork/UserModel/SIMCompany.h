//
//  SIMCompany.h
//  Kaihuibao
//
//  Created by 王小琪 on 2019/4/1.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface SIMCompany : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *company_id;
@property (nonatomic, strong) NSString *company_name;
@property (nonatomic, strong) NSString *company_conf;
@property (nonatomic, strong) NSString *normal_password;
@property (nonatomic, strong) NSString *is_owner;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *is_pay;

// 字典转模型方法
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
