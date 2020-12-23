//
//  SIMReservateOrderViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/10/31.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMReservateOrderViewController.h"
#import "SIMReservateOrderCell.h"
@interface SIMReservateOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView* tableView;
@property (strong,nonatomic) NSMutableArray* minePlan;

@end
static NSString *historyCell = @"SIMReservateOrderCell";
@implementation SIMReservateOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _minePlan = [NSMutableArray array];
    // 那么请求接口
    [self initSubTableView];
}
- (void)setPageIndex:(NSInteger)pageIndex {
    _pageIndex = pageIndex;
//    switch (_pageIndex) {
//        case 0:
//            [self  requestOrderList:@"all"];
//            break;
//        case 1:
//            [self  requestOrderList:@"1"];
//            break;
//        case 2:
//            [self  requestOrderList:@"0"];
//            break;
//        case 3:
//            [self  requestOrderList:@"2"];
//            break;
//        default:
//            break;
//    }
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
    [self.tableView registerClass:[SIMReservateOrderCell class] forCellReuseIdentifier:historyCell];
    MJRefreshNormalHeader *refreshHead = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDatas)];
    refreshHead.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = refreshHead;
}
- (void)refreshDatas {
//    switch (_pageIndex) {
//        case 0:
//            [self  requestOrderList:@"all"];
//            break;
//        case 1:
//            [self  requestOrderList:@"1"];
//            break;
//        case 2:
//            [self  requestOrderList:@"0"];
//            break;
//        case 3:
//            [self  requestOrderList:@"2"];
//            break;
//        default:
//            break;
//    }
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
//    return self.minePlan.count;
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

//设置单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMReservateOrderCell *conCell = [tableView dequeueReusableCellWithIdentifier:historyCell];
    // 那么请求接口
//    conCell.currentModel = self.minePlan[indexPath.row];
    return conCell;
}
//- (void)requestOrderList:(NSString *)payStatus {
//    [MainNetworkRequest newPayPlanRecordResult:@{@"payStatus":payStatus} success:^(id success) {
//        NSLog(@"newPayPlanRecordResult %@",success);
//        if ([success[@"code"] integerValue] == successCodeOK) {
//            [_minePlan removeAllObjects];
//            for (NSDictionary *dic in success[@"data"]) {
//                SIMNewPlanCurrentModel *model = [[SIMNewPlanCurrentModel alloc] initWithDictionary:dic];
//                [_minePlan addObject:model];
//            }
//            [self.tableView reloadData];
//        }else {
//            [MBProgressHUD cc_showText:success[@"msg"]];
//        }
//        [self.tableView.mj_header endRefreshing];
//    } failure:^(id failure) {
//        [self.tableView.mj_header endRefreshing];
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
//    }];
//
//}

@end
