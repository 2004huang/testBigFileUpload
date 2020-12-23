//
//  CCUser.h
//  Kaihuibao
//
//  Created by Ferris on 2017/3/29.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "SIMCompany.h"

@class CCUser_companylist;
@interface CCUser : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *uid;//个人id
@property (nonatomic,strong) NSString *username; // 新增
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *mobile;// 电话
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *position;// 职务名称
@property (nonatomic,strong) NSString *introduction;
@property (nonatomic, strong) NSString *status;
@property (nonatomic,strong) NSString *self_conf;// 个人会议ID
@property (nonatomic,strong) NSString *conf_name;// 会议室名称
//@property (nonatomic,strong) NSString *company_count;// 公司个数
//@property (nonatomic,strong) NSArray *self_tag;// 个人标签列表
@property (nonatomic,strong) SIMCompany *currentcompany;
@property (nonatomic,strong) NSString *userSig;
@property (nonatomic,strong) NSString *company_serial;

// 字典转模型方法
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end

//@interface CCUser_companylist : MTLModel <MTLJSONSerializing>
//@property (nonatomic, strong) NSString *company_id;
//@property (nonatomic, strong) NSString *company_name;
//@property (nonatomic, strong) NSString *company_conf;
//@property (nonatomic, strong) NSString *normal_password;
//@property (nonatomic, strong) NSString *is_owner;
//@property (nonatomic, strong) NSString *role;
//@property (nonatomic, strong) NSString *is_pay;
//
//// 字典转模型方法
//-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
//
//@end
