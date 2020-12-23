//
//  SIMTabBarViewController.m
//  OralSystem
//
//  Created by Ferris on 2017/2/26.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMTabBarViewController.h"
#import "SIMSettingViewController.h"
#import "SIMMainMeetingViewController.h"
#import "SIMCalledViewController.h"

#import "UITabBarController+badge.h"
#import "ConversationController.h"
#import "SIMNewContactMainController.h"
#import "SIMNewConfListViewController.h"
#import "SIMMainContactPageViewController.h"
#import "SIMManTranslationController.h"

#import "MLLivesViewContrller_main.h"
#import "MLPastViewContrller_main.h"
#import "MLHomeViewContrller_main.h"


@interface SIMTabBarViewController ()<CLConferenceDelegate>
//@property (nonatomic, strong) ConversationController *messageVC;
//@property (nonatomic, strong) SIMManTranslationController *teacherVC;
//@property (nonatomic, strong) SIMConfAllViewController *classlistVC;

@end

@implementation SIMTabBarViewController
-(instancetype)init
{
    if (self = [super init]) {
        if ([self.cloudVersion.im boolValue]) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeWithNotice:) name:@"HaveNotification" object:nil];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterCalledConfMethod:) name:CallAccpectInConf object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushTheCalledPage:) name:PushTheCalledPage object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterConfMethodCalling)   name:CallResultConf object:nil];
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ;
}

- (void)dealloc
{
    NSLog(@"tabbarControllerDealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
#if TypeMeeLike
    [self meeliketabBar];
#else
    
    SIMMainMeetingViewController *meetingVC = [[SIMMainMeetingViewController alloc] init];
    SIMNewConfListViewController *listVC = [[SIMNewConfListViewController alloc] init];
    ConversationController *messageVC = [[ConversationController alloc] init];
    SIMMainContactPageViewController *contactVC = [[SIMMainContactPageViewController alloc] init];
    SIMSettingViewController *settingVC = [[SIMSettingViewController alloc] init];
    
    // 首页会议
    meetingVC.tabBarItem.image = [[UIImage imageNamed:@"首页-标准"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    meetingVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"首页-选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    meetingVC.tabBarItem.title = SIMLocalizedString(@"TabBarMeetTitle", nil);

    // 会议列表
    listVC.tabBarItem.image = [[UIImage imageNamed:@"会议-标准"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    listVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"会议-选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    listVC.tabBarItem.title = SIMLocalizedString(@"TabBarConfTitle", nil);

    // 通讯录
    contactVC.tabBarItem.image = [[UIImage imageNamed:@"通讯录-标准"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    contactVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"通讯录-选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    contactVC.tabBarItem.title = SIMLocalizedString(@"TabBarContantTitle", nil);

    // 消息 （公开直播 -- ！！！！！改为消息）
    messageVC.tabBarItem.image = [[UIImage imageNamed:@"消息-正常"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    messageVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"消息-选择"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    messageVC.tabBarItem.title = SIMLocalizedString(@"TabBarMessageTitle", nil);

    // 我的
    settingVC.tabBarItem.image = [[UIImage imageNamed:@"我的-标准"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    settingVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"我的-选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    settingVC.tabBarItem.title = SIMLocalizedString(@"TabBarSetTitle", nil);
    
    NSMutableArray *viewArrM = [NSMutableArray array];
    [viewArrM addObject:[meetingVC sim_wrappedBySIMNavigationController]];
//#if TypeClassBao
//    if ([self.currentUser.mobile isEqualToString:@"15110191111"]) {
//        // 发现找老师
//        SIMManTranslationController *teacherVC = [[SIMManTranslationController alloc] init];
//        teacherVC.tabBarItem.image = [[UIImage imageNamed:@"教师-常态"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        teacherVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"教师-选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        teacherVC.tabBarItem.title = SIMLocalizedString(@"TabBarFindTitle", nil);
//        [viewArrM addObject:[teacherVC sim_wrappedBySIMNavigationController]];
//    }else {
        [viewArrM addObject:[listVC sim_wrappedBySIMNavigationController]];
//    }
//#else
//    [viewArrM addObject:[listVC sim_wrappedBySIMNavigationController]];
//#endif
//    if ([self.cloudVersion.im boolValue]) {
//        [viewArrM addObject:[messageVC sim_wrappedBySIMNavigationController]];
//    }
    if ([self.cloudVersion.address_book boolValue]) {
        [viewArrM addObject:[contactVC sim_wrappedBySIMNavigationController]];
    }
    [viewArrM addObject:[settingVC sim_wrappedBySIMNavigationController]];
    self.viewControllers = viewArrM.copy;

//    if (@available(iOS 13.0, *)) {
//        // 设置未被选中 的颜色
//        UITabBarAppearance *appearance = [UITabBarAppearance new];
//        appearance.stackedLayoutAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName:TabbarBtnNormalColor};
//        // 设置被选中时的颜色
//        appearance.stackedLayoutAppearance.selected.titleTextAttributes = @{NSForegroundColorAttributeName:TabbarBtnSelectColor};
//        meetingVC.tabBarItem.standardAppearance = appearance;
//        listVC.tabBarItem.standardAppearance = appearance;
//        _messageVC.tabBarItem.standardAppearance = appearance;
//        contactVC.tabBarItem.standardAppearance = appearance;
//        settingVC.tabBarItem.standardAppearance = appearance;
//    }else {
//        // 设置 tabbarItem 选中状态下的文字颜色(不被系统默认渲染,显示文字自定义颜色)
//        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TabbarBtnNormalColor} forState:UIControlStateNormal];
//        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TabbarBtnSelectColor} forState:UIControlStateSelected];
//    }
    
    self.tabBar.tintColor = TabbarBtnSelectColor;
    self.tabBar.unselectedItemTintColor = TabbarBtnNormalColor;
    
    self.selectedIndex = 0;
    
#endif

    
}

-(void)meeliketabBar{
    MLHomeViewContrller_main *homeVC = [[MLHomeViewContrller_main alloc] init];
    [self configtabbrItem:homeVC imageName:@"首页-正常" selectName:@"首页-选择" title:@"TabBarMeetTitle"];
    
    MLLivesViewContrller_main *livesVC = [[MLLivesViewContrller_main alloc] init];
    [self configtabbrItem:livesVC imageName:@"直播-正常" selectName:@"直播-选择" title:@"TabBarLivesTitle"];
    
    MLPastViewContrller_main *pastVC = [[MLPastViewContrller_main alloc] init];
    [self configtabbrItem:pastVC imageName:@"往期直播正常" selectName:@"往期直播选择" title:@"TabBarPastTitle"];

    SIMSettingViewController *settingVC = [[SIMSettingViewController alloc] init];
    [self configtabbrItem:settingVC imageName:@"我的正常" selectName:@"我的选择" title:@"TabBarSetTitle"];
    
    NSMutableArray *viewArrM = [NSMutableArray array];
    [viewArrM addObject:[homeVC sim_wrappedBySIMNavigationController]];
    [viewArrM addObject:[livesVC sim_wrappedBySIMNavigationController]];
    [viewArrM addObject:[pastVC sim_wrappedBySIMNavigationController]];
    [viewArrM addObject:[settingVC sim_wrappedBySIMNavigationController]];
    
    self.viewControllers = viewArrM.copy;
    self.tabBar.tintColor = TabbarBtnSelectColor;
    self.tabBar.unselectedItemTintColor = TabbarBtnNormalColor;
    self.selectedIndex = 0;
}

-(void)configtabbrItem:(UIViewController *)controller imageName:(NSString *)imageName selectName:(NSString * )selectName title:(NSString *)title{
    controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.title = SIMLocalizedString(title, nil);
}


- (void)setBadgeWithNotice:(NSNotification *)notification {
    if ([self.cloudVersion.im boolValue]) {
        NSString *type = [[notification userInfo] valueForKey:@"type"];
        if ([type isEqualToString:@"showRedBtn"]) {
            //显示tabbar上的小红点
            [self showBadgeOnItemIndex:2];
        }else {
            [self hideBadgeOnItemIndex:2];
        }
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


- (void)pushTheCalledPage:(NSNotification *)notification {
//
//    NSString *confDescD = [[notification userInfo] valueForKey:@"confId"];
//    NSString *srcNickName = [[notification userInfo] valueForKey:@"nickname"];
//    NSString *mobile = [[notification userInfo] valueForKey:@"mobile"];
    dispatch_async(dispatch_get_main_queue(), ^{
        // 不在会议 那么唤起被呼叫的界面 被呼叫方可以进行选择
//        _confDescD = [NSDictionary dictionaryWithDictionary:confDescDic];
        SIMCalledViewController *calledVC = [[SIMCalledViewController alloc] init];
//        calledVC.srcNickName = srcNickName;
//        calledVC.confDescDic = confDescD;
//        calledVC.mobile = mobile;
        calledVC.dictionary = [notification userInfo];
//        NSLog(@"calledVC.mobile %@",calledVC.mobile);
        calledVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:calledVC animated:YES completion:nil];
     });

}

- (void)enterCalledConfMethod:(NSNotification *)notification {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *myDictionary = [notification userInfo];
        NSString *webStr;
        if (myDictionary[@"webStr"] != nil && [myDictionary[@"webStr"] length] > 0) {
            webStr = myDictionary[@"webStr"];
        }else {
            webStr = kApiBaseUrl;
        }
        [SIMNewEnterConfTool enterTheMineConfWithCid:[myDictionary objectForKey:@"confId"] psw:webStr confType:EnterConfTypeConf isJoined:YES viewController:self];
    });
    //    dispatch_async(dispatch_get_main_queue(), ^{
//        });
}


@end
