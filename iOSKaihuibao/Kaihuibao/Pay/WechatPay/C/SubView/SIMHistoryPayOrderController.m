//
//  SIMHistoryPayOrderController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/11.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMHistoryPayOrderController.h"
#import "SIMHistoryPayCell.h"
#import "SIMNewPlanListModel.h"
@interface SIMHistoryPayOrderController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView* tableView;
@property (strong,nonatomic) NSMutableArray* minePlan;

@end
static NSString *historyCell = @"SIMHistoryPayCell";
@implementation SIMHistoryPayOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = SIMLocalizedString(@"NPayMain_HistoryOrder", nil);
    
    _minePlan = [NSMutableArray array];
    // 那么请求接口
    [self initSubTableView];
}
- (void)setPageIndex:(NSInteger)pageIndex {
    _pageIndex = pageIndex;
    switch (_pageIndex) {
        case 0:
            [self  requestOrderList:@"all"];
            break;
        case 1:
            [self  requestOrderList:@"1"];
            break;
        case 2:
            [self  requestOrderList:@"0"];
            break;
        case 3:
            [self  requestOrderList:@"2"];
            break;
        default:
            break;
    }
}
- (void)initSubTableView {
    // 创建表格
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - StatusNavH - 46) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = ZJYColorHex(@"#f7f7f7");
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    self.tableView.estimatedRowHeight = 60;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[SIMHistoryPayCell class] forCellReuseIdentifier:historyCell];
    MJRefreshNormalHeader *refreshHead = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas)];
    refreshHead.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = refreshHead;
}
- (void)refreshDatas {
    switch (_pageIndex) {
        case 0:
            [self  requestOrderList:@"all"];
            break;
        case 1:
            [self  requestOrderList:@"1"];
            break;
        case 2:
            [self  requestOrderList:@"0"];
            break;
        case 3:
            [self  requestOrderList:@"2"];
            break;
        default:
            break;
    }
}
#pragma mark -- UITableViewDelegate
//设置页眉高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
//分区中行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.minePlan.count;
//    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
//    if (indexPath.section==0) {
//        return 215;
//    }else {
//        return 270;
//    }
//    //    return [self.tableView cellHeightForIndexPath:indexPath model:nil keyPath:@"model" cellClass:[SIMChoosePayPlanCell class] contentViewWidth:screen_width];
}

//设置单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMHistoryPayCell *conCell = [tableView dequeueReusableCellWithIdentifier:historyCell];
//    if (self.hisarr.count == 0) {
//        // 那么请求接口
        conCell.currentModel = self.minePlan[indexPath.row];
//    }else {
//        conCell.hismodel = self.hisarr[indexPath.row];
//    }
//    conCell.hismodel = [[SIMPayHistoryModel alloc] init];
    return conCell;
}
- (void)requestOrderList:(NSString *)payStatus {
    [MainNetworkRequest newPayPlanRecordResult:@{@"payStatus":payStatus} success:^(id success) {
        NSLog(@"newPayPlanRecordResult %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [_minePlan removeAllObjects];
            for (NSDictionary *dic in success[@"data"]) {
                SIMNewPlanCurrentModel *model = [[SIMNewPlanCurrentModel alloc] initWithDictionary:dic];
                [_minePlan addObject:model];
            }
            [self.tableView reloadData];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(id failure) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
}

// 请求历史订单
//- (void)requsetHistoryOrders {
//    [MainNetworkRequest historypayOrderResult:nil success:^(id success) {
//        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
//        NSLog(@"wechatHistorypayOrderDic   %@",success);
//        // 成功
//        if ([success[@"status"] isEqualToString:@"ok"]) {
//            NSLog(@"请求成功");
//            [_minePlan removeAllObjects];
//            for (NSDictionary *dic in success[@"list"]) {
//                SIMPayHistoryModel *model = [[SIMPayHistoryModel alloc] initWithDictionary:dic];
//                [_minePlan addObject:model];
//
//            }
//            [self.tableView reloadData];
//        }else {
//            NSLog(@"请求失败");
//        }
//    } failure:^(id failure) {
//        [MBProgressHUD cc_showText:@"请求失败"];
//    }];
//
//}

@end
