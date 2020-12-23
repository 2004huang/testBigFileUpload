//
//  SIMNMyCompanyMemberController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/12.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMNMyCompanyMemberController.h"
#import "SIMNewDepartMent.h"
#import "SIMListTableViewCell.h"
#import "SIMNMDepartMemberController.h"
#import "SIMResultDisplayViewController.h"
#import "SIMContactDetailViewController.h"
#import "SIMAddUserMainViewController.h"

@interface SIMNMyCompanyMemberController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate>
@property (strong,nonatomic) SIMContactTableView* tableView;
@property (nonatomic, strong) NSMutableArray *departAllArr;// 部门数据
@property (nonatomic, strong) NSMutableArray *memberArr;// 部门里人员以及闲散人员的数据
@property(nonatomic,strong) SIMResultDisplayViewController *mySRTVC;// 展示搜索结果的VC
@property(nonatomic,strong) UISearchController *searchController;// 搜索条
@property (strong,nonatomic) NSMutableArray *searchResult;
@property (nonatomic, strong) UIButton *gotoBuy;

@end

@implementation SIMNMyCompanyMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = self.titleStr;
    self.view.backgroundColor = [UIColor whiteColor];
    _departAllArr = [[NSMutableArray alloc] init];
    _memberArr = [[NSMutableArray alloc] init];
    
//    [self addsubViews];
    if (self.pidStr.length <= 0) {
        [self addSearchBarUI];
        [self requestData:@"0"];
    }else {
        [self requestData:self.pidStr];
    }
    
}
- (void)addsubViews {
    self.tableView = [[SIMContactTableView alloc] initPlainInViewController:self style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[SIMListTableViewCell class] forCellReuseIdentifier:@"SIMListTableViewCell"];
//    MJRefreshNormalHeader *refreshHead = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(addRefreshDatas)];
//    refreshHead.lastUpdatedTimeLabel.hidden = YES;
//    self.tableView.mj_header = refreshHead;
    
}
//- (void)addRefreshDatas {
//    [self.tableView reloadData];
//    [self.tableView.mj_header endRefreshing];
//}
#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _departAllArr.count;
    }else {
        return _memberArr.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50;
    }else {
        return 55;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.001;
    }else {
        return 80;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }else {
        NSString *string = SIMLocalizedString(@"ContactInviteAddBottomTitle", nil);
        CGSize buttonSize = [string sizeWithAttributes:@{NSFontAttributeName:FontRegularName(15)}];
        CGFloat buttonwidth = buttonSize.width+30;
        
        UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 70)];
        _gotoBuy = [[UIButton alloc] initWithFrame:CGRectMake((screen_width - buttonwidth)/2, 15, buttonwidth, 34)];
        [_gotoBuy setTitle:string forState:UIControlStateNormal];
        _gotoBuy.layer.borderColor = BlueButtonColor.CGColor;
        _gotoBuy.layer.borderWidth = 1;
        [_gotoBuy setBackgroundColor:[UIColor whiteColor]];
        [_gotoBuy setTitleColor:BlueButtonColor forState:UIControlStateNormal];
        [_gotoBuy setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
        [_gotoBuy setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
        _gotoBuy.titleLabel.font = FontRegularName(15);
        _gotoBuy.layer.masksToBounds = YES;
        _gotoBuy.layer.cornerRadius = 17;
        
        [_gotoBuy addTarget:self action:@selector(gotoBuythegood) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:_gotoBuy];
        
        return footerView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 && _departAllArr.count > 0 && _memberArr.count > 0) {
        return 10;
    }else {
        return 0.001;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        NSString *titleStr = [NSString stringWithFormat:@"%@(%ld)",[_departAllArr[indexPath.row] name],[[_departAllArr[indexPath.row] userCount] integerValue]];
        cell.textLabel.text = titleStr;
        cell.textLabel.font = FontMediumName(16);
        cell.textLabel.textColor = BlackTextColor;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = ZJYColorHex(@"#e3e3e4");
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        return cell;
    }else {
        SIMListTableViewCell *memberCell = [tableView dequeueReusableCellWithIdentifier:@"SIMListTableViewCell"];
        memberCell.contants = _memberArr[indexPath.row];
        memberCell.accessoryType = UITableViewCellAccessoryNone;
        return memberCell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    SIMNMDepartMemberController *departVC = [[SIMNMDepartMemberController alloc] init];
//    departVC.didStr = [_departAllArr[indexPath.row] did];
//    departVC.navigationItem.title = [_departAllArr[indexPath.row] name];
//    [self.navigationController pushViewController:departVC animated:YES];
    
    if (indexPath.section == 0) {
        SIMNMyCompanyMemberController *departVC = [[SIMNMyCompanyMemberController alloc] init];
        departVC.titleStr = [_departAllArr[indexPath.row] name];
        departVC.pidStr = [[_departAllArr[indexPath.row] did] stringValue];
        [self.navigationController pushViewController:departVC animated:YES];
    }else {
        NSLog(@"点击了闲散人员或者部门里人员");
        SIMContactDetailViewController *conver = [[SIMContactDetailViewController alloc] init];
        conver.person = _memberArr[indexPath.row];
        conver.person.isContant = NO;
        [self.navigationController pushViewController:conver animated:YES];
    }
}
#pragma mark -- event
- (void)gotoBuythegood {
    SIMAddUserMainViewController *addVC = [[SIMAddUserMainViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}
// 请求企业联系人数据
- (void)requestData:(NSString *)pidstr {
    [MainNetworkRequest newDepartmentGetlistRequestParams:@{@"pid":pidstr} success:^(id success) {
        NSLog(@"successuserdepartlist  %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [_departAllArr removeAllObjects];
            [_memberArr removeAllObjects];
            NSDictionary *dicData = success[@"data"];
            for (NSDictionary *dic in dicData[@"dp_list"]) {
                SIMNewDepartMent *userContant = [[SIMNewDepartMent alloc] initWithDictionary:dic];
                [_departAllArr addObject:userContant];
            }
            for (NSDictionary *dic in dicData[@"user_list"]) {
                SIMContants *userContant = [[SIMContants alloc] initWithDictionary:dic];
                [_memberArr addObject:userContant];
            }
//            [self.tableView reloadData];
            [self addsubViews];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
//    [MainNetworkRequest departmentGetlistRequestParams:nil success:^(id success) {
//        NSLog(@"successnewdepatrcontact%@",success);
//        if ([success[@"status"] isEqualToString:@"ok"]) {
//            for (NSDictionary *dic in success[@"list"]) {
//                SIMNewDepartMent *contant = [[SIMNewDepartMent alloc] initWithDictionary:dic];
//                [_departAllArr addObject:contant];
//            }
//            [self.tableView reloadData];
//        }else {
//            [MBProgressHUD cc_showText:@""];
//        }
//        [self.tableView.mj_header endRefreshing];
//    } failure:^(id failure) {
//        [self.tableView.mj_header endRefreshing];
//    }];
//    if (didStr.length <= 0 ) {
//        _departAllArr = [NSMutableArray arrayWithObjects:@"财务部",@"人事部",@"销售部",@"哈哈哈", nil];
//        _memberArr = [NSMutableArray arrayWithObjects:@"fafd放到",@"弟弟",@"热食",@"哈哈发都发", nil];
//    }else {
//        _departAllArr = [NSMutableArray arrayWithObjects:@"财务部",@"人事部",@"销售部",@"哈哈哈", nil];
//        _memberArr = [NSMutableArray array];
//    }
    
    
//    [_departAllArr addObjectsFromArray:self.testArr];

}
- (void)addSearchBarUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mySRTVC = [[SIMResultDisplayViewController alloc] init];
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
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    //设置搜索控制器的结果更新代理对象
    self.searchController.searchResultsUpdater=self;
    self.searchController.searchBar.delegate=self;
    self.definesPresentationContext=YES;
    
}
#pragma mark - UISearchResultsUpdating
/**实现更新代理*/
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //获取到用户输入的数据
    NSString *searchText = searchController.searchBar.text;
//    NSMutableArray *conArr = [[NSMutableArray alloc] init];
//    for (SIMContants *person in _departAllArr) {
//        if ([person.nickname.lowercaseString rangeOfString:searchText.lowercaseString].location != NSNotFound) {
//            person.isContant = YES;
//            [conArr addObject:person];
//        }
//    }
//    self.mySRTVC.datas = conArr;
//    NSLog(@"self.mySRTVC.searchResults%@ %@",searchText,self.mySRTVC.datas);
    /**通知结果ViewController进行更新*/
//    [self.mySRTVC.tableView reloadData];
    if (searchText.length > 0) {
        [self searchUserRequestData:searchText];
    }
    
    // 修改按钮文字为中文
//    searchController.searchBar.showsCancelButton = YES;
    for(id sousuo in [searchController.searchBar subviews])
    {
        for (id zz in [sousuo subviews])
        {
            if([zz isKindOfClass:[UIButton class]]){
                UIButton *btn = (UIButton *)zz;
                [btn setTitle:SIMLocalizedString(@"AlertCCancel", nil) forState:UIControlStateNormal];
                [btn setTitleColor:BlueButtonColor forState:UIControlStateNormal];
            }
        }
    }
}

- (void)searchUserRequestData:(NSString *)searchStr {
    _searchResult = [NSMutableArray array];
    [MainNetworkRequest searchContractorRequestParams:@{@"name":searchStr} success:^(id success) {
        NSLog(@"successseachcontactlist  %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            
            NSDictionary *dicData = success[@"data"];
            for (NSDictionary *dic in dicData) {
                SIMContants *userContant = [[SIMContants alloc] initWithDictionary:dic];
                [_searchResult addObject:userContant];
            }
            self.mySRTVC.datas = _searchResult;
            NSLog(@"self.mySRTVC.searchResults %@",self.mySRTVC.datas);
            /**通知结果ViewController进行更新*/
            [self.mySRTVC.tableView reloadData];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
    }];
    
}
@end
