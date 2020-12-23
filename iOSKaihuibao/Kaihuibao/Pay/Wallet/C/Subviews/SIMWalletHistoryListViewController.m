//
//  SIMWalletHistoryListViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/7/5.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMWalletHistoryListViewController.h"

#import "SIMWalletDetailTableViewCell.h"

@interface SIMWalletHistoryListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) SIMBaseTableView* tableView;
@property (strong,nonatomic) NSMutableArray *arrDatas;

@end

@implementation SIMWalletHistoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrDatas = [NSMutableArray array];
    [self requestWalletHistory];
    self.title = SIMLocalizedString(@"TopUpwithdraw_detailTitle", nil);
//    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"returnicon"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
//    self.navigationItem.leftBarButtonItem = backBtn;
    [self addsubViews];
}
- (void)addsubViews {
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.frame = CGRectMake(0, 0, screen_width, screen_height - StatusNavH);
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[SIMWalletDetailTableViewCell class] forCellReuseIdentifier:@"SIMWalletDetailTableViewCell"];
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
    return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return BottomSaveH;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMWalletDetailTableViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"SIMWalletDetailTableViewCell"];
    detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    detailCell.dic = _arrDatas[indexPath.row];
    return detailCell;
}


- (void)requestWalletHistory {
    [MainNetworkRequest walletHistoryResult:@{@"wallet_id":self.walletID} success:^(id success) {
        NSLog(@"walletmycountsuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            for (NSDictionary *dic in success[@"data"]) {
                [_arrDatas addObject:dic];
            }
            [self.tableView reloadData];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}
@end
