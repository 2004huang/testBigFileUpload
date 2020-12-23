//
//  SIMEnterConf.h
//  Kaihuibao
//
//  Created by 王小琪 on 2017/9/21.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIMEnterConfTool : NSObject
//<ConferenceApiDelegate>

// 加弹出框输入密码的进会
+ (void)addAlertControllerWithCid:(NSString *)cid uid:(NSString *)uid name:(NSString *)name token:(NSString *)token psw:(NSString *)psw signID:(NSString *)signid viewController:(UIViewController *)viewController;
// 召开会议 --- 注册用户 非匿名
//
+ (void)transferVideoMethodWithUid:(NSString *)uid name:(NSString *)name token:(NSString *)token confID:(NSString *)confID psw:(NSString *)psw signID:(NSString *)signid  viewController:(UIViewController *)viewController;
// 召开会议 --- 匿名
+ (void)quickEnterConfWithUid:(NSString *)uid name:(NSString *)name token:(NSString *)token confID:(NSString *)confID psw:(NSString *)psw viewController:(UIViewController *)viewController;
// 被动入会
+ (void)hadJoinTheVideoMethodWithUid:(NSString *)uid name:(NSString *)name token:(NSString *)token confID:(NSString *)confID psw:(NSString *)psw viewController:(UIViewController *)viewController;
// 点对点呼叫
+ (void)callTheVideoMethodWithUid:(NSString *)uid name:(NSString *)name token:(NSString *)token confID:(NSString *)confID psw:(NSString *)psw viewController:(UIViewController *)viewController;

// 是否开启相机权限
+ (BOOL)avauthorizationStatusWithViewController:(UIViewController *)viewcontroller;

// 从本地拿出密码
+ (NSString *)passWordFromUserDefaults;

// 查询服务器地址
//+ (void)searchTheServer;


/**
 *  呼叫功能
 */

// 邀请入会 -- 同时自己入会
+ (void)inviteJoinTheConfWithConfID:(NSString *)confID
                            confPsd:(NSString *)confPsd
                              title:(NSString *)title
                       inviteUserId:(NSString *)inviteUserId
                     inviteUserName:(NSString *)inviteUserName
       thenQuickEnterConfWithUserId:(NSString *)userId
                           userName:(NSString *)userName
                              token:(NSString *)token
                     viewController:(UIViewController *)viewController;

//// 被邀请者 -- 同意或者拒绝入会等
//+ (void)responInviteWithConfID:(NSString *)confID inviteResult:(ResponseConfInviteType)inviteResult srcUserID:(NSString *)srcUserID;
//
//// 邀请入会 -- 不自动入会
//+ (void)inviteJoinConfWithConfID:(NSString *)confID confPsd:(NSString *)confPsd title:(NSString *)title canRefuseInvite:(BOOL)canRefuseInvite inviteUserId:(NSString *)userId andUserName:(NSString *)userName withDelegateVC:(UIViewController<ConferenceApiDelegate> *)delegateVC;
//
//// 取消邀请
// + (void)cancelInviteJoinConfWithConfID:(NSString *)confID inviteUserID:(NSString *)inviteUserID;




@end
