//
//  SIMAddFromAdressViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/7/9.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMAddFromAdressViewController.h"

#import "SIMContants.h"
#import "SIMAddUserResultViewController.h"

#import "SIMAddFromAdressCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
@interface SIMAddFromAdressViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) SIMAddUserResultViewController *mySRTVC;
@property (nonatomic, strong) SIMBaseTableView *tableView;
@property (nonatomic, strong) SIMContants *sont;// 人员模型
@property (nonatomic, strong) NSMutableArray *mutArray;// 数据源
@property (nonatomic, strong) UISearchController *searchController;//搜索框
@property (nonatomic, strong) NSMutableArray *dataSource;// 排序后的数据源
@property (nonatomic, strong) UIButton *gotoBuy;
@property (nonatomic, strong) UILabel *countLab;
@property (nonatomic, strong) NSMutableArray *choseIndexArr;
@end

static NSString *reuse = @"SIMAddFromAdressCell";

@implementation SIMAddFromAdressViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"AddFromAdressTitle", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    _choseIndexArr = [NSMutableArray array];
    _mutArray = [[NSMutableArray alloc] init];
    [self getAdressDataInfo];
    [self addSubViews];
    [self addSearchBarUI];// 添加搜索框搜索结果展示页
    
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
    for (NSArray *sections in self.dataSource) {
        for (SIMContants *person in sections) {
            if ([person.nickname.lowercaseString rangeOfString:searchText.lowercaseString].location != NSNotFound || [person.mobile.lowercaseString rangeOfString:searchText.lowercaseString].location != NSNotFound) {
                [searchResult addObject:person];
            }
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
            for (NSArray *arr in self.dataSource) {
                for (SIMContants *person in arr) {
                    person.isNotClick = YES;
                }
            }
            for (SIMContants *person in _choseIndexArr) {
                person.isNotClick = NO;
            }
        }else {
            for (NSArray *arr in self.dataSource) {
                for (SIMContants *person in arr) {
                    person.isNotClick = NO;
                }
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
    return [UILocalizedIndexedCollation currentCollation].sectionTitles.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.dataSource[section] count]) {
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 25)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 25)];
        label.textColor = BlackTextColor;
        label.font = [UIFont fontWithName:@"Helvetica" size:13.5];
        [headerView addSubview:label];
        if ([self.dataSource[section] count]) {
            label.text = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
        }else{
            label.text = @"";
        }
        return headerView;
    }else {
        return nil;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.dataSource[section] count]) {
        return 25;
    }else {
        return 0.001;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SIMAddFromAdressCell *addCell = [tableView dequeueReusableCellWithIdentifier:reuse];
    SIMContants *ss = self.dataSource[indexPath.section][indexPath.row];
    addCell.contants = ss;
    return addCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 是添加按钮 才可以展示详情页面 如果有邀请按钮 那么不需要cell点击查看详情
    SIMContants *person = self.dataSource[indexPath.section][indexPath.row];
    person.isSelectt = !person.isSelectt;
    if (person.isSelectt) {
        [_choseIndexArr addObject:person];
    }else {
        [_choseIndexArr removeObject:person];
        
    }
    if (_choseIndexArr.count >= 50) {
//        [MBProgressHUD cc_showText:@"一次最多选择50人"];
        for (NSArray *arr in self.dataSource) {
            for (SIMContants *person in arr) {
                person.isNotClick = YES;
            }
        }
        for (SIMContants *person in _choseIndexArr) {
            person.isNotClick = NO;
        }
    }else {
        for (NSArray *arr in self.dataSource) {
            for (SIMContants *person in arr) {
                person.isNotClick = NO;
            }
        }
    }
    [self.tableView reloadData];
    _countLab.text = [NSString stringWithFormat:@"%@：%ld",SIMLocalizedString(@"AddFromAdressAreadyChoose", nil),_choseIndexArr.count];
    [_gotoBuy setTitle:[NSString stringWithFormat:@"%@(%ld/50)",SIMLocalizedString(@"JSBNextConfirmClick", nil),_choseIndexArr.count] forState:UIControlStateNormal];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    NSArray *titles = collation.sectionTitles;
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < self.dataSource.count; i++) {
        if ([self.dataSource[i] count] > 0) {
            NSString *title = [titles objectAtIndex:i];
            [arrM addObject:title];
        }
    }
    return arrM;
}
// 排序
- (void)loadDataSource {
    
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    //1.获取获取section标题
    NSArray *titles = collation.sectionTitles;
    //2.构建每个section数组
    NSMutableArray *secionArray = [NSMutableArray arrayWithCapacity:titles.count];
    for (int i = 0; i < titles.count; i++) {
        NSMutableArray *subArr = [[NSMutableArray alloc] init];
        [secionArray addObject:subArr];
    }
    //3.排序
    //3.1 按照将需要排序的对象放入到对应分区数组
    for (SIMContants *person in _mutArray) {
        NSInteger section = [collation sectionForObject:person collationStringSelector:@selector(nickname)];
        NSMutableArray *subArr = secionArray[section];
        
        [subArr addObject:person];
    }
    //3.2 分别对分区进行排序
    for (NSMutableArray *subArr in secionArray) {
        NSArray *sortArr = [collation sortedArrayFromArray:subArr collationStringSelector:@selector(nickname)];
        [subArr removeAllObjects];
        [subArr addObjectsFromArray:sortArr];
    }
    //修改数据源
    self.dataSource = [NSMutableArray arrayWithArray:secionArray];
}
// 获取通讯录列表从后台
- (void)getAdressDataInfo {
    [MainNetworkRequest adressGetListRequestParams:nil success:^(id success) {
        // 成功
        if ([success[@"code"] integerValue] == successCodeOK) {
            [_mutArray removeAllObjects];
            NSLog(@"adresscontantlistarr%@",success[@"data"]);
            NSLog(@"addressbookscount %ld",[success[@"data"] count]);
            for (NSDictionary *cont in success[@"data"]) {
                SIMContants *adressM = [[SIMContants alloc] initWithDictionary:cont];
                [_mutArray addObject:adressM];
            }
            [self loadDataSource];
            [self.tableView reloadData];
            
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
        [self.tableView.mj_header endRefreshing];
    }];
    
}

// 将选择的联系人给后台
- (void)addUserToSend {
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    [dicM setValue:@"1" forKey:@"source"];
    NSMutableArray *arrM = [NSMutableArray array];
    for (SIMContants *per in _choseIndexArr) {
        [arrM addObject:per.mobile];
    }
    // 将数组转化成json 并过滤掉字符
    NSString *jsonString = [NSString ObjectTojsonString:arrM];
    [dicM setValue:jsonString forKey:@"mobileList"];
    NSLog(@"successsuccessdicM %@",dicM);
    [MainNetworkRequest userAddFromAdressRequestParams:dicM success:^(id success) {
        NSLog(@"successsuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [MBProgressHUD cc_showText:success[@"msg"] delay:3];
            
            [_choseIndexArr removeAllObjects];
            for (NSArray *arr in self.dataSource) {
                for (SIMContants *person in arr) {
                    person.isNotClick = NO;
                    person.isSelectt = NO;
                }
            }
            [self.tableView reloadData];
            _countLab.text = [NSString stringWithFormat:@"%@：%ld",SIMLocalizedString(@"AddFromAdressAreadyChoose", nil),_choseIndexArr.count];
            [_gotoBuy setTitle:[NSString stringWithFormat:@"%@(%ld/50)",SIMLocalizedString(@"JSBNextConfirmClick", nil),_choseIndexArr.count] forState:UIControlStateNormal];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"] delay:3];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
}



@end
