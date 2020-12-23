//
//  SIMAddUserViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/2/2.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMAddUserViewController.h"

#import "SIMAddLittle.h"

#import "SIMListTableViewCell.h"

#import "SIMAdressViewController.h"
#import "SIMAccountCompanyViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareSheetConfiguration.h>
#import <Contacts/Contacts.h>

@interface SIMAddUserViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *_backView;// 蒙层
    SIMAddLittle *_little;// 添加人员视图
}

@property (nonatomic, strong) SIMBaseTableView *tableView;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSArray *array2;

@end
static NSString *reuse = @"SIMListTableViewCell0";
@implementation SIMAddUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"CCAddTheMemberTitle", nil);
    _array = @[@[SIMLocalizedString(@"CAddCompanyBYHand", nil),SIMLocalizedString(@"CAddCompanyFromAdress", nil),SIMLocalizedString(@"CAddCompanyBYWeChat", nil)]];
    _array2 = @[@[@"addContant_ss",@"contantNew_AdressList",@"wechatIconContant"]];
    
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
//设置分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//分区中行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
//设置单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 上线版本这样改 以后打开地下注释
    
    SIMListTableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:reuse];
    commonCell.label.text = _array[indexPath.section][indexPath.row];
    [commonCell.iconBtn setBackgroundImage:[UIImage imageNamed:_array2[indexPath.section][indexPath.row]] forState:UIControlStateNormal];
    commonCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return commonCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 跳转添加用户
            SIMAccountCompanyViewController *addContentVC = [[SIMAccountCompanyViewController alloc] init];
            [self.navigationController pushViewController:addContentVC animated:YES];
        }else if (indexPath.row == 1) {
            [self requestAuthorizationForAddressBook];
        }else {
            // 直接去微信分享
            [self shareToWeChat];
        }
    }
    
}

- (void)shareToWeChat {
    
    NSString *messStr = [NSString stringWithFormat:@"%@%@",self.currentUser.nickname,SIMLocalizedString(@"ShareAddContantWECHAT", nil)];
    NSMutableDictionary *sharePar = [NSMutableDictionary dictionary];
    [sharePar SSDKSetupShareParamsByText:messStr images:[UIImage imageNamed:@"share_meeting"] url:[NSURL URLWithString:@"https://kaihuibao.net"] title:messStr type:SSDKContentTypeAuto];
    
    //进行分享
    [ShareSDK share:SSDKPlatformTypeWechat //传入分享的平台类型
         parameters:sharePar
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:SIMLocalizedString(@"AlertCShareSuccess", nil)
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 NSString *errorStr;
                 if (error.code == 208) {
                     NSLog(@"error%@",error);
                     errorStr = [NSString stringWithFormat:@"%@",SIMLocalizedString(@"AdressBookShareERROR", nil)];
                 }else {
                     errorStr = [NSString stringWithFormat:@"%@",SIMLocalizedString(@"AlertCShareFail", nil)];
                 }
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:SIMLocalizedString(@"AlertCShareFail", nil)

                                                                 message:errorStr
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
                 [alert show];
                 break;
             }
             default:
                 break;
         }
         
     }];
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
        adbVC.isUserContant = YES;
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
