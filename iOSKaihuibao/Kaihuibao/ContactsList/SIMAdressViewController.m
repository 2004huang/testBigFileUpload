//
//  SIMAdressViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2017/12/26.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMAdressViewController.h"
#import "SIMAdress.h"
#import "SIMContants.h"
#import "SIMResultViewController.h"
#import "SIMAccountCompanyViewController.h"
#import "SIMContactDetailViewController.h"

#import "SIMAdressTableViewCell.h"
#import <Contacts/Contacts.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "SIMNewAddContantViewController.h"
#import "SIMShareTool.h"

@interface SIMAdressViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) SIMResultViewController *mySRTVC;
@property (nonatomic, strong) SIMBaseTableView *tableView;
//@property (nonatomic, strong) SIMAdress *sont;// 人员模型
@property (nonatomic, strong) SIMContants *sont;// 人员模型
@property (nonatomic, strong) NSMutableArray *mutArray;// 数据源
@property (nonatomic, strong) UISearchController *searchController;//搜索框
@property (nonatomic, strong) NSMutableArray *dataSource;// 排序后的数据源
@property(nonatomic,strong) NSString *jsonString;
@property(nonatomic,strong) NSArray *contactArr;
@end

static NSString *reuse = @"SIMAdressTableViewCell";

@implementation SIMAdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = SIMLocalizedString(@"ShareInContant", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    _mutArray = [[NSMutableArray alloc] init];
    [self requestAuthorizationForAddressBook];
    
    
    
//    [self jugedContantAuthorization];
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height - StatusNavH - TabbarH) style:UITableViewStylePlain];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    //    [self.tableView setSeparatorColor:ZJYColorHex(@"#e3e3e4")];
//    self.tableView.backgroundColor = [UIColor whiteColor];
//    //    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//    [self.view addSubview:self.tableView];
//    self.tableView.tableFooterView = [[UIView alloc] init];
//
    
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.frame = CGRectMake(0, 0, screen_width, screen_height-StatusNavH);
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[SIMAdressTableViewCell class] forCellReuseIdentifier:reuse];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(screen_height-StatusNavH);
    }];
    
//    [self addDatas];
    [self addSearchBarUI];// 添加搜索框搜索结果展示页
    
    MJRefreshNormalHeader *refreshHead = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getAdressDataInfo)];
    refreshHead.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = refreshHead;
}

// 添加搜索框搜索结果展示页
- (void)addSearchBarUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mySRTVC = [[SIMResultViewController alloc] init];
    self.mySRTVC.mainSearchController = self;
    self.searchController=[[UISearchController alloc]initWithSearchResultsController:self.mySRTVC];
    //设置与界面有关的样式
    [self.searchController.searchBar sizeToFit];   //大小调整
    _searchController.searchBar.placeholder = SIMLocalizedString(@"CGSearchBarPlaceHolder", nil);
    //    _searchController.searchBar.barStyle = UISearchBarStyleProminent;
    _searchController.searchBar.barTintColor = [UIColor whiteColor];
    _searchController.searchBar.backgroundColor = [UIColor whiteColor];
    //    [_searchController.searchBar setBackgroundColor:[UIColor clearColor]];
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
    NSString *searchText=searchController.searchBar.text;
    NSMutableArray *searchResult=[[NSMutableArray alloc]init];
    // 通讯录
    for (NSArray *sections in self.dataSource) {
        for (SIMContants *person in sections) {
            if ([person.nickname.lowercaseString rangeOfString:searchText.lowercaseString].location != NSNotFound || [person.mobile.lowercaseString rangeOfString:searchText.lowercaseString].location != NSNotFound) {
                [searchResult addObject:person];
            }
        }
    }
//    self.mySRTVC.selectPage = 2;
    self.mySRTVC.isNeedChange = self.isNeedChange;
    self.mySRTVC.searchResults = searchResult;
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
                [btn setTitle:SIMLocalizedString(@"NavBackCancelTitle", nil) forState:UIControlStateNormal];
                [btn setTitleColor:BlueButtonColor forState:UIControlStateNormal];
            }
        }
    }
}
- (void)willDismissSearchController:(UISearchController *)searchController {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
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
    
    SIMAdressTableViewCell *addCell = [tableView dequeueReusableCellWithIdentifier:reuse];
    SIMContants *ss = self.dataSource[indexPath.section][indexPath.row];
//    SIMAdress *ss = self.dataSource[indexPath.section][indexPath.row];
//    ss.isUserContant = _isUserContant;
//    ss.isNeedChange = self.isNeedChange;
    addCell.contants = ss;
    __weak typeof(self) weakSelf = self;
    addCell.addBnClick = ^{
        
        if (ss.isNeedChange && ss.isUser) {
                // 已经注册了
                if (!ss.isFriend) {
                    // 如果不是好友那么去添加好友
                    NSLog(@"添加好友的方法");
                    [self addContractorRequest:ss.mobile];
                }
        }else {
            // 从邀请进入 和没有注册的话 都是邀请
            NSString *shareStr = [NSString stringWithFormat:SIMLocalizedString(@"NewAdressBookShareTitle", nil),kApiBaseUrl,@"/admin/downloadcenter/index"];
            [[SIMShareTool shareInstace] showMessageViewWithRecipients:@[ss.mobile] body:shareStr viewController:weakSelf];// 调用发送短信
        }
    };
//        if (ss.isUserContant) {
//            // 从添加用户的地方进来
//            if (!ss.is_user) {
//                // 跳转
////                SIMAccountCompanyViewController *accountVC = [[SIMAccountCompanyViewController alloc] init];
////                accountVC.adress = ss;
////                [weakSelf.navigationController pushViewController:accountVC animated:YES];
//            }
//        }else {
//            // 从外部联系人地方进来
//            if (ss.is_user) {
//                // 已经注册
//                if (!ss.is_friend) {
//                    // 不是好友 -- 那么添加好友
//                    [MBProgressHUD cc_showText:SIMLocalizedString(@"CCSendFriend_Success", nil)];
//                    // 将模型里的按钮选中设置为yes 显示已发送字样 刷新表格展示
//                    ss.isSelectSend = YES;
//                    [weakSelf.tableView reloadData];
//                    // 添加好友接口
//                    [weakSelf addContractorRequest:ss.mobile];
//                }
//            }else {
//                // 未注册
//                [MBProgressHUD cc_showText:SIMLocalizedString(@"CCSendMess_Success", nil)];
//                // 将模型里的按钮选中设置为yes 显示已发送字样 刷新表格展示
//                ss.isSelectSend = NO;
//                [weakSelf.tableView reloadData];
//                // 发送邀请的短信
//
//                if ([MFMessageComposeViewController canSendText]) {
//                    // 邀请联系人 发送短信
//                    [MBProgressHUD cc_showLoading:nil delay:3];
//
//
//                    [weakSelf showMessageView:@[ss.mobile] title:nil body:[NSString stringWithFormat:@"%@：%@ %@",weakSelf.currentUser.nickname,SIMLocalizedString(@"AdressShareSendTest", nil),[NSURL URLWithString:@"kaihuibao.net"]]];
//
//                }else {
//                    [MBProgressHUD cc_showText:SIMLocalizedString(@"MessageSendTest", nil)];
//                }
        
//            }
//        }
    
    
    return addCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    SIMAdress *adr = self.dataSource[indexPath.section][indexPath.row];
    
//    SIMNewAddContantViewController *conver = [[SIMNewAddContantViewController alloc] init];
//    conver.adress = adr;
//    conver.adress.isUserContant = _isUserContant;
//    // 将本页的model数组按下标传递给下一页 下一页用一个model属性接受
//    [self.navigationController pushViewController:conver animated:YES];
    if (self.isNeedChange) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        // 是添加按钮 才可以展示详情页面 如果有邀请按钮 那么不需要cell点击查看详情
        SIMContants *adr = self.dataSource[indexPath.section][indexPath.row];
        // 成员列表
        SIMContactDetailViewController *conver = [[SIMContactDetailViewController alloc] init];
        conver.person = adr;
        [self.navigationController pushViewController:conver animated:YES];
    }
    
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
        [_mutArray removeAllObjects];
        if ([success[@"code"] integerValue] == successCodeOK) {
            NSLog(@"adresscontantlistarr%@",success[@"data"]);
            NSLog(@"addressbookscount %ld",[success[@"data"] count]);
            for (NSDictionary *cont in success[@"data"]) {
//                SIMAdress *adressM = [[SIMAdress alloc] initWithDictionary:cont];
                SIMContants *adressM = [[SIMContants alloc] initWithDictionary:cont];
                adressM.isNeedChange = self.isNeedChange;
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

// 添加联系人数据
- (void)addContractorRequest:(NSString *)mobileStr {
    [MBProgressHUD cc_showLoading:nil];
    NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithObjectsAndKeys:mobileStr ,@"mobile", nil];
    
    [MainNetworkRequest contractorAddRequestParams:dicM success:^(id success) {
        NSLog(@"AddContantsuccess%@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [MBProgressHUD cc_showText:success[@"msg"]];
            [self getAdressDataInfo];
            // 发送列表刷新通知
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshCompanyContactData object:nil];
        }else {
            
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        NSError *error = failure;
        // 取消网络用 如果是取消了 不提示失败的弹框
        if (error.code == -999) {
            [MBProgressHUD cc_showText:@"取消了"];
        }else {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
        }
        
    }];
}

- (void)jugedContantAuthorization {
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (authorizationStatus == CNAuthorizationStatusRestricted ||authorizationStatus == CNAuthorizationStatusDenied) {
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
        [self presentViewController:alertView animated:YES completion:nil];
        
    }
}
//  返回页面取消请求
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MainNetworkRequest cancelAllRequest];
}

- (void)requestAuthorizationForAddressBook {
    
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    if(authorizationStatus ==CNAuthorizationStatusAuthorized) {
        NSLog(@"已经授权过了通讯录==");
        [self getContact]; //获取用户通讯录
    }
}

- (void)getContact{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IsHaveAdressBook"] == YES) {
        // 说明已经传过服务器了 不用再传了
        [self getAdressDataInfo];
        return ;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addGetAlertViewController];
    });
    
    // 以前没传过 需要上传服务器
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
        NSArray*keysToFetch =@[CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey,CNContactPhoneticOrganizationNameKey];
        CNContactFetchRequest*fetchRequest = [[CNContactFetchRequest alloc]initWithKeysToFetch:keysToFetch];
        CNContactStore*contactStore = [[CNContactStore alloc]init];
        //创建一个保存通讯录的数组
        NSMutableArray *contactArr = [[NSMutableArray alloc] init];
        
        __weak typeof(self) weakSelf = self;
        [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            NSString *oneString;
            
            if (contact.familyName.length == 0) {
                oneString = contact.givenName;
            }else {
                oneString = [contact.familyName stringByAppendingString:contact.givenName];
            }
            if (oneString.length == 0) {
                //                if (contact.organizationName.length > 0) {
                //                    oneString = contact.organizationName;
                //                }else {
                oneString = @"未知电话";
                //                }
            }
            NSArray *phoneNumbers = contact.phoneNumbers;
            for (CNLabeledValue *labelValue in phoneNumbers) {
                CNPhoneNumber *phoneNumber = labelValue.value;
                NSDictionary *conts = @{@"contactName":oneString,@"contactMobile":phoneNumber.stringValue};
                [contactArr addObject:conts];
            }
            //        *stop = YES;  // 停止循环，相当于break；
        }];
        if (contactArr.count == 0) {
            // 如果本地通讯录就是空 那么不上传  同时记录一下 本地记录已经存过了 否则会无限弹出提示框
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsHaveAdressBook"];
            NSLog(@"shangchuannnkong");
            return ;
            
        }
        self.contactArr = [NSArray arrayWithArray:contactArr];
        self.jsonString = [NSString ObjectTojsonString:self.contactArr];
        NSLog(@"shangchuannn%@",_jsonString);
        [weakSelf postContactTo]; //上传通讯录
    });
}

// 上传通讯录到后台
- (void)postContactTo {
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    [dicM setValue:_jsonString forKey:@"arr"];
    NSLog(@"shangchuan%@",dicM);
    [MainNetworkRequest adressbookListRequestParams:dicM success:^(id success) {
        NSLog(@"shangchuanwande%@",success);
        // 成功
        if ([success[@"code"] integerValue] == successCodeOK) {
            NSLog(@"成功shangchuan");
            // 传完之后 本地记录已经存过了
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsHaveAdressBook"];
            [MBProgressHUD cc_showText:success[@"msg"]];
            [self getAdressDataInfo];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IsHaveAdressBook"];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IsHaveAdressBook"];
    }];
}
- (void)addGetAlertViewController {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:SIMLocalizedString(@"CCAdressPostOnServer", nil) message:SIMLocalizedString(@"CCAdressPostOnServerTEST", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCOk", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
//    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self presentViewController:alertView animated:YES completion:nil];
}
@end
