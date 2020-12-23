//
//  SIMNCustomListController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/12.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMNCustomListController.h"
#import "SIMListTableViewCell.h"
#import "SIMContactDetailViewController.h"

#import "PopView.h"
#import "SIMAddLittle.h"
#import "SIMAdressViewController.h"

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <Contacts/Contacts.h>

@interface SIMNCustomListController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (strong,nonatomic) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray *mutArray;
@property (nonatomic, strong) NSArray *sectTwoArr;
@property (nonatomic, strong) UIView *backView;// 蒙层
@property (nonatomic, strong) SIMAddLittle *little;// 添加人员视图

@end

@implementation SIMNCustomListController
//-(instancetype)init
//{
//    if (self = [super init]) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:RefreshContactData object:nil];
//    }
//    return self;
//}
//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//- (void)refreshData {
//    [self requestUserList];// 请求数据
//}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestUserList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _mutArray = [[NSMutableArray alloc] init];// 企业联系人
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"添加好友" style:UIBarButtonItemStylePlain target:self action:@selector(addFriendClick)];
    self.navigationItem.rightBarButtonItem = doneBtn;
    
    
    [self addsubViews];
}
- (void)addsubViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height - StatusNavH) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = TableViewBackgroundColor;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
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
//    SIMNewConverViewController *conver = [[SIMNewConverViewController alloc] init];
//    conver.person = _mutArray[indexPath.row];
//    conver.person.isContant = YES;
//    // 将本页的model数组按下标传递给下一页 下一页用一个model属性接受
//    [self.navigationController pushViewController:conver animated:YES];
//
    SIMContactDetailViewController *conver = [[SIMContactDetailViewController alloc] init];
    conver.person = _mutArray[indexPath.row];
    conver.person.isContant = YES;
    [self.navigationController pushViewController:conver animated:YES];

}

#pragma mark -- DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"我的好友页面-灰度好友"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"查找好友并开始会议";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:FontRegularName(15),
                                 NSForegroundColorAttributeName:BlackTextColor,
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
//- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
//    button.backgroundColor = [UIColor redColor];
//    return button;
//}
- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return [[UIImage imageNamed:@"添加联系人文字按钮"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *text = @"添加联系人";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:FontRegularName(16),
                                 NSForegroundColorAttributeName:BlackTextColor,
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//- (nullable UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
//    return [[UIImage imageNamed:@"添加联系人空视图按钮"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    NSLog(@"点击了空白的按钮");
}

- (void)addFriendClick {
//    __weak typeof(self) weakSelf = self;
    [PopView configCustomPopViewWithFrame:CGRectMake(screen_width - 235, StatusNavH, 230, 100) imagesArr:nil dataSourceArr:@[@"通过手机号添加",@"从手机联系人添加"] seletedRowForIndex:^(NSInteger index) {
        if (index == 0) {
            // 手机号搜索
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            _backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            _backView.backgroundColor = [UIColor blackColor];
            _backView.alpha = 0.2;
            _little = [[SIMAddLittle alloc] initWithFrame:CGRectMake( kWidthScale(47), kWidthScale(175), kWidthScale(280),190)];
            [_little.input becomeFirstResponder];
            [UIView animateWithDuration:0.4 animations:^{
                [window addSubview:_backView];
                [window addSubview:_little];
            }];
            __weak typeof(self)weakSelf = self;
            __weak typeof(SIMAddLittle *)weakLittle = _little;
            _little.cancelClick = ^{
                [weakSelf tapClick];// 取消按钮方法
            };
            // 保存按钮方法
            _little.saveClick = ^{
                // 保存按钮方法 添加人的手机号
                if (weakLittle.input.text.length <= 0) {
                    [MBProgressHUD cc_showText:SIMLocalizedString(@"KHBPhoneNumPlaceHolder", nil)];
                    return;
                }
                NSLog(@"点击了添加好友");
                [weakSelf addContractorRequest];
                [weakSelf tapClick];
            };
        }else if(index == 1) {
            // 跳转到通讯录
            [self requestAuthorizationToAdd:@"从手机联系人添加" isNeedChange:YES];
        }
    } animation:YES timeForCome:0.4 timeForGo:0.2];
}
// window点击手势
- (void)tapClick {
    [UIView animateWithDuration:0.2 animations:^{
        _backView.alpha = 0;
        _little.alpha = 0;
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        [_little removeFromSuperview];
        _backView = nil;
        _little = nil;
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
- (void)requestAuthorizationToAdd:(NSString *)title isNeedChange:(BOOL)isNeedChange {
    
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    if(authorizationStatus ==CNAuthorizationStatusNotDetermined) {
        
        CNContactStore*contactStore = [[CNContactStore alloc]init];
        
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
// 添加联系人数据
- (void)addContractorRequest {
    [MBProgressHUD cc_showLoading:nil];
    NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithObjectsAndKeys:_little.input.text ,@"mobile", nil];
    
    [MainNetworkRequest contractorAddRequestParams:dicM success:^(id success) {
        NSLog(@"AddContantsuccess%@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [MBProgressHUD cc_showText:success[@"msg"]];
            [self requestUserList];
            // 发送列表刷新通知
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshCompanyContactData object:nil];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
        
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}
// 请求我的联系人列表
- (void)requestUserList {
    [MainNetworkRequest contractorListRequestParams:nil success:^(id success) {
        NSLog(@"ListContantsuccess%@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [_mutArray removeAllObjects];
            for (NSDictionary *dic in success[@"data"]) {
                SIMContants *model = [[SIMContants alloc] initWithDictionary:dic];
                [_mutArray addObject:model];
            }
            [self.tableView reloadData];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        [self.tableView.mj_header endRefreshing];
    } failure:^(id failure) {
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
}
@end
