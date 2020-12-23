//
//  SIMNowPlanViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/5/22.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMNowPlanViewController.h"
#import "SIMBottomView.h"
#import "SIMNewMainPayViewController.h"
#import "SIMNewPlanListModel.h"

@interface SIMNowPlanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@property (nonatomic, strong) SIMBottomView *bottomView;
@property (nonatomic, strong) SIMNewPlanCurrentModel *model;
@end

@implementation SIMNowPlanViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestMinePlan];
    [self initSubTableView];
}

- (void)initSubTableView {
    // 创建表格
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, self.view.frame.size.height - StatusNavH - 46) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
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
    
    MJRefreshNormalHeader *refreshHead = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestMinePlan)];
    refreshHead.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = refreshHead;
}

#pragma mark -- UITableViewDelegate
//设置页眉高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kWidthScale(100) + kWidthS(150);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kWidthScale(100) + kWidthS(150))];
    view.backgroundColor = [UIColor whiteColor];
    __weak typeof(self) weakSelf = self;
    _bottomView = [[SIMBottomView alloc] init];
    _bottomView.model = _model;
    _bottomView.btnClick = ^{
        if ([weakSelf.model.plan_type intValue] == 2) {
            // 计时计划的 带着关闭计划
            [weakSelf requestCloseWalletPlan];
        }else {
            // 其他计划 都跳到第一个栏目那里
            [[NSNotificationCenter defaultCenter] postNotificationName:PayRefreshTheMainPage object:nil];
        }
        
    };
    [view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kWidthS(150));
        make.top.mas_equalTo(kWidthScale(100));
    }];
    return view;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 10;
}

//设置单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)requestMinePlan {
    [MainNetworkRequest newPayNowPlanResult:@{@"plan_type":@"2"} success:^(id success) {
//        NSLog(@"nowPlansuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            _model = [[SIMNewPlanCurrentModel alloc] initWithDictionary:success[@"data"]];
            _model.type = @"minePage";
            [[NSUserDefaults standardUserDefaults] setObject:_model.planName forKey:@"currentPlanName"];
            [[NSUserDefaults standardUserDefaults] setObject:[_model.pid stringValue] forKey:@"currentPlanID"];
            [[NSUserDefaults standardUserDefaults] synchroinzeCurrentUser];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
}
- (void)requestCloseWalletPlan {
    [MBProgressHUD cc_showLoading:nil];
    [MainNetworkRequest walletCloseTimePlanResult:nil success:^(id success) {
        NSLog(@"walletCloseTimePlanResult %@",success);
        [MBProgressHUD cc_showText:success[@"msg"]];
        [self requestMinePlan];
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
}

@end
