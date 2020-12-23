//
//  SIMConfShorthandViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/12/3.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMConfShorthandViewController.h"
#import "SIMConfShorthandCell.h"

@interface SIMConfShorthandViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger  _pageNumber; // 上拉加载第几页 从0开始
}
@property (strong,nonatomic) SIMBaseTableView* tableView;
@property (strong,nonatomic) NSMutableArray *cellDatas;
@property (nonatomic, strong) UIButton *findBtn;
@property(nonatomic,strong) UISearchController *searchController;// 搜索条


@end

@implementation SIMConfShorthandViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.conf_name;
    _cellDatas = [[NSMutableArray alloc] init];
    [self getAllDatas]; // 请求网络列表数据
    // 加载tableview
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.estimatedRowHeight = 30;
    self.tableView.estimatedSectionFooterHeight = 10;
    self.tableView.estimatedSectionHeaderHeight = 10;
    self.tableView.frame = CGRectMake(0, 0, screen_width, screen_height - StatusNavH);
    [self.tableView registerClass:[SIMConfShorthandCell class] forCellReuseIdentifier:@"SIMConfShorthandCell"];
    [self.view addSubview:self.tableView];
    MJRefreshNormalHeader *refreshHead = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [refreshHead setTitle:@"下拉加载更多会议速记" forState:MJRefreshStateIdle];
//    refreshHead.stateLabel.hidden = YES;
    refreshHead.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = refreshHead;
}
#pragma mark - TableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellDatas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMConfShorthandCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"SIMConfShorthandCell"];
    commonCell.model = self.cellDatas[indexPath.row];
    return commonCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)getAllDatas {
    NSInteger limitCount = 10;
    NSInteger temp = 0;
    
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    [dicM setObject:self.model.conf_id forKey:@"conf_id"];
    [dicM setObject:@(limitCount) forKey:@"limit"];
    [dicM setObject:[NSString stringWithFormat:@"%ld",temp] forKey:@"offset"];
    NSLog(@"temptemptemptemp %ld",temp);
    [MainNetworkRequest shorthandDetailRequestParams:dicM success:^(id success) {
        NSLog(@"shorthandDetailsuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [_cellDatas removeAllObjects];
            for (NSDictionary *dic in success[@"data"]) {
                SIMCofShorthandModel *model = [[SIMCofShorthandModel alloc] initWithDictionary:dic];
                [_cellDatas insertObject:model atIndex:0];
            }
            NSLog(@"_cellDatasShorthandsuccess %@",_cellDatas);
            
            [self.tableView reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_cellDatas.count > 0) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_cellDatas.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }
            });
            
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}
- (void)loadNewData {
    NSInteger limitCount = 10;
    NSInteger temp = 0;
    temp = _pageNumber + 1;
    
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    [dicM setObject:self.model.conf_id forKey:@"conf_id"];
    [dicM setObject:@(limitCount) forKey:@"limit"];
    [dicM setObject:[NSString stringWithFormat:@"%ld",temp] forKey:@"offset"];
    NSLog(@"temptemptemptemp %ld",temp);
    [MainNetworkRequest shorthandDetailRequestParams:dicM success:^(id success) {
        NSLog(@"shorthandDetailloadsuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            for (NSDictionary *dic in success[@"data"]) {
                SIMCofShorthandModel *model = [[SIMCofShorthandModel alloc] initWithDictionary:dic];
                [_cellDatas insertObject:model atIndex:0];
            }
            
            if (_cellDatas.count < limitCount) {
                [(MJRefreshNormalHeader *)self.tableView.mj_header setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
            }
            NSLog(@"_cellDatasShorthandloadDetailsuccess %@",_cellDatas);
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            
            _pageNumber += 1;// 如果是网络请求成功了 才加一
            
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}
@end
