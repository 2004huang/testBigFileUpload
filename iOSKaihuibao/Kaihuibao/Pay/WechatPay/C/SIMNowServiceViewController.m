//
//  SIMNowServiceViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/9/18.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMNowServiceViewController.h"
#import "SIMNowServiceModel.h"
#import "SIMNowPayServiceCell.h"
#import "SIMOrderPayNextViewController.h"

@interface SIMNowServiceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) SIMBaseTableView* tableView;
@property (strong,nonatomic) NSMutableArray *arrDatas;

@end

@implementation SIMNowServiceViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _arrDatas = [NSMutableArray array];
    [self serviceCurrentListRequest];
    [self addsubViews];
}
- (void)addsubViews {
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.frame = CGRectMake(0, 0, screen_width, screen_height - StatusNavH);
    self.tableView.estimatedRowHeight = 60;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[SIMNowPayServiceCell class] forCellReuseIdentifier:@"SIMNowPayServiceCell"];
}
#pragma mark - TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrDatas.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMNowPayServiceCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"SIMNowPayServiceCell"];
    detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    SIMNowServiceModel *model = _arrDatas[indexPath.row];
    detailCell.model = model;
    __weak typeof(self) weakSelf = self;
    detailCell.buttonCilckBlock = ^(NSInteger btnserial) {
        if (btnserial == 5) {
            // 关闭
            [weakSelf requestCloseWalletService:[model.pid stringValue]];
        }else {
            // 续费
            NSLog(@"点击了续费");
            SIMOrderPayNextViewController *nextVC = [[SIMOrderPayNextViewController alloc] init];
            nextVC.nowSModel = model;
            [weakSelf.navigationController pushViewController:nextVC animated:YES];
        }
    };
    return detailCell;
}
- (void)serviceCurrentListRequest {
    [MainNetworkRequest serviceCurrentListResult:nil success:^(id success) {
        NSLog(@"nowServicesuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [_arrDatas removeAllObjects];
            for (NSDictionary *dic in success[@"data"]) {
                SIMNowServiceModel *model = [[SIMNowServiceModel alloc] initWithDictionary:dic];
                [_arrDatas addObject:model];
            }
            [self.tableView reloadData];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}
- (void)requestCloseWalletService:(NSString *)pid {
    [MBProgressHUD cc_showLoading:nil];
    [MainNetworkRequest walletCloseTimeServiceResult:@{@"id":pid} success:^(id success) {
        NSLog(@"walletCloseTimePlanResult %@",success);
        [MBProgressHUD cc_showText:success[@"msg"]];
        [self serviceCurrentListRequest];
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
}
@end
