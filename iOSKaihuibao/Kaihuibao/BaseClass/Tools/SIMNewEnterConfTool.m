//
//  SIMNewEnterConfTool.m
//  Kaihuibao
//
//  Created by mac126 on 2019/3/29.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMNewEnterConfTool.h"

#import "SIMWXpayViewController.h"
#import "SIMNewMainPayViewController.h"
#import "SIMConfConfig.h"
#import "SIMEnterConfMessageViewController.h"
#import "SIMWalletMainViewController.h"
#import "SIMVersionUpdateModel.h"
#import "SIMEnterConfPayAlertView.h"
#import "SIMMessNotifListViewController.h"
#import "SIMLoginMainViewController.h"
#import "SIMNewWalletViewController.h"

//static dispatch_group_t _groupEnter;

//static UIView *backView;
@interface SIMNewEnterConfTool()
//@property (nonatomic, strong) SIMEnterConfPayAlertView *confpayAlertView;
//@property (nonatomic, strong) UIView *backView;// 蒙层
@end
static BOOL isNoTokenJoin; // 未登录时候 yes是未登录进会 no是有token进会

@implementation SIMNewEnterConfTool
// sdk进会方法
+ (void)enterSDKConfWithUID:(NSString *)uid Cid:(NSString *)cidStr name:(NSString *)nameStr needOpenLocalAudio:(BOOL)needOpenLocalAudio needOpenLocalVideo:(BOOL)needOpenLocalVideo confMessage:(NSDictionary *)confmessage  viewController:(UIViewController<CLConferenceDelegate> *)viewController success:(SuccessBaseBlock)successBase failure:(FailureBaseBlock)failureBase {

    if ([confmessage[@"lock"] intValue] == 1 && [confmessage[@"isCreateUser"] intValue] == 0) {
        // 会议是否锁定（0：未锁定，1：锁定）是否是会议的创建者（0：不是创建者，1：会议创建者）
//        [MBProgressHUD cc_showText:@"会议已被主持人加锁"];
        [self pushAlertWithTitle:SIMLocalizedString(@"ERR_CONF_OTHER", nil) message:SIMLocalizedString(@"ERR_CONF_ALREADYLOCK", nil) viewController:viewController];
        return ;
    }
    SIMConfConfig *confConfig = [[SIMConfConfig alloc] initWithDictionary:confmessage];
    if ([confmessage[@"isCreateUser"] intValue] == 1) {
        // 如果相同 那么就是用主持人判断
        confConfig.isNeedOpenVideo = ([confmessage[@"mainVideo"] intValue] == 1 && needOpenLocalVideo == YES)?YES:NO;
//        confConfig.isNeedOpenAudio = ([confmessage[@"mainAudio"] intValue] == 1 && needOpenLocalAudio == YES)?YES:NO;
    }else {
        // 如果不相同 那么就是用参会者判断
        confConfig.isNeedOpenVideo = ([confmessage[@"participantVideo"] intValue] == 1 && needOpenLocalVideo == YES)?YES:NO;
    }
    confConfig.isSpeaker = YES;// 是否开启扬声器 默认yes
    confConfig.isNeedMLST = NO;
    confConfig.isNeedCS = NO;
    confConfig.isNeedLT = NO;
    NSLog(@"confConfigconfConfigs %@ %@",confConfig,uid);
//    confConfig.conf_URL = @"https://192.168.4.154:4443";
    NSString *shareUrlStr = [NSString stringWithFormat:@"%@/admin/conference/joinmeeting?m=%@&ref=%@&timetap=%@",kApiBaseUrl,confConfig.conf_id,[NSString stringWithFormat:@"iOS%@",getApp_Version],[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]];
    confConfig.invite_URL = shareUrlStr;
    confConfig.doc_URL = confmessage[@"webUrl"];
    confConfig.isNeedInvite = !isNoTokenJoin;
    
    NSString *bundleIDStr = [NSString stringWithFormat:@"%@.ScreenRecorder",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]];
    confConfig.broadcastExtensionBundleID = bundleIDStr;
    confConfig.appGroupIdentifier = @"group.kaihuibao.screenrecorder";
//    NSInteger resolution = [[NSUserDefaults standardUserDefaults] integerForKey:@"confConfig.resolution"];
//    confConfig.resolution = resolution;
    
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
    confConfig.token = tokenStr;
    
    [[CLConference conference] configurationConference:confConfig];
    CLOwn *user = [CLOwn createOwn:uid nick:nameStr forceH264:NO];
    
    
    if ([confmessage[@"confMode"] isEqualToString:@"EHSfieldOperation"]) {
        // 会议模式是EHS
        [[CLConference conference] enterEHS:user delegate:viewController callback:^(NSError * _Nonnull error) {
            NSLog(@"enterEHSconferror%@",error);
            if (error == nil) {
                NSLog(@"进入成功");
                successBase(error);
            }else {
                [self pushAlertWithTitle:SIMLocalizedString(@"ERR_CONF_OTHER", nil) message:[NSString stringWithFormat:@"%@",error] viewController:viewController];
                NSLog(@"进会失败 %@",error);
                failureBase(error);
            }
        }];
    }
    else if ([confmessage[@"confMode"] isEqualToString:@"intercom"]) {
        // 会议模式是对讲模式时候 要吧进会成功的人员加入到这个群组里
        [[CLConference conference] enterConf:user delegate:viewController callback:^(NSError * _Nonnull error) {
            //        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
            NSLog(@"enterconferror%@",error);
            if (error == nil) {
                NSLog(@"进入成功");
                [self addIMGroupsWithConfID:cidStr username:self.currentUser.username];
                successBase(error);
            }else {
                [self pushAlertWithTitle:SIMLocalizedString(@"ERR_CONF_OTHER", nil) message:[NSString stringWithFormat:@"%@",error] viewController:viewController];
                //            [MBProgressHUD cc_showText:[NSString stringWithFormat:@"进会失败 %@",error]];
                NSLog(@"进会失败 %@",error);
                failureBase(error);
            }
        }];
    }
    else {
        // 普通会议模式
        [[CLConference conference] enterConf:user delegate:viewController callback:^(NSError * _Nonnull error) {
            //        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
            NSLog(@"enterconferror%@",error);
            if (error == nil) {
                NSLog(@"进入成功");
                successBase(error);
            }else {
                [self pushAlertWithTitle:SIMLocalizedString(@"ERR_CONF_OTHER", nil) message:[NSString stringWithFormat:@"%@",error] viewController:viewController];
                //            [MBProgressHUD cc_showText:[NSString stringWithFormat:@"进会失败 %@",error]];
                NSLog(@"进会失败 %@",error);
                failureBase(error);
            }
        }];
    }
    
    
}

+ (void)clickEnterConfSumCountWithDataMsg:(NSDictionary *)dataDic viewController:(UIViewController<CLConferenceDelegate> *)viewController result:(void (^)(BOOL isOK))result {
    NSString *enteryMsg = dataDic[@"entery_msg"];
    NSString *enteryTxt = dataDic[@"entery_txt"];
    NSDictionary *enteryDic = dataDic[@"entery_data"];
    if (dataDic[@"entery_data"] == nil) {
        if ([enteryMsg isEqualToString:@"entry"]) {
            result (YES);
        }else if ([enteryMsg isEqualToString:@"create"]) {
            // 参会者进入到创建者的会议室 创建者未支付 去通知
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:enteryTxt preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"去通知" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SIMEnterConfMessageViewController *messageVC = [[SIMEnterConfMessageViewController alloc] init];
                UIViewController *navc = [messageVC sim_wrappedByNavigationViewControllerClass:[SIMBaseNavigationViewController class]];
                navc.modalPresentationStyle = 0;
                [viewController presentViewController:navc animated:YES completion:nil];
            }]];
            [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

            }]];
            [viewController presentViewController:alertView animated:YES completion:nil];

            result (NO);
        }else if ([enteryMsg isEqualToString:@"payment"] || [enteryMsg isEqualToString:@"current"] || [enteryMsg isEqualToString:@"overdue"]) {
            NSString *string;
            if ([enteryMsg isEqualToString:@"payment"]) {
                string = @"立即升级";
            }else if ([enteryMsg isEqualToString:@"current"]) {
                string = @"立即升级";
            } else if ([enteryMsg isEqualToString:@"overdue"]) {
                string = @"立即续费";
            }
            // 创建者自己就没有付费 去支付
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:enteryTxt preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:string style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SIMNewMainPayViewController *planVC = [[SIMNewMainPayViewController alloc] init];
                planVC.isConfVC = YES;
                UIViewController *navc = [planVC sim_wrappedByNavigationViewControllerClass:[SIMBaseNavigationViewController class]];
                navc.modalPresentationStyle = 0;
                [viewController presentViewController:navc animated:YES completion:nil];
    //            SIMNewMainPayViewController *planVC = [[SIMNewMainPayViewController alloc] init];
    //
    //            [viewController.navigationController pushViewController:planVC animated:YES];
            }]];
            [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

            }]];
            [viewController presentViewController:alertView animated:YES completion:nil];
            result (NO);
        }else if ([enteryMsg isEqualToString:@"recharge"]) {
            // 充值
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:enteryTxt preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"立即充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SIMWalletMainViewController *walletVC = [[SIMWalletMainViewController alloc] init];
                walletVC.isConfVC = YES;
                UIViewController *navc = [walletVC sim_wrappedByNavigationViewControllerClass:[SIMBaseNavigationViewController class]];
                navc.modalPresentationStyle = 0;
                [viewController presentViewController:navc animated:YES completion:nil];
    //            [viewController.navigationController pushViewController:planVC animated:YES];
            }]];
            [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

            }]];
            [viewController presentViewController:alertView animated:YES completion:nil];
            result (NO);
        }else if ([enteryMsg isEqualToString:@"soon"]) {
            // 快过期了
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:enteryTxt preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"立即续费" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SIMNewMainPayViewController *planVC = [[SIMNewMainPayViewController alloc] init];
                planVC.isConfVC = YES;
                UIViewController *navc = [planVC sim_wrappedByNavigationViewControllerClass:[SIMBaseNavigationViewController class]];
                navc.modalPresentationStyle = 0;
                [viewController presentViewController:navc animated:YES completion:nil];
                result (NO);
            }]];
            [alertView addAction:[UIAlertAction actionWithTitle:@"进入会议" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                result (YES);
            }]];
            [viewController presentViewController:alertView animated:YES completion:nil];

        }else {
            result (YES);
        }
    }else {
        // 新接口
        NSLog(@"新接口的支付");
        if ([enteryMsg isEqualToString:@"entry"]) {
            result (YES);
        }else {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            
            UIView *backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            backView.backgroundColor = [UIColor blackColor];
            backView.alpha = 0.2;
            backView.tag = 30001;
            [window addSubview:backView];
            NSLog(@"window添加了backView");
            UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
            [backView addGestureRecognizer:tapG];
            
            SIMEnterConfPayAlertView *confpayAlertView = [[SIMEnterConfPayAlertView alloc] init];
            confpayAlertView.dicM = enteryDic;
            confpayAlertView.tag = 30002;
            [window addSubview:confpayAlertView];
            NSLog(@"window添加了confpayAlertView");
            [confpayAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.left.mas_equalTo(kWidthScale(10));
                make.right.mas_equalTo(-kWidthScale(10));
            }];
            __weak typeof(self)weakSelf = self;
            // 保存按钮方法
            confpayAlertView.buttonSerialBlock = ^(NSString * _Nonnull serial) {
                [weakSelf tapClick];
                NSLog(@"serialString %@",serial);
                if ([serial isEqualToString:@"entry"]) {
                    result (YES);
                }else if ([serial isEqualToString:@"cancel"]) {
                    result (NO);
                }else if ([serial isEqualToString:@"notice"]) {
                    // 去通知
                    SIMEnterConfMessageViewController *messageVC = [[SIMEnterConfMessageViewController alloc] init];
                    UIViewController *navc = [messageVC sim_wrappedByNavigationViewControllerClass:[SIMBaseNavigationViewController class]];
                    navc.modalPresentationStyle = 0;
                    [viewController presentViewController:navc animated:YES completion:nil];
                    result (NO);
                }else if (isNoTokenJoin && ![self.cloudVersion.version isEqualToString:@"privatization"]) {
                    // 去登陆页面 // 公有
                    [viewController dismissViewControllerAnimated:NO completion:^{
                        UIViewController *loginNVC = [[[SIMLoginMainViewController alloc] init] sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
                        loginNVC.modalPresentationStyle = 0;
                        [windowRootViewController presentViewController:loginNVC animated:YES completion:nil];
                    }];
                    result (NO);
                }else if ([serial isEqualToString:@"wallet"]) {
                    // 钱包
                    SIMNewWalletViewController *walletVC = [[SIMNewWalletViewController alloc] init];
                    walletVC.isConfVC = YES;
                    UIViewController *navc = [walletVC sim_wrappedByNavigationViewControllerClass:[SIMBaseNavigationViewController class]];
                    navc.modalPresentationStyle = 0;
                    [viewController presentViewController:navc animated:YES completion:nil];
                    result (NO);
                }else if ([serial isEqualToString:@"recharge"]) {
                    // 充值
                    SIMWalletMainViewController *rechargeVC = [[SIMWalletMainViewController alloc] init];
                    rechargeVC.isConfVC = YES;
                    UIViewController *navc = [rechargeVC sim_wrappedByNavigationViewControllerClass:[SIMBaseNavigationViewController class]];
                    navc.modalPresentationStyle = 0;
                    [viewController presentViewController:navc animated:YES completion:nil];
                    result (NO);
                }else if ([serial isEqualToString:@"plan"]) {
                    // 计划
                    SIMNewMainPayViewController *planVC = [[SIMNewMainPayViewController alloc] init];
                    planVC.isConfVC = YES;
                    UIViewController *navc = [planVC sim_wrappedByNavigationViewControllerClass:[SIMBaseNavigationViewController class]];
                    navc.modalPresentationStyle = 0;
                    [viewController presentViewController:navc animated:YES completion:nil];
                    result (NO);
                }else if ([serial isEqualToString:@"welfare"]) {
                    SIMMessNotifListViewController *messVC = [[SIMMessNotifListViewController alloc] init];
                    messVC.title = SIMLocalizedString(@"WellBeingTitle", nil);
                    messVC.isConfVC = YES;
                    UIViewController *navc = [messVC sim_wrappedByNavigationViewControllerClass:[SIMBaseNavigationViewController class]];
                    navc.modalPresentationStyle = 0;
                    [viewController presentViewController:navc animated:YES completion:nil];
                    result (NO);
                }else {
                    result (NO);
                }
            };
            confpayAlertView.cancelClick = ^{
                [weakSelf tapClick];
                result (NO);
            };
//            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:enteryDic[@"prompt_text"] preferredStyle:UIAlertControllerStyleAlert];
//            if ([enteryDic[@"left_button_jump"] isEqualToString:@"cancel"]) {
//                [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    result (NO);
//                }]];
//            }else {
//                [alertView addAction:[UIAlertAction actionWithTitle:enteryDic[@"left_button_text"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    if ([enteryDic[@"left_button_jump"] isEqualToString:@"entry"]) {
//                        result (YES);
//                    }else if ([enteryDic[@"left_button_jump"] isEqualToString:@"wallet"]) {
//                        // 充值
//                        SIMWalletMainViewController *walletVC = [[SIMWalletMainViewController alloc] init];
//                        walletVC.isConfVC = YES;
//                        UIViewController *navc = [walletVC sim_wrappedByNavigationViewControllerClass:[SIMBaseNavigationViewController class]];
//                        navc.modalPresentationStyle = 0;
//                        [viewController presentViewController:navc animated:YES completion:nil];
//                        result (NO);
//                    }else if ([enteryDic[@"left_button_jump"] isEqualToString:@"plan"]) {
//                        SIMNewMainPayViewController *planVC = [[SIMNewMainPayViewController alloc] init];
//                        planVC.isConfVC = YES;
//                        UIViewController *navc = [planVC sim_wrappedByNavigationViewControllerClass:[SIMBaseNavigationViewController class]];
//                        navc.modalPresentationStyle = 0;
//                        [viewController presentViewController:navc animated:YES completion:nil];
//                        result (NO);
//                    }else if ([enteryDic[@"left_button_jump"] isEqualToString:@"notice"]) {
//                        SIMEnterConfMessageViewController *messageVC = [[SIMEnterConfMessageViewController alloc] init];
//                        UIViewController *navc = [messageVC sim_wrappedByNavigationViewControllerClass:[SIMBaseNavigationViewController class]];
//                        navc.modalPresentationStyle = 0;
//                        [viewController presentViewController:navc animated:YES completion:nil];
//                        result (NO);
//                    }else {
//                        result (NO);
//                    }
//                }]];
//            }
            
//            if ([enteryDic[@"right_button_jump"] isEqualToString:@"cancel"]) {
//                [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    result (NO);
//                }]];
//            }else {
//                [alertView addAction:[UIAlertAction actionWithTitle:enteryDic[@"right_button_text"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    if ([enteryDic[@"right_button_jump"] isEqualToString:@"entry"]) {
//                        result (YES);
//                    }else if ([enteryDic[@"right_button_jump"] isEqualToString:@"wallet"]) {
//                        // 充值
//                        SIMWalletMainViewController *walletVC = [[SIMWalletMainViewController alloc] init];
//                        walletVC.isConfVC = YES;
//                        UIViewController *navc = [walletVC sim_wrappedByNavigationViewControllerClass:[SIMBaseNavigationViewController class]];
//                        navc.modalPresentationStyle = 0;
//                        [viewController presentViewController:navc animated:YES completion:nil];
//                        result (NO);
//                    }else if ([enteryDic[@"right_button_jump"] isEqualToString:@"plan"]) {
//                        SIMNewMainPayViewController *planVC = [[SIMNewMainPayViewController alloc] init];
//                        planVC.isConfVC = YES;
//                        UIViewController *navc = [planVC sim_wrappedByNavigationViewControllerClass:[SIMBaseNavigationViewController class]];
//                        navc.modalPresentationStyle = 0;
//                        [viewController presentViewController:navc animated:YES completion:nil];
//                        result (NO);
//                    }else if ([enteryDic[@"right_button_jump"] isEqualToString:@"notice"]) {
//                        SIMEnterConfMessageViewController *messageVC = [[SIMEnterConfMessageViewController alloc] init];
//                        UIViewController *navc = [messageVC sim_wrappedByNavigationViewControllerClass:[SIMBaseNavigationViewController class]];
//                        navc.modalPresentationStyle = 0;
//                        [viewController presentViewController:navc animated:YES completion:nil];
//                        result (NO);
//                    }else {
//                        result (NO);
//                    }
//
//                }]];
//            }
//            [viewController presentViewController:alertView animated:YES completion:nil];
            
        }
    }
    
    
}
// 会议配置查询接口
+ (void)configRequestConfWithUID:(NSString *)uidStr Cid:(NSString *)cidStr webStr:(NSString *)webStr name:(NSString *)nameStr needOpenLocalAudio:(BOOL)needOpenLocalAudio needOpenLocalVideo:(BOOL)needOpenLocalVideo  viewController:(UIViewController<CLConferenceDelegate> *)viewController success:(SuccessConfigBlock)successBase failure:(FailureConfigBlock)failureBase cidMessage:(ConfMessageBlock)confmessage {
    NSLog(@"进入到视频会议配置查询接口");
    [MBProgressHUD cc_showLoading:nil];
    [MainNetworkRequest configConfRequestParams:@{@"conf_id":cidStr} webStr:webStr success:^(id success) {
        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
        NSLog(@"successConfIDRequest %@ webStr %@ cidStr %@",success,webStr,cidStr);
        if ([success[@"code"] integerValue] == successCodeOK) {
            NSDictionary *dataDic = success[@"data"];
            
            [self clickEnterConfSumCountWithDataMsg:dataDic viewController:viewController result:^(BOOL isOK) {
                if (!isOK) {
                    NSLog(@"需要进入支付页面提示框");
                } else {
                    NSLog(@"已经都支付过了可以进入会议界面");
                    // 未登录就加入会议时候 如果会议配置是拿到的是对讲 那么就要提示弹框
                        if (isNoTokenJoin && [dataDic[@"confMode"] isEqualToString:@"intercom"]) {
                            [self pushAlertWithTitle:SIMLocalizedString(@"ERR_CONF_OTHER", nil) message:SIMLocalizedString(@"ERR_CONF_NoLoginConfServer", nil) viewController:viewController];
                            return ;
                        }
                        // 是否需要密码（1：需要密码，0：不需要密码）
                        if ([dataDic[@"neednormalPassword"] intValue] == 1) {
                            NSString *confidSTR = dataDic[@"conf_id"];
                            // 弹框需要用户输入密码
                            UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
                                                                                                      message: SIMLocalizedString(@"EnterPutinPSW", nil)
                                                                                               preferredStyle:UIAlertControllerStyleAlert];
                            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                                textField.placeholder = SIMLocalizedString(@"EnterPSWPlaceHolder", nil);
                                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                                textField.secureTextEntry = YES;
                            }];

                            [alertController addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleDefault handler:nil]];
                            [alertController addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCOk", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                NSArray * textfields = alertController.textFields;
                                UITextField *passwordfiled = textfields[0];
                                // 请求验证用户输入的密码是否正确
                                [self verifyPSWConfRequestWithUID:uidStr Cid:confidSTR psw:passwordfiled.text name:nameStr needOpenLocalAudio:needOpenLocalAudio needOpenLocalVideo:needOpenLocalVideo confMessage:dataDic viewController:viewController success:^(id  _Nonnull success) {
                                    successBase(success);
                                    confmessage(dataDic);
                                } failure:^(id  _Nonnull failure) {
                                    failureBase(failure);
                                }];

                            }]];
                            [viewController presentViewController:alertController animated:YES completion:nil];

                        }else {
                            // 入会
                            //                [self enterSDKConfWithUID:uidStr Cid:cidStr name:nameStr needOpenLocalAudio:needOpenLocalAudio needOpenLocalVideo:needOpenLocalVideo viewController:viewController];
                            [self enterSDKConfWithUID:uidStr Cid:cidStr name:nameStr needOpenLocalAudio:needOpenLocalAudio needOpenLocalVideo:needOpenLocalVideo  confMessage:dataDic viewController:viewController success:^(id  _Nonnull success) {
                                successBase(success);
                                confmessage(dataDic);
                            } failure:^(id  _Nonnull failure) {
                                failureBase(failure);
                            }];
                        }
                }
            }];
        }else {
            [self pushAlertWithTitle:SIMLocalizedString(@"ERR_CONF_OTHER", nil) message:success[@"msg"] viewController:viewController];
        }
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OneConfServerAdress"];
        [[NSUserDefaults standardUserDefaults] synchronize];// 如果是链接入会 那么存储本地 当进会不管成功失败 都删掉本地的 一次性服务器
            
    } failure:^(id failure) {
        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
        [self pushAlertWithTitle:SIMLocalizedString(@"ERR_CONF_OTHER", nil) message:SIMLocalizedString(@"NETWORK_error_other", nil) viewController:viewController];
        //        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OneConfServerAdress"];
        [[NSUserDefaults standardUserDefaults] synchronize];// 如果是链接入会 那么存储本地 当进会不管成功失败 都删掉本地的 一次性服务器
    }];
//    }
}

// 验证入会密码
+ (void)verifyPSWConfRequestWithUID:(NSString *)uidStr Cid:(NSString *)cidStr psw:(NSString *)psw name:(NSString *)nameStr needOpenLocalAudio:(BOOL)needOpenLocalAudio needOpenLocalVideo:(BOOL)needOpenLocalVideo   confMessage:(NSDictionary *)confmessage viewController:(UIViewController<CLConferenceDelegate> *)viewController success:(SuccessVerifyBlock)successBase failure:(FailureVerifyBlock)failureBase{
    [MBProgressHUD cc_showLoading:nil];
    [MainNetworkRequest verifyPSWConfRequestParams:@{@"conf_id":cidStr,@"password":psw,@"disting":@"normal"} success:^(id success) {
        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
        NSLog(@"successverifyPSWRequest %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            if ([success[@"data"][@"status"] isEqualToString:@"ok"]) {
                // 入会
                [self enterSDKConfWithUID:uidStr Cid:cidStr name:nameStr needOpenLocalAudio:needOpenLocalAudio needOpenLocalVideo:needOpenLocalVideo confMessage:confmessage viewController:viewController success:^(id  _Nonnull success) {
                    successBase(success);
                } failure:^(id  _Nonnull failure) {
                    failureBase(failure);
                }];
            }else {
                
                [self pushAlertWithTitle:SIMLocalizedString(@"ERR_CONF_OTHER", nil) message:SIMLocalizedString(@"ERROR_WRONG_PASSWORD", nil) viewController:viewController];
//                [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_WRONG_PASSWORD", nil)];
            }
            
        }else {
            [self pushAlertWithTitle:SIMLocalizedString(@"ERR_CONF_OTHER", nil) message:success[@"msg"] viewController:viewController];
        }
    } failure:^(id failure) {
        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
        [self pushAlertWithTitle:SIMLocalizedString(@"ERR_CONF_OTHER", nil) message:SIMLocalizedString(@"NETWORK_error_other", nil) viewController:viewController];
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}
+ (void)pushAlertWithTitle:(NSString *)title message:(NSString *)message viewController:(UIViewController<CLConferenceDelegate> *)viewController {
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCOk", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [viewController presentViewController:alertView animated:YES completion:nil];
}


// 登录入会
+ (void)enterTheMineConfWithCid:(NSString *)cidStr psw:(NSString *)psw confType:(EnterConfType)confType isJoined:(BOOL)isJoined viewController:(UIViewController<CLConferenceDelegate> *)viewController {
    isNoTokenJoin = NO;
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    if (!manager.isReachable) {
        [self pushAlertWithTitle:SIMLocalizedString(@"ERR_CONF_OTHER", nil) message:SIMLocalizedString(@"ENTER_NETWORK_NO_CONNECT", nil) viewController:viewController];
        return ;
    }
    if (cidStr.length == 0) {
        [self pushAlertWithTitle:SIMLocalizedString(@"ERR_CONF_OTHER", nil) message:SIMLocalizedString(@"ERR_CONF_NoConfIDRequest", nil) viewController:viewController];
        return ;
    }
    // 获取是否有相机权限
    if (![self  avauthorizationStatusWithViewController:viewController]) return;
//    _groupEnter = dispatch_group_create();
//
//    __block BOOL canContinue;
//    [self searchUpdateVersionwithViewController:viewController result:^(BOOL isOK) {
//        if (isOK) {
            // 请求会议配置项
            [self configRequestConfWithUID:self.currentUser.uid Cid:cidStr webStr:psw name:self.currentUser.nickname needOpenLocalAudio:YES needOpenLocalVideo:YES viewController:viewController success:^(id  _Nonnull success) {
                
            } failure:^(id  _Nonnull failure) {
                
            } cidMessage:^(NSDictionary * _Nonnull confMessageDic) {
                
            }];
//        }
////        canContinue = isOK;
//    }];
//    dispatch_group_notify(_groupEnter, dispatch_get_main_queue(), ^{
//        if (!canContinue) {
//            return ;
//        }
        
//    });
}
// 登录入会  带block回调
+ (void)enterTheMineConfWithCid:(NSString *)cidStr webstr:(NSString *)psw nickname:(NSString *)nickname confType:(EnterConfType)confType isJoined:(BOOL)isJoined  needOpenLocalAudio:(BOOL)needOpenLocalAudio needOpenLocalVideo:(BOOL)needOpenLocalVideo viewController:(UIViewController <CLConferenceDelegate>*)viewController success:(SuccessBlock)successBase failure:(FailureBlock)failureBase  cidMessage:(getConfMessageBlock)confmessage {
    isNoTokenJoin = NO;
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    if (!manager.isReachable) {
        [self pushAlertWithTitle:SIMLocalizedString(@"ERR_CONF_OTHER", nil) message:SIMLocalizedString(@"ENTER_NETWORK_NO_CONNECT", nil) viewController:viewController];
        return ;
    }
    if (cidStr.length == 0) {
        // 说明没获取到confID  那么先不仅会
        [self pushAlertWithTitle:SIMLocalizedString(@"ERR_CONF_OTHER", nil) message:SIMLocalizedString(@"ERR_CONF_NoConfIDRequest", nil) viewController:viewController];
        return ;
    }
    // 获取是否有相机权限
    if (![self  avauthorizationStatusWithViewController:viewController]) return;
//    _groupEnter = dispatch_group_create();
//
//    __block BOOL canContinue;
    [self searchUpdateVersionwithViewController:viewController result:^(BOOL isOK) {
//        canContinue = isOK;
        if (isOK) {
            [self configRequestConfWithUID:self.currentUser.uid Cid:cidStr webStr:psw name:nickname needOpenLocalAudio:needOpenLocalAudio needOpenLocalVideo:needOpenLocalVideo viewController:viewController success:^(id  _Nonnull success) {
                successBase(success);
            } failure:^(id  _Nonnull failure) {
                failureBase(failure);
            } cidMessage:^(NSDictionary * _Nonnull confMessageDic) {
                confmessage(confMessageDic);
            }];
        }
    }];
//    dispatch_group_notify(_groupEnter, dispatch_get_main_queue(), ^{
//        if (!canContinue) {
//            return ;
//        }
        
        
        
//    });
    
}

// 快速入会 （匿名入会不是加入会议页面的）
+ (void)quickEnterTheMineConfWithCid:(NSString *)cidStr psw:(NSString *)psw name:(NSString *)nameStr  confType:(EnterConfType)confType  viewController:(UIViewController<CLConferenceDelegate> *)viewController {
    isNoTokenJoin = YES;
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    if (!manager.isReachable) {
        [self pushAlertWithTitle:SIMLocalizedString(@"ERR_CONF_OTHER", nil) message:SIMLocalizedString(@"ENTER_NETWORK_NO_CONNECT", nil) viewController:viewController];
        return ;
    }
    if (cidStr.length == 0) {
        // 说明没获取到confID  那么先不仅会
        [self pushAlertWithTitle:SIMLocalizedString(@"ERR_CONF_OTHER", nil) message:SIMLocalizedString(@"ERR_CONF_NoConfIDRequest", nil) viewController:viewController];
        return ;
    }
    // 获取是否有相机权限
    if (![self  avauthorizationStatusWithViewController:viewController]) return;
//    _groupEnter = dispatch_group_create();
//
//    __block BOOL canContinue;
    [self searchUpdateVersionwithViewController:viewController result:^(BOOL isOK) {
//        canContinue = isOK;
        if (isOK) {
            // 生成随机的uid
            int randomUID = (arc4random() % 20000001) + 10000000;
            NSString *uidStr = [NSString stringWithFormat:@"%d",randomUID];
            // 入会
            [self configRequestConfWithUID:uidStr Cid:cidStr webStr:psw name:nameStr needOpenLocalAudio:YES needOpenLocalVideo:YES viewController:viewController success:^(id  _Nonnull success) {
                
            } failure:^(id  _Nonnull failure) {
                
            } cidMessage:^(NSDictionary * _Nonnull confMessageDic) {
                
            }];
        }
    }];
//    dispatch_group_notify(_groupEnter, dispatch_get_main_queue(), ^{
//        if (!canContinue) {
//            return ;
//        }
        
        
        
//    });
    
    
}

// 快速入会 （匿名入会） 带block回调 加入会议页面
+ (void)quickEnterTheMineConfWithCid:(NSString *)cidStr psw:(NSString *)psw name:(NSString *)nameStr  confType:(EnterConfType)confType needOpenLocalAudio:(BOOL)needOpenLocalAudio needOpenLocalVideo:(BOOL)needOpenLocalVideo  viewController:(UIViewController <CLConferenceDelegate>*)viewController  success:(SuccessBlock)successBase failure:(FailureBlock)failureBase cidMessage:(getConfMessageBlock)confmessage {
    isNoTokenJoin = YES;
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    if (!manager.isReachable) {
        [self pushAlertWithTitle:SIMLocalizedString(@"ERR_CONF_OTHER", nil) message:SIMLocalizedString(@"ENTER_NETWORK_NO_CONNECT", nil) viewController:viewController];
        return ;
    }
    if (cidStr.length == 0) {
        // 说明没获取到confID  那么先不仅会
        [self pushAlertWithTitle:SIMLocalizedString(@"ERR_CONF_OTHER", nil) message:SIMLocalizedString(@"ERR_CONF_NoConfIDRequest", nil) viewController:viewController];
        return ;
    }
    // 获取是否有相机权限
    if (![self  avauthorizationStatusWithViewController:viewController]) return;
    
//    _groupEnter = dispatch_group_create();
//
//    __block BOOL canContinue;
    [self searchUpdateVersionwithViewController:viewController result:^(BOOL isOK) {
//        canContinue = isOK;
        if (isOK) {
            // 生成随机的uid
            int randomUID = (arc4random() % 20000001) + 10000000;
            NSString *uidStr = [NSString stringWithFormat:@"%d",randomUID];
            // 入会
            [self configRequestConfWithUID:uidStr Cid:cidStr webStr:psw name:nameStr needOpenLocalAudio:needOpenLocalAudio needOpenLocalVideo:needOpenLocalVideo viewController:viewController success:^(id  _Nonnull success) {
                successBase(success);
            } failure:^(id  _Nonnull failure) {
                failureBase(failure);
            } cidMessage:^(NSDictionary * _Nonnull confMessageDic) {
                confmessage(confMessageDic);
            }];
        }
    }];
//    dispatch_group_notify(_groupEnter, dispatch_get_main_queue(), ^{
//        if (!canContinue) {
//            return ;
//        }
        
        
        
//    });
    
}



+ (BOOL)avauthorizationStatusWithViewController:(UIViewController *)viewcontroller {
    // 判断相机权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
        // 没有权限
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:SIMLocalizedString(@"Enter_Info_Video", nil) message:SIMLocalizedString(@"Enter_Info_Video_None", nil) preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCSet", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //跳入当前App设置界面,
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:^(BOOL        success) {
                }];
            }
        }]];
        [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleDefault handler:nil]];
        [viewcontroller presentViewController:alertView animated:YES completion:nil];
        return NO;
    }
    return YES;
}
+ (void)addIMGroupsWithConfID:(NSString *)confID username:(NSString *)username {
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    [dicM setObject:confID forKey:@"confSerial"];
    [dicM setObject:username forKey:@"username"];
    [MBProgressHUD cc_showLoading:nil];
    [MainNetworkRequest addIMgroupMemberRequestParams:dicM success:^(id success) {
        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
        NSLog(@"addIMgroupMembersuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            
        }else {
            
        }
    } failure:^(id failure) {
        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
    }];
}

+ (void)exitTheConf {
    [[CLConference conference] ExitConf];
    
}

// 通过查询后台接口是版本号需要更新还是强制更新
+ (void)searchUpdateVersionwithViewController:(UIViewController<CLConferenceDelegate> *)viewController result:(void (^)(BOOL isOK))result {
    NSDictionary *dic = @{@"versionCode":[NSString getLocalAppVersion],@"packageName":[NSString getBundleID],@"device":@"ios"};
//    NSLog(@"searchupdateversiondic  %@",dic);
    [MBProgressHUD cc_showLoading:nil];
    [MainNetworkRequest updateVersionRequestParams:dic success:^(id success) {
        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
        // 成功
//        NSLog(@"confsearchupdateversionSuccess  %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {

            NSDictionary *dic = success[@"data"];
            SIMVersionUpdateModel *model = [[SIMVersionUpdateModel alloc] initWithDictionary:dic];
            if (model.needUpdate) {
                if (model.enforce) {
//                    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@%@",SIMLocalizedString(@"UpdateTitleText", nil),model.appName] message:@"" preferredStyle:UIAlertControllerStyleAlert];
//                    [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"UpdateTitleYES", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        NSString *urls = model.downloadurl;
//                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urls]];
//                    }]];
//                    [viewController presentViewController:alertView animated:YES completion:nil];
                    result (YES);
                }else {
//                    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@%@",SIMLocalizedString(@"UpdateTitleText", nil),model.appName] message:@"" preferredStyle:UIAlertControllerStyleAlert];
//                    [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"UpdateTitleYES", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        NSString *urls = model.downloadurl;
//                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urls]];
//                    }]];
//                    [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"UpdateTitleNO", nil) style:UIAlertActionStyleDefault handler:nil]];
//
//                    [viewController presentViewController:alertView animated:YES completion:nil];
                    result (YES);
                }

            }else {
                result (YES);
            }
        }else {
            result (YES);
        }
    } failure:^(id failure) {
        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
        result (YES);
    }];
}

+ (void)tapClick {
    [[[UIApplication sharedApplication].keyWindow viewWithTag:30001] removeFromSuperview];
    [[[UIApplication sharedApplication].keyWindow viewWithTag:30002] removeFromSuperview];
}

@end
