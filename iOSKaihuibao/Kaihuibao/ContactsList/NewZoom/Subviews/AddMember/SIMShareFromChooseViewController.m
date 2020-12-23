//
//  SIMShareFromChooseViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/7/24.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMShareFromChooseViewController.h"
#import "SIMContants.h"
#import "SIMAddUserResultViewController.h"
#import "SIMAddFromAdressCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
@interface SIMShareFromChooseViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    dispatch_queue_t _queueEnter;
    dispatch_group_t _groupEnter;
}
@property (nonatomic, strong) SIMAddUserResultViewController *mySRTVC;
@property (nonatomic, strong) SIMBaseTableView *tableView;
@property (nonatomic, strong) SIMContants *sont;// 人员模型
@property (nonatomic, strong) UISearchController *searchController;//搜索框
@property (nonatomic, strong) NSMutableArray *dataSource;// 数据源
@property (nonatomic, strong) UIButton *gotoBuy;
@property (nonatomic, strong) UILabel *countLab;
@property (nonatomic, strong) NSMutableArray *choseIndexArr;
@property (nonatomic, assign) int successCount;
@property (nonatomic, assign) int failCount;
@end

static NSString *reuse = @"SIMAddFromAdressCell";

@implementation SIMShareFromChooseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"AddFromIMAdressTitle", nil);
    // 创建全局队列
    _queueEnter = dispatch_get_global_queue(0, 0);
    _groupEnter = dispatch_group_create();
    
    self.view.backgroundColor = [UIColor whiteColor];
    _choseIndexArr = [NSMutableArray array];
    _dataSource = [[NSMutableArray alloc] init];
    [self requestData];
    [self addSubViews];
    [self addSearchBarUI];// 添加搜索框搜索结果展示页
    
    // 如果是会议内部界面的话 那么是返回是dismiss
    if (self.isConfVC) {
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"returnicon"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
        self.navigationItem.leftBarButtonItem = backBtn;
    }
    
}
- (void)backClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)addSubViews {
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.frame = CGRectMake(0, 0, screen_width, screen_height-StatusNavH);
    [self.view addSubview:self.tableView];
    self.tableView.bounces = NO;
    [self.tableView registerClass:[SIMAddFromAdressCell class] forCellReuseIdentifier:reuse];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(screen_height-StatusNavH -50 - BottomSaveH);
    }];
    UIView* footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50 + BottomSaveH);
    }];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = ZJYColorHex(@"#ebebeb");
    [footerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    _gotoBuy = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 85, 30)];
    [_gotoBuy setTitle:[NSString stringWithFormat:@"%@(%d/50)",SIMLocalizedString(@"JSBNextConfirmClick", nil),0] forState:UIControlStateNormal];
    [_gotoBuy setBackgroundColor:BlueButtonColor];
    [_gotoBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_gotoBuy setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [_gotoBuy setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    _gotoBuy.titleLabel.font = FontRegularName(14);
    _gotoBuy.layer.masksToBounds = YES;
    _gotoBuy.layer.cornerRadius = 6;
    [_gotoBuy addTarget:self action:@selector(addUserToSend) forControlEvents:UIControlEventTouchUpInside];
//    [footerView addSubview:_gotoBuy];
//    [_gotoBuy mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(10);
//        make.right.mas_equalTo(-15);
//        make.width.mas_equalTo(85);
//        make.height.mas_equalTo(30);
//    }];
    UIBarButtonItem *customBtn = [[UIBarButtonItem alloc] initWithCustomView:_gotoBuy];
    self.navigationItem.rightBarButtonItem = customBtn;
    
    _countLab = [[UILabel alloc] init];
    _countLab.textColor = BlueButtonColor;
    _countLab.font = FontRegularName(14);
    _countLab.text = [NSString stringWithFormat:@"%@：%d",SIMLocalizedString(@"AddFromAdressAreadyChoose", nil),0];
    [footerView addSubview:_countLab];
    [_countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(15);
    }];
    //    MJRefreshNormalHeader *refreshHead = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getAdressDataInfo)];
    //    refreshHead.lastUpdatedTimeLabel.hidden = YES;
    //    self.tableView.mj_header = refreshHead;
}

// 添加搜索框搜索结果展示页
- (void)addSearchBarUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mySRTVC = [[SIMAddUserResultViewController alloc] init];
    self.mySRTVC.mainSearchController = self;
    self.searchController=[[UISearchController alloc]initWithSearchResultsController:self.mySRTVC];
    //设置与界面有关的样式
    [self.searchController.searchBar sizeToFit];   //大小调整
    _searchController.searchBar.placeholder = SIMLocalizedString(@"CGSearchBarPlaceHolder", nil);
    _searchController.searchBar.barTintColor = [UIColor whiteColor];
    _searchController.searchBar.backgroundColor = [UIColor whiteColor];
    UITextField *searchField = [self.searchController.searchBar valueForKey:@"searchField"];
    searchField.textColor = BlackTextColor;
    searchField.font = FontRegularName(16);
    searchField.backgroundColor=ZJYColorHex(@"#ededee");
    // 更改背景颜色并去掉黑线
    UIImageView *barimag = [[[_searchController.searchBar.subviews firstObject] subviews] firstObject];
    barimag.layer.borderColor = [UIColor whiteColor].CGColor;
    barimag.layer.borderWidth = 1;
    self.tableView.tableHeaderView = _searchController.searchBar;
    //设置搜索控制器的结果更新代理对象
    self.searchController.searchResultsUpdater=self;
    self.searchController.searchBar.delegate=self;
    self.searchController.delegate = self;
    self.definesPresentationContext=YES;
}
#pragma mark - UISearchResultsUpdating
/**实现更新代理*/
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //获取到用户输入的数据
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *searchResult = [[NSMutableArray alloc]init];
    // 通讯录
    for (SIMContants *person in self.dataSource) {
        if ([person.nickname.lowercaseString rangeOfString:searchText.lowercaseString].location != NSNotFound || [person.mobile.lowercaseString rangeOfString:searchText.lowercaseString].location != NSNotFound) {
            [searchResult addObject:person];
        }
    }
    self.mySRTVC.searchResults = searchResult;
    self.mySRTVC.chooseArr = self.choseIndexArr;
    NSLog(@"_chooseArr_chooseArryuan %@ %p",self.choseIndexArr,self.choseIndexArr);
    /**通知结果ViewController进行更新*/
    [self.mySRTVC.tableView reloadData];
    
    // 修改按钮文字为中文
//    searchController.searchBar.showsCancelButton = YES;
    for(id sousuo in [searchController.searchBar subviews])
    {
        for (id zz in [sousuo subviews])
        {
            if([zz isKindOfClass:[UIButton class]]){
                UIButton *btn = (UIButton *)zz;
                [btn setTitle:SIMLocalizedString(@"NavBackComplete", nil) forState:UIControlStateNormal];
                [btn setTitleColor:BlueButtonColor forState:UIControlStateNormal];
            }
        }
    }
}
- (void)willDismissSearchController:(UISearchController *)searchController {
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    NSLog(@"_choseIndexArr_choseIndexArr  %@ %p",_choseIndexArr,_choseIndexArr);
    if (_choseIndexArr.count >= 50) {
        //            [MBProgressHUD cc_showText:@"一次最多选择50人"];
        
        for (SIMContants *person in self.dataSource) {
            person.isNotClick = YES;
        }
        for (SIMContants *person in _choseIndexArr) {
            person.isNotClick = NO;
        }
    }else {
        for (SIMContants *person in self.dataSource) {
            person.isNotClick = NO;
        }
    }
    [self.tableView reloadData];
    _countLab.text = [NSString stringWithFormat:@"%@：%ld",SIMLocalizedString(@"AddFromAdressAreadyChoose", nil),_choseIndexArr.count];
    [_gotoBuy setTitle:[NSString stringWithFormat:@"%@(%ld/50)",SIMLocalizedString(@"JSBNextConfirmClick", nil),_choseIndexArr.count] forState:UIControlStateNormal];
    //    });
}
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SIMAddFromAdressCell *addCell = [tableView dequeueReusableCellWithIdentifier:reuse];
    SIMContants *ss = self.dataSource[indexPath.row];
    ss.isContant = YES;// 这里用这个标记
    addCell.contants = ss;
    return addCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 是添加按钮 才可以展示详情页面 如果有邀请按钮 那么不需要cell点击查看详情
    SIMContants *person = self.dataSource[indexPath.row];
    person.isSelectt = !person.isSelectt;
    if (person.isSelectt) {
        [_choseIndexArr addObject:person];
    }else {
        [_choseIndexArr removeObject:person];
        
    }
    if (_choseIndexArr.count >= 50) {
        //        [MBProgressHUD cc_showText:@"一次最多选择50人"];
        for (SIMContants *person in self.dataSource) {
            person.isNotClick = YES;
        }
        for (SIMContants *person in _choseIndexArr) {
            person.isNotClick = NO;
        }
    }else {
        for (SIMContants *person in self.dataSource) {
            person.isNotClick = NO;
        }
    }
    [self.tableView reloadData];
    _countLab.text = [NSString stringWithFormat:@"%@：%ld",SIMLocalizedString(@"AddFromAdressAreadyChoose", nil),_choseIndexArr.count];
    [_gotoBuy setTitle:[NSString stringWithFormat:@"%@(%ld/50)",SIMLocalizedString(@"JSBNextConfirmClick", nil),_choseIndexArr.count] forState:UIControlStateNormal];
}

// 请求企业联系人数据
- (void)requestData {
    [MainNetworkRequest userListRequestParams:nil success:^(id success) {
        NSLog(@"successusercontactlist  %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [_dataSource removeAllObjects];
            NSDictionary *dicData = success[@"data"];
            for (NSDictionary *dic in dicData[@"member_list"]) {
                SIMContants *userContant = [[SIMContants alloc] initWithDictionary:dic];
                if (![userContant.uid isEqualToString:self.currentUser.uid]) {
                    [_dataSource addObject:userContant];
                }
            }
            [self.tableView reloadData];
            
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
//        [self.tableView.mj_header endRefreshing];
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
//        [self.tableView.mj_header endRefreshing];
    }];
    
}
- (void)requestChatIM:(SIMContants *)per {
//    __block int successCount = 0;
//    __block int failCount = 0;
    
    dispatch_group_enter(_groupEnter);
    TIMConversation * c2c_conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:per.username];
    TIMTextElem * text_elem = [[TIMTextElem alloc] init];
    [text_elem setText:self.shareText];
    TIMMessage * msg = [[TIMMessage alloc] init];
    TIMOfflinePushInfo *offlineInfo = [[TIMOfflinePushInfo alloc] init];
    offlineInfo.desc = self.shareText;
    offlineInfo.ext = self.shareText;
    [msg setOfflinePushInfo:offlineInfo];
    [msg addElem:text_elem];
    //        __weak typeof(self)weakSelf = self;
    [c2c_conversation sendMessage:msg succ:^(){
        NSLog(@"SendcustomMsg Succ");
        _successCount += 1;
        dispatch_group_leave(_groupEnter);
    }fail:^(int code, NSString * err) {
        NSLog(@"SendcustomMsg Failed:%d->%@", code, err);
        //            [MBProgressHUD cc_showText:@"分享失败"];
        _failCount += 1;
        dispatch_group_leave(_groupEnter);
    }];
}
// 将选择的联系人给腾讯IM
- (void)addUserToSend {
    
    [MBProgressHUD cc_showLoading:nil];
    for (SIMContants *per in _choseIndexArr) {
        dispatch_group_async(_groupEnter, _queueEnter, ^{
            [self requestChatIM:per];
        });
    }
    dispatch_group_notify(_groupEnter, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
        [MBProgressHUD cc_showText:[NSString stringWithFormat:@"%d条分享成功，%d条分享失败",_successCount,_failCount]];
        
        _successCount = 0;
        _failCount = 0;
        [_choseIndexArr removeAllObjects];
        for (SIMContants *person in self.dataSource) {
            person.isNotClick = NO;
            person.isSelectt = NO;
        }
        [self.tableView reloadData];
        _countLab.text = [NSString stringWithFormat:@"%@：%ld",SIMLocalizedString(@"AddFromAdressAreadyChoose", nil),_choseIndexArr.count];
        [_gotoBuy setTitle:[NSString stringWithFormat:@"%@(%ld/50)",SIMLocalizedString(@"JSBNextConfirmClick", nil),_choseIndexArr.count] forState:UIControlStateNormal];
    });
    
}

@end
