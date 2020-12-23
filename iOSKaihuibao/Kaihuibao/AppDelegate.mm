//
//  AppDelegate.m
//  Kaihuibao
//
//  Created by Ferris on 2017/3/28.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "AppDelegate.h"

#import "SIMTabBarViewController.h"
#import "BaseNetworking.h"
#import "SIMEntranceViewController.h"
#import "SIMMainMeetingViewController.h"
#import "SIMOrderPayNextViewController.h"
#import "SIMFreeNextViewController.h"
#import "SIMJoinMeetingViewController.h"
#import "SIMWalletMainViewController.h"
#import "SIMScrollTextAlertView.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "SIMTempCompanyViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <Bugly/Bugly.h>
//#import <UMCommon/UMCommon.h>
//#import <UMCommonLog/UMCommonLogHeaders.h>
#import "TUIKit.h"
#import "SIMNewIMHelper.h"
#import <ShareSDK/ShareSDK.h>
//微信和QQ的SDK头文件
#import "WXApi.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import "TencentOpenAPI/TencentOAuth.h"

#import "SIMPayResultAlertView.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<WXApiDelegate,UNUserNotificationCenterDelegate,NSURLConnectionDataDelegate,AMapLocationManagerDelegate>
{
    BOOL _payTureFaulseBack;    //支付回调处理判断
//    CLLocationManager *locationManager;
}
@property (nonatomic, strong) SIMPayResultAlertView *little;
@property (nonatomic, strong) UIView *backView;// 蒙层
@property (nonatomic, assign) BOOL isjoinPage;// 是否是调起app的加入会议界面
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation AppDelegate
- (void)getWifiSsid {
//    self.locationManager = [[AMapLocationManager alloc] init];
//    [self.locationManager setDelegate:self];
//    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
//    [self.locationManager startUpdatingLocation];
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
        CGFloat version = [phoneVersion floatValue];
//     如果是iOS13 未开启地理位置权限 需要提示一下
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined && version >= 13) {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"alreadyPushTheCalledPage"];
//    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);// 程序崩溃走的自定义方法
    // 可以设置好强制竖屏
//    UIInterfaceOrientation orientation = UIInterfaceOrientationPortrait;
//    [[UIApplication sharedApplication] setStatusBarOrientation:orientation];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showTheWechat"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[UITabBar appearance] setTranslucent:NO];// tabbar不透明防止ios12图片跳动
    [[BaseNetworking shareInstance] getReach];     // 监听联网状态
    [SIMInternationalController initUserLanguage]; // 初始化应用语言
    BOOL isClose = [[NSUserDefaults standardUserDefaults] boolForKey:@"isChangeServerSwitchClose"];
    if (!isClose) {
        // 设置默认的服务器地址和端口
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"NEWHostNetString"] == nil) {
            [[NSUserDefaults standardUserDefaults] setObject:DefaultApiBaseHost forKey:@"NEWHostNetString"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"NEWPortNetString"] == nil) {
            [[NSUserDefaults standardUserDefaults] setObject:DefaultApiBasePort forKey:@"NEWPortNetString"];
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"NEWHttpNetString"] == nil) {
            [[NSUserDefaults standardUserDefaults] setObject:DefaultApiBaseHttp forKey:@"NEWHttpNetString"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    NSLog(@"resultisChangeTheServer %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"NEWHostNetString"]);
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"confConfig.resolution.isset"]) {
//        // 用户有没有设置过清晰度
//        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"confConfig.resolution"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    [self shareSDKMethod];// 第三方分享
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 10.0) {
        // 针对 10.0 以上的iOS系统进行处理 ios10以下不处理
        [Bugly startWithAppId:BuglyAPPID];// 集成bug检测工具
    }
//    [WXApi registerApp:WeichatAPPID];// 微信支付
    NSString *link = WXuniversalLink;
    [WXApi registerApp:WeichatAPPID universalLink:link];
    
    [AMapServices sharedServices].apiKey = AMapAPPID;// 地图
    [self addNotifactionMethod:application]; // 注册远程通知
    // 友盟统计
//    [UMConfigure initWithAppkey:@"5d1dd2810cafb212b8000a73" channel:@"App Store"];
//    [UMCommonLogManager setUpUMCommonLogManager];
//    [UMConfigure setEncryptEnabled:YES];//打开加密传输
    
    [self searchISPrivateMethod]; // 配置根视图
    
    [[SIMNewIMHelper shareInstance] addMessageListener];// 自行实现腾讯IM的监听 为了处理点对点呼叫功能
    NSInteger sdkAppid = 1400217711; //填入自己 App 的 SDKAppID
    NSString *accountType = @"0"; //填入自己 App 的 accountType
    //    TUIKitConfig *config = [TUIKitConfig defaultConfig];//默认 TUIKit 配置，这个您可以根据自己的需求在 TUIKitConfig 里面自行配置
    [[TUIKit sharedInstance] initKit:sdkAppid accountType:accountType withConfig:[TUIKitConfig defaultConfig]];
    
//    [self getWifiSsid];
    return YES;
}
- (void)searchISPrivateMethod {
    /*
     这里分公有云和私有云 --如果是公有云那么有注册等 --如果是私有云没有注册等
     私有云分两种情况 1.使用开会宝的私有云 2.自己有app的私有云
     1.使用开会宝的私有云： iOS是默认是自己服务器 app上来都用自己的服务器请求公有还是私有 我们自己的服务器应该都是公有所以刚上来是有注册等界面的 如果需要私有那么前去设置服务期之后才生效 回来后刷新界面变成私有 然后存储本地
     之后都从本地拿值同时请求接口 并重新异步请求存本地（防止客户中途有权限修改）然后下次生效 当前就不要即使刷新了 防止程序闪屏
     如果本地没有值那么就是第一次下载app 那么久让他在请求结束保存本地才初始化视图 有一个等待
     2.自己有app的私有云：这种情况打包的时候 就会将默认服务器修改了 那么第一次使用就用默认服务器请求 然后加载视图 保存本地 下次用本地的进入就行了 更新本地 如果他要修改服务器设置 那么在重新刷新
     秉承的原则是 每次都请求 为了防止配置变化 但是 如果原来有一份了 不要影响程序启动 所以先用本地初始化 然后请求回来更新本地配置 下次生效  如果没有 那么是第一次 慢点就慢点了 如果是改了服务器地址那么就在返回页面时候就要更新配置刷新界面
     */
    if (self.cloudVersion != nil) {
        // 如果本地有那么从本地拿值
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        [self addRootViewMethod];
        // 这个webFileUrl是后加的 所以要对旧的已经存在的值更新一下
        NSLog(@"本地本来有之后刷新本地的  %@",self.cloudVersion.version);
        NSString *typeSTR = [PrivateRequestType isEqualToString:@"privateTYPE"]?@"2":@"1";
        [MainNetworkRequest searchIsPrivateRequestParams:@{@"type":typeSTR} success:^(id success) {
            if ([success[@"code"] integerValue] == successCodeOK) {
//                NSLog(@"本地本来有之后刷新本地的searchIsPrivateSuccess  %@",success);
            
                NSDictionary *dic = success[@"data"];
                NSString *version = dic[@"version"];
                NSMutableDictionary *dicMM = [[NSMutableDictionary alloc] initWithDictionary:dic[@"switches"]];
                NSDictionary *adressdic = dic[@"switches"][@"addressbook_show"];
                NSDictionary *invitationdic = dic[@"switches"][@"invitation"];
                
                [dicMM addEntriesFromDictionary:adressdic];
                [dicMM addEntriesFromDictionary:invitationdic];
                if (dic[@"confModeSwitches"] != nil) {
                    [dicMM addEntriesFromDictionary:dic[@"confModeSwitches"]];
                }
                
                for (int i =0; i<dicMM.count; i++) {
                    if ([[dicMM objectForKey:dicMM.allKeys[i]] isKindOfClass:[NSNumber class]]) {
                        NSString *key = dicMM.allKeys[i];
                        NSNumber *longn = [NSNumber numberWithLong:[[dicMM objectForKey:key] longValue]];
                        NSString *longss = [longn stringValue];
                        [dicMM removeObjectForKey:key];
                        [dicMM setObject:longss forKey:key];
                    }
                }
                [dicMM setObject:version forKey:@"version"];
                if (dic[@"webFileUrl"] != nil) {
                    [dicMM setObject:dic[@"webFileUrl"] forKey:@"webFileUrl"];
                }else {
                    [dicMM setObject:@"" forKey:@"webFileUrl"];
                }
                if ([dic[@"switches"][@"shareDocument"] boolValue] == NO) {
                    [dicMM setObject:@"" forKey:@"webFileUrl"];
                }
//                [dicMM setObject:@"0" forKey:@"video_playback"]; // 测试用
//                NSLog(@"searchIsPrivateSuccess  %@ %@ %@",success,dic[@"switches"][@"shareDocument"],dic[@"webFileUrl"]);
                SIMCloudVersion *cloudVersion = [[SIMCloudVersion alloc] initWithDictionary:dicMM];
                self.cloudVersion = cloudVersion;
                [self.cloudVersion synchroinzeCloudVersion];
                NSLog(@"self.cloudVersionhas %@",self.cloudVersion);
//                [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"SearchSurrounding"];
                if ([self.cloudVersion.cloud_server boolValue]) {
                    // 公有界面
                    NSArray *repeatArr = @[@"中国",@"中国（香港）"];
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"NEWHostNetString"] isEqualToString:DefaultApiBaseHost]) {
                        // 是默认的地址
                        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isChangeServerSwitchClose"];
                        [[NSUserDefaults standardUserDefaults] setObject:repeatArr[0] forKey:@"NEWServerText"]; // 这个是选择的国家文字
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"NEWHostNetString"] isEqualToString:HKApiBaseHost]) {
                        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isChangeServerSwitchClose"];
                        [[NSUserDefaults standardUserDefaults] setObject:repeatArr[1] forKey:@"NEWServerText"]; // 这个是选择的国家文字
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }else {
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isChangeServerSwitchClose"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }else {
                    // 私有
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isChangeServerSwitchClose"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }else {
                NSLog(@"请求私有化配置失败");
            }
        } failure:^(id failure) {
            NSLog(@"请求私有化配置失败");
        }];
    }else {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
        self.window.rootViewController = [[SIMBaseViewController alloc] init];
        [self.window makeKeyAndVisible];
        NSString *typeSTR = [PrivateRequestType isEqualToString:@"privateTYPE"]?@"2":@"1";
        [MainNetworkRequest searchIsPrivateRequestParams:@{@"type":typeSTR} success:^(id success) {
            // 成功
            if ([success[@"code"] integerValue] == successCodeOK) {
                NSDictionary *dic = success[@"data"];
                NSString *version = dic[@"version"];
                NSMutableDictionary *dicMM = [[NSMutableDictionary alloc] initWithDictionary:dic[@"switches"]];
                NSDictionary *adressdic = dic[@"switches"][@"addressbook_show"];
                NSDictionary *invitationdic = dic[@"switches"][@"invitation"];
                [dicMM addEntriesFromDictionary:adressdic];
                [dicMM addEntriesFromDictionary:invitationdic];
                if (dic[@"confModeSwitches"] != nil) {
                    [dicMM addEntriesFromDictionary:dic[@"confModeSwitches"]];
                }
                for (int i =0; i<dicMM.count; i++) {
                    if ([[dicMM objectForKey:dicMM.allKeys[i]] isKindOfClass:[NSNumber class]]) {
                        NSString *key = dicMM.allKeys[i];
                        NSNumber *longn = [NSNumber numberWithLong:[[dicMM objectForKey:key] longValue]];
                        NSString *longss = [longn stringValue];
                        [dicMM removeObjectForKey:key];
                        [dicMM setObject:longss forKey:key];
                    }
                }
                
                [dicMM setObject:version forKey:@"version"];
                if (dic[@"webFileUrl"] != nil) {
                    [dicMM setObject:dic[@"webFileUrl"] forKey:@"webFileUrl"];
                }else {
                    [dicMM setObject:@"" forKey:@"webFileUrl"];
                }
                if ([dic[@"switches"][@"shareDocument"] boolValue] == NO) {
                    [dicMM setObject:@"" forKey:@"webFileUrl"];
                }
//                NSLog(@"searchIsPrivateSuccess  %@ %@ %@",success,dic[@"switches"][@"shareDocument"],dic[@"webFileUrl"]);
                
                SIMCloudVersion *cloudVersion = [[SIMCloudVersion alloc] initWithDictionary:dicMM];
                self.cloudVersion = cloudVersion;
                [self.cloudVersion synchroinzeCloudVersion];
                NSLog(@"self.cloudVersionsuccess %@",self.cloudVersion);
                
                if ([self.cloudVersion.cloud_server boolValue]) {
                    // 公有界面
                    NSArray *repeatArr = @[@"中国",@"中国（香港）"];
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"NEWHostNetString"] isEqualToString:DefaultApiBaseHost]) {
                        // 是默认的地址
                        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isChangeServerSwitchClose"];
                        [[NSUserDefaults standardUserDefaults] setObject:repeatArr[0] forKey:@"NEWServerText"]; // 这个是选择的国家文字
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"NEWHostNetString"] isEqualToString:HKApiBaseHost]) {
                        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isChangeServerSwitchClose"];
                        [[NSUserDefaults standardUserDefaults] setObject:repeatArr[1] forKey:@"NEWServerText"]; // 这个是选择的国家文字
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }else {
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isChangeServerSwitchClose"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }else {
                    // 私有
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isChangeServerSwitchClose"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
//                [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"SearchSurrounding"];
//                [[NSUserDefaults standardUserDefaults] setObject:@"privatization" forKey:@"SearchSurrounding"]; // 这个是自己测试用的写的数据
            }else {
                [self addDicDatas];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addRootViewMethod];
            });
            
        } failure:^(id failure) {
            [self addDicDatas];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addRootViewMethod];
            });
        }];
        // 这里无论该接口成功失败 只要返回结果回来了都要初始化跟视图 只不过是 如果请求成功那么有值代表私有云privatization 如果是公有云或者请求失败那么都是正常布局
    }
}
- (void)addDicDatas {
    SIMCloudVersion *cloudVersion = [[SIMCloudVersion alloc] initWithDeflaut];
    self.cloudVersion = cloudVersion;
    [self.cloudVersion synchroinzeCloudVersion];
    NSLog(@"self.cloudVersionfail %@",self.cloudVersion);
}

- (void)addRootViewMethod {
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSString *app_ownVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
//    if ([app_Version isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"version"]] && [app_ownVersion isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"ownVersion"]]) {
        // 版本号相同
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"] == nil) {
            // 没有token跳转到登录页面
            self.window.rootViewController  = [SIMEntranceViewController new];
            
        }else {
            if (self.currentUser.currentCompany.company_id.length <= 0 || self.currentUser == nil) {
                self.window.rootViewController = [SIMEntranceViewController new];
                // 需要弹出登录然后选择公司页面 以后做吧 先不这么做
            }else {
                // 有token跳转到首页
                self.window.rootViewController = [SIMTabBarViewController new];
            }
        }
//    }else{
//        // 版本号不同 那么将现在的版本号存法nsuserdefaults里
//        [[NSUserDefaults standardUserDefaults] setObject:app_Version forKey:@"version"];
//        [[NSUserDefaults standardUserDefaults] setObject:app_ownVersion forKey:@"ownVersion"];
//        [self logoutRequestAfter];
//        self.window.rootViewController = [SIMEntranceViewController new];
//    }
    NSLog(@"comcomteo %@ %@", self.currentUser.uid, self.currentCompany.company_name);
    NSLog(@"appdelegatecurrentUser+++%@",self.currentUser.currentCompany.company_id);
    NSLog(@"appdelegatetoken+++%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]);
    
    // 弹出隐私的框子
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"privateAlertView"]) {
        [self pushThePrivateAlert];
    }
//    self.window.rootViewController = rootViewController;
    [self haveRootVCThenConfIN];
}
- (void)haveRootVCThenConfIN{
    if (self.cidstr.length > 0) {
        if ([self.window.rootViewController isKindOfClass:[SIMTabBarViewController class]]) {
            
            self.shareTheConfEnter = @{@"confId":self.cidstr,@"webStr":self.weburlstr};
            
            self.isShareEnter = YES;
        }else if ([self.window.rootViewController isKindOfClass:[SIMEntranceViewController class]]) {
            SIMEntranceViewController *vc = (SIMEntranceViewController *)windowRootViewController;
            [vc.presentedViewController dismissViewControllerAnimated:NO completion:nil];
            
            NSDictionary *mySendDic = @{@"confId":self.cidstr,@"webStr":self.weburlstr};
            [[NSNotificationCenter defaultCenter] postNotificationName:EnterConfBYShare object:nil userInfo:mySendDic];
        }
    }
    if (_isjoinPage == YES) {
        // 匿名进会默认为启动页 都回到启动页 非匿名进会无论app之前停留页 都回到首页会议界面
        if ([windowRootViewController isKindOfClass:[SIMTabBarViewController class]]) {
            SIMJoinMeetingViewController *joinVC = [[SIMJoinMeetingViewController alloc] init];
            UIViewController *joinMeetingNaviVC = [joinVC sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
            joinVC.isLive = NO;
            joinVC.isJoinPage = YES;
            joinVC.webUrlStr = self.weburlstr;
            joinVC.navigationItem.title = SIMLocalizedString(@"MJoinTheMeeting", nil);
            joinMeetingNaviVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [windowRootViewController presentViewController:joinMeetingNaviVC animated:YES completion:nil];
        }else if ([windowRootViewController isKindOfClass:[SIMEntranceViewController class]]) {
            SIMEntranceViewController *vc = (SIMEntranceViewController *)windowRootViewController;
            [vc.presentedViewController dismissViewControllerAnimated:NO completion:nil];
            
            SIMJoinMeetingViewController *joinVC = [[SIMJoinMeetingViewController alloc] init];
            UIViewController* joinMeetingNaviVC = [joinVC sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
            joinVC.isLive = NO;
            joinVC.webUrlStr = self.weburlstr;
            joinVC.navigationItem.title = SIMLocalizedString(@"MJoinTheMeeting", nil);
            joinMeetingNaviVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [vc presentViewController:joinMeetingNaviVC animated:YES completion:nil];
        }
    }
}

- (void)addNotifactionMethod:(UIApplication *)application {
    if ([UIDevice currentDevice].systemVersion.floatValue <10.0) {
        //iOS8 - iOS10
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
    }else {
        //iOS10
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNAuthorizationOptions options = UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert;
        [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"远程通知请求成功");
            } else {
                NSLog(@"远程通知请求失败");
            }
            
        }];
        //设置通知的代理
        center.delegate = self;
    }
    //注册远程通知
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    self.deviceToken = deviceToken;
    NSLog(@"获取的deviceToken %@",self.deviceToken);
}
// 退出登录网络请求 之后的操作
- (void)logoutRequestAfter {
    self.currentUser.currentCompany = [SIMCompany new];
    self.currentUser = [CCUser new]; // 释放主用户对象
    self.currentCompany = [SIMCompany new];// 释放公司模型
    [self.currentCompany synchroinzeCurrentCompany];
//    [self.currentUser synchroinzeCurrentUser];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userToken"]; // 立即清token
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MYCONF"];// 清空我的会议室model
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MYLIVE"];// 清空我的直播间model
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentPlanName"]; // 当前的会议计划名称
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentPlanID"]; // 当前的会议计划名称
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IsHaveAdressBook"]; // 是否传了通讯录
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"showTheWechat"];// 是否上线显示微信
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"JoinTheMeetingNumber"];// 这个是以前用来存储加入会议的保存手机号的 现在不用了 但是之前用户数据要删掉
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OneConfServerAdress"]; // 链接入会一次性地址 也要删掉 防止链接唤起app被挤掉线
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 前台运行 会调用的方法
 iOS10之前, 在前台运行时, 不会出现通知的横幅
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    
}
/**
 后台运行及程序退出 会调用的方法
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    
    NSLog(@"点击进入app");
    
    completionHandler();
}

- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    __block UIBackgroundTaskIdentifier bgTaskID;
    bgTaskID = [application beginBackgroundTaskWithExpirationHandler:^ {
        //不管有没有完成，结束 background_task 任务
        [application endBackgroundTask: bgTaskID];
        bgTaskID = UIBackgroundTaskInvalid;
    }];
    //获取未读计数
    int unReadCount = 0;
    NSArray *convs = [[TIMManager sharedInstance] getConversationList];
    for (TIMConversation *conv in convs) {
        if([conv getType] == TIM_SYSTEM){
            continue;
        }
        unReadCount += [conv getUnReadMessageNum];

    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = unReadCount;

    //doBackground
    TIMBackgroundParam  *param = [[TIMBackgroundParam alloc] init];
    [param setC2cUnread:unReadCount];
    [[TIMManager sharedInstance] doBackground:param succ:^() {
        NSLog(@"doBackgroud Succ");
    } fail:^(int code, NSString * err) {
        NSLog(@"Fail: %d->%@", code, err);
    }];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0]; //清除角标
    [[UIApplication sharedApplication] cancelAllLocalNotifications];//清除APP所有通知消息
    
    _payTureFaulseBack = NO;// 每次进来都为no 只有当走了openurl是微信的才会设为yes
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!_payTureFaulseBack) {
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"newPayOrderNum"] length] > 0) {
                NSLog(@"zoudeshiapplicationWillEnterForeground");
                [self checkOutTheOrderWithOrderNum:[[NSUserDefaults standardUserDefaults] objectForKey:@"newPayOrderNum"]];
            }
        }
    });
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0]; //清除角标
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[TIMManager sharedInstance] doForeground:^() {
        NSLog(@"doForegroud Succ");
    } fail:^(int code, NSString * err) {
        NSLog(@"Fail: %d->%@", code, err);
    }];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
}

#pragma mark - Private method
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    NSLog(@"urlopenresult = %@",url);
    if ([url.scheme isEqualToString:EnterConfURL]){
         // 拆分连接地址 拿出会议号和密码 进会
         NSLog(@"url hostt: %@,%@",[url host],url.absoluteString);//url : newkhb://?cid=27514215384&cp=1234
         NSString *urlStr = url.absoluteString;

         NSRange range = [urlStr rangeOfString:@"cid="];
         NSString *tempStr;
         if (range.length > 0  ||  range.location != NSNotFound) {
             tempStr = [urlStr substringFromIndex:range.location+range.length];
             NSLog(@"cidstringcidstring %@",tempStr);
         }
         NSRange range2 = [tempStr rangeOfString:@"&"];
         NSString *cidstring;
         if (range2.length > 0  ||  range2.location != NSNotFound) {
             cidstring = [tempStr substringToIndex:range2.location];
         }else {
             cidstring = tempStr;
         }
         NSRange range3 = [urlStr rangeOfString:@"weburl="];
         NSString *confurlStr;
         if (range3.length > 0  ||  range3.location != NSNotFound) {
             confurlStr = [urlStr substringFromIndex:range3.location+range3.length];
         }
         NSLog(@"cidStr & : %@,confurl: %@",cidstring,confurlStr);
        NSString *webstr;
        if (confurlStr != nil && confurlStr.length > 0) {
            webstr = confurlStr;
        }else {
            webstr = kApiBaseUrl;
        }
//         [[NSUserDefaults standardUserDefaults] setObject:confurlStr forKey:@"OneConfServerAdress"];
//        [MBProgressHUD cc_showText:[NSString stringWithFormat:@"%@",cidstring]];

         // 匿名进会默认为启动页 都回到启动页 非匿名进会无论app之前停留页 都回到首页会议界面
         if ([windowRootViewController isKindOfClass:[SIMTabBarViewController class]]) {
             
             self.shareTheConfEnter = @{@"confId":cidstring,@"webStr":webstr};
             self.isShareEnter = YES;
         }else if ([windowRootViewController isKindOfClass:[SIMEntranceViewController class]]) {
             SIMEntranceViewController *vc = (SIMEntranceViewController *)windowRootViewController;
             [vc.presentedViewController dismissViewControllerAnimated:NO completion:nil];

             NSDictionary *mySendDic = @{@"confId":cidstring,@"webStr":webstr};
             [[NSNotificationCenter defaultCenter] postNotificationName:EnterConfBYShare object:nil userInfo:mySendDic];
         }else {
//             self.shareTheConfEnter = @{@"cid":cidStr,@"psw":pswStr};

//             self.isShareEnter = YES;
             self.cidstr = cidstring;
             self.weburlstr = webstr;
         }
        
        return YES;
    }else if ([url.scheme isEqualToString:JoinPageURL]) {
        NSLog(@"url hostt: %@,%@",[url host],url.absoluteString);//url : newkhb://?cid=27514215384&cp=1234
        NSString *urlStr = url.absoluteString;
        NSRange range3 = [urlStr rangeOfString:@"weburl="];
        NSString *confurlStr;
        if (range3.length > 0  ||  range3.location != NSNotFound) {
            confurlStr = [urlStr substringFromIndex:range3.location+range3.length];
        }
        NSLog(@"openurljoinpageconfurl: %@",confurlStr);
        NSString *webstr;
        if (confurlStr != nil && confurlStr.length > 0) {
            webstr = confurlStr;
        }else {
            webstr = kApiBaseUrl;
        }
        // 匿名进会默认为启动页 都回到启动页 非匿名进会无论app之前停留页 都回到首页会议界面
        if ([windowRootViewController isKindOfClass:[SIMTabBarViewController class]]) {
            SIMJoinMeetingViewController *joinVC = [[SIMJoinMeetingViewController alloc] init];
            UIViewController *joinMeetingNaviVC = [joinVC sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
            joinVC.isLive = NO;
            joinVC.isJoinPage = YES;
            joinVC.webUrlStr = webstr;
            joinVC.navigationItem.title = SIMLocalizedString(@"MJoinTheMeeting", nil);
            joinMeetingNaviVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [windowRootViewController presentViewController:joinMeetingNaviVC animated:YES completion:nil];
        }else if ([windowRootViewController isKindOfClass:[SIMEntranceViewController class]]) {
            SIMEntranceViewController *vc = (SIMEntranceViewController *)windowRootViewController;
            [vc.presentedViewController dismissViewControllerAnimated:NO completion:nil];
            
            SIMJoinMeetingViewController *joinVC = [[SIMJoinMeetingViewController alloc] init];
            UIViewController* joinMeetingNaviVC = [joinVC sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
            joinVC.isLive = NO;
            joinVC.webUrlStr = webstr;
            joinVC.navigationItem.title = SIMLocalizedString(@"MJoinTheMeeting", nil);
            joinMeetingNaviVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [vc presentViewController:joinMeetingNaviVC animated:YES completion:nil];
        }else {
            _isjoinPage = YES;
            self.weburlstr = webstr;
        }
    }else if ([url.scheme isEqualToString:WeichatAPPID]) {
        _payTureFaulseBack = YES;
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"tencent%@",QQAPPID]]) {
        return  [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}


//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的
-(void) onResp:(BaseResp*)resp
{
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcodeWechat:%d", resp.errCode];
    NSLog(@"wechatpayResoult%@",payResoult);
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0: {
                payResoult = @"支付结果：成功！";
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"newPayOrderNum"] length] > 0) {
                    NSLog(@"zoudeshionResp");
                    [self checkOutTheOrderWithOrderNum:[[NSUserDefaults standardUserDefaults] objectForKey:@"newPayOrderNum"]];
                }
                
            }
                break;
            case -1:
                payResoult = @"支付结果：失败！";
                [MBProgressHUD cc_showText:SIMLocalizedString(@"NPayAlertViewfail", nil)];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newPayOrderNum"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newOrderType"];
                break;
            case -2: {
                payResoult = @"用户已经退出支付！";
                [MBProgressHUD cc_showText:SIMLocalizedString(@"NPayAlertViewNoPayed", nil)];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newPayOrderNum"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newOrderType"];
                break;
            }
            default:
                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                [MBProgressHUD cc_showText:SIMLocalizedString(@"NPayAlertViewfail", nil)];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newPayOrderNum"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newOrderType"];
                break;
        }
    }else if ([resp isMemberOfClass:[SendAuthResp class]])  {
        NSLog(@"******************获得的微信登录授权******************");
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode != 0 ) {
            [MBProgressHUD cc_showFail:@"微信登录授权失败"];
            return;
        }
        NSString *code = aresp.code;
        NSLog(@"wechatcodecode %@",code);
        NSDictionary *codeDic = @{@"code":code,@"platform":@"wechat"};
        [[NSNotificationCenter defaultCenter] postNotificationName:ThirdLoginGetData object:nil userInfo:codeDic];
    }
}

- (void)checkOutTheOrderWithOrderNum:(NSString *)orderNum {
    NSLog(@"orderNumorderNum %@",orderNum);
    // 支付种类  钱包和计划
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"newOrderType"] isEqualToString:@"WalletAdd"]) {
        // 钱包
        [MainNetworkRequest walletConfireMineWechatResult:@{@"order_num":orderNum,@"type":APPWechatTitle} success:^(id success) {
            NSLog(@"paysuccesssuccess%@",success);
            if ([success[@"code"] integerValue] == successCodeOK) {
                NSLog(@"新的支付订单验证成功");
                [self presentTheAlertView:success istype:@"WalletAdd"];
            }else {
                [self presentTheAlertView:success istype:@"WalletAdd"];
            }
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newPayOrderNum"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newOrderType"];
            
        } failure:^(id failure) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newPayOrderNum"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newOrderType"];
            [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
        }];
    }else {
        // 计划
        [MainNetworkRequest newPayPayVerifyResult:@{@"orderNum":orderNum,@"type":APPWechatTitle} success:^(id success) {
            NSLog(@"payPLANsuccesssuccess%@",success);
            if ([success[@"code"] integerValue] == successCodeOK) {
                NSLog(@"新的支付订单验证成功");
                [self presentTheAlertView:success istype:@"ProjectAdd"];
            }else {
                [self presentTheAlertView:success istype:@"ProjectAdd"];
            }
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newPayOrderNum"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newOrderType"];
        } failure:^(id failure) {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
            // 这里不管成功失败都要清掉 防止接口报错之后下次还要验证去提示 客户端这里只做提示效果 其实后台已经保存了
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newPayOrderNum"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newOrderType"];
        }];
    }
}


- (void)presentTheAlertView:(NSDictionary *)dic istype:(NSString *)type {
    _backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.2;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 添加到窗口
    [window addSubview:_backView];
    
    _little = [[SIMPayResultAlertView alloc] initWithFrame:CGRectMake((screen_width - 280)/2, (screen_height - 180)/2, 280,155)];
    _little.dicM = dic;
    
    [window addSubview:_little];

    __weak typeof(self)weakSelf = self;
    // 保存按钮方法
    _little.saveClick = ^{
        [weakSelf tapClick];
//        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshMainPageData object:nil];
        SIMTabBarViewController *tabVc = (SIMTabBarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        UINavigationController *selectedNavc = (UINavigationController *)tabVc.selectedViewController;
        [selectedNavc dismissViewControllerAnimated:NO completion:nil];
//        if ([selectedNavc.topViewController isKindOfClass:[SIMWalletMainViewController class]]) {
//            [selectedNavc.navigationBar  setTranslucent:NO];
//            selectedNavc.navigationBar.opaque = YES;
//            [selectedNavc.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//            [selectedNavc.navigationBar setTintColor:BlueButtonColor];
//            selectedNavc.navigationBar.titleTextAttributes=
//            @{NSForegroundColorAttributeName:NewBlackTextColor,
//              NSFontAttributeName:FontRegularName(18)};
//            [selectedNavc.navigationBar setShadowImage:[UIImage imageWithColor:ZJYColorHex(@"#f4f3f3")]];
//            selectedNavc.navigationBar.barStyle = UIBarStyleDefault; //状态栏改为黑色
//        }
        [selectedNavc popToRootViewControllerAnimated:NO];
        [tabVc setSelectedIndex:0];
    };
}

- (void)tapClick {
    [_backView removeFromSuperview];
    [_little removeFromSuperview];
}
- (void)shareSDKMethod {
    
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        [platformsRegister setupWeChatWithAppId:WeichatAPPID appSecret:WeichatAPPSecret universalLink:WXuniversalLink];
        [platformsRegister setupQQWithAppId:QQAPPID appkey:QQAPPSecret enableUniversalLink:NO universalLink:nil];
    }];
    
//    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
//        //QQ
//        [platformsRegister setupQQWithAppId:QQAPPID appkey:QQAPPSecret];
//        //微信
//        [platformsRegister setupWeChatWithAppId:WeichatAPPID appSecret:WeichatAPPSecret];
//    }];
}
- (void)pushThePrivateAlert {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.2;
    backView.tag = 1000;
    [window addSubview:backView];
    NSLog(@"window添加了backView");
    
    SIMScrollTextAlertView *privateAlertView = [[SIMScrollTextAlertView alloc] init];
    privateAlertView.tag = 1001;
    [window addSubview:privateAlertView];
    [privateAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(kWidthScale(50));
        make.right.mas_equalTo(-kWidthScale(50));
    }];
    NSLog(@"window添加了privateAlertView");
    
    privateAlertView.buttonSerialBlock = ^(NSInteger index) {
        if (index == 1) {
            // 代表同意 以后不用弹了
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"privateAlertView"];
        }
        [[[UIApplication sharedApplication].keyWindow viewWithTag:1000] removeFromSuperview];
        [[[UIApplication sharedApplication].keyWindow viewWithTag:1001] removeFromSuperview];
    };
    NSString *privateStr = @"《隐私协议》";
    [privateAlertView.content yb_addAttributeTapActionWithStrings:@[privateStr] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
        // 跳到隐私政策
        SIMTempCompanyViewController *webVC = [[SIMTempCompanyViewController alloc] init];
        UIViewController* navVC = [webVC sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
        navVC.modalPresentationStyle = UIModalPresentationFullScreen;
        webVC.isPresent = YES;
        webVC.navigationItem.title = SIMLocalizedString(@"KHBseverceAndListPrivateClick", nil);
        webVC.webStr = [NSString stringWithFormat:@"%@%@",kApiBaseUrl,self.cloudVersion.privacy_path];
        [windowRootViewController presentViewController:navVC animated:YES completion:nil];
    
    }];
}


@end
