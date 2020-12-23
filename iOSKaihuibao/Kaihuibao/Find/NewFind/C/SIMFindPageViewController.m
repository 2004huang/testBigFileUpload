//
//  SIMFindPageViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/12/5.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMFindPageViewController.h"
#import "SIMMessNotifListViewController.h"
#import "SIMMessNotiModel.h"
#import "SIMMessNotifListTableViewCell.h"
@interface SIMFindPageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *messlistArr;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SIMFindPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"TabBarFindTitle", nil);
    _messlistArr = [NSMutableArray array];
    [self requestData];
    [self setupViews];
    
}
- (void)setupViews
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height - StatusNavH)];
    _tableView.backgroundColor = TableViewBackgroundColor;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    MJRefreshNormalHeader *refreshHead = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    refreshHead.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = refreshHead;
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messlistArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    // 通知类和营销类
    SIMMessNotiModel *model = _messlistArr[indexPath.row];
    SIMMessNotifListViewController *messVC = [[SIMMessNotifListViewController alloc] init];
    messVC.title = SIMLocalizedString(@"TabBarFindTitle", nil);
    messVC.classification_id = [model.classification_id stringValue];
    [self.navigationController pushViewController:messVC animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SIMMessNotifListTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"SIMMessNotifListTableViewCell"];
    if(!cell){
        cell = [[SIMMessNotifListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SIMMessNotifListTableViewCell"];
    }
    SIMMessNotiModel *model = _messlistArr[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)requestData {
    [MainNetworkRequest messageClassificationRequestParams:nil success:^(id success) {
        NSLog(@"messageClassificationList %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [_messlistArr removeAllObjects];
            for (NSDictionary *dic in success[@"data"]) {
                SIMMessNotiModel *model = [[SIMMessNotiModel alloc] initWithDictionary:dic];
                [_messlistArr addObject:model];
            }
            [_tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}

@end
