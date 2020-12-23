//
//  SIMChatMessListViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2020/6/14.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import "SIMChatMessListViewController.h"
#import "SIMMessNotifListViewController.h"
#import "SIMMessNotiModel.h"
#import "SIMMessNotifListTableViewCell.h"

@interface SIMChatMessListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) SIMBaseTableView* tableView;
@property (nonatomic, strong) NSMutableArray *messlistArr;

@end

@implementation SIMChatMessListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _messlistArr = [NSMutableArray array];
    [self setupViews];
    if ([self.cloudVersion.find boolValue] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
        [self requestData];
    }
}
- (void)setupViews
{
    // 加载tableview
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.frame = CGRectMake(0, 0, screen_width, screen_height - StatusNavH - TabbarH - 45);
    [self.tableView registerClass:[SIMMessNotifListTableViewCell class] forCellReuseIdentifier:@"SIMMessNotifListTableViewCell"];
    [self.view addSubview:self.tableView];
    
    MJRefreshNormalHeader *refreshHead = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    refreshHead.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = refreshHead;
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messlistArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    // 通知类和营销类
    SIMMessNotiModel *model = _messlistArr[indexPath.row];
    SIMMessNotifListViewController *messVC = [[SIMMessNotifListViewController alloc] init];
    messVC.title = SIMLocalizedString(@"TabBarMessageTitle", nil);
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
