//
//  SIMAdressBookViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/7/31.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMAdressBookViewController.h"
#import "SIMAdressBookTableViewCell.h"
#import "SIMContants.h"
#import "SIMResultViewController.h"
#import "SIMAdressNewViewController.h"
#import <Contacts/Contacts.h>
#import <MessageUI/MessageUI.h>


@interface SIMAdressBookViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate,MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) SIMResultViewController *mySRTVC;
@property (nonatomic, strong) SIMBaseTableView *tableView;
@property (nonatomic, strong) SIMContants *sont;// 人员模型
@property (nonatomic, strong) NSMutableArray *mutArray;// 数据源
@property (nonatomic, strong) UISearchController *svc;//搜索框
@property (nonatomic, strong) NSMutableArray *dataSource;// 排序后的数据源

@end
static NSString *reuse = @"SIMAdressBookTableViewCell";
@implementation SIMAdressBookViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"ShareInContant", nil);
    
    _mutArray = [[NSMutableArray alloc] init];
    [self getAdressBookInfo];
    
    [self loadDataSource];// 3-- 将1步的数据
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.frame = CGRectMake(0, 0, screen_width, screen_height-StatusNavH);
    [self.view addSubview:self.tableView];
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 40)];
//    self.tableView.tableFooterView = footerView;
    [self.tableView registerClass:[SIMAdressBookTableViewCell class] forCellReuseIdentifier:reuse];
    
    [self addSearchBar];// 添加搜索框搜索结果展示页
    
    MJRefreshNormalHeader *refreshHead = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    refreshHead.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = refreshHead;
}
// 下拉刷新的响应方法
- (void)loadNewData {
    [self getAdressBookInfo];
}
// 添加搜索框搜索结果展示页
- (void)addSearchBar {
    self.mySRTVC = [[SIMResultViewController alloc] init];
    self.mySRTVC.mainSearchController = self;
    self.svc=[[UISearchController alloc]initWithSearchResultsController:self.mySRTVC];
    //设置与界面有关的样式
    [self.svc.searchBar sizeToFit];   //大小调整
    _svc.searchBar.placeholder=SIMLocalizedString(@"CGSearchBarPlaceHolder", nil);
    _svc.searchBar.barTintColor = SearchBackColor;
    // 更改背景颜色并去掉黑线
    UIImageView *barimag = [[[_svc.searchBar.subviews firstObject] subviews] firstObject];
    barimag.layer.borderColor = SearchBackColor.CGColor;
    barimag.layer.borderWidth = 1;
//    [self.view addSubview:self.svc.searchBar];
    self.tableView.tableHeaderView = _svc.searchBar;
    //设置搜索控制器的结果更新代理对象
    self.svc.searchResultsUpdater=self;
    self.svc.searchBar.delegate=self;
    self.definesPresentationContext=YES;
//    self.mySRTVC.isNewHaveBtn = self.isNewHaveBtn;
//    self.mySRTVC.shareType = self.shareType;
//    self.mySRTVC.webAdress = self.webAdress;
//    self.mySRTVC.nfPic = self.nfPic;
//    self.mySRTVC.adDetail = self.adDetail;
//    self.mySRTVC.gdDetail = self.gdDetail;
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [UILocalizedIndexedCollation currentCollation].sectionTitles.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
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
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.dataSource[section] count]) {
        return 20;
    }
    return 0.001;
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
    
    SIMAdressBookTableViewCell *addCell = [tableView dequeueReusableCellWithIdentifier:reuse];
    
    SIMContants *ss = self.dataSource[indexPath.section][indexPath.row];
    addCell.sont = ss;
    
    if (self.isNewHaveBtn==YES) {
        addCell.addBtn.hidden = YES;
    }else {
        addCell.addBtn.hidden = NO;
    }
    
    if (self.isNewHaveBtn == NO) {
        addCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else {
        addCell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    __weak typeof(self) weakSelf = self;
    addCell.addClick = ^{
        if ([MFMessageComposeViewController canSendText]) {
            // 邀请联系人 发送短信
            [MBProgressHUD cc_showLoading:nil delay:3];
            if (weakSelf.shareType == 1001) {
                // 开会为1001
                [weakSelf showMessageView:@[ss.mobile] title:nil body:[NSString stringWithFormat:@"%@：%@ %@",weakSelf.currentUser.nickname,SIMLocalizedString(@"AdressBookShareTest", nil),[NSURL URLWithString:@"https://www.kaihuibao.net/"]]];
            }else if (weakSelf.shareType == 1005) {
                // 老板理财等发现页面其他的为1005-- 不要了 目前换成视频客服了首页的
                NSString *titleStr = SIMLocalizedString(@"MMainConfVideoSupport", nil);;
                
                NSString *urlString = kApiBaseUrl;
                
                NSString *urlSs = [NSString stringWithFormat:@"%@/duokelai1/index.html?sid=27578231060&from=singlemessage&isappinstalled=0",urlString];
                
                // 设备为1005
                [weakSelf showMessageView:@[ss.mobile] title:nil body:[NSString stringWithFormat:@"%@ %@", titleStr,[NSURL URLWithString:urlSs]]];
                
            }
            
        }else {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"MessageSendTest", nil)];
        }
    };
    return addCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SIMContants *contants = self.dataSource[indexPath.section][indexPath.row];
    if (self.isNewHaveBtn == YES) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        SIMAdressNewViewController *newAdress = [[SIMAdressNewViewController alloc] init];
        
        newAdress.conts = contants;
        
        [self.navigationController pushViewController:newAdress animated:YES];
    }
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
- (void)getAdressBookInfo {
    [_mutArray removeAllObjects];
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
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSString *oneString;
        oneString = [contact.familyName stringByAppendingString:contact.givenName];
        if (contact.familyName.length == 0) {
            oneString = contact.givenName;
        }
        if (oneString.length == 0) {
            oneString = @"#";
        }
//        NSLog(@"contactcontactcontact%@",contact);
        NSArray *phoneNumbers = contact.phoneNumbers;
        
        for (CNLabeledValue *labelValue in phoneNumbers) {
            CNPhoneNumber *phoneNumber = labelValue.value;
            SIMContants *conts = [[SIMContants alloc] initWithDictionary:@{@"nickname":oneString,@"mobile":phoneNumber.stringValue}];
            [weakSelf.mutArray addObject:conts];
//            NSLog(@"%@",labelValue.label);
        }
//        NSLog(@"_mutArray%@",_mutArray);
        
        //        *stop = YES;  // 停止循环，相当于break；
    }];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark-- messageCompose
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.body = body;
        controller.messageComposeDelegate = self;
        controller.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
}

#pragma mark -- messageComposeDelegate
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            [MBProgressHUD cc_showSuccess:SIMLocalizedString(@"MessageSendSend", nil)];
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            [MBProgressHUD cc_showFail:SIMLocalizedString(@"MessageSendFail", nil)];
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            [MBProgressHUD cc_showSuccess:SIMLocalizedString(@"MessageSendCancel", nil)];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UISearchResultsUpdating
/**实现更新代理*/
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //获取到用户输入的数据
    NSString *searchText=searchController.searchBar.text;
    NSMutableArray *searchResult=[[NSMutableArray alloc]init];
    // 联系人
    
    for (NSArray *sections in self.dataSource) {
        for (SIMContants *person in sections) {
            if ([person.nickname.lowercaseString rangeOfString:searchText.lowercaseString].location != NSNotFound) {
                [searchResult addObject:person];
            }
        }
    }
//    self.mySRTVC.selectPage = 1;
    self.mySRTVC.searchResults=searchResult;
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




@end
