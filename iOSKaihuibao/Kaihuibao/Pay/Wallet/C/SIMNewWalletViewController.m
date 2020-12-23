//
//  SIMNewWalletViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2020/2/25.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import "SIMNewWalletViewController.h"

#import "SIMNModel.h"
#import "SIMNMmainCell.h"
#import "SIMNewWalletHeader.h"

#import "SIMCloudSpaceViewController.h"
#import "SIMNewMainPayViewController.h"
#import "SIMWalletHistoryListViewController.h"
#import "SIMMessNotifListViewController.h"
#import "SIMWalletMainViewController.h"
#import "SIMTempCompanyViewController.h"

@interface SIMNewWalletViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) SIMBaseTableView *tableView;
@property (strong,nonatomic) NSMutableArray *arr;
@property (nonatomic, strong) NSString *walletID;
@property (strong,nonatomic) SIMNewWalletHeader *headerView;

@end

static NSString *reuseNew = @"SIMNMmainCell";

@implementation SIMNewWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arr = [NSMutableArray array];
    self.title = SIMLocalizedString(@"SMyWallet", nil);
    [self requestHeaderAmountCount];
    [self requestServerListDatas];
    [self addsubViews];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"TopUpwithdraw_detailTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem = rightBtn;
// 如果是会议内部界面的话 那么是返回是dismiss
    if (self.isConfVC) {
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"returnicon"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
        self.navigationItem.leftBarButtonItem = backBtn;
    }
}
- (void)backClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)addsubViews {
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.frame = CGRectMake(0, 0, screen_width, screen_height - StatusNavH);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];

    [self.tableView registerClass:[SIMNMmainCell class] forCellReuseIdentifier:reuseNew];
    
    _headerView = [[SIMNewWalletHeader alloc] initWithFrame:CGRectMake(0, 0, screen_width, 230)];
    self.tableView.tableHeaderView = _headerView;
    __weak typeof (self)weakSelf = self;
    _headerView.indexTagBlock = ^(NSInteger btnserial) {
        if (btnserial == 1000) {
            // 红包
            SIMMessNotifListViewController *messVC = [[SIMMessNotifListViewController alloc] init];
            messVC.title = SIMLocalizedString(@"WellBeingTitle", nil);
            [weakSelf.navigationController pushViewController:messVC animated:YES];
        }else {
            // 充值
            SIMWalletMainViewController *walletVC = [[SIMWalletMainViewController alloc] init];
            [weakSelf.navigationController pushViewController:walletVC animated:YES];
        }
    };
}
#pragma mark - TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SIMNModel *model = _arr[indexPath.section];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[SIMNMmainCell class] contentViewWidth:screen_width];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMNMmainCell *btnListCell = [tableView dequeueReusableCellWithIdentifier:reuseNew];
    SIMNModel *modelD = _arr[indexPath.section];
    btnListCell.model = modelD;
    
    __weak typeof (self)weakSlf = self;
    btnListCell.indexTagBlock = ^(NSInteger btnserial) {
        [weakSlf btnSerialClickMethod:btnserial];
    };
    return btnListCell;
}
- (void)btnSerialClickMethod:(NSInteger)btnserial {
    SIMNModel *model = _arr[0];
    NSArray *arr = model.btn_list;
    NSString *clickSerial = [NSString stringWithFormat:@"%ld",btnserial];
    NSInteger clickIndex = [clickSerial integerValue] - 200;
    SIMNModel_btnList *listModel = arr[clickIndex];
    // 跳转到链接页面
    SIMTempCompanyViewController *webVC = [[SIMTempCompanyViewController alloc] init];
    webVC.navigationItem.title = listModel.titleName;
//    webVC.hasShare = YES;
    webVC.webStr = listModel.url;
    [self.navigationController pushViewController:webVC animated:YES];
}


#pragma mark -- EVENT
// 跳转明细页面
- (void)rightBtnClick {
    SIMWalletHistoryListViewController *walletVC = [[SIMWalletHistoryListViewController alloc] init];
    walletVC.walletID = _walletID;
    [self.navigationController pushViewController:walletVC animated:YES];
}

- (void)requestHeaderAmountCount {
    [MainNetworkRequest walletmyWalletResult:nil success:^(id success) {
        NSLog(@"walletmycountsuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            NSString *string = success[@"data"][@"balance"];
            _walletID = success[@"data"][@"wallet_id"];
            NSLog(@"balancestring %@ %@",string,_walletID);
            if (string.length > 0) {
                _headerView.balanceCount = string;
            }
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}
- (void)requestServerListDatas {
    NSMutableArray *allArrM = [NSMutableArray array];
    [MainNetworkRequest walletserverListResult:nil success:^(id success) {
        NSLog(@"walletserverListsuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [_arr removeAllObjects];
            NSArray *arr = success[@"data"][@"amount_list"];
            for (int i = 0; i< arr.count; i++) {
                SIMNModel_btnList *list = [[SIMNModel_btnList alloc] initWithDictionary:arr[i]];
                list.webData = YES;
                list.serial = [NSString stringWithFormat:@"%d",i + 200];// 转化类型
                [allArrM addObject:list];
            }
            
            NSDictionary *dd1 = @{@"mainTitle":SIMLocalizedString(@"MMainMoreAppTitle", nil),@"btn_list":allArrM,@"serial":@"005",@"isMore":@"yes"};
            SIMNModel *model1 = [[SIMNModel alloc] initWithDictionary:dd1];
            [_arr addObject:model1];
            [self.tableView reloadData];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}
//// 云空间 网络请求后台活动参数+会议文档会议速记
//- (void)addConfDocDatas {
//    NSMutableArray *allArrM = [NSMutableArray array];
//    if ([self.cloudVersion.cloud_space boolValue] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
//        [MainNetworkRequest walletserverListResult:nil success:^(id success) {
//        NSLog(@"walletserverListsuccess %@",success);
//        if ([success[@"code"] integerValue] == successCodeOK) {
//            [_arr removeAllObjects];
//            NSArray *arr = success[@"data"][@"amount_list"];
//
//                NSArray *arr = success[@"data"];
//                for (NSDictionary *dic in arr) {
//                    SIMNModel_btnList *list = [[SIMNModel_btnList alloc] initWithDictionary:dic];
//                    list.webData = YES;
//                    list.serial = [dic[@"id"] stringValue];// 转化类型
//                    [allArrM addObject:list];
//                }
//                NSDictionary *dd1 = @{@"mainTitle":SIMLocalizedString(@"MMainMoreAppTitle", nil),@"btn_list":allArrM,@"serial":@"005",@"isMore":@"yes"};
//                SIMNModel *model1 = [[SIMNModel alloc] initWithDictionary:dd1];
//                [_arr addObject:model1];
//                [self.tableView reloadData];
//            }else {
//                [MBProgressHUD cc_showText:success[@"msg"]];
//            }
//        } failure:^(id failure) {
//            [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
//        }];
//    }
//}
@end
