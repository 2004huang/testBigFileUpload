//
//  SIMAddContentViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/7/31.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMAddContentViewController.h"
#import "SIMListTableViewCell.h"
#import "SIMAddLittle.h"
#import "SIMAccountCompanyViewController.h"
#import "SIMAdressViewController.h"
#import <Contacts/Contacts.h>

@interface SIMAddContentViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *_backView;// 蒙层
    SIMAddLittle *_little;// 添加人员视图
}

@property (nonatomic, strong) SIMBaseTableView *tableView;

@end
static NSString *reuse = @"SIMListTableViewCell0";
@implementation SIMAddContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"CCAddContantLittle", nil);
    
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[SIMListTableViewCell class] forCellReuseIdentifier:reuse];
}
//设置页眉高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
//设置页脚高度－－最小值不能为0.0
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
////设置页眉的子视图
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *vieww = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 30)];
//    vieww.backgroundColor = [UIColor clearColor];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screen_width-20, 30)];
//    label.text = @"添加外部联系人";
//    label.font = FontRegularName(13];
//    label.textColor = GrayPromptTextColor;
//    [vieww addSubview:label];
//    return vieww;
//
//}
//设置分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//分区中行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
//设置单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 上线版本这样改 以后打开地下注释
    NSArray *array = @[@[SIMLocalizedString(@"CAddCompanyBYHand", nil),SIMLocalizedString(@"CAddCompanyFromAdress", nil)]];
    NSArray *array2 = @[@[@"addContant_ss",@"contantNew_AdressList"]];
    SIMListTableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:reuse];
//    commonCell.label.text = array[indexPath.row];
    commonCell.label.text = array[indexPath.section][indexPath.row];
    [commonCell.iconBtn setBackgroundImage:[UIImage imageNamed:array2[indexPath.section][indexPath.row]] forState:UIControlStateNormal];
    commonCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return commonCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 手机号搜索
            // 点击添加联系人  跳出添加联系人小视图  手机号
            _backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            _backView.backgroundColor = [UIColor blackColor];
            _backView.alpha = 0.2;
//            UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            // 添加到窗口
            [window addSubview:_backView];
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
//            [_backView addGestureRecognizer:tap];
            
            _little = [[SIMAddLittle alloc] initWithFrame:CGRectMake( kWidthScale(47), kWidthScale(175), kWidthScale(280),190)];
//            [_little.input becomeFirstResponder];
            [window addSubview:_little];
            
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
                [weakSelf tapClick];
            };
            
        }else {
            // 跳转通讯录
//            SIMAdressBookViewController *adbVC = [[SIMAdressBookViewController alloc] init];
//            adbVC.shareType = 1001;
//            adbVC.isNewHaveBtn = NO;
//            [self.navigationController pushViewController:adbVC animated:YES];
            [self requestAuthorizationForAddressBook];
            
        }
    }
//    if (indexPath.section == 1) {
////        //  用户管理
////        SIMUserManagerViewController *userVC = [[SIMUserManagerViewController alloc] init];
////        [self.navigationController pushViewController:userVC animated:YES];
//
//        SIMAccountCompanyViewController *companyVC = [[SIMAccountCompanyViewController alloc] init];
//        [self.navigationController pushViewController:companyVC animated:YES];
//    }
    
}
// window点击手势
- (void)tapClick {
    [_backView removeFromSuperview];
    [_little removeFromSuperview];
}


- (void)requestAuthorizationForAddressBook {
    
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
        adbVC.isUserContant = NO;
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

@end
