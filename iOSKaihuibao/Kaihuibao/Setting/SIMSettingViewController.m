//
//  SIMSettingViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/5/25.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMSettingViewController.h"

#import "SIMAvatarTableViewCell.h"
#import "SIMSettingNewCell.h"
#import "SIMEditProfileViewController.h"
#import "SIMMainPayScrollViewController.h"
#import "SIMSettingSubViewController.h"
#import "SIMMainPlanDetailViewController.h"
//#import "SIMMessageEditViewController.h"
#import "SIMAboutViewController.h"
//#import "SIMLanguageChooseViewController.h"
#import "SIMSetChangeCompanyViewController.h"
#import "SIMNewMainPayViewController.h"
#import "SIMNewWalletViewController.h"
//#import "SIMConfDocumentViewController.h"
#import "SIMAppPurchaseTool.h"
//#import "SIMMainReservateOrderViewController.h"
#import "SIMNewPlanListModel.h"
#import "SIMMessNotifListViewController.h"
#import "SIMFindPageViewController.h"
#import "SIMMainSubIconViewController.h"
#import "SIMAdressViewController.h"

#import <Contacts/Contacts.h>

@interface SIMSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) SIMBaseTableView* tableView;
@property (strong,nonatomic) NSArray *cellDatas;

@end

@implementation SIMSettingViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getUserList];
    [self requestMinePlan];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"SettingMainTitle", nil);
    [self addNewDatas];
    // 加载tableview
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.frame = CGRectMake(0, 0, screen_width, screen_height - StatusNavH - TabbarH);
    [self.tableView registerClass:[SIMSettingNewCell class] forCellReuseIdentifier:@"SIMSettingNewCell"];
    [self.view addSubview:self.tableView];

}

#pragma mark - TableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0) {
        return 94;
    }else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellDatas.count + 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return 1;
    }else {
        return [self.cellDatas[section - 1] count];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SIMAvatarTableViewCell *cell = [[SIMAvatarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SIMAvatarTableViewCell"];
        return cell;
    }else {
        SIMSettingNewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"SIMSettingNewCell"];
        NSDictionary *indexDic = self.cellDatas[indexPath.section - 1][indexPath.row];
        commonCell.datas = indexDic;
        NSString *indexStr = indexDic[@"title"];
        if ([indexStr isEqualToString:SIMLocalizedString(@"SLearningCentre", nil)]) {
            commonCell.userInteractionEnabled = NO;
            commonCell.title.textColor = GrayPromptTextColor;
        }else {
            commonCell.userInteractionEnabled = YES;
            commonCell.title.textColor = BlackTextColor;
        }
        return commonCell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        SIMEditProfileViewController *editProfile = [[SIMEditProfileViewController alloc] init];
        [self.navigationController pushViewController:editProfile animated:YES];
    }else {
        NSDictionary *indexDic = self.cellDatas[indexPath.section - 1][indexPath.row];
        NSString *indexStr = indexDic[@"title"];
        if ([indexStr isEqualToString:SIMLocalizedString(@"SConfPlan", nil)]) {
            // 会议计划
            SIMNewMainPayViewController *planVC = [[SIMNewMainPayViewController alloc] init];
            [self.navigationController pushViewController:planVC animated:YES];
        }else if ([indexStr isEqualToString:SIMLocalizedString(@"SMyWallet", nil)]) {
//            NSLog(@"点击了钱包");
            SIMNewWalletViewController *walletVC = [[SIMNewWalletViewController alloc] init];
            [self.navigationController pushViewController:walletVC animated:YES];
        }else if ([indexStr isEqualToString:SIMLocalizedString(@"AlertCSet", nil)]) {
//            NSLog(@"点击了设置");
            SIMSettingSubViewController *setVC = [[SIMSettingSubViewController alloc] init];
            [self.navigationController pushViewController:setVC animated:YES];
        }else if ([indexStr isEqualToString:SIMLocalizedString(@"SBuyOrder", nil)]) {
            // 购买记录
            SIMMainPayScrollViewController *orderVC = [[SIMMainPayScrollViewController alloc] init];
            [self.navigationController pushViewController:orderVC animated:YES];
        }else if ([indexStr isEqualToString:SIMLocalizedString(@"TabBarFindTitle", nil)]) {
            // 发现
            SIMFindPageViewController *findVC = [[SIMFindPageViewController alloc] init];
            [self.navigationController pushViewController:findVC animated:YES];
        }else if ([indexStr isEqualToString:SIMLocalizedString(@"CloudSpaceTitle", nil)]) {
            // 云空间
            SIMMainSubIconViewController *subVC = [[SIMMainSubIconViewController alloc] init];
            subVC.typeStr = @"5004";
            [self.navigationController pushViewController:subVC animated:YES];
        }
        else if ([indexStr isEqualToString:SIMLocalizedString(@"SInviteFriends", nil)]) {
            SIMMessNotifListViewController *messVC = [[SIMMessNotifListViewController alloc] init];
            messVC.title = SIMLocalizedString(@"WellBeingTitle", nil);
            [self.navigationController pushViewController:messVC animated:YES];
        }else if ([indexStr isEqualToString:SIMLocalizedString(@"SAbort", nil)]) {
            // 关于开会宝
            SIMAboutViewController *aboutEdit = [[SIMAboutViewController alloc] init];
            [self.navigationController pushViewController:aboutEdit animated:YES];
        }else if ([indexStr isEqualToString:SIMLocalizedString(@"ServiceCenterTitle", nil)]) {
            // 服务中心
            SIMMainPlanDetailViewController *planVC = [[SIMMainPlanDetailViewController alloc] init];
            [self.navigationController pushViewController:planVC animated:YES];
        }else if ([indexStr isEqualToString:SIMLocalizedString(@"WellBeingTitle", nil)]) {
            // 福利社
            SIMMessNotifListViewController *messVC = [[SIMMessNotifListViewController alloc] init];
            messVC.title = SIMLocalizedString(@"WellBeingTitle", nil);
            [self.navigationController pushViewController:messVC animated:YES];
        }
        else if ([indexStr isEqualToString:SIMLocalizedString(@"CompanyChose_change_title", nil)]) {
            // 切换公司
            SIMSetChangeCompanyViewController *changeVC = [[SIMSetChangeCompanyViewController alloc] init];
            [self.navigationController pushViewController:changeVC animated:YES];
//            SIMAdvertWebViewController *companyVC = [[SIMAdvertWebViewController alloc] init];
//            companyVC.navigationItem.title = SIMLocalizedString(@"SAbortUSConnect", nil);
//            companyVC.webStr = @"http://video.kaihuibao.net/duokelai2/index.html?sid=28693463335&gid=4254103607&from=singlemessage&isappinstalled=0";
//            [self.navigationController pushViewController:companyVC animated:YES];
        }else if ([indexStr isEqualToString:@"手机通讯录"]) {
            // 邀请好友入会 通讯录
            [self requestAuthorizationToAdd:SIMLocalizedString(@"ShareFromAdressBookTitle", nil) isNeedChange:NO];
        }
        else {
            [MBProgressHUD cc_showText:@"功能即将开放"];
        }
//        else if ([indexStr isEqualToString:SIMLocalizedString(@"SConfSetting", nil)]) {
//            // 会议设置
//            SIMConfEditViewController *confEdit = [[SIMConfEditViewController alloc] init];
//            [self.navigationController pushViewController:confEdit animated:YES];
//        }else if ([indexStr isEqualToString:SIMLocalizedString(@"SConfDocument", nil)]) {
//            // 会议文档
//            SIMConfDocumentViewController *confDoc = [[SIMConfDocumentViewController alloc] init];
//            confDoc.pageType = @"doc";
//            [self.navigationController pushViewController:confDoc animated:YES];
//        }else if ([indexStr isEqualToString:SIMLocalizedString(@"SMessageNotify", nil)]) {
//            // 消息通知
//            SIMMessageEditViewController *messEdit = [[SIMMessageEditViewController alloc] init];
//            [self.navigationController pushViewController:messEdit animated:YES];
//        }else if ([indexStr isEqualToString:SIMLocalizedString(@"SLanguages", nil)]) {
//            // 多语言环境
//            SIMLanguageChooseViewController *langVC = [[SIMLanguageChooseViewController alloc] init];
//            langVC.pageType = @"login";
//            [self.navigationController pushViewController:langVC animated:YES];
//        }
        
    }

}
// 获取用户信息列表
- (void)getUserList {
    
    [MainNetworkRequest getInfoRequestParams:nil success:^(id success) {
        // 成功
        if ([success[@"code"] integerValue] == successCodeOK) {
//            NSLog(@"getnewuser_info:+++%@",success);
            
            // 字典 加入一个token值 用来初始化CCUser
            NSMutableDictionary *dicMM = [[NSMutableDictionary alloc] initWithDictionary:success[@"data"]];
            
            for (int i =0; i<dicMM.count; i++) {
                if ([[dicMM objectForKey:dicMM.allKeys[i]] isKindOfClass:[NSNumber class]]) {
                    NSString *key = dicMM.allKeys[i];
                    NSNumber *longn = [NSNumber numberWithLong:[[dicMM objectForKey:key] longValue]];
                    NSString *longss = [longn stringValue];
                    [dicMM removeObjectForKey:key];
                    [dicMM setObject:longss forKey:key];
                }
            }
            
            if ([[dicMM objectForKey:@"avatar"] length] >0) {
                // 将face的value取出来 然后拼接
                NSString *faceValue = [dicMM objectForKey:@"avatar"];
                NSString *newFaceValue = [NSString stringWithFormat:@"%@/%@",kApiBaseUrl,faceValue];
                
                [dicMM removeObjectForKey:@"avatar"];
                [dicMM setObject:newFaceValue forKey:@"avatar"];
            }
            
            //  登录或注册服务器默认有的参数 赋值给self.currentUser以后全局可用 主要是不可以改变
            CCUser *myUser = [[CCUser alloc] initWithDictionary:dicMM];
            self.currentUser = myUser;
            
            self.currentUser.currentCompany = self.currentCompany;
            
            [self.currentUser synchroinzeCurrentUser];
            NSLog(@"newcurrentUser:+++%@",self.currentUser);
//
//            NSLog(@"newcomcom %@ %@",self.currentUser.currentCompany.company_id,self.currentUser.currentCompany.company_name);
//            NSLog(@"newcomcomteo %@ %@", self.currentCompany.company_id, self.currentCompany.company_name);
            [self.tableView reloadData];
        }
        
        
    } failure:^(id failure) {
        NSError *error = failure;
        // 取消网络用 如果是取消了 不提示失败的弹框 但是现在都不用了
        if (error.code == -999) {
            
        }else {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil) ];
        }
        
    }];
}
- (void)addDatas {
    NSMutableArray *section1 = [NSMutableArray array];
    NSMutableArray *section2 = [NSMutableArray array];
    NSMutableArray *section3 = [NSMutableArray array];
    
#if TypeClassBao
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"] && [self.cloudVersion.plan boolValue]) {
        [section1 addObject:@{@"icon":@"setting会议计划",
                              @"title":SIMLocalizedString(@"SConfPlan", nil)}];
        [section1 addObject:@{@"icon":@"setting购买记录",
                              @"title":SIMLocalizedString(@"SBuyOrder", nil)}];
        [section1 addObject:@{@"icon":@"setting我的钱包",
                              @"title":SIMLocalizedString(@"SMyWallet", nil)}];
    }
    
    if ([self.cloudVersion.find boolValue] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
        [section1 addObject:@{@"icon":@"setting发现",
        @"title":SIMLocalizedString(@"TabBarFindTitle", nil)}];
    }
#else
    // 分区1
    if ([self.cloudVersion.plan boolValue]) {
        [section1 addObject:@{@"icon":@"setting会议计划",
                              @"title":SIMLocalizedString(@"SConfPlan", nil)}];
        [section1 addObject:@{@"icon":@"setting购买记录",
                              @"title":SIMLocalizedString(@"SBuyOrder", nil)}];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"] == YES) {
            [section1 addObject:@{@"icon":@"setting我的钱包",
                                  @"title":SIMLocalizedString(@"SMyWallet", nil)}];
        }
//        [section1 addObject:@{@"icon":@"setting我的钱包",
//        @"title":SIMLocalizedString(@"NPayReservationOrderTitle", nil)}];
    }
    if ([self.cloudVersion.find boolValue] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
        [section1 addObject:@{@"icon":@"setting发现",
        @"title":SIMLocalizedString(@"TabBarFindTitle", nil)}];
    }
#endif

    // 分区2
//    [section2 addObject:@{@"icon":@"setting会议设置",
//                          @"title":SIMLocalizedString(@"SConfSetting", nil)}];
    [section2 addObject:@{@"icon":@"setting会议设置",
                          @"title":SIMLocalizedString(@"AlertCSet", nil)}];
    if ([self.cloudVersion.find boolValue] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
        [section2 addObject:@{@"icon":@"setting邀请好友",
        @"title":SIMLocalizedString(@"SInviteFriends", nil)}];
    }
    if ([self.cloudVersion.learning_center boolValue]) {
        [section2 addObject:@{@"icon":@"setting学习中心",
        @"title":SIMLocalizedString(@"SLearningCentre", nil)}];
    }
    
//    if (self.cloudVersion.webFileUrl.length > 0) {
//        [section2 addObject:@{@"icon":@"setting会议文档",
//        @"title":SIMLocalizedString(@"SConfDocument", nil)}];
//    }
//    if ([self.cloudVersion.im boolValue]) {
//        [section2 addObject:@{@"icon":@"setting消息通知",
//                              @"title":SIMLocalizedString(@"SMessageNotify", nil)}];
//    }
//    if ([self.cloudVersion.many_languages boolValue]) {
//        [section2 addObject:@{@"icon":@"setting多语言",
//        @"title":SIMLocalizedString(@"SLanguages", nil)}];
//    }
    if ([self.cloudVersion.cloud_space boolValue] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
        [section2 addObject:@{@"icon":@"setting云空间",
        @"title":SIMLocalizedString(@"CloudSpaceTitle", nil)}];
    }
    
    [section2 addObject:@{@"icon":@"setting关于",
                          @"title":SIMLocalizedString(@"SAbort", nil)}];
    // 分区3
    if ([self.cloudVersion.change_company boolValue]) {
        [section3 addObject:@{@"icon":@"setting切换企业",
                              @"title":SIMLocalizedString(@"CompanyChose_change_title", nil)}];
        
    }
    self.cellDatas = @[section1,section2,section3];
//    [self.tableView reloadData];
}

- (void)requestMinePlan {
    // 查询当前计划 如果展示微信 才请求当前计划
    [MainNetworkRequest newPayNowPlanResult:@{@"plan_type":@"2"} success:^(id success) {
//        NSLog(@"nowPlansuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            SIMNewPlanCurrentModel *currentModel = [[SIMNewPlanCurrentModel alloc] initWithDictionary:success[@"data"]];
            [[NSUserDefaults standardUserDefaults] setObject:currentModel.planName forKey:@"currentPlanName"];
            [[NSUserDefaults standardUserDefaults] setObject:[currentModel.pid stringValue] forKey:@"currentPlanID"];
            [[NSUserDefaults standardUserDefaults] synchroinzeCurrentUser];
            [self.tableView reloadData];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}

-(void)onZoomtypeDatas{
    NSMutableArray *section1 = [NSMutableArray array];
    if ([self.cloudVersion.plan boolValue]) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"] == YES) {
            [section1 addObject:@{@"icon":@"setting会议计划",
            @"title":SIMLocalizedString(@"SConfPlan", nil)}];
            [section1 addObject:@{@"icon":@"setting我的钱包",
                                  @"title":SIMLocalizedString(@"SMyWallet", nil)}];
            [section1 addObject:@{@"icon":@"setting我的订单",
                                  @"title":SIMLocalizedString(@"SBuyOrder", nil)}];
        }
        
    }
    [section1 addObject:@{@"icon":@"setting会议设置",
                          @"title":SIMLocalizedString(@"AlertCSet", nil)}];
    
    
    [section1 addObject:@{@"icon":@"setting关于",
                          @"title":SIMLocalizedString(@"SAbort", nil)}];
    self.cellDatas = @[section1];
}

-(void)defaultDatas{
        NSMutableArray *section1 = [NSMutableArray array];
        
    #if TypeClassBao
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"] && [self.cloudVersion.plan boolValue]) {
            [section1 addObject:@{@"icon":@"setting会议计划",
            @"title":SIMLocalizedString(@"SConfPlan", nil)}];
            [section1 addObject:@{@"icon":@"setting我的钱包",
            @"title":SIMLocalizedString(@"SMyWallet", nil)}];
            [section1 addObject:@{@"icon":@"setting我的订单",
                                  @"title":SIMLocalizedString(@"SBuyOrder", nil)}];

        }
    #else
        // 分区1
        if ([self.cloudVersion.plan boolValue]) {
            [section1 addObject:@{@"icon":@"setting会议计划",
            @"title":SIMLocalizedString(@"SConfPlan", nil)}];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"] == YES) {
                [section1 addObject:@{@"icon":@"setting我的钱包",
                                      @"title":SIMLocalizedString(@"SMyWallet", nil)}];
            }
            [section1 addObject:@{@"icon":@"setting我的订单",
                                  @"title":SIMLocalizedString(@"SBuyOrder", nil)}];
            
        }
    #endif
    //    [section1 addObject:@{@"icon":@"setting预约",
    //    @"title":@"我的预约"}];
    //    [section1 addObject:@{@"icon":@"setting我的动态",
    //    @"title":@"我的动态"}];
        
        [section1 addObject:@{@"icon":@"setting服务大厅",
        @"title":SIMLocalizedString(@"ServiceCenterTitle", nil)}];
        
//        [section1 addObject:@{@"icon":@"setting直播大厅",
//        @"title":@"直播大厅"}];
        
    //    if ([self.cloudVersion.cloud_space boolValue] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
    //        [section1 addObject:@{@"icon":@"setting云空间",
    //        @"title":SIMLocalizedString(@"CloudSpaceTitle", nil)}];
    //    }
    //
    //    if ([self.cloudVersion.find boolValue] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
    //        [section1 addObject:@{@"icon":@"setting发现",
    //        @"title":SIMLocalizedString(@"TabBarFindTitle", nil)}];
    //    }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
            [section1 addObject:@{@"icon":@"setting会员福利",
            @"title":SIMLocalizedString(@"WellBeingTitle", nil)}];
        }
        
    //    [section1 addObject:@{@"icon":@"setting关注",
    //    @"title":@"关注"}];
    //
    //    if ([self.cloudVersion.invite boolValue] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
    //        [section1 addObject:@{@"icon":@"setting邀请好友",
    //        @"title":@"手机通讯录"}];
    //    }
        [section1 addObject:@{@"icon":@"setting会议设置",
                              @"title":SIMLocalizedString(@"AlertCSet", nil)}];
        
        
        [section1 addObject:@{@"icon":@"setting关于",
                              @"title":SIMLocalizedString(@"SAbort", nil)}];
        self.cellDatas = @[section1];
    //    [self.tableView reloadData];
}

- (void)addNewDatas {
    #if TypeKaihuibao
        [self defaultDatas];
    #elif TypeVideoBao
        [self defaultDatas];
    #elif TypeClassBao
        [self defaultDatas];
    #elif TypeJianshenBao
        [self defaultDatas];
    #elif TypeXviewPrivate
        [self onZoomtypeDatas];
    #endif
}

//
//- (void)addNewDatas {
//    NSMutableArray *section1 = [NSMutableArray array];
//
//#if TypeClassBao
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"] && [self.cloudVersion.plan boolValue]) {
//        [section1 addObject:@{@"icon":@"setting会议计划",
//        @"title":SIMLocalizedString(@"SConfPlan", nil)}];
//        [section1 addObject:@{@"icon":@"setting我的钱包",
//        @"title":SIMLocalizedString(@"SMyWallet", nil)}];
//        [section1 addObject:@{@"icon":@"setting我的订单",
//                              @"title":SIMLocalizedString(@"SBuyOrder", nil)}];
//
//    }
//#else
//    // 分区1
//    if ([self.cloudVersion.plan boolValue]) {
//        [section1 addObject:@{@"icon":@"setting会议计划",
//        @"title":SIMLocalizedString(@"SConfPlan", nil)}];
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"] == YES) {
//            [section1 addObject:@{@"icon":@"setting我的钱包",
//                                  @"title":SIMLocalizedString(@"SMyWallet", nil)}];
//        }
//        [section1 addObject:@{@"icon":@"setting我的订单",
//                              @"title":SIMLocalizedString(@"SBuyOrder", nil)}];
//
//    }
//#endif
////    [section1 addObject:@{@"icon":@"setting预约",
////    @"title":@"我的预约"}];
////    [section1 addObject:@{@"icon":@"setting我的动态",
////    @"title":@"我的动态"}];
//
//    [section1 addObject:@{@"icon":@"setting服务大厅",
//    @"title":SIMLocalizedString(@"ServiceCenterTitle", nil)}];
//
//    [section1 addObject:@{@"icon":@"setting直播大厅",
//    @"title":@"直播大厅"}];
//
////    if ([self.cloudVersion.cloud_space boolValue] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
////        [section1 addObject:@{@"icon":@"setting云空间",
////        @"title":SIMLocalizedString(@"CloudSpaceTitle", nil)}];
////    }
////
////    if ([self.cloudVersion.find boolValue] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
////        [section1 addObject:@{@"icon":@"setting发现",
////        @"title":SIMLocalizedString(@"TabBarFindTitle", nil)}];
////    }
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
//        [section1 addObject:@{@"icon":@"setting会员福利",
//        @"title":SIMLocalizedString(@"WellBeingTitle", nil)}];
//    }
//
////    [section1 addObject:@{@"icon":@"setting关注",
////    @"title":@"关注"}];
////
////    if ([self.cloudVersion.invite boolValue] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
////        [section1 addObject:@{@"icon":@"setting邀请好友",
////        @"title":@"手机通讯录"}];
////    }
//    [section1 addObject:@{@"icon":@"setting会议设置",
//                          @"title":SIMLocalizedString(@"AlertCSet", nil)}];
//
//
//    [section1 addObject:@{@"icon":@"setting关于",
//                          @"title":SIMLocalizedString(@"SAbort", nil)}];
//    self.cellDatas = @[section1];
////    [self.tableView reloadData];
//}



- (void)requestAuthorizationToAdd:(NSString *)title isNeedChange:(BOOL)isNeedChange {
    
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    if(authorizationStatus ==CNAuthorizationStatusNotDetermined) {
        
        CNContactStore*contactStore = [[CNContactStore alloc]init];
        
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted,NSError*_Nullable error) {
            if(granted) {
                NSLog(@"通讯录获取授权成功==");
                
            }else{
                NSLog(@"授权失败, error=%@", error);
            }
        }];
    }
    else if (authorizationStatus == CNAuthorizationStatusRestricted ||authorizationStatus == CNAuthorizationStatusDenied) {
        NSLog(@"用户没有授权==");
        [self addAdressAlertViewController];
    }
    else if(authorizationStatus ==CNAuthorizationStatusAuthorized){
        NSLog(@"已经授权过了通讯录==");
        // 跳转通讯录
        SIMAdressViewController *adbVC = [[SIMAdressViewController alloc] init];
        adbVC.isNeedChange = isNeedChange;
        adbVC.navigationItem.title = title;
        [self.navigationController pushViewController:adbVC animated:YES];
    }
    
}

// 通讯录未开启权限弹框
- (void)addAdressAlertViewController {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:SIMLocalizedString(@"CCInfoPlistAdress", nil) message:SIMLocalizedString(@"CCInfoPlistAdressTEST", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCSet", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳入当前App设置界面,
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if( [[UIApplication sharedApplication]canOpenURL:url] ) {
            [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:^(BOOL        success) {
            }];
        }
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVc presentViewController:alertView animated:YES completion:nil];
}
@end
