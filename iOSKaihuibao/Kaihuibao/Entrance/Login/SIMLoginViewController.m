//
//  SIMLoginViewController.m
//  Kaihuibao
//
//  Created by Ferris on 2017/3/30.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMLoginViewController.h"
#import "SIMRecoverViewController.h"
#import "SIMBaseInputTableViewCell.h"
#import "SIMRegisterViewController.h"
#import "SIMBaseCommonTableViewCell.h"
#import "SIMChoseCompanyViewController.h"


@interface SIMLoginViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL logBtnOnce;
}
@property (strong,nonatomic) SIMBaseTableView* tableView;// 基础表格
@end

@implementation SIMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"KHBLogin", nil);
    logBtnOnce = YES;
    // 取消按钮及响应方法
//    __weak typeof(self) weakSelf = self;
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"NavBackCancelTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    cancel.tintColor = BlueButtonColor;
    self.navigationItem.leftBarButtonItem = cancel;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
}
- (void)cancelBtnClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 2;
//    }else {
        return 2;
//    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section==0) {
        return 0.01f;
//    }else {
//        return 40;
//    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (section==0) {
        return 50;
//    }else {
//        return 0.01f;
//    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 130)];
    footView.backgroundColor = [UIColor whiteColor];
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.backgroundColor = BlueButtonColor;
    loginButton.titleLabel.font = FontRegularName(18);
    [loginButton setTitle:SIMLocalizedString(@"KHBLogin", nil) forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [loginButton setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 45/4;
    [footView addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
    }];
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
//    // 忘记密码按钮
//    UIButton *recoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    recoverButton.titleLabel.textAlignment = NSTextAlignmentRight;
//    [recoverButton setTitleColor:BlueButtonColor forState:UIControlStateNormal];
//    [recoverButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    recoverButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
////        recoverButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
//    [recoverButton setTitle:SIMLocalizedString(@"KHBForgetPassword", nil) forState:UIControlStateNormal];
//    recoverButton.titleLabel.font = FontRegularName(12);
//    [footView addSubview:recoverButton];
//    [recoverButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(loginButton.mas_width).multipliedBy(0.5);
//        make.height.mas_equalTo(kWidthScale(10));
//        make.right.mas_equalTo(loginButton);
//        make.top.mas_equalTo(loginButton.mas_bottom).offset(15);
//    }];
//    [recoverButton addTarget:self action:@selector(recover:) forControlEvents:UIControlEventTouchUpInside];
//
//    // 去注册按钮
//    UIButton *registButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    registButton.titleLabel.textAlignment = NSTextAlignmentLeft;
//    [registButton setTitleColor:BlueButtonColor forState:UIControlStateNormal];
//    [registButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    registButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
////        registButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//    [registButton setTitle:SIMLocalizedString(@"KHBGoRegister", nil) forState:UIControlStateNormal];
//    registButton.titleLabel.font = FontRegularName(12);
//    [footView addSubview:registButton];
//    [registButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(loginButton.mas_width).multipliedBy(0.5);
//        make.height.mas_equalTo(kWidthScale(10));
//        make.left.mas_equalTo(loginButton);
//        make.top.mas_equalTo(loginButton.mas_bottom).offset(15);
//    }];
//    [registButton addTarget:self action:@selector(regist:) forControlEvents:UIControlEventTouchUpInside];
    return footView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMBaseInputTableViewCell* inputCell = [[SIMBaseInputTableViewCell alloc] init];
    if(indexPath.row == 1)
    {
        inputCell.placeHolderStr = SIMLocalizedString(@"KHBPassword", nil);
        inputCell.textfield.secureTextEntry = YES;
//        inputCell.textfield.keyboardType = UIKeyboardTypeASCIICapable;
        inputCell.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    else
    {
        inputCell.textfield.placeholder = SIMLocalizedString(@"KHBAccount", nil);
//        inputCell.textfield.keyboardType =UIKeyboardTypeNumberPad;
        inputCell.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return inputCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - Event
// --登录--
- (void)login:(UIButton*)sender
{
    // 正在加载框
    [MBProgressHUD cc_showLoading:nil];
    SIMBaseInputTableViewCell* phoneCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString* phoneNum = phoneCell.textfield.text;
    SIMBaseInputTableViewCell* passwordCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString* password = passwordCell.textfield.text;
    
    [phoneCell.textfield resignFirstResponder];
    [passwordCell.textfield resignFirstResponder];
    
    if (phoneNum.length == 0) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"KHBAccountPlaceHolder", nil)];
        logBtnOnce = YES;
        return;
    }
    if (password.length == 0) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"KHBPasswordPlaceHolder", nil)];
        logBtnOnce = YES;
        return;
    }
//    if (![self regexMatchWithStr:email regex:@"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$"])
//    {
//        [MBProgressHUD cc_showText:@"请输入正确的手机号码"];
//        return;
//    }
//    // 新增的手机号长度需要时11位 但是去掉了判断手机号的正则（因为好多小号不是手机号的格式）
//    if (email.length != 11) {
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_WRONG_PhoneNumber", nil)];
//        return;
//    }
    // 传递参数字典
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    [dicM setObject:phoneNum forKey:@"username"];
    [dicM setObject:password forKey:@"password"];
    UIDevice *myDecive = [UIDevice currentDevice];
    [dicM setObject:myDecive.model forKey:@"loginEquipment"];
    // 请求
    [MainNetworkRequest staticLoginRequestParams:dicM success:^(id success) {
        // 成功
        if ([success[@"code"] integerValue] == successCodeOK) {
            NSLog(@"loginSuccessdata  %@",success);
            
            [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
            
            NSDictionary *dic = success[@"data"];
            
            // 保存token 不管几个公司 token都会先存
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"token"] forKey:@"userToken"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isINtheLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 判断公司个数 1.如果只有一家公司那么默认都是在这一步存本地
            if ([[dic[@"company_count"] stringValue] isEqualToString:@"1"]) {

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

//                NSDictionary *companyD = dic[@"company_list"][0];
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
                [self.currentCompany synchroinzeCurrentCompany];
                [self.currentUser synchroinzeCurrentUser];


                NSLog(@"loginOneCompanycomcom %@ %@", self.currentUser.currentCompany.company_name, self.currentCompany.company_name);
                NSLog(@"loginOneCompanycurrentUser:+++%@",self.currentUser);

                // 当前只有一个公司的时候 默认跳转到主页面
                [self dismissViewControllerAnimated:NO completion:^{
                    // 将现有页面dismiss掉 跳转到主页面
                    [windowRootViewController transitionToViewController:[[SIMTabBarViewController alloc] init] withAnmitionType:SIMTransitionTypePush];
                }];
            }else {
                // 2.这个是多个公司的情况
                // 先不初始化个人资料 只是提供一个公司列表 去选择
                // 忘记密码和登录一个流程 ：跳转到选择公司界面 当前页面不dismiss 直接push出选择公司界面有返回按钮
                // 注册这里的流程应该是默认进到刚注册好的这个公司我是主管理的公司里
                NSMutableArray *arrM = [NSMutableArray array];
                for (NSDictionary *companydic in dic[@"company_list"]) {
                    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithDictionary:companydic];
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
                    [arrM addObject:comp];
                }
                SIMChoseCompanyViewController *choseCompanyVC = [[SIMChoseCompanyViewController alloc] init];
                choseCompanyVC.companyList = arrM.copy;
                [self.navigationController pushViewController:choseCompanyVC animated:YES];
            }
            
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_theNet", nil)];
        
    }];

    
}

//// 忘记密码按钮响应方法
//- (void)recover:(UIButton *)sender {
//    SIMRecoverViewController *recover = [[SIMRecoverViewController alloc] init];
//    [self.navigationController pushViewController:recover animated:YES];
//}
//// 注册按钮响应方法
//- (void)regist:(UIButton *)sender {
//    [self dismissViewControllerAnimated:NO completion:^{
//        UIViewController* registerNavigationViewController = [[[SIMRegisterViewController alloc] init] sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
//        [windowRootViewController presentViewController:registerNavigationViewController animated:YES completion:nil];
//    }];
//
//}



@end
