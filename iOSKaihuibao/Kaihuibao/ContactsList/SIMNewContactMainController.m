//
//  SIMNewContactMainController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/8.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMNewContactMainController.h"
#import "SIMNCHeader.h"
#import "SIMListTableViewCell.h"
#import "SIMContants.h"
#import "SIMNewConverViewController.h"
#import "SIMAddUserViewController.h"
#import "SIMAddContentViewController.h"
//#import "SIMGroupListViewController.h"
#import "SIMNCustomListController.h"
#import "SIMNMyCompanyMemberController.h"
#import "SIMNCSearchMainController.h"
#import "SIMNCNormalCell.h"
#import "SIMAddNewFriendCell.h"
#import <Contacts/Contacts.h>

@interface SIMNewContactMainController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView* tableView;
@property (strong,nonatomic) SIMNCHeader* headerView;
@property (nonatomic, strong) NSMutableArray *departAllArr;//企业联系人数据
@property (nonatomic, strong) NSArray *sectTwoArr;
// 上传通讯录用到的属性
@property (nonatomic, strong) SIMContants *sont;// 人员模型
@property(nonatomic,strong) NSArray *contactArr;
@property(nonatomic,strong) NSString *jsonString;
@end

@implementation SIMNewContactMainController
-(instancetype)init
{
    if (self = [super init]) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reNetWorkActive) name:NetWorkReConnect object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:RefreshCompanyContactData object:nil];
    }
    return self;
}
- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)refreshData {
    [self requestData];// 请求数据
}
// 重新登录入会-- 没网络链接,需要重新查询服务器,防止第一次进入时候就没网没查到地址
- (void)reNetWorkActive
{
    [self requestAuthorizationForAddressBook];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = SIMLocalizedString(@"CCContantMainName", nil);
    _departAllArr = [[NSMutableArray alloc] init];// 企业联系人
    [self requestAuthorizationForAddressBook];
    
    [self requestData];
    NSDictionary *dic1 = @{@"face":@"logocompany",
                          @"nickname":  self.currentUser.currentCompany.company_name,@"picture":@"Addmembers",@"title":SIMLocalizedString(@"CCAddTheMemberTitle", nil)};
//    NSDictionary *dic2 = @{@"face":@"ExternalContacts",
//                          @"nickname":SIMLocalizedString(@"CContactCustomerManage", nil)};
//    NSDictionary *dic3 = @{@"face":@"Framework",
//                           @"nickname":SIMLocalizedString(@"CContactOrgan", nil)};
//    _sectTwoArr = @[dic1,dic3,dic2];
_sectTwoArr = @[dic1];
    [self addsubViews];
}
- (void)addsubViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height - TabbarH - StatusNavH) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorColor:ZJYColorHex(@"#eeeeee")];
    self.tableView.backgroundColor = TableViewBackgroundColor;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerClass:[SIMListTableViewCell class] forCellReuseIdentifier:@"SIMListTableViewCell"];
    [self.tableView registerClass:[SIMNCNormalCell class] forCellReuseIdentifier:@"SIMNCNormalCell"];
    [self.tableView registerClass:[SIMAddNewFriendCell class] forCellReuseIdentifier:@"SIMAddNewFriendCell"];
    
    
//    _headerView = [[SIMNCHeader alloc] initWithFrame:CGRectMake(0, 0, screen_width, 145)];
//    __weak typeof (self)weakSlf = self;
//    _headerView.indexTagBlock = ^(NSInteger btnserial) {
//        if (btnserial == 1000) {
//            // 点击了手机联系人
//            NSLog(@"跳转到外部联系人列表");
//            SIMNCustomListController *customVC = [[SIMNCustomListController alloc] init];
//            customVC.navigationItem.title = SIMLocalizedString(@"CContactPhoneContant", nil);
//            [weakSlf.navigationController pushViewController:customVC animated:YES];
//        }else if (btnserial == 1001) {
//            // 点击了我的好友
//            SIMNCustomListController *customVC = [[SIMNCustomListController alloc] init];
//            customVC.navigationItem.title = SIMLocalizedString(@"CContactMineAdress", nil);
//            [weakSlf.navigationController pushViewController:customVC animated:YES];
//        }else if (btnserial == 1002) {
//            // 点击了我的讨论组
//            SIMGroupListViewController *groupVC = [[SIMGroupListViewController alloc] init];
//            [weakSlf.navigationController pushViewController:groupVC animated:YES];
//        }else if (btnserial == 1003) {
//            // 点击了企业广场
//            // 拓展商机
//            SIMSquareViewController *accountVC = [[SIMSquareViewController alloc] init];
//            accountVC.navigationItem.title = SIMLocalizedString(@"MMainConfHeaderAdress", nil);
//            [weakSlf.navigationController pushViewController:accountVC animated:YES];
//        }
//
//    };
//    _headerView.btnClick = ^{
//        SIMNCSearchMainController *searchMainVC = [[SIMNCSearchMainController alloc] init];
//        searchMainVC.listDatas = weakSlf.departAllArr;
//        [weakSlf.navigationController pushViewController:searchMainVC animated:NO];
//    };
//    self.tableView.tableHeaderView = _headerView;
    
    MJRefreshNormalHeader *refreshHead = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    refreshHead.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = refreshHead;
}

- (void)loadNewData {
    [self requestData];// 请求数据
}
#pragma mark - TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2; //3
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 1;
//    }else
    if(section == 0) { //1
        return _sectTwoArr.count;
    }else {
        return _departAllArr.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        return 70;
//    }else {
        return 60;
//    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) { //2
        if (_departAllArr.count == 0) {
            return CGFLOAT_MIN;
        }else {
            return 50;
        }
    }else {
        return 10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) { // 1
        return 10;
    }else {
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) { // 2
        if (_departAllArr.count == 0) {
            return nil;
        }else {
            UIView *backV = [[UIView alloc] init];
            backV.backgroundColor = [UIColor whiteColor];
            backV.frame = CGRectMake(0, 10, screen_width, 50);
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(15, 0, screen_width, 50);
            label.font = FontMediumName(18);
            label.textColor = NewBlackTextColor;
            [backV addSubview:label];
            label.text = SIMLocalizedString(@"CCContantMainName", nil);
            return backV;
        }
    }else {
        UIView *mainback = [[UIView alloc] init];
        mainback.frame = CGRectMake(0, 0, screen_width, 10);
        return mainback;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) { // 1
        UIView *mainback = [[UIView alloc] init];
        mainback.frame = CGRectMake(0, 0, screen_width, 10);
        return mainback;
    }else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        SIMAddNewFriendCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"SIMAddNewFriendCell"];
//        NSDictionary *dic = @{@"face":@"Newfriends",
//                              @"nickname":SIMLocalizedString(@"CCAddNewFriends", nil)};
//        commonCell.theNewDic = dic;
//        commonCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        return commonCell;
//    }
    if (indexPath.section == 1) { // 2
        SIMListTableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"SIMListTableViewCell"];
        commonCell.contants = _departAllArr[indexPath.row];
        commonCell.accessoryType = UITableViewCellAccessoryNone;
        return commonCell;
    }
    else if (indexPath.section == 0) { // 1
        SIMNCNormalCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"SIMNCNormalCell"];
        commonCell.theNewDic = _sectTwoArr[indexPath.row];
        __weak typeof(self) weakSelf = self;
        commonCell.btnClick = ^{
            NSLog(@"点击了添加成员");
            SIMAddUserViewController *addUserVC = [[SIMAddUserViewController alloc] init];
            [weakSelf.navigationController pushViewController:addUserVC animated:YES];
        };
        return commonCell;
    }
    else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) { // 2
        // 成员列表
        SIMNewConverViewController *conver = [[SIMNewConverViewController alloc] init];
        conver.person = _departAllArr[indexPath.row];
        conver.person.isContant = NO;
        // 将本页的model数组按下标传递给下一页 下一页用一个model属性接受
        [self.navigationController pushViewController:conver animated:YES];
    }
//    else if (indexPath.section == 0) {
//        NSLog(@"跳转到添加外部联系人页面");
//        SIMAddContentViewController *addVC = [[SIMAddContentViewController alloc] init];
//        [self.navigationController pushViewController:addVC animated:YES];
//    }else if (indexPath.section == 1) {
//        if (indexPath.row == 2) {
//            NSLog(@"跳转到外部联系人列表");
//            SIMNCustomListController *customVC = [[SIMNCustomListController alloc] init];
//            customVC.navigationItem.title = SIMLocalizedString(@"CContactCustomerManage", nil);
//            [self.navigationController pushViewController:customVC animated:YES];
//        }else if (indexPath.row == 1) {
//            NSLog(@"跳转到企业成员列表");
//            SIMNMyCompanyMemberController *customVC = [[SIMNMyCompanyMemberController alloc] init];
//            customVC.navigationItem.title = SIMLocalizedString(@"CContactOrgan", nil);
//            [self.navigationController pushViewController:customVC animated:YES];
//        }
//    }
}
// 请求企业联系人数据
- (void)requestData {
    [MainNetworkRequest userListRequestParams:nil success:^(id success) {
        NSLog(@"successusercontactlist  %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [_departAllArr removeAllObjects];
            NSDictionary *dicData = success[@"data"];
            for (NSDictionary *dic in dicData[@"member_list"]) {
                SIMContants *userContant = [[SIMContants alloc] initWithDictionary:dic];
                [_departAllArr addObject:userContant];
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }else {
            [self.tableView.mj_header endRefreshing];
        }
    } failure:^(id failure) {
        [self.tableView.mj_header endRefreshing];
    }];
    
}
#pragma mark -- UIAlertController
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
- (void)addGetAlertViewController {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:SIMLocalizedString(@"CCAdressPostOnServer", nil) message:SIMLocalizedString(@"CCAdressPostOnServerTEST", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCOk", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVc presentViewController:alertView animated:YES completion:nil];
}

- (void)requestAuthorizationForAddressBook {
    
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    if(authorizationStatus ==CNAuthorizationStatusNotDetermined) {
        
        CNContactStore*contactStore = [[CNContactStore alloc]init];
        
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted,NSError*_Nullable error) {
            if(granted) {
                NSLog(@"通讯录获取授权成功==");
                [self getContact]; // 获取用户通讯录
                
            }else{
                NSLog(@"授权失败, error=%@", error);
            }
        }];
    }
//    else if (authorizationStatus == CNAuthorizationStatusRestricted ||authorizationStatus == CNAuthorizationStatusDenied) {
//        NSLog(@"用户没有授权==");
//        [self addAdressAlertViewController];
//
//    }
    else if(authorizationStatus ==CNAuthorizationStatusAuthorized){
        NSLog(@"已经授权过了通讯录==");
        [self getContact]; //获取用户通讯录
    }
    
}

- (void)getContact{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IsHaveAdressBook"] == YES) {
        // 说明已经传过服务器了 不用再传了
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
            
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IsHaveAdressBook"];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IsHaveAdressBook"];
    }];
}


@end
