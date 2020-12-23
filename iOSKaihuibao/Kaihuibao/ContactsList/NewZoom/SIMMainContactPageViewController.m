//
//  SIMMainContactPageViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/5/13.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMMainContactPageViewController.h"

#import "SIMResultDisplayViewController.h"
#import "SIMContactDetailViewController.h"
#import "SIMAdressViewController.h"
#import "SIMNCustomListController.h"
#import "SIMNMyCompanyMemberController.h"
#import "SIMOtherContactBaseController.h"
#import "SIMConfRoomListViewController.h"
#import "SIMAddUserMainViewController.h"

#import "SIMMainContactTableViewCell.h"
#import "SIMListTableViewCell.h"
#import "PopView.h"

#import "SIMContants.h"

#import <Contacts/Contacts.h>
//#import <ImSDK/ImSDK.h>
#import "THelper.h"
#import "TVoiceMessageCell.h"
#import "JJOptionView.h"

@interface SIMMainContactPageViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate,AVAudioRecorderDelegate,JJOptionViewDelegate>
{
    BOOL _isExpaned;
    dispatch_queue_t _queueEnter;
    dispatch_group_t _groupEnter;
}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *searchResult;
@property(nonatomic,strong) SIMResultDisplayViewController *mySRTVC;// 展示搜索结果的VC
@property(nonatomic,strong) UISearchController *searchController;// 搜索条
@property (strong,nonatomic) NSMutableArray  *dataList;
@property (nonatomic, strong) NSMutableArray *departAllArr;//企业联系人数据
@property(nonatomic,strong) NSArray *contactArr;
@property(nonatomic,strong) NSString *jsonString;
@property(nonatomic,strong) UIImageView *expandImage;
@property(nonatomic,strong) UIView *line;
@property(nonatomic,strong) UIView *footerV;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic,strong) NSMutableArray *listArr;
@property (strong,nonatomic) JJOptionView *optionView;

@end

@implementation SIMMainContactPageViewController
-(instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:RefreshCompanyContactData object:nil];
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)refreshData {
    [self addDatas];// 请求数据
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self requestAuthorizationForAddressBook];// 如果没穿成功那么每次进来都传一下 如果穿成功了 那么就不用了
//}

- (void)viewDidLoad {
    [super viewDidLoad];
//    _isExpaned = YES;
    _departAllArr = [[NSMutableArray alloc] init];// 企业联系人
    _dataList = [[NSMutableArray alloc] init];    // 展示列表list文字和数量
    _listArr = [NSMutableArray array];
    _searchResult = [NSMutableArray array];
    self.title = SIMLocalizedString(@"CCContantMainName", nil);
    // 创建全局队列
    _queueEnter = dispatch_get_global_queue(0, 0);
    _groupEnter = dispatch_group_create();
    
    [self addDatas];
    
    [self addSearchBarUI];
    [self addSubViews];
    
    [self searchTheCompanyListRequest];
}
- (void)addDatas {
    
    dispatch_group_async(_groupEnter, _queueEnter, ^{
        [self getListCount];
    });
    dispatch_group_async(_groupEnter, _queueEnter, ^{
        [self requestData];
    });
    
    dispatch_group_notify(_groupEnter, dispatch_get_main_queue(), ^{
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    });
    
}

- (void)addSubViews {
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"邀请联系人"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addFriendClick)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.tableView = [[SIMContactTableView alloc] initPlainInViewController:self style:UITableViewStyleGrouped];
    self.tableView.frame = CGRectMake(0, 0, screen_width, screen_height - StatusNavH - TabbarH);
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SIMMainContactTableViewCell class] forCellReuseIdentifier:@"SIMMainContactTableViewCell"];
    [self.tableView registerClass:[SIMListTableViewCell class] forCellReuseIdentifier:@"SIMListTableViewCell"];
    
    MJRefreshNormalHeader *refreshHead = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(addDatas)];
    refreshHead.lastUpdatedTimeLabel.hidden = YES;
    refreshHead.backgroundColor = [UIColor whiteColor];
    self.tableView.mj_header = refreshHead;
    
    if (!_isExpaned) {
        _footerV = [self addBottomView];
        [self.view addSubview:_footerV];
    }
    
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 50)];
    _optionView = [[JJOptionView alloc] initWithFrame:CGRectMake(20, 5, screen_width - kWidthScale(50), 40)];
    _optionView.borderWidth = 0;
    _optionView.titleFontSize = 16;
    _optionView.title = self.currentUser.currentCompany.company_name;
    _optionView.isMoreChoose = NO;
    _optionView.delegate = self;
    [backView addSubview:_optionView];
    self.tableView.tableHeaderView = backView;
    
}
#pragma mark - TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _dataList.count;
    }else {
        return _isExpaned?_departAllArr.count:0;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 40;
    }else {
        return _isExpaned?55:0;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.searchController.searchBar.height;
    }else {
        return 40;
    }
}
- (UIView *)addBottomView {
    UIView* footerView = [[UIView alloc] init];
    if (_isExpaned) {
        footerView.frame = CGRectMake(0, 0, screen_width, 70);
    }else {
        footerView.frame = CGRectMake(0, screen_height - StatusNavH - TabbarH - 70, screen_width, 70);
    }
    NSString *string = SIMLocalizedString(@"ContactInviteAddBottomTitle", nil);
    CGSize buttonSize = [string sizeWithAttributes:@{NSFontAttributeName:FontRegularName(15)}];
    CGFloat buttonwidth = buttonSize.width+30;
    
    UIButton *gotoBuy = [[UIButton alloc] initWithFrame:CGRectMake((screen_width - buttonwidth)/2, 15, buttonwidth, 34)];
    [gotoBuy setTitle:string forState:UIControlStateNormal];
    gotoBuy.layer.borderColor = BlueButtonColor.CGColor;
    gotoBuy.layer.borderWidth = 1;
    [gotoBuy setBackgroundColor:[UIColor whiteColor]];
    [gotoBuy setTitleColor:BlueButtonColor forState:UIControlStateNormal];
    [gotoBuy setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [gotoBuy setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    gotoBuy.titleLabel.font = FontRegularName(15);
    gotoBuy.layer.masksToBounds = YES;
    gotoBuy.layer.cornerRadius = 17;
    [gotoBuy addTarget:self action:@selector(gotoBuythegood) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:gotoBuy];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1 && _isExpaned) {
        return 70;
    }else {
        return 0.001;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1 && _isExpaned) {
        return [self addBottomView];
    }else {
        return nil;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.searchController.searchBar;
    }else if (section == 1 && _departAllArr.count > 0) {
        UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 40)];
        headerV.backgroundColor = [UIColor whiteColor];
        CGFloat iconHeight = 15;
        _expandImage = [[UIImageView alloc] init];
        _expandImage.contentMode = UIViewContentModeCenter;
        [headerV addSubview:_expandImage];

        UILabel *mainTitle = [[UILabel alloc] init];
        mainTitle.text = SIMLocalizedString(@"ContactCompanyContactTitle", nil);
        mainTitle.textColor = BlackTextColor;
        mainTitle.font = FontMediumName(16);
        [headerV addSubview:mainTitle];

        UILabel *detailLab = [[UILabel alloc] init];
        detailLab.textColor = BlackTextColor;
        detailLab.text = [NSString stringWithFormat:@"%ld",self.departAllArr.count];
        detailLab.font = FontRegularName(14);
        detailLab.textAlignment = NSTextAlignmentRight;
        [headerV addSubview:detailLab];

        _line = [[UIView alloc] init];
        _line.backgroundColor = ZJYColorHex(@"#e3e3e4");
        [headerV addSubview:_line];

        if (_isExpaned) {
            _expandImage.image = [UIImage imageNamed:@"通讯录页-箭头展开"];
            _line.hidden = YES;
            _footerV.hidden = YES;
        }else {
            _expandImage.image = [UIImage imageNamed:@"通讯录页-箭头"];
            _line.hidden = NO;
            _footerV.hidden = NO;
        }

        [_expandImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(iconHeight);
            make.width.mas_equalTo(iconHeight);
        }];
        [mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(_expandImage.mas_right).offset(15);
            make.right.mas_equalTo(-80);
        }];
        [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-20);
        }];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];

        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [headerV addGestureRecognizer:tapG];
        return headerV;
    }else {
        return nil;
    }
}
- (void)tapClick {
    _isExpaned = !_isExpaned;
    if (_isExpaned) {
        _expandImage.image = [UIImage imageNamed:@"通讯录页-箭头展开"];
        _line.hidden = YES;
    }else {
        _expandImage.image = [UIImage imageNamed:@"通讯录页-箭头"];
        _line.hidden = NO;
    }
    [UIView performWithoutAnimation:^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SIMMainContactTableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"SIMMainContactTableViewCell"];
        NSDictionary *dic = _dataList[indexPath.row];
        commonCell.dic = dic;
//        if ([dic[@"serial"] isEqualToString:@"inviteMan"]) {
//            commonCell.mainTitle.font = FontMediumName(17);
//        }else
        if ([dic[@"serial"] isEqualToString:@"companyTitle"]) {
            commonCell.mainTitle.font = FontMediumName(19);
            [commonCell.mainTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.left.mas_equalTo(15);
                make.right.mas_equalTo(-80);
            }];
        }
        return commonCell;
    }else if (indexPath.section == 1) {
        if (_isExpaned) {
            SIMListTableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"SIMListTableViewCell"];
            commonCell.contants = _departAllArr[indexPath.row];
            return commonCell;
        }else {
            return nil;
        }
        
    }else {
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSDictionary *dic = _dataList[indexPath.row];
        if ([dic[@"serial"] isEqualToString:@"adressContact"]) {
            [self requestAuthorizationToAdd:_dataList[indexPath.row][@"name"] isNeedChange:YES];
//            requestAuthorizationForAddressBook
        }else if ([dic[@"serial"] isEqualToString:@"extraContact"]) {
            SIMOtherContactBaseController *otherVC = [[SIMOtherContactBaseController alloc] init];
            otherVC.navigationItem.title = _dataList[indexPath.row][@"name"];
            [self.navigationController pushViewController:otherVC animated:YES];
        }else if ([dic[@"serial"] isEqualToString:@"myFriend"]) {
            SIMNCustomListController *customVC = [[SIMNCustomListController alloc] init];
            customVC.navigationItem.title = _dataList[indexPath.row][@"name"];
            [self.navigationController pushViewController:customVC animated:YES];
            
        }
//        else if ([dic[@"serial"] isEqualToString:@"inviteMan"]) {
//            [self requestAuthorizationToAdd:_dataList[indexPath.row][@"name"] isNeedChange:NO];
//        }
        else if ([dic[@"serial"] isEqualToString:@"department"]) {
            SIMNMyCompanyMemberController *companyVC = [[SIMNMyCompanyMemberController alloc] init];
            companyVC.titleStr = self.currentUser.currentCompany.company_name;
            [self.navigationController pushViewController:companyVC animated:YES];
        }else if ([dic[@"serial"] isEqualToString:@"confRoom"]) {
            SIMConfRoomListViewController *roomVC = [[SIMConfRoomListViewController alloc] init];
            roomVC.navigationItem.title = _dataList[indexPath.row][@"name"];
            [self.navigationController pushViewController:roomVC animated:YES];
        }
    }else if (indexPath.section == 1) {
        // 成员列表点击跳转详情页面
        SIMContactDetailViewController *conver = [[SIMContactDetailViewController alloc] init];
        conver.person = _departAllArr[indexPath.row];
        conver.person.isContant = NO;
        [self.navigationController pushViewController:conver animated:YES];
    }
}
- (void)addSearchBarUI {
    
    self.mySRTVC = [[SIMResultDisplayViewController alloc] init];
    self.mySRTVC.mainSearchController = self;
    self.searchController=[[UISearchController alloc]initWithSearchResultsController:self.mySRTVC];
    //设置与界面有关的样式
    [self.searchController.searchBar sizeToFit];   //大小调整
    _searchController.searchBar.placeholder = SIMLocalizedString(@"CGSearchBarPlaceHolder", nil);
    _searchController.searchBar.barTintColor = [UIColor whiteColor];
    _searchController.searchBar.backgroundColor = [UIColor whiteColor];
    //    [_searchController.searchBar setBackgroundColor:[UIColor clearColor]];
//    if (@available(iOS 13.0, *)) {
//        UISearchTextField *searchField = self.searchController.searchBar.searchTextField;
//        searchField.textColor = BlackTextColor;
//        searchField.font = FontRegularName(16);
//        searchField.backgroundColor=ZJYColorHex(@"#ededee");
//    } else {
        UITextField *searchField = [self.searchController.searchBar valueForKey:@"searchField"];
        searchField.textColor = BlackTextColor;
        searchField.font = FontRegularName(16);
        searchField.backgroundColor=ZJYColorHex(@"#ededee");
//    }
    
    // 更改背景颜色并去掉黑线
    UIImageView *barimag = [[[_searchController.searchBar.subviews firstObject] subviews] firstObject];
    barimag.layer.borderColor = [UIColor whiteColor].CGColor;
    barimag.layer.borderWidth = 1;
//    self.tableView.tableHeaderView = self.searchController.searchBar;
    //设置搜索控制器的结果更新代理对象
    self.searchController.searchResultsUpdater=self;
    self.searchController.searchBar.delegate=self;
    self.definesPresentationContext=YES;
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 55)];
//    [view addSubview:self.searchController.searchBar];
//    [self.view addSubview:view];
    
}

#pragma mark - UISearchResultsUpdating
/**实现更新代理*/
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //获取到用户输入的数据
    NSString *searchText = searchController.searchBar.text;
//    NSMutableArray *conArr = [[NSMutableArray alloc] init];
//    for (SIMContants *person in _departAllArr) {
//        if ([person.nickname.lowercaseString rangeOfString:searchText.lowercaseString].location != NSNotFound || [person.mobile.lowercaseString rangeOfString:searchText.lowercaseString].location != NSNotFound) {
//            person.isContant = YES; // 如果后台加上了是否注册是否好友的话 这里这个判断就不用了
//            [conArr addObject:person];
//        }
//    }
    if (searchText.length > 0) {
        [self searchUserRequestData:searchText];
    }
//    else {
//        NSLog(@"resultsearchResult %@",_searchResult);
//    }
    
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
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_searchResult removeAllObjects];
    self.mySRTVC.datas = _searchResult;
    NSLog(@"self.mySRTVC.searchResults222 %@",self.mySRTVC.datas);
    /**通知结果ViewController进行更新*/
    [self.mySRTVC.tableView reloadData];
}
#pragma mark -- event
- (void)gotoBuythegood {
    SIMAddUserMainViewController *addVC = [[SIMAddUserMainViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}
#pragma mark -- UIAlertController
- (void)requestAuthorizationToAdd:(NSString *)title isNeedChange:(BOOL)isNeedChange {
    
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    if(authorizationStatus == CNAuthorizationStatusNotDetermined) {
        
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted,NSError*_Nullable error) {
            if(granted) {
                NSLog(@"通讯录获取授权成功==");
                
            }else{
                NSLog(@"授权失败, error=%@", error);
            }
        }];
    }
    else if (authorizationStatus == CNAuthorizationStatusRestricted ||authorizationStatus == CNAuthorizationStatusDenied) {
        NSLog(@"用户没有授权==");
        [self addAdressAlertViewController];
    }
    else if(authorizationStatus ==CNAuthorizationStatusAuthorized){
        NSLog(@"已经授权过了通讯录==");
        // 跳转通讯录
        SIMAdressViewController *adbVC = [[SIMAdressViewController alloc] init];
        adbVC.isNeedChange = isNeedChange;
        adbVC.navigationItem.title = title;
        [self.navigationController pushViewController:adbVC animated:YES];
    }
    
}

// 通讯录未开启权限弹框
- (void)addAdressAlertViewController {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:SIMLocalizedString(@"CCInfoPlistAdress", nil) message:SIMLocalizedString(@"CCInfoPlistAdressTEST", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCSet", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳入当前App设置界面,
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if( [[UIApplication sharedApplication]canOpenURL:url] ) {
            [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:^(BOOL        success) {
            }];
        }
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVc presentViewController:alertView animated:YES completion:nil];
}

- (void)addFriendClick {
    SIMAddUserMainViewController *addVC = [[SIMAddUserMainViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}
// 请求企业联系人数据
- (void)requestData {
    dispatch_group_enter(_groupEnter);
    [MainNetworkRequest userListRequestParams:nil success:^(id success) {
        NSLog(@"successusercontactlist  %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [_departAllArr removeAllObjects];
            NSDictionary *dicData = success[@"data"];
            for (NSDictionary *dic in dicData[@"member_list"]) {
                SIMContants *userContant = [[SIMContants alloc] initWithDictionary:dic];
                [_departAllArr addObject:userContant];
            }
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
        dispatch_group_leave(_groupEnter);
    } failure:^(id failure) {
        dispatch_group_leave(_groupEnter);
    }];
    
}

- (void)getListCount {
    dispatch_group_enter(_groupEnter);
    [MainNetworkRequest adressbookListCountRequestParams:nil success:^(id success) {
        NSLog(@"successlistcount  %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [_dataList removeAllObjects];
            NSDictionary *dicData = success[@"data"];
            NSMutableArray *arrM = [NSMutableArray array];
            if ([self.cloudVersion.contacts boolValue]) {
                [arrM addObject:@{@"name":SIMLocalizedString(@"CContactPhoneContant", nil),@"count":[dicData[@"addrCount"] stringValue],@"serial":@"adressContact"}];
            }

//            [arrM addObject:@{@"name":SIMLocalizedString(@"CContactOthersMan", nil),@"count":@"0",@"serial":@"extraContact"}];
            if ([self.cloudVersion.myfriend boolValue]) {
                [arrM addObject:@{@"name":SIMLocalizedString(@"CContactMineAdress", nil),@"count":[dicData[@"contactCount"] stringValue],@"serial":@"myFriend"}];
            }
//            if ([self.cloudVersion.invite boolValue]) {
//                [arrM addObject:@{@"name":SIMLocalizedString(@"ContactIvitedPeople", nil),@"count":@"",@"serial":@"inviteMan"}];
//            }
            [arrM addObject:@{@"name":SIMLocalizedString(@"ContactCompanyTitle", nil),@"count":@"",@"serial":@"companyTitle"}];
            [arrM addObject:@{@"name":SIMLocalizedString(@"CContactOrgan", nil),@"count":[dicData[@"departmentCount"] stringValue],@"serial":@"department"}];
//            [arrM addObject:@{@"name":SIMLocalizedString(@"ContactConfRoomTitle", nil),@"count":@"0",@"serial":@"confRoom"}];
            
            [_dataList addObjectsFromArray:arrM];
            NSLog(@"_dataList_dataList %@",_dataList);
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
       dispatch_group_leave(_groupEnter);
    } failure:^(id failure) {
        dispatch_group_leave(_groupEnter);
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}
- (void)searchUserRequestData:(NSString *)searchStr {
    [MainNetworkRequest searchContractorRequestParams:@{@"name":searchStr} success:^(id success) {
        NSLog(@"successseachcontactlist  %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [_searchResult removeAllObjects];
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
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
}



- (void)optionView:(JJOptionView *)optionView selectedIndex:(NSInteger)selectedIndex {
    
    if ([self.currentUser.currentCompany.company_id isEqualToString:[_listArr[selectedIndex] company_id]]) {
        [self addActionSheetOneCompany];
    }else {
        [self addActionSheet:_listArr[selectedIndex]];
    }
    NSLog(@"selectedIndex %ld",selectedIndex);
}

// 查询公司列表的请求
- (void)searchTheCompanyListRequest {
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    [dicM setValue:@"1" forKeyPath:@"type"];

//    [MBProgressHUD cc_showLoading:nil];
    [MainNetworkRequest changeCompanyRequestParams:dicM success:^(id success) {
        if ([success[@"code"] integerValue] == successCodeOK) {
            NSLog(@"searchCompanyListSuccess %@",success);
//            [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];

            for (NSDictionary *dic in success[@"data"]) {
                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
                for (int i =0; i<tempDic.count; i++) {
                    if ([[tempDic objectForKey:tempDic.allKeys[i]] isKindOfClass:[NSNumber class]]) {
                        NSString *key = tempDic.allKeys[i];
                        NSNumber *longn = [NSNumber numberWithLong:[[tempDic objectForKey:key] longValue]];
                        NSString *longss = [longn stringValue];
                        [tempDic removeObjectForKey:key];
                        [tempDic setObject:longss forKey:key];
                    }
                }

                SIMCompany *comp = [[SIMCompany alloc] initWithDictionary:tempDic];
                [_listArr addObject:comp];
            }

            _optionView.dataSource = _listArr;
//            for (int i = 0; i < _listArr.count; i++) {
//                if ([self.currentUser.currentCompany.company_id isEqualToString:[_listArr[i] company_id]]) {
//                    currentIndex = i;
//                }
//            }
//
            
//            [self.tableView reloadData];
        }
        
    } failure:^(id failure) {
        
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];


}
- (void)addActionSheet:(SIMCompany *)company {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:SIMLocalizedString(@"CompanyChose_enter", nil) message:company.company_name preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCOk", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self changeTheCompanyIDRequest:company];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:action];
    [alertC addAction:action3];
    [self presentViewController:alertC animated:YES completion:nil];
}
- (void)addActionSheetOneCompany {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:SIMLocalizedString(@"ChangeCompanyErrorTitle", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCKnow", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:action3];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)changeTheCompanyIDRequest:(SIMCompany *)company {
    // 传给服务器一份切换公司的接口
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    [dicM setValue:@"2" forKeyPath:@"type"];
    [dicM setValue:company.company_id forKeyPath:@"company_id"];
    UIDevice *myDecive = [UIDevice currentDevice];
    [dicM setObject:myDecive.model forKey:@"loginEquipment"];

    [MBProgressHUD cc_showLoading:nil];
    [MainNetworkRequest changeCompanyRequestParams:dicM success:^(id success) {
        if ([success[@"code"] integerValue] == successCodeOK) {
            NSLog(@"changeCompanySuccess %@",success);
            [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];

            NSDictionary *dic = success[@"data"];

            // 字典 可变为了转化里面的都为字符串 用来初始化CCUser
            NSMutableDictionary *dicMM = [[NSMutableDictionary alloc] initWithDictionary:dic[@"user_info"]];
            for (int i =0; i<dicMM.count; i++) {
                if ([[dicMM objectForKey:dicMM.allKeys[i]] isKindOfClass:[NSNumber class]]) {
                    NSString *key = dicMM.allKeys[i];
                    NSNumber *longn = [NSNumber numberWithLong:[[dicMM objectForKey:key] longValue]];
                    NSString *longss = [longn stringValue];
                    [dicMM removeObjectForKey:key];
                    [dicMM setObject:longss forKey:key];
                }
            }

            if ([[dicMM objectForKey:@"avatar"] length] >0) {
                // 将face的value取出来 然后拼接
                NSString *faceValue = [dicMM objectForKey:@"avatar"];
                NSString *newFaceValue = [NSString stringWithFormat:@"%@/%@",kApiBaseUrl,faceValue];

                [dicMM removeObjectForKey:@"avatar"];
                [dicMM setObject:newFaceValue forKey:@"avatar"];
            }
            //  登录或注册服务器默认有的参数 赋值给self.currentUser以后全局可用 主要是不可以改变
            CCUser *myUser = [[CCUser alloc] initWithDictionary:dicMM];
            self.currentUser = myUser;

            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithDictionary:dic[@"company_info"]];
            for (int i =0; i<tempDic.count; i++) {
                if ([[tempDic objectForKey:tempDic.allKeys[i]] isKindOfClass:[NSNumber class]]) {
                    NSString *key = tempDic.allKeys[i];
                    NSNumber *longn = [NSNumber numberWithLong:[[tempDic objectForKey:key] longValue]];
                    NSString *longss = [longn stringValue];
                    [tempDic removeObjectForKey:key];
                    [tempDic setObject:longss forKey:key];
                }
            }
            SIMCompany *comp = [[SIMCompany alloc] initWithDictionary:tempDic];
            self.currentCompany = comp;
            // 再把当前默认的这个公司 给当前用户里的当前公司属性 并立即写入
            self.currentUser.currentCompany = comp;
            [ self.currentCompany synchroinzeCurrentCompany];
            [self.currentUser synchroinzeCurrentUser];

            NSLog(@"enterChangecompanycomcom %@ %@", self.currentUser.currentCompany.company_name, self.currentCompany.company_name);
            NSLog(@"enterChangeCompanycurrentUser:+++%@",self.currentUser);

            [self resetTabbarController];// 重新载入tabbar整个框架

        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];


}
// 重新载入tabbar整个框架 仿照企业微信直接选中tabbar第一个 同切换国际化语言的写法
- (void)resetTabbarController {
    [self.navigationController popToRootViewControllerAnimated:NO];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SIMTabBarViewController *tabVC = [[SIMTabBarViewController alloc] init];
    delegate.window.rootViewController = tabVC;
    tabVC.selectedIndex = 0;
}
@end
