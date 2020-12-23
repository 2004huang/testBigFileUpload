//
//  SIMEnterConf.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/9/21.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMEnterConfTool.h"
//#import <AVFoundation/AVFoundation.h>
//#import "SIMWXpayViewController.h"
@implementation SIMEnterConfTool
//
//// 输入会议密码弹出框进入会议
//+ (void)addAlertControllerWithCid:(NSString *)cid uid:(NSString *)uid name:(NSString *)name token:(NSString *)token psw:(NSString *)psw signID:(NSString *)signid viewController:(UIViewController<ConferenceApiDelegate> *)viewController {
//    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
//                                                                              message: SIMLocalizedString(@"EnterPutinPSW", nil)
//                                                                       preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = SIMLocalizedString(@"EnterPSWPlaceHolder", nil);
//        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        textField.secureTextEntry = YES;
//    }];
//
//    [alertController addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleDefault handler:nil]];
//    [alertController addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCOk", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        NSArray * textfields = alertController.textFields;
//        UITextField *passwordfiled = textfields[0];
//        if ([passwordfiled.text isEqualToString:psw]) {
//            [self transferVideoMethodWithUid:uid name:name token:token confID:cid psw:psw signID:signid viewController:viewController];
//        }else {
//            [MBProgressHUD cc_showText:SIMLocalizedString(@"Enter_psw_putinRight", nil)];
//        }
//    }]];
//    [viewController presentViewController:alertController animated:YES completion:nil];
//}
//
//
//// 召开会议 --- 注册用户 非匿名
////
//+ (void)transferVideoMethodWithUid:(NSString *)uid name:(NSString *)name token:(NSString *)token confID:(NSString *)confID psw:(NSString *)psw  signID:(NSString *)signid viewController:(UIViewController<ConferenceApiDelegate> *)viewController {
//    //signid指的是我的会议1 直播2  视频客服3 视频营销4
//
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    if (!manager.reachable) {
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"ENTER_NETWORK_NO_CONNECT", nil)];
//        return ;
//    }
//    if (confID.length == 0) {
//        // 说明没获取到confID  那么先不仅会
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERR_CONF_NoConfIDRequest", nil)];
//        return ;
//    }
//    if (psw == nil) {
//        // 说明没获取到confID  那么先不仅会
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERR_CONF_NoPSWRequest", nil)];
//        return ;
//    }
//
//    // 如果没有登录会议服务器成功 那么不可以入会
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loginConfServerSuccess"] == NO) {
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERR_CONF_NoConfIDRequest", nil)];
//        return ;
//    }
//
//    // 区分上线与否 隐藏支付内容
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"] == YES) {
//        // 上线了 显示支付相关
//        [MainNetworkRequest canJoinTheMeetrequeset:nil typeId:@"IOS" signid:signid success:^(id success) {
//            NSLog(@"canshowtheWechatDic%@",success);
//            if ([success[@"status"] isEqualToString:@"ok"]) {
//                //"yes":不跳窗，"no": 跳窗
//                if ([success[@"is_pay"] isEqualToString:@"yes"]) {
//
//                    //******************  登录后入会的流程 第二部 入会 ****************
//                    //    点击了进入的按钮
//                    [MBProgressHUD cc_showLoading:nil delay:8];
//                    if ([signid isEqualToString:@"1"]) {
//                        // 全部进会
//                        [[ConferenceApi sharedInstance] enterConfWithConfID:confID.longLongValue password:psw andDelegateVC:viewController];
//                    }else {
//                        // 直播 调用直播的接口
//                        [[ConferenceApi sharedInstance] enterLiveWithConfID:confID.longLongValue password:psw andDelegateVC:viewController];
//
//                    }
//
//                }else {
//                    // 说明不是付费用户  那么进入支付
//                    SIMWXpayViewController*payVC = [[SIMWXpayViewController alloc] init];
//                    payVC.pageIndex = [signid intValue] - 1;
//                    [viewController.navigationController pushViewController:payVC animated:YES];
//                }
//            }else {
//                [MBProgressHUD cc_showText:SIMLocalizedString(@"ERR_CONF_NoConfIDRequest", nil)];
//            }
//
//        } failure:^(id failure) {
//            [MBProgressHUD cc_showText:SIMLocalizedString(@"ERR_CONF_NoConfIDRequest", nil)];
//        }];
//
//    }else {
//        // 没上线 隐藏支付相关 没上线直接进会
//        //******************  登录后入会的流程 第二部 入会 ****************
//        //    点击了进入的按钮
//        [MBProgressHUD cc_showLoading:nil delay:8];
//        if ([signid isEqualToString:@"1"]) {
//            // 全部进会
//            [[ConferenceApi sharedInstance] enterConfWithConfID:confID.longLongValue password:psw andDelegateVC:viewController];
//
//        }else {
//            // 直播 调用直播的接口
//            [[ConferenceApi sharedInstance] enterLiveWithConfID:confID.longLongValue password:psw andDelegateVC:viewController];
//        }
//    }
//
//
//
//
////    [[ConferenceApi sharedInstance] quickEnterConfWithUserId:uid userName:name token:token confId:confID confPsw:psw withDelegateVC:viewController];
//}
//
//// 召开会议 --- 注册用户 非匿名  被动入会
//+ (void)hadJoinTheVideoMethodWithUid:(NSString *)uid name:(NSString *)name token:(NSString *)token confID:(NSString *)confID psw:(NSString *)psw viewController:(UIViewController<ConferenceApiDelegate> *)viewController {
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    if (!manager.reachable) {
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"ENTER_NETWORK_NO_CONNECT", nil)];
//        return ;
//    }
//    if (confID.length == 0) {
//        // 说明没获取到confID  那么先不仅会
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERR_CONF_NoConfIDRequest", nil)];
//        return ;
//    }
//    if (psw == nil) {
//        // 说明没获取到confID  那么先不仅会
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERR_CONF_NoPSWRequest", nil)];
//        return ;
//    }
//
//    // 如果没有登录会议服务器成功 那么不可以入会
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loginConfServerSuccess"] == NO) {
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERR_CONF_NoConfIDRequest", nil)];
//        return ;
//    }
//
//    //    点击了进入的按钮
//    [MBProgressHUD cc_showLoading:nil delay:8];
//
//    //******************  登录后入会的流程 第二部 入会 ****************
//    [[ConferenceApi sharedInstance] enterConfWithConfID:confID.longLongValue password:psw andDelegateVC:viewController];
//}
//// 点对点呼叫
//+ (void)callTheVideoMethodWithUid:(NSString *)uid name:(NSString *)name token:(NSString *)token confID:(NSString *)confID psw:(NSString *)psw viewController:(UIViewController<ConferenceApiDelegate> *)viewController {
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    if (!manager.reachable) {
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"ENTER_NETWORK_NO_CONNECT", nil)];
//        return ;
//    }
//    if (confID.length == 0) {
//        // 说明没获取到confID  那么先不仅会
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERR_CONF_NoConfIDRequest", nil)];
//        return ;
//    }
//    if (psw == nil) {
//        // 说明没获取到confID  那么先不仅会
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERR_CONF_NoPSWRequest", nil)];
//        return ;
//    }
//
//    // 如果没有登录会议服务器成功 那么不可以入会
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loginConfServerSuccess"] == NO) {
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERR_CONF_NoConfIDRequest", nil)];
//        return ;
//    }
//
//    //    点击了进入的按钮
//    [MBProgressHUD cc_showLoading:nil delay:8];
//
//    [[ConferenceApi sharedInstance] enterVideoChatWithConfID:confID.longLongValue password:psw andDelegateVC:viewController];
//}
//
//// 召开会议 --- 匿名
//+ (void)quickEnterConfWithUid:(NSString *)uid name:(NSString *)name token:(NSString *)token confID:(NSString *)confID psw:(NSString *)psw viewController:(UIViewController<ConferenceApiDelegate> *)viewController {
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    if (!manager.reachable) {
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"ENTER_NETWORK_NO_CONNECT", nil)];
//        return ;
//    }
//    //    点击了进入的按钮
//    [MBProgressHUD cc_showLoading:nil delay:8];
//
//    //******************  快速入会的流程 ****************
//    [[ConferenceApi sharedInstance] quickEnterConfWithUserId:uid userName:name token:token confId:confID confPsw:psw withDelegateVC:viewController];
//}
//
//+ (BOOL)avauthorizationStatusWithViewController:(UIViewController *)viewcontroller {
//    // 判断相机权限
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
//        // 没有权限
//        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:SIMLocalizedString(@"Enter_Info_Video", nil) message:SIMLocalizedString(@"Enter_Info_Video_None", nil) preferredStyle:UIAlertControllerStyleAlert];
//        [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCSet", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            //跳入当前App设置界面,
//            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//            if( [[UIApplication sharedApplication]canOpenURL:url] ) {
//                [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:^(BOOL        success) {
//                }];
//            }
//        }]];
//        [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleDefault handler:nil]];
//        [viewcontroller presentViewController:alertView animated:YES completion:nil];
//        return NO;
//    }
//    return YES;
//}
//
//// 从本地拿出密码
//+ (NSString *)passWordFromUserDefaults {
//    // 自己进入自己的会议 将本地存储二进制model 拿出存储的normal_password密码
//    NSData *dataa = [[NSUserDefaults standardUserDefaults] objectForKey:@"MYCONF"];
//    NSString *strin = [[NSString alloc] initWithData:dataa encoding:NSUTF8StringEncoding];
//    NSData *datastr = [strin dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *dd = [NSJSONSerialization JSONObjectWithData:datastr options:NSJSONReadingMutableLeaves error:nil];
//    return [dd objectForKey:@"normal_password"];
//}
//
//// 第一步--登录服务器
//
//-(void)conferenceApiDelegateOnConnectResponseWithType:(ConnectResponseType)type {
//    NSLog(@"----退回实现的会掉方法-----");
//}
//
//
///**
// *  呼叫功能
// */
//
//// 邀请入会 -- 同时自己入会
//+ (void)inviteJoinTheConfWithConfID:(NSString *)confID
//                            confPsd:(NSString *)confPsd
//                            title:(NSString *)title
//                            inviteUserId:(NSString *)inviteUserId
//                          inviteUserName:(NSString *)inviteUserName
//            thenQuickEnterConfWithUserId:(NSString *)userId
//                                userName:(NSString *)userName
//                                   token:(NSString *)token
//                     viewController:(UIViewController<ConferenceApiDelegate> *)viewController {
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    if (!manager.reachable) {
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"ENTER_NETWORK_NO_CONNECT", nil)];
//        return ;
//    }
//    //    点击了进入的按钮
////    [MBProgressHUD cc_showLoading:nil delay:8];
//    [[ConferenceApi sharedInstance] inviteJoinConfWithConfID:confID.longLongValue confPsd:confPsd title:title canRefuseInvite:YES inviteUserId:inviteUserId inviteUserName:inviteUserName thenQuickEnterConfWithUserId:userId userName:userName token:token withDelegateVC:viewController];
//
//}
//
//// 响应呼叫
//+ (void)responInviteWithConfID:(NSString *)confID inviteResult:(ResponseConfInviteType)inviteResult srcUserID:(NSString *)srcUserID {
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    if (!manager.reachable) {
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"ENTER_NETWORK_NO_CONNECT", nil)];
//        return ;
//    }
//    //    点击了进入的按钮
////    [MBProgressHUD cc_showLoading:nil delay:8];
//    [[ConferenceApi sharedInstance] responseConfInviteWithConfID:confID.longLongValue inviteResult:inviteResult srcUserID:srcUserID.longLongValue];
//}
//
//
//// 邀请入会 -- 不自动入会
//+ (void)inviteJoinConfWithConfID:(NSString *)confID confPsd:(NSString *)confPsd title:(NSString *)title canRefuseInvite:(BOOL)canRefuseInvite inviteUserId:(NSString *)userId andUserName:(NSString *)userName withDelegateVC:(UIViewController<ConferenceApiDelegate> *)delegateVC {
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    if (!manager.reachable) {
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"ENTER_NETWORK_NO_CONNECT", nil)];
//        return ;
//    }
//    [[ConferenceApi sharedInstance] inviteJoinConfWithConfID:confID.longLongValue confPsd:confPsd title:title canRefuseInvite:canRefuseInvite inviteUserId:userId andUserName:userName withDelegateVC:delegateVC];
//}
//
//
//// 取消邀请
//+ (void)cancelInviteJoinConfWithConfID:(NSString *)confID inviteUserID:(NSString *)inviteUserID {
//    [[ConferenceApi sharedInstance] cancelInviteJoinConfWithConfID:confID.longLongValue inviteUserID:inviteUserID.longLongValue];
//}
//



@end
