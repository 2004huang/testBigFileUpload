//
//  MainNetworkRequest.h
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/22.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNetworking.h"
#define LINK_URL(host, uri) [NSString stringWithFormat:@"%@/%@", host, uri]

//#define kApiBaseUrl [NSString stringWithFormat:@"http://%@%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostNetString"], [[NSUserDefaults standardUserDefaults] objectForKey:@"PortNetString"]]
//#define kApiBaseUrl @"http://video.kaihuibao.net"
/**
 临时地址 --- 验证支付
 */
//#define kApiBaseUrl @"http://192.168.4.241:8001/app"
/**
 测试服务器地址
 */
#define kApiTestBaseUrl @"http://47.92.168.111"

/**
 查询服务器地址接口
 */
// 查询服务器地址端口
//#define search_server_api LINK_URL(kApiBaseUrl, @"api/address/list/")
#define search_server_api LINK_URL(kApiBaseUrl, @"api/serveraddress/get")
// 查询延时直播和实时直播
#define search_living_api LINK_URL(kApiBaseUrl, @"api/address/seeding/")
// 查询现在的版本号
#define search_version_api LINK_URL(kApiBaseUrl, @"update/shellversion.ini")
// 查询是不是私有云部署
#define search_isPrivate_api LINK_URL(kApiBaseUrl, @"api/index/cloudversion")
// 查询是否需要更新
#define update_version_api LINK_URL(kApiBaseUrl, @"api/version/update")

/**
 个人信息（汉字部分为现使用接口）
 */
// 验证手机号码
#define validation_phoneNum_api LINK_URL(kApiBaseUrl, @"api/account/available/mobile/")
// 发送短信验证码
//#define send_sms_validation_api LINK_URL(kApiBaseUrl, @"api/account/validate/mobile/")
#define send_sms_validation_api LINK_URL(kApiBaseUrl, @"api/sms/send")

// 判断验证码正确性 (换接口)
#define judgement_sms_validation_api LINK_URL(kApiBaseUrl, @"api/account/confirm/mobile/")
// send email validation
#define send_email_validation_api LINK_URL(kApiBaseUrl, @"api/account/validate/email/")
// 注册
//#define register_api LINK_URL(kApiBaseUrl, @"api/account/register/")
#define register_api LINK_URL(kApiBaseUrl, @"api/user/register")

// 登录！！！！！！！
#define stati_login_api LINK_URL(kApiBaseUrl, @"api/user/login")
// 退出登录
#define logout_api LINK_URL(kApiBaseUrl, @"api/user/logout")
// 忘记密码
//#define recover_password_api LINK_URL(kApiBaseUrl, @"api/account/recover/")
#define recover_password_api LINK_URL(kApiBaseUrl, @"api/user/resetpwd")
// 完善个人信息
#define perfact_userinfo_api LINK_URL(kApiBaseUrl, @"api/user/perfectuser")
// 验证码直接登录
#define captcha_login_api LINK_URL(kApiBaseUrl, @"api/user/captchalogin")
// 第三方登录
#define third_login_api LINK_URL(kApiBaseUrl, @"api/user/third")
// 设置密码
#define set_password_api LINK_URL(kApiBaseUrl, @"api/account/security/password/")
// set email
#define set_email_api LINK_URL(kApiBaseUrl, @"api/account/security/email/")
// 设置个人信息
#define set_info_api LINK_URL(kApiBaseUrl, @"api/user/profile")
// 获取用户信息
#define get_info_api LINK_URL(kApiBaseUrl, @"api/user/index")
// 上传用户自己的头像
#define send_my_headerPic_api LINK_URL(kApiBaseUrl, @"api/user/changeavatar")
// 查看个人会议
#define get_conf_info_api LINK_URL(kApiBaseUrl, @"api/account/conf/info/")
// 编辑个人会议 -- 现在的编辑个人会议同编辑会议  这个接口用的是设置里面的会议参数编辑
#define set_conf_edit_api LINK_URL(kApiBaseUrl, @"api/account/conf/option/edit/")
// 查看个人直播间
#define get_live_info_api LINK_URL(kApiBaseUrl, @"api/account/live/info/")
// 查看个人视频客服sign=2  查看个人营销客服sign=3
#define get_service_info_api(signID) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/conf/self/conf?sign=%@",signID]]
// 公司名称
#define set_company_name_api LINK_URL(kApiBaseUrl, @"api/account/update/company_name/")
// 切换公司
#define change_company_api LINK_URL(kApiBaseUrl, @"api/user/changecompany")

/**
 会议
 */
// 创建会议（安排会议）！！！！！！
#define create_conf_api LINK_URL(kApiBaseUrl, @"api/conference/create")
// 会议列表 这里的sign是后加的为了区分1会议2客服3营销 列表通用都是会议列表但是根据sign区分类型 直播因为是单独的接口所以这里没有直播 （其他接口区分这四个类型的时候都是1会议2直播3客服4营销这里去掉了直播）
#define conf_list_api(start,limit,status,signID) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/conf/list?start=%@&limit=%@&status=%@&sign=%@",start,limit,status,signID]]
#define new_conf_list_api LINK_URL(kApiBaseUrl, @"api/conference/all")
// 已加入会议列表
#define joint_conf_list_api LINK_URL(kApiBaseUrl, @"api/conf/joint/")
// 编辑会议
//#define edit_conf_api_cid(cid) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/conf/%@/edit/",cid]]
#define edit_conf_api_cid LINK_URL(kApiBaseUrl, @"api/conference/edit")

// 会议详情
//#define conf_detail_api(cid) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/conf/%@/detail/",cid]]
#define conf_detail_api LINK_URL(kApiBaseUrl, @"api/conference/info")

// 添加会议成员
#define append_member_conf_api(cid) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/conf/%@/member/append/",cid]]
// 删除会议成员
#define remove_member_conf_api(cid) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/conf/%@/member/remove/",cid]]
// 会议成员列表
#define list_member_conf_api(cid) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/conf/%@/member/list/",cid]]
// 删除会议
//#define delete_conf_api(cid) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/conf/%@/delete/",cid]]
#define delete_conf_api LINK_URL(kApiBaseUrl, @"api/conference/del")

// 会议配置
#define config_conf_api LINK_URL(kApiBaseUrl, @"api/conference/config")
// 验证入会密码
#define verifyPSW_conf_api LINK_URL(kApiBaseUrl, @"api/conference/verify")

/**
 直播接口
 */
// 新建直播
#define creat_new_live_api LINK_URL(kApiBaseUrl, @"api/live/create/")
// 编辑直播
#define edit_new_live_api(cid) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/live/%@/edit/",cid]]
// 直播详情
#define detail_new_live_api(cid) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/live/%@/detail/",cid]]
// 直播列表
#define live_list_api(start,limit,status) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/live/list/?start=%@&limit=%@&status=%@",start,limit,status]]
// 删除直播
#define delete_live_api(cid) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/live/%@/delete/",cid]]
// 公开直播列表
//#define live_public_list_api(start,limit,status) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/live/alllist/?start=%@&limit=%@&status=%@",start,limit,status]]

// 公开直播列表
#define live_public_list_api LINK_URL(kApiBaseUrl, @"api/live/alllist/")
// 公开直播列表 公开直播新列表形式
#define live_public_test_list_api LINK_URL(kApiBaseUrl, @"api/live/testlist/")
//@"http://192.168.4.230/api/live/testlist/"

// 分享直播
#define search_adress_video_api LINK_URL(kApiBaseUrl, @"api/address/video/")

//#define testtwo_adress_video_api LINK_URL(kApiBaseUrl, @"admin/index/login")
//#define test_adress_video_api LINK_URL(kApiBaseUrl, @"admin/auth/admin/index?addtabs=1&sort=id&order=desc&offset=0&limit=10&filter=%7B%7D&op=%7B%7D&_=1553495930549")

/**
 联系人和群组--通讯录
 */
// ----用户
// 用户列表
//#define user_list_api LINK_URL(kApiBaseUrl, @"api/user/list/")
#define user_list_api LINK_URL(kApiBaseUrl, @"api/member/list")
// 创建用户
#define user_create_api LINK_URL(kApiBaseUrl, @"api/member/add")
// 删除用户
#define user_delete_api LINK_URL(kApiBaseUrl, @"api/member/del")
// 获取公共信息接口
#define user_publicinfo_api LINK_URL(kApiBaseUrl, @"api/user/publicinfo")
// 从手机通讯录添加子用户
#define user_addfromAdress_api LINK_URL(kApiBaseUrl, @"api/addressbook/adduser")

/**
  组织架构
*/
// 部门列表
#define department_getlist_api LINK_URL(kApiBaseUrl, @"api/department/list/")
#define new_department_getlist_api LINK_URL(kApiBaseUrl, @"api/department/info")

// 部门里面的人员
#define department_memberList_api(did) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/department/%@/member/list/",did]]


// ----联系人
// 联系人列表
//#define contractor_list_api(start,limit) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/contractor/list/?start=%@&limit=%@",start,limit]]
#define contractor_list_api LINK_URL(kApiBaseUrl, @"api/contact/all")

// 删除联系人
#define contractor_delete_api LINK_URL(kApiBaseUrl, @"api/contractor/delete/")
// 添加联系人
//#define contractor_add_api LINK_URL(kApiBaseUrl, @"api/contractor/add/")
// 添加好友
#define contact_add_api LINK_URL(kApiBaseUrl, @"api/contact/add")
// 模糊搜索
#define search_contact_api LINK_URL(kApiBaseUrl, @"api/department/usersearch")


// 添加常用联系人
#define concern_contractor_add_api LINK_URL(kApiBaseUrl, @"api/contractor/concern/add/")
// 取消常用联系人
#define concern_contractor_remove_api LINK_URL(kApiBaseUrl, @"api/contractor/concern/remove/")
// 常用联系人列表
#define concern_contractor_list_api LINK_URL(kApiBaseUrl, @"api/contractor/concern/list/")
//#define concern_contractor_list_api(start,limit) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/contractor/concern/list/?start=%@&limit=%@",start,limit]]
// 企业通讯录列表
//#define department_list_api(start,limit,detail) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/department/list/?start=%@&limit=%@&detail=%@",start,limit,detail]]
#define department_list_api(detail) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/department/list/?detail=%@",detail]]
// 联系人和用户列表
#define contractor_alllist_api LINK_URL(kApiBaseUrl, @"api/contractor/all/")
// 上传通讯录内容
#define adressbook_list_api LINK_URL(kApiBaseUrl, @"api/addressbook/update/")
// 获取通讯录的内容列表
#define adressbook_get_list_api LINK_URL(kApiBaseUrl, @"api/addressbook/info")
// 通讯录统计各个模块的人数
#define adressbooklist_count_api LINK_URL(kApiBaseUrl, @"api/addressbook/modelcount")


// ----讨论组
// 创建讨论组
#define group_create_api LINK_URL(kApiBaseUrl, @"api/group/create/")
// 编辑讨论组
#define group_edit_api(gid) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/group/%@/edit/",gid]]
// 删除讨论组
#define group_delete_api(gid) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/group/%@/delete/",gid]]
// append group members
#define group_append_api(gid) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/group/%@/member/append/",gid]]
// 将用户移出讨论组
#define group_remove_api(gid) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/group/%@/member/remove/",gid]]
// 讨论组成员列表
#define group_member_list_api(gid) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/group/%@/member/list/",gid]]
// 讨论组列表
#define group_list_api(kind) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/group/list/?kind=%@",kind]]
// 可加入的讨论组列表
#define group_available_list_api LINK_URL(kApiBaseUrl, @"api/group/available/")

// 已加入的讨论组列表
//#define group_joint_list_api LINK_URL(kApiBaseUrl, @"api/group/joint/")
#define group_joint_list_api(kind) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/group/joint/?kind=%@",kind]]
// 加入讨论组
#define group_member_join_api(gid) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/group/%@/member/join/",gid]]
// 退出讨论组
#define group_member_quit_api(gid) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/group/%@/member/quit/",gid]]
// 添加常用讨论组
#define group_concern_join_api(gid) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/group/%@/concern/add/",gid]]
// 取消常用讨论组
#define group_concern_remove_api(gid) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/group/%@/concern/remove/",gid]]
// 常用讨论组列表
#define group_concern_list_api LINK_URL(kApiBaseUrl, @"api/group/concern/list/")
/**
  设备
 */
// 添加设备
#define add_device_api LINK_URL(kApiBaseUrl, @"api/device/add/")
// 编辑设备
#define edit_device_api LINK_URL(kApiBaseUrl, @"api/device/edit/")
// 删除设备
#define delete_device_api LINK_URL(kApiBaseUrl, @"api/device/delete/")
// 设备列表
#define list_device_api LINK_URL(kApiBaseUrl, @"api/device/list/")

/**
 支付
 */
// 微信支付
//#define wechatPay_post_api LINK_URL(@"http://video.duokelai.cn/", @"api/wechatpay/wechart/APP/Pay/")
#define wechatPay_post_api(signId) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/wechatpay/wechart/APP/Pay/?pay_type=%@",signId]]
// 微信支付 验证订单成功与否
//#define wechatPayResult_check_api LINK_URL(@"http://video.duokelai.cn/", @"api/wechatpay/wechat/Pay/confirm")
#define wechatPayResult_check_api(signId) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/wechatpay/wechat/Pay/confirm/?pay_type=%@",signId]]
//@"http://video.duokelai.cn/api/wechatpay/wechat/Pay/confirm"

// 请求栏目的计划  区分类型 视频的1
#define requestChoosenPlanResult_api(signId) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/payplan/info/?sign=%@",signId]]
// 我当前的计划  区分类型 视频的1
#define requestMyChoosenPlan_api(signId) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/payplan/myplan/info/?sign=%@",signId]]
// 请求历史订单
#define historypay_order_api LINK_URL(kApiBaseUrl, @"api/payplan/myplan/")

// 用于是否展示微信支付 开关
#define show_theWechat_api LINK_URL(kApiBaseUrl, @"api/payplan/payplan_show/")

// 支付用于是否进会
#define can_joinTheMeet_api(typeId,signId) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/payplan/LoginConfCount/?type=%@&sign=%@",typeId,signId]]

// 购买了免费的计划
#define buyThe_Freeorder_api LINK_URL(kApiBaseUrl, @"api/payplan/pay_free_plan/")

// 我的钱包
#define Wallet_Mine_api LINK_URL(kApiBaseUrl, @"api/wallet/my_wallet/")

// 我的钱包充值
#define Wallet_AddMine_api  LINK_URL(kApiBaseUrl, @"api/wallet/recharge")

// 我的钱包充值确认
#define Wallet_ConfireMine_api  LINK_URL(kApiBaseUrl, @"api/wallet/payVerify")

// 我的钱包充值金额list请求
#define Wallet_amountList_api  LINK_URL(kApiBaseUrl, @"api/wallet/rechargeAmount")
// 我的钱包余额
#define Wallet_mywallet_api  LINK_URL(kApiBaseUrl, @"api/wallet/myWallet")
// 我的钱包明细
#define Wallet_history_api  LINK_URL(kApiBaseUrl, @"api/wallet/walletRecord")
// 充值确定是立即开通还是充值界面
#define wallet_dredgeTimePlan_api  LINK_URL(kApiBaseUrl, @"api/wallet/dredgeTimePlan")
// 关闭计时计划
#define wallet_closeTimePlan_api  LINK_URL(kApiBaseUrl, @"api/wallet/closeTimePlan")
// 关闭计时计划服务
#define wallet_closeTimeService_api  LINK_URL(kApiBaseUrl, @"api/wallet/closeTimeService")
// 免费计划详情介绍
#define freeplan_detail_api  LINK_URL(kApiBaseUrl, @"api/plan/freeplan")
// 我的钱包充值下面的服务列表的list请求
#define walletserver_List_api  LINK_URL(kApiBaseUrl, @"api/wallet/service")

/**
 新版本支付
 */
// 我的计划列表
#define newPay_planlist_api  LINK_URL(kApiBaseUrl, @"api/plan/planlist")
// 某个计划详情
#define newPay_plandetail_api  LINK_URL(kApiBaseUrl, @"api/plan/detail")
// 我当前的计划
#define newPay_nowplan_api  LINK_URL(kApiBaseUrl, @"api/plan/currentplan")
// 计划和服务购买记录
#define newPay_planrecord_api  LINK_URL(kApiBaseUrl, @"api/plan/planrecord")
// 扩展服务列表
#define newPay_servicelist_api  LINK_URL(kApiBaseUrl, @"api/plan/servicelist")
// 某个服务的详情
#define newPay_servicedetail_api  LINK_URL(kApiBaseUrl, @"api/plan/servicedetail")
// 新微信支付
#define newPay_appPay_api  LINK_URL(kApiBaseUrl, @"api/wechatplan/appPay")
// 新微信支付验证
#define newPay_payVerify_api  LINK_URL(kApiBaseUrl, @"api/wechatplan/payVerify")
// 我的当前服务列表
#define service_current_api  LINK_URL(kApiBaseUrl, @"api/plan/currentservice")

/**
 动态获取图片(首页和发现页的设备宣传图)
 */
// 首页
#define firstPage_Picture_api LINK_URL(kApiBaseUrl, @"api/carousel/%E9%A6%96%E9%A1%B5/carousel/list/")
// 发现
#define findPage_Picture_api LINK_URL(kApiBaseUrl, @"api/carousel/discover/carousel/list/")

// 发现列表
#define findlist_Picture_api LINK_URL(kApiBaseUrl, @"api/carousel/DiscoverList/carousel/list/")

/**
 新版发现数据 广告和广告位
 */
// 广告列表 目前用于首页的企业广场
//#define advertise_search_api LINK_URL(kApiBaseUrl, @"api/advertise/search/?sign=user")
#define advertise_search_api(user) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/advertise/search/?sign=%@",user]]

// 广告位管理
#define advertiseposil_all_api LINK_URL(kApiBaseUrl, @"api/advertiseposil/select_all_posit/")

// 广告位以及广告整个列表  目前用的接口
#define advert_all_api LINK_URL(kApiBaseUrl, @"api/advertiseposil/advertposil/")

// 通过广告唯一id去查询广告详情
//#define advert_select_api LINK_URL(kApiBaseUrl, @"api/advertise/get/info/")
#define advert_select_api(advertid) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/advertise/get/info/?serial=%@",advertid]]

// 发现页面广告轮播
#define newFind_Picture_api LINK_URL(kApiBaseUrl, @"api/carousel/93094375855/carousel/list/")

/**
 企业广场
 */
// 商铺商品总列表 用于list展示
#define companySquare_list_api LINK_URL(kApiBaseUrl, @"api/goods/goodshop/?source=1")

// 搜索 商铺或者商品 get请求 shop或者good
#define companySquare_search_api(vague,dist) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/goods/search/?vague=%@&dist=%@",vague,dist]]
// 商铺总列表
//#define companyShop_list_api LINK_URL(kApiBaseUrl, @"api/shop/shop_list/?source=1")
#define companyShop_list_api(adid) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/shop/shop_list/?source=%@",adid]]
// 商品总列表
#define companyGood_list_api LINK_URL(kApiBaseUrl, @"api/goods/goods_list/?sign=WeChat&source=1")
// 店铺详情
#define goodlist_detail_api LINK_URL(kApiBaseUrl, @"api/shop/shop_details/")

// 上传营销的背景图片
#define sendVM_backPic_api LINK_URL(kApiBaseUrl, @"api/carousel/upload/image/")

// 提交表单 新用户申请加入
#define submit_contact_api LINK_URL(kApiBaseUrl, @"api/admin/contact/submit/")

// 管理助手
#define manage_assis_api LINK_URL(kApiBaseUrl, @"api/identity/userList")

// 视频营销客服
#define sale_video_api LINK_URL(kApiBaseUrl, @"api/conf/list/?status=0&sign=3")

// 发送反馈
#define send_feedback_api LINK_URL(kApiBaseUrl, @"api/user/feedback")

// 入会时候加入到群组IM
#define add_IMgroup_member_api LINK_URL(kApiBaseUrl, @"api/txim/add_group_member")

// 会议文档列表
#define confDoc_List_api LINK_URL(kApiBaseUrl, @"api/confdoc/myself")
// 上传文档
#define confDoc_upload_api LINK_URL(kApiBaseUrl, @"api/confdoc/newupload")
// 会议速记上传
#define shorthand_record_api LINK_URL(kApiBaseUrl, @"api/shorthand/record")
// 会议速记详细列表
#define shorthand_detail_api LINK_URL(kApiBaseUrl, @"api/shorthand/all")

// 消息管理
#define message_classification_api LINK_URL(kApiBaseUrl, @"api/message/message_classification")
// 查询消息下的具体列表
#define messageDetail_list_api LINK_URL(kApiBaseUrl, @"api/message/message_list")
// 要不要支付
#define hidePlan_api LINK_URL(kApiBaseUrl, @"api/wallet/hidePlan")
// 苹果pay
#define inapppay_api LINK_URL(kApiBaseUrl, @"api/appstore/IOSPay")
// 苹果pay列表
#define inapppayList_api LINK_URL(kApiBaseUrl, @"api/plan/planlistios")
// 苹果pay服务列表
#define servicelistforauditList_api LINK_URL(kApiBaseUrl, @"api/plan/servicelisforaudit")
// 苹果pay生成预订单
#define inapppayGetorder_api LINK_URL(kApiBaseUrl, @"api/appstore/get_order")
// 首页的跳转到查看消息
#define homeMessage_api LINK_URL(kApiBaseUrl, @"api/message/home_message")
// 首页的云空间列表
#define cloudspace_class_api LINK_URL(kApiBaseUrl, @"api/cloudspace/spaceclass")
// 首页的云空间列表里面的详情列表
#define cloudspace_detail_api LINK_URL(kApiBaseUrl, @"api/cloudspace/spacelist")
// 首页的教学模式列表
#define classmodel_list_api(iconID) [NSString stringWithFormat:@"%@/%@", kApiBaseUrl, [NSString stringWithFormat:@"api/advanced/modelist?mode=%@",iconID]]
// 首页的教学模式列表里面的详情支付
#define classmodel_detailpay_api LINK_URL(kApiBaseUrl, @"api/advanced/modeinfo")
// 首页的教学模式列表里面支付
#define classmodel_gotopay_api LINK_URL(kApiBaseUrl, @"api/advanced/modeorder")
// 服务中心顶部栏目
#define servicecenter_sortlist_api LINK_URL(kApiBaseUrl, @"api/service_center/sortlist")
// 服务中心列表
#define servicecenter_centerlist_api LINK_URL(kApiBaseUrl, @"api/service_center/centerlist")
// 服务中心详情
#define servicecenter_centerinfo_api LINK_URL(kApiBaseUrl, @"api/service_center/centerinfo")
// 首页的图片列表
#define mainpage_pic_api LINK_URL(kApiBaseUrl, @"api/home_management/index")
// 同声传译列表
#define interpreterman_list_api LINK_URL(kApiBaseUrl, @"api/interpreter/system")
// 知识店铺列表
#define commodity_info_api LINK_URL(kApiBaseUrl, @"api/commodity/info")
// 知识店铺购买
#define price_service_info_api LINK_URL(kApiBaseUrl, @"api/price_service/auth")


#pragma mark - meelike api

#define conference_liveindex_api LINK_URL(kApiBaseUrl, @"api/conference/liveindex")




@interface MainNetworkRequest : NSObject
/**
 查询服务器地址接口
 */

// 查询服务器地址
+ (void)searchServerRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 查询直播地址
+ (void)searchLivingRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 查询现在的版本号
+ (void)searchVersionRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 查询是不是私有云部署
+ (void)searchIsPrivateRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 查询是否需要更新
+ (void)updateVersionRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

/**
 个人信息
 */
// 验证手机号码
+ (void)validationPhoneNumRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 发送验证码
+ (void)sendSmsValidationRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 验证验证码
+ (void)judgementSmsValidationRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;


// send email validation
+ (void)sendEmailValidationRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// register
+ (void)registerRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// static login
+ (void)staticLoginRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// dynamic login
+ (void)dynamicLoginRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 退出登录
+ (void)logoutRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 忘记密码
+ (void)recoverPasswordRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 完善个人信息
+ (void)perfactUserInfoRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 验证码直接登录
+ (void)captchaLoginRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 第三方登录
+ (void)thirdLoginRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 设置密码
+ (void)setPasswordRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// set email
+ (void)setEmailRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// set mobile
+ (void)setMobileRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 设置个人信息
+ (void)setInfoRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// set callback
+ (void)setCallbackRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 获取用户信息
+ (void)getInfoRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 上传用户自己的头像
+ (void)sendMyHeaderPicRequestParams:(NSDictionary *)params bodys:(BodysBlock)mainBodys progress:(ProgressBlock)mainProgress success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 查看个人会议
+ (void)getConfInfoRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 编辑个人会议 -- 现在的编辑个人会议同编辑会议  这个接口用的是设置里面的会议参数编辑
+ (void)editConfInfoRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 查看个人直播间
+ (void)getLiveInfoRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 查看个人视频客服sign = 2 查看个人营销客服sign = 3
+ (void)getServiceInfoRequestParams:(NSDictionary *)params signid:(NSString *)signID success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;


// 公司名称
+ (void)settingCompanyNameRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 切换公司
+ (void)changeCompanyRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

/**
 会议
 */
// 创建会议
+ (void)createConfInfoRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 会议列表
+ (void)confListRequestParams:(NSDictionary *)params start:(NSString *)startString limit:(NSString *)limitString status:(NSString *)statusString signid:(NSString *)signID success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

// 会议列表 新
+ (void)newconfListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

// 已加入会议列表
+ (void)jointConfListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 编辑会议
+ (void)editConfListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 会议详情
+ (void)confDetailRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

// 添加会议成员
+ (void)appendMemberConfRequestParams:(NSDictionary *)params cid:(NSString *)cidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 删除会议成员
+ (void)removeMemberConfRequestParams:(NSDictionary *)params cid:(NSString *)cidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 会议成员列表
+ (void)listMemberConfRequestParams:(NSDictionary *)params cid:(NSString *)cidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 删除会议
+ (void)deleteConfRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 会议配置
+ (void)configConfRequestParams:(NSDictionary *)params  webStr:(NSString *)webStr success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 验证入会密码
+ (void)verifyPSWConfRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

/**
 直播接口
 */
// 新建直播
+ (void)creatNewLiveRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 编辑直播
+ (void)editNewLiveRequestParams:(NSDictionary *)params cid:(NSString *)cidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 直播详情
+ (void)detailNewLiveRequestParams:(NSDictionary *)params cid:(NSString *)cidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 直播列表
+ (void)liveListRequestParams:(NSDictionary *)params start:(NSString *)startString limit:(NSString *)limitString status:(NSString *)statusString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 删除直播
+ (void)deleteLiveRequestParams:(NSDictionary *)params cid:(NSString *)cidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 公开直播列表
//+ (void)livePublicListRequestParams:(NSDictionary *)params start:(NSString *)startString limit:(NSString *)limitString status:(NSString *)statusString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 公开直播列表
+ (void)livePublicListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

// 公开直播列表 新形式测试接口
+ (void)livePublicTestListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 分享直播
+ (void)searchAdressVideoListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

//+ (void)testtwoAdressVideoListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
//+ (void)testAdressVideoListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

/**
 联系人和群组
 */
// ----用户
// 用户列表
+ (void)userListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
//+ (void)userListRequestParams:(NSDictionary *)params start:(NSString *)startString limit:(NSString *)limitString certification:(NSString *)certString premium:(NSString *)premiumString role:(NSString *)roleString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

// 创建用户
+ (void)userCreateRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 删除用户
+ (void)userDeleteRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 获取公共信息接口
+ (void)userPublicinfoRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 从手机通讯录添加子用户
+ (void)userAddFromAdressRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

/**
 组织架构
 */
// 部门列表
+ (void)departmentGetlistRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
+ (void)newDepartmentGetlistRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

// 部门里面的人员
+ (void)departmentMemberlistRequestParams:(NSDictionary *)params did:(NSString *)didString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

// ---通讯录
// 联系人列表
//+ (void)contractorListRequestParams:(NSDictionary *)params start:(NSString *)startString limit:(NSString *)limitString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
+ (void)contractorListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 删除联系人
+ (void)contractorDeleteRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 添加联系人
//+ (void)contractorAddRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 添加好友
+ (void)contractorAddRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 模糊搜索
+ (void)searchContractorRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

// 添加常用联系人
+ (void)concernContractorAddRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 取消常用联系人
+ (void)concernContractorRemoveRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 常用联系人列表
//+ (void)concernContractorListRequestParams:(NSDictionary *)params start:(NSString *)startString limit:(NSString *)limitString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
+ (void)concernContractorListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 企业通讯录列表
//+ (void)departmentListRequestParams:(NSDictionary *)params start:(NSString *)startString limit:(NSString *)limitString detail:(NSString *)detailString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
+ (void)departmentListRequestParams:(NSDictionary *)params detail:(NSString *)detailString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 联系人和用户列表
+ (void)contractorAllListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 上传通讯录内容
+ (void)adressbookListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 获取通讯录的内容列表
+ (void)adressGetListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 通讯录统计各个模块的人数
+ (void)adressbookListCountRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

// 用户组
// 创建讨论组
+ (void)createGroupRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 编辑讨论组
+ (void)editGroupRequestParams:(NSDictionary *)params gid:(NSString *)gidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 删除讨论组
+ (void)deleteGroupRequestParams:(NSDictionary *)params gid:(NSString *)gidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// append group members
+ (void)appendGroupRequestParams:(NSDictionary *)params gid:(NSString *)gidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 将用户移出讨论组
+ (void)removeMemberGroupRequestParams:(NSDictionary *)params gid:(NSString *)gidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 讨论组成员列表
+ (void)groupMemberListRequestParams:(NSDictionary *)params gid:(NSString *)gidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 讨论组列表
+ (void)groupListRequestParams:(NSDictionary *)params kind:(NSString *)kindString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 可加入的讨论组列表
+ (void)groupAvailableListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 已加入的讨论组列表
+ (void)groupJointListRequestParams:(NSDictionary *)params kind:(NSString *)kindString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
//+ (void)groupJointListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 加入讨论组
+ (void)groupMemberJoinRequestParams:(NSDictionary *)params gid:(NSString *)gidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 退出讨论组
+ (void)groupMemberQuitRequestParams:(NSDictionary *)params gid:(NSString *)gidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 添加常用讨论组
+ (void)groupConcernJoinRequestParams:(NSDictionary *)params gid:(NSString *)gidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 取消常用讨论组
+ (void)groupConcernRemoveRequestParams:(NSDictionary *)params gid:(NSString *)gidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 常用讨论组列表
+ (void)groupConcernListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
/**
 设备
 */
// 添加设备
+ (void)addDeviceRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 编辑设备
+ (void)editDeviceRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 删除设备
+ (void)deleteDeviceRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 设备列表
+ (void)deviceListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
/**
 支付
 */
// 微信支付
+ (void)getWechatPay:(NSDictionary *)params signid:(NSString *)signid success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 用于微信支付结果订单验证成功与否
+ (void)wechatPayResult:(NSDictionary *)params signid:(NSString *)signid success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 请求栏目的计划 区分类型 视频的1
+ (void)requesetPlanChooseResult:(NSDictionary *)params signid:(NSString *)signid success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 我当前的计划 区分类型 视频的1
+ (void)requesetMyPlanChooseResult:(NSDictionary *)params signid:(NSString *)signid success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 请求历史订单
+ (void)historypayOrderResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 展示微信支付
+ (void)showTheWechatResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 用于是否进会
+ (void)canJoinTheMeetrequeset:(NSDictionary *)params typeId:(NSString *)typeId signid:(NSString *)signid success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

// 购买了免费的计划
+ (void)buyTheFreeorderWechatResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

// 我的钱包
+ (void)walletMineWechatResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 我的钱包充值
+ (void)walletAddMineWechatResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 我的钱包充值确认
+ (void)walletConfireMineWechatResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 我的钱包充值金额list请求
+ (void)walletAmountListResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 我的钱包余额
+ (void)walletmyWalletResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 我的钱包明细
+ (void)walletHistoryResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 充值确定是立即开通还是充值界面
+ (void)walletDredgeTimePlanResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 关闭计时计划
+ (void)walletCloseTimePlanResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 关闭计时计划服务
+ (void)walletCloseTimeServiceResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 免费计划详情介绍
+ (void)freeplanDetailResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 我的钱包充值下面的服务列表的list请求
+ (void)walletserverListResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;


/**
 新版本支付
 */
// 我的计划列表
+ (void)newPayPlanListResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 某个计划详情
+ (void)newPayPlanDetailResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 我当前的计划
+ (void)newPayNowPlanResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 计划和服务购买记录
+ (void)newPayPlanRecordResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 扩展服务列表
+ (void)newPayServiceListResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 某个服务的详情
+ (void)newPayServiceDetailResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 新微信支付
+ (void)newPayAppPayResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 新微信支付验证
+ (void)newPayPayVerifyResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 我的当前服务列表
+ (void)serviceCurrentListResult:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;


/**
 动态获取图片(首页和发现页的设备宣传图)
 */
// 首页
+ (void)firstPagePicturePay:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 发现
+ (void)findPagePicturePay:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 发现列表
+ (void)findListPicturePay:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

/**
 新版发现数据 广告和广告位
 */
// 广告
+ (void)advertiseSearchParams:(NSDictionary *)params user:(NSString *)userString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

// 广告位管理
+ (void)advertiseposilAllParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

// 广告位以及广告整个列表  目前用的接口
+ (void)advertAllParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

// 通过广告唯一id去查询广告详情
+ (void)advertSelectParams:(NSDictionary *)params aid:(NSString *)aidString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

// 发现页面广告轮播
+ (void)newFindPicturePay:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;


/**
 企业广场
 */
// 商铺套商品总列表 用于list展示
+ (void)companySquareListPay:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

// 搜索 商铺或者商品 get请求
+ (void)companySquareSearchParams:(NSDictionary *)params vague:(NSString *)vagueString dist:(NSString *)distString success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

// 商铺总列表
+ (void)companyShopListPay:(NSDictionary *)params adid:(NSString *)adidStr success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 商品总列表
+ (void)companyGoodListPay:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 店铺详情
+ (void)goodListDetailPay:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 提交表单 新用户申请加入
+ (void)submitContactPay:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 管理助手
+ (void)manageAssisRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

// 视频营销客服
+ (void)saleVideomanageAssisRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

// 上传营销的背景图片
+ (void)sendVMBackPicRequestParams:(NSDictionary *)params bodys:(BodysBlock)mainBodys progress:(ProgressBlock)mainProgress success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 发送反馈
+ (void)sendFeedBackRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

// 入会时候加入到群组IM
+ (void)addIMgroupMemberRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 会议文档列表
+ (void)confDocListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 上传文档
+ (void)confDocUploadRequestParams:(NSDictionary *)params bodys:(BodysBlock)mainBodys progress:(ProgressBlock)mainProgress success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 会议速记上传
+ (void)shorthandRecordRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 会议速记列表
+ (void)shorthandListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 会议速记详细列表
+ (void)shorthandDetailRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;


// 消息管理
+ (void)messageClassificationRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 查询消息下的具体列表
+ (void)messageDetailListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 要不要支付
+ (void)hidePlanRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 苹果pay
+ (void)inappPayRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 苹果pay列表
+ (void)inappPayListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 苹果pay服务列表
+ (void)servicelistforauditListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 苹果pay生成预订单
+ (void)inappPayGetorderRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 首页的跳转到查看消息
+ (void)homeMessageRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 首页的云空间列表
+ (void)cloudspaceClassRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 首页的云空间列表里面的详情列表
+ (void)cloudspaceDetailRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 首页的教学模式列表
+ (void)classmodelListRequestParams:(NSDictionary *)params iconid:(NSString *)iconid  success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 首页的教学模式列表里面的详情支付
+ (void)classmodelDetailpayRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 首页的教学模式列表里面支付
+ (void)classmodelgotopayRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

// 服务中心顶部栏目
+ (void)servicecenterSortlistRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 服务中心列表
+ (void)servicecenterlistRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 服务中心详情
+ (void)servicecenterinfoRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 首页的图片列表
+ (void)mainpagePicRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 同声传译列表
+ (void)interpreterListRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 知识店铺列表
+ (void)commodityInfoRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;
// 知识店铺购买
+ (void)priceServiceInfoRequestParams:(NSDictionary *)params success:(SuccessBlock)mainSuccess failure:(FailureBlock)mainFailure;

+ (void)cancelAllRequest;

@end
