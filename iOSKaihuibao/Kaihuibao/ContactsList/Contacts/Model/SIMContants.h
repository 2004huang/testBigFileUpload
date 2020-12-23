//
//  SIMContants.h
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/26.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 这个模型：企业通讯录和外部联系人 人员共同模型
 */
@interface SIMContants : NSObject


/** 和后台相同的参数 */
@property (nonatomic, copy) NSString *nickname;  // 姓名
@property (nonatomic, copy) NSString *username;  // 用户名 为了兼容私有云 和同一个手机号的问题 所以用账号确保唯一
@property (nonatomic, copy) NSString *mobile;    // 电话号码
@property (nonatomic, copy) NSString *email;     // 邮箱
@property (nonatomic, copy) NSString *conf;      // 会议号
@property (nonatomic, copy) NSString *uid;       // 本后台用户系统唯一id
@property (nonatomic, copy) NSString *avatar;      // 头像
@property (nonatomic, copy) NSString *role;      // 角色 每个用户注册就有角色 主用户为1 子用户为0（移动端暂时只有1和0）
@property (nonatomic, copy) NSString *company_name;   // 公司名字
@property (nonatomic, copy) NSString *companyName;   // 新版本接口公司名字
@property (nonatomic, copy) NSString *position;       // 职务
@property (nonatomic, copy) NSArray *departmentName;// 部门名字数组
@property (nonatomic, copy) NSString *department_name;// 部门名字
@property (nonatomic, assign) NSNumber *userDevice;   // 在线类型
@property (nonatomic, assign) NSNumber* online;       // 是否在线
@property (nonatomic, copy) NSString *introduction;// 介绍
@property (nonatomic, strong) NSString *createtime; // 新参数
@property (nonatomic, strong) NSString *rid; // 新参数

/** 自用参数*/
@property (nonatomic, assign) BOOL isSelectt; // 是否选中cell （选择联系人时候使用）
@property (nonatomic, assign) BOOL isBeen;    // 区分是否已经选择这个人了（选择联系人时候使用）
@property (nonatomic, assign) BOOL isContant; // 是否为联系人 分用户no和联系人yes 公用这个model
@property (nonatomic, assign) BOOL isNotClick; // cell是否不能点击了 （选择联系人时候使用）

// 部门里面的多的参数
@property (nonatomic, strong) NSArray *department_name_list;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *role_id;
@property (nonatomic, strong) NSString *role_name;

@property (nonatomic, assign) BOOL isFriend; // 是不是好友关系
@property (nonatomic, assign) BOOL isUser; // 有没有注册
@property (nonatomic, assign) BOOL isCompany; // 是不是同个公司下的

@property (nonatomic, assign) BOOL isUserContant;// 用来区分是不是用户进入的界面还是好友的
@property (nonatomic, assign) BOOL isSelectSend;

@property (nonatomic, assign) BOOL isNeedChange;// 需要判断注册和好友 如果为no那么就是统一邀请


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

