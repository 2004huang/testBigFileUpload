//
//  SIMNewPlanListViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/5/21.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMNewPlanListViewController.h"
#import "SIMNewPlanListCell.h"
#import "SIMOrderPayNextViewController.h"
#import "SIMNewPlanListModel.h"
#import "SIMWalletMainViewController.h"
#import "SIMWalletPayAlertView.h"
#import "SIMTempCompanyViewController.h"
#import "SIMEnterConfPayAlertView.h"
#import "SIMMessNotifListViewController.h"
#import "SIMNewMainPayViewController.h"
#import "SIMNewWalletViewController.h"


@interface SIMNewPlanListViewController ()<UITableViewDelegate,UITableViewDataSource,CLConferenceDelegate>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *planArr;
@property (assign,nonatomic) BOOL isHaveMoney;
@property (nonatomic, strong) SIMWalletPayAlertView *little;
@property (nonatomic, strong) UIView *backView;// 蒙层

@end

@implementation SIMNewPlanListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = SIMLocalizedString(@"NPayAccountUpgrade", nil);
    _planArr = [NSMutableArray array];
    [self initSubTableView];
}
- (void)setType:(NSString *)type {
    _type = type;

    if ([_type isEqualToString:@"plan"]) {
        // 计划列表
        [self requestPlanList];
    }else {
        // 设备列表
        [self requestDeviceList];
    }
}
- (void)initSubTableView {
    // 创建表格
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, self.view.frame.size.height - StatusNavH - 46) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = ZJYColorHex(@"#f7f7f7");
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.estimatedSectionHeaderHeight =0;
    self.tableView.estimatedSectionFooterHeight =0;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[SIMNewPlanListCell class] forCellReuseIdentifier:@"SIMNewPlanListCell"];
    
    MJRefreshNormalHeader *refreshHead = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas)];
    refreshHead.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = refreshHead;
}
- (void)refreshDatas {
    if ([_type isEqualToString:@"plan"]) {
        // 计划列表
        [self requestPlanList];
    }else {
        // 设备列表
        [self requestDeviceList];
    }
}
#pragma mark -- UITableViewDelegate
//设置页眉高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _planArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

//设置单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    SIMNewPlanListCell *conCell = [tableView dequeueReusableCellWithIdentifier:@"SIMNewPlanListCell"];
    SIMNewPlanListModel *model = _planArr[indexPath.row];
    model.type = self.type;
    conCell.model = model;
    conCell.btnClick = ^{
//        if ([model.type isEqualToString:@"plan"]) {
            if ([model.orderType intValue] == 3) {
                [weakSelf addAlertViewController:model];
            }else if ([model.orderType intValue] == 4) {
                // 到充值钱包页面
                SIMWalletMainViewController *walletVC = [[SIMWalletMainViewController alloc] init];
                [self.navigationController pushViewController:walletVC animated:YES];
            }else if ([model.orderType intValue] == 5) {
                // 跳转到链接页面
                SIMTempCompanyViewController *webVC = [[SIMTempCompanyViewController alloc] init];
                webVC.navigationItem.title = SIMLocalizedString(@"NPayDetailTitle", nil);
                webVC.webStr = model.contact_url;
                [self.navigationController pushViewController:webVC animated:YES];
            }else if ([model.orderType intValue] == 6) {
                [self freeplanDetailDataRequest];
            }else {
                // 详情页面
                SIMOrderPayNextViewController *payVC = [[SIMOrderPayNextViewController alloc] init];
                payVC.type = weakSelf.type;
                payVC.model = weakSelf.planArr[indexPath.row];
                [weakSelf.navigationController pushViewController:payVC animated:YES];
            }
//        }else {
//            // 详情页面
//            SIMOrderPayNextViewController *payVC = [[SIMOrderPayNextViewController alloc] init];
//            payVC.type = weakSelf.type;
//            payVC.model = weakSelf.planArr[indexPath.row];
//            [weakSelf.navigationController pushViewController:payVC animated:YES];
//        }
        
    };
    return conCell;
}
#pragma mark -- UIAlertViewController
- (void)addAlertViewController:(SIMNewPlanListModel *)model {
    NSString *title;
    NSString *subtitle;
    if ([model.type isEqualToString:@"plan"]) {
        title = [NSString stringWithFormat:@"%@%@？",SIMLocalizedString(@"NPayConfirmedOpening", nil),model.name];
        subtitle = [NSString stringWithFormat:SIMLocalizedString(@"NPayConfirmedOpeningPText", nil),model.name];
    }else {
        title = [NSString stringWithFormat:@"%@%@？",SIMLocalizedString(@"NPayConfirmedOpening", nil),model.name];
        subtitle = [NSString stringWithFormat:SIMLocalizedString(@"NPayConfirmedOpeningSText", nil),model.name];
    }
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:subtitle preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:SIMLocalizedString(@"JSBNextConfirmClick", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self requestWalletPlan:model];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:confirm];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
}


- (void)requestPlanList {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"] == YES && [self.cloudVersion.plan boolValue]) {
        [MainNetworkRequest newPayPlanListResult:@{@"plan_type":@"4"} success:^(id success) {
                NSLog(@"planlistsuccess %@",success);
                if ([success[@"code"] integerValue] == successCodeOK) {
                    [_planArr removeAllObjects];
                    for (NSDictionary *dic in success[@"data"]) {
                        SIMNewPlanListModel *model = [[SIMNewPlanListModel alloc] initWithDictionary:dic];
                        [_planArr addObject:model];
                    }
        //            NSLog(@"planArrplanArr %@",_planArr);
                    [self.tableView reloadData];
                }else {
                    [MBProgressHUD cc_showText:success[@"msg"]];
                }
                [self.tableView.mj_header endRefreshing];
            } failure:^(id failure) {
                [self.tableView.mj_header endRefreshing];
                [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
            }];
    }else {
#if TypeClassBao || TypeXviewPrivate
    
#else
    [MainNetworkRequest inappPayListRequestParams:nil success:^(id success) {
            NSLog(@"planlistinapppaysuccess %@",success);
            if ([success[@"code"] integerValue] == successCodeOK) {
                [_planArr removeAllObjects];
                for (NSDictionary *dic in success[@"data"]) {
                    SIMNewPlanListModel *model = [[SIMNewPlanListModel alloc] initWithDictionary:dic];
                    [_planArr addObject:model];
                }
    //            NSLog(@"planArrplanArr %@",_planArr);
                [self.tableView reloadData];
            }else {
                [MBProgressHUD cc_showText:success[@"msg"]];
            }
            [self.tableView.mj_header endRefreshing];
        } failure:^(id failure) {
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
        }];
#endif
        
    }
    
}

- (void)freeplanDetailDataRequest {
    [MainNetworkRequest freeplanDetailResult:nil success:^(id success) {
        NSLog(@"freeplanDetailsuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            NSDictionary *dic = success[@"data"];
            NSDictionary *enteryDic = dic[@"entery_data"];
            [self pushTheAlert:enteryDic];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
}
- (void)pushTheAlert:(NSDictionary *)enteryDic {
    // 弹出免费的弹框
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.2;
    backView.tag = 30003;
    [window addSubview:backView];
    NSLog(@"window添加了backView");
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [backView addGestureRecognizer:tapG];

    SIMEnterConfPayAlertView *confpayAlertView = [[SIMEnterConfPayAlertView alloc] init];
    confpayAlertView.dicM = enteryDic;
    confpayAlertView.tag = 30004;
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
        if ([serial isEqualToString:@"recharge"]) {
            // 充值
            SIMWalletMainViewController *rechargeVC = [[SIMWalletMainViewController alloc] init];
            rechargeVC.isConfVC = YES;
            UIViewController *navc = [rechargeVC sim_wrappedByNavigationViewControllerClass:[SIMBaseNavigationViewController class]];
            navc.modalPresentationStyle = 0;
            [self presentViewController:navc animated:YES completion:nil];
            
        }else if ([serial isEqualToString:@"wallet"]) {
            // 钱包
            SIMNewWalletViewController *walletVC = [[SIMNewWalletViewController alloc] init];
            walletVC.isConfVC = YES;
            UIViewController *navc = [walletVC sim_wrappedByNavigationViewControllerClass:[SIMBaseNavigationViewController class]];
            navc.modalPresentationStyle = 0;
            [self presentViewController:navc animated:YES completion:nil];
        }else if ([serial isEqualToString:@"plan"]) {
            // 计划
            SIMNewMainPayViewController *planVC = [[SIMNewMainPayViewController alloc] init];
            planVC.isConfVC = YES;
            UIViewController *navc = [planVC sim_wrappedByNavigationViewControllerClass:[SIMBaseNavigationViewController class]];
            navc.modalPresentationStyle = 0;
            [self presentViewController:navc animated:YES completion:nil];
            
        }else if ([serial isEqualToString:@"welfare"]) {
            SIMMessNotifListViewController *messVC = [[SIMMessNotifListViewController alloc] init];
            messVC.title = SIMLocalizedString(@"WellBeingTitle", nil);
            messVC.isConfVC = YES;
            UIViewController *navc = [messVC sim_wrappedByNavigationViewControllerClass:[SIMBaseNavigationViewController class]];
            navc.modalPresentationStyle = 0;
            [self presentViewController:navc animated:YES completion:nil];
        }
    };
    confpayAlertView.cancelClick = ^{
        [weakSelf tapClick];
    };
}
- (void)tapClick {
    [[[UIApplication sharedApplication].keyWindow viewWithTag:30003] removeFromSuperview];
    [[[UIApplication sharedApplication].keyWindow viewWithTag:30004] removeFromSuperview];
}
- (void)requestDeviceList {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"] == YES && [self.cloudVersion.plan boolValue]) {
            [MainNetworkRequest newPayServiceListResult:nil success:^(id success) {
                    NSLog(@"servicelistsuccess %@",success);
                    if ([success[@"code"] integerValue] == successCodeOK) {
                        [_planArr removeAllObjects];
                        for (NSDictionary *dic in success[@"data"]) {
                            SIMNewPlanListModel *model = [[SIMNewPlanListModel alloc] initWithDictionary:dic];
                            [_planArr addObject:model];
                        }
            //            NSLog(@"serviceArrServicearr %@",_planArr);
                        [self.tableView reloadData];
                    }else {
                        [MBProgressHUD cc_showText:success[@"msg"]];
                    }
                    [self.tableView.mj_header endRefreshing];
                } failure:^(id failure) {
                    [self.tableView.mj_header endRefreshing];
                    [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
                }];
        }else {
    #if TypeClassBao || TypeXviewPrivate
        
    #else
        [MainNetworkRequest servicelistforauditListRequestParams:nil success:^(id success) {
                NSLog(@"servicelistinapppaysuccess %@",success);
                if ([success[@"code"] integerValue] == successCodeOK) {
                    [_planArr removeAllObjects];
                    for (NSDictionary *dic in success[@"data"]) {
                        SIMNewPlanListModel *model = [[SIMNewPlanListModel alloc] initWithDictionary:dic];
                        [_planArr addObject:model];
                    }
        //            NSLog(@"planArrplanArr %@",_planArr);
                    [self.tableView reloadData];
                }else {
                    [MBProgressHUD cc_showText:success[@"msg"]];
                }
                [self.tableView.mj_header endRefreshing];
            } failure:^(id failure) {
                [self.tableView.mj_header endRefreshing];
                [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
            }];
    #endif
            
        }
    
}
- (void)requestWalletPlan:(SIMNewPlanListModel *)model {
    NSString *title;
    if ([model.type isEqualToString:@"plan"]) {
        title = @"p";
    }else {
        title = @"s";
    }
    [MBProgressHUD cc_showLoading:nil];
    [MainNetworkRequest walletDredgeTimePlanResult:@{@"distinct":title,@"id":model.pid} success:^(id success) {
        NSLog(@"walletDredgeTimesuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
            NSDictionary *dic = success[@"data"];
//            是否跳转到钱包：=1 余额不足跳转，=0 余额充足不跳转直接开通
            BOOL isHaveMoney = [dic[@"isJump"] boolValue];
            if (isHaveMoney) {
                // 到充值钱包页面
                SIMWalletMainViewController *walletVC = [[SIMWalletMainViewController alloc] init];
                [self.navigationController pushViewController:walletVC animated:YES];
            }else {
                // 显示已开通弹框
                [self presentTheAlertView];
            }
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
}
- (void)presentTheAlertView {
    _backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.2;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 添加到窗口
    [window addSubview:_backView];
    
    _little = [[SIMWalletPayAlertView alloc] initWithFrame:CGRectMake((screen_width - 290)/2, (screen_height - 200)/2, 290,195)];
    [window addSubview:_little];
    
    __weak typeof(self)weakSelf = self;
    // 保存按钮方法
    _little.saveClick = ^{
        [weakSelf tapLittleAlertClick];
        [weakSelf requestPlanList];
    };
}

- (void)tapLittleAlertClick {
    [_backView removeFromSuperview];
    [_little removeFromSuperview];
}

@end
