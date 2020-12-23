//
//  SIMResultViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/30.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMResultViewController.h"

#import "SIMContants.h"
//#import "SIMAdress.h"
//#import "SIMAdressBookTableViewCell.h"
#import "SIMAdressTableViewCell.h"
#import "SIMShareTool.h"
#import "SIMContactDetailViewController.h"


@interface SIMResultViewController ()<UITableViewDelegate,UITableViewDataSource>
@end
//static NSString *reuse = @"SIMAdressBookTableViewCell";
static NSString *reuse1 = @"SIMAdressTableViewCell";
@implementation SIMResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self.navigationController.navigationBar setTranslucent:YES];
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.frame = CGRectMake(0, isIPhoneXAll ? StatusNavH + 10 : StatusNavH, screen_width, screen_height - (isIPhoneXAll ? StatusNavH + 10 : StatusNavH));
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
//    [self.tableView registerClass:[SIMAdressBookTableViewCell class] forCellReuseIdentifier:reuse];
    [self.tableView registerClass:[SIMAdressTableViewCell class] forCellReuseIdentifier:reuse1];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.searchResults.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (_selectPage == 1) {
//        SIMAdressBookTableViewCell *addCell = [tableView dequeueReusableCellWithIdentifier:reuse];
//        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        // 从原有的分享界面进入的
//        SIMContants *model = self.searchResults[indexPath.row];
//        addCell.sont = model;
//
//        if (self.isNewHaveBtn==YES) {
//            addCell.addBtn.hidden = YES;
//        }else {
//            addCell.addBtn.hidden = NO;
//        }
//
//        if (self.isNewHaveBtn == NO) {
//            addCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }else {
//            addCell.selectionStyle = UITableViewCellSelectionStyleDefault;
//        }
//        __weak typeof (self)weakSelf = self;
//        addCell.addClick = ^{
//            if ([MFMessageComposeViewController canSendText]) {
//                // 邀请联系人 发送短信
//                [MBProgressHUD cc_showLoading:nil delay:3];
//                if (weakSelf.shareType == 1001) {
//                    // 开会为1001
//                    [weakSelf showMessageView:@[model.mobile] title:nil body:[NSString stringWithFormat:@"%@：%@ %@",weakSelf.currentUser.nickname,SIMLocalizedString(@"AdressShareSendTest", nil),[NSURL URLWithString:@"kaihuibao.net"]]];
//                }else if (weakSelf.shareType == 1002) {
//                    // 健身为1002 -- 不要了
//                    [weakSelf showMessageView:@[model.mobile] title:nil body:[NSString stringWithFormat:@"%@:我正在与帅哥靓女一起健身，现在你也来吧。 %@",weakSelf.currentUser.nickname,[NSURL URLWithString:@"kaihuibao.net/5"]]];
//                }else if (weakSelf.shareType == 1003) {
//                    // 面试分享为1003 -- 不要了  目前换成企业广场的 链接需要换一下
//                    NSString *titleStr = self.gdDetail.name;
//                    NSString *messStr = self.gdDetail.name;
//                    NSString *urlString = kApiBaseUrl;
//                    NSString *urlSs;
//                    if (self.gdDetail.shop_serial == nil) {
//                        urlSs = [NSString stringWithFormat:@"%@/duokelai1/index.html?sid=%@",urlString,self.gdDetail.serial];
//                    }else {
//                        urlSs = [NSString stringWithFormat:@"%@/duokelai1/index.html?sid=%@&gid=%@",urlString,self.gdDetail.shop_serial,self.gdDetail.serial];
//                    }
//                    [self showMessageView:@[model.mobile] title:nil body:[NSString stringWithFormat:@" %@ \n %@ \n %@",titleStr,messStr,[NSURL URLWithString:urlSs]]];
//
//                }else if (weakSelf.shareType == 1004) {
//                    // 企业视频客服为1004 -- 不要了 目前换成发现页面轮播广告的
//                    [weakSelf showMessageView:@[model.mobile] title:nil body:[NSString stringWithFormat:@"%@ \n%@ %@",weakSelf.nfPic.name,weakSelf.nfPic.detail,[NSURL URLWithString:self.nfPic.url]]];
//
//                }else if (weakSelf.shareType == 1005) {
//                    // 老板理财等发现页面其他的为1005-- 不要了 目前换成视频客服了首页的
//                    NSString *titleStr = SIMLocalizedString(@"MMainConfVideoSupport", nil);;
//
//                    NSString *urlString = kApiBaseUrl;
//
//                    NSString *urlSs = [NSString stringWithFormat:@"%@/duokelai1/index.html?sid=27578231060&from=singlemessage&isappinstalled=0",urlString];
//
//                    // 设备为1005
//                    [weakSelf showMessageView:@[model.mobile] title:nil body:[NSString stringWithFormat:@"%@ %@", titleStr,[NSURL URLWithString:urlSs]]];
//
//                }else if (_shareType == 1006) {
//                    // 首页为1006
//                    NSString *titleStr = self.adDetail.main_title;
//                    NSString *messStr = self.adDetail.subtitle;
//                    NSString *urlString = kApiBaseUrl;
//                    NSString *urlSs = [NSString stringWithFormat:@"%@/find/index.html?cid=%@",urlString,self.adDetail.serial];
//                    [self showMessageView:@[model.mobile] title:nil body:[NSString stringWithFormat:@" %@ \n %@ \n %@",titleStr,messStr,[NSURL URLWithString:urlSs]]];
//
//                }
//
//            }else {
//                [MBProgressHUD cc_showText:SIMLocalizedString(@"MessageSendTest", nil)];
//            }
//        };
//        return addCell;
//    }else if (_selectPage == 2) {// 从后台获取的通讯录界面进入
        SIMAdressTableViewCell *addCell = [tableView dequeueReusableCellWithIdentifier:reuse1];
        SIMContants *ss = self.searchResults[indexPath.row];

        addCell.contants = ss;
        __weak typeof(self) weakSelf = self;
        addCell.addBnClick = ^{
            
            if (ss.isNeedChange && ss.isUser) {
                // 已经注册了
                if (!ss.isFriend) {
                    // 如果不是好友那么去添加好友
                    NSLog(@"添加好友的方法");
                    [self addContractorRequest:ss.mobile];
                }
            }else {
                // 从邀请进入 和没有注册的话 都是邀请
                NSString *shareStr = [NSString stringWithFormat:SIMLocalizedString(@"NewAdressBookShareTitle", nil),kApiBaseUrl,@"/admin/downloadcenter/index"];
                [[SIMShareTool shareInstace] showMessageViewWithRecipients:@[ss.mobile] body:shareStr viewController:weakSelf];// 调用发送短信
            }
        };
        
        return addCell;
//    }else {
//        return nil;
//    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isNeedChange) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        // 是添加按钮 才可以展示详情页面 如果有邀请按钮 那么不需要cell点击查看详情
        SIMContants *adr = self.searchResults[indexPath.row];
        adr.isNeedChange = self.isNeedChange;
        // 成员列表
        SIMContactDetailViewController *conver = [[SIMContactDetailViewController alloc] init];
        conver.person = adr;
        [self.mainSearchController.navigationController pushViewController:conver animated:YES];
    }
}

// 添加联系人数据
- (void)addContractorRequest:(NSString *)mobileStr {
    [MBProgressHUD cc_showLoading:nil];
    NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithObjectsAndKeys:mobileStr ,@"mobile", nil];
    
    [MainNetworkRequest contractorAddRequestParams:dicM success:^(id success) {
        NSLog(@"AddContantsuccess%@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [MBProgressHUD cc_showText:success[@"msg"]];
            // 发送列表刷新通知
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshCompanyContactData object:nil];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}

@end
