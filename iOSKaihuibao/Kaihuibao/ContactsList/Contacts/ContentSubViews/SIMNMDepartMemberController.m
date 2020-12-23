//
//  SIMNMDepartMemberController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/26.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMNMDepartMemberController.h"
#import "SIMListTableViewCell.h"
#import "SIMNewConverViewController.h"
#import "SIMContants.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface SIMNMDepartMemberController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (strong,nonatomic) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray *mutArray;

@end

@implementation SIMNMDepartMemberController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _mutArray = [[NSMutableArray alloc] init];
    NSLog(@"didStrdidStr %@",self.didStr);
    [self requestUserList];
    [self addsubViews];
}

- (void)addsubViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height - StatusNavH) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.tableView setSeparatorColor:ZJYColorHex(@"#e3e3e4")];
    self.tableView.backgroundColor = [UIColor whiteColor];
//    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerClass:[SIMListTableViewCell class] forCellReuseIdentifier:@"SIMListTableViewCell"];
    
    MJRefreshNormalHeader *refreshHead = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    refreshHead.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = refreshHead;
}

- (void)loadNewData {
    [self requestUserList];// 请求数据
}
#pragma mark - TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mutArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMListTableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"SIMListTableViewCell"];
    commonCell.contants = _mutArray[indexPath.row];
    commonCell.accessoryType = UITableViewCellAccessoryNone;
    return commonCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SIMNewConverViewController *conver = [[SIMNewConverViewController alloc] init];
    conver.person = _mutArray[indexPath.row];
    conver.person.isContant = NO; // 说明是部门
    // 将本页的model数组按下标传递给下一页 下一页用一个model属性接受
    [self.navigationController pushViewController:conver animated:YES];
    
}
#pragma mark -- DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_tableview_icon"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = SIMLocalizedString(@"MMainSquareNoneTitle", nil);
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:FontRegularName(14),
                                 NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

// 请求列表
- (void)requestUserList {
    [MainNetworkRequest departmentMemberlistRequestParams:nil did:self.didStr success:^(id success) {
        if ([success[@"status"] isEqualToString:@"ok"]) {
            [_mutArray removeAllObjects];
            for (NSDictionary *dic in success[@"list"]) {
                SIMContants *model = [[SIMContants alloc] initWithDictionary:dic];
                [_mutArray addObject:model];
            }
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(id failure) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
}


@end
