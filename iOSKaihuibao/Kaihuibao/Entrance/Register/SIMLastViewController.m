//
//  SIMLastViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/6/5.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMLastViewController.h"
#import "SIMTextField.h"
#import "SIMLoginMainViewController.h"
#import "SIMReUserInfoViewController.h"
#import "SIMChoseCompanyViewController.h"

#define BackColor ZJYColorHex(@"#E5E5E5")
static NSString *tokenStr;
@interface SIMLastViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) SIMTextField *passW;
@property (nonatomic, strong) SIMTextField *repeatW;
@property (nonatomic, strong) SIMTextField *nicknameW;
@property (nonatomic, strong) UIButton *regist;
@property (nonatomic, strong) UIButton *login;
@end

@implementation SIMLastViewController
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//}
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"KHBRegister", nil);
    
    self.view.backgroundColor = ZJYColorHex(@"#FAFAFA");
    [self addsubViews];
}
- (void)addsubViews {
    
    _header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kWidthScale(190))];
    _header.image = [UIImage imageNamed:[SIMInternationalController getLanPicNameWithPicName:@"register_3_new"]];
    _header.backgroundColor = ZJYColorHex(@"#FAFAFA");
    _header.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_header];
    
    _passW = [[SIMTextField alloc] init];
    _passW.placeholder = SIMLocalizedString(@"KHBPSWLengthPlaceHolder", nil);
    _passW.keyboardType = UIKeyboardTypeDefault;
    _passW.secureTextEntry = YES;
    [_passW addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    _passW.delegate = self;
    [self.view addSubview:_passW];
    [_passW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(_header.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = BackColor;
    lineView.frame = CGRectMake(0, 49, screen_width - 40, 1);
    [_passW addSubview:lineView];
    
    _repeatW = [[SIMTextField alloc] init];
    _repeatW.placeholder = SIMLocalizedString(@"KHBPSWRightPlaceHolder", nil);
    _repeatW.keyboardType = UIKeyboardTypeDefault;
    _repeatW.secureTextEntry = YES;
    [_repeatW addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_repeatW];
    [_repeatW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(_passW.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(50);
    }];
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = BackColor;
    lineView2.frame = CGRectMake(0, 49, screen_width - 40, 1);
    [_repeatW addSubview:lineView2];
    
//    _nicknameW = [[SIMTextField alloc] init];
//    _nicknameW.placeholder = SIMLocalizedString(@"KHBNickNamePlaceHolder", nil);
//    [self.view addSubview:_nicknameW];
//    [_nicknameW addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    [_nicknameW mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(20);
//        make.right.mas_equalTo(-20);
//        make.top.mas_equalTo(_repeatW.mas_bottom).mas_offset(10);
//        make.height.mas_equalTo(50);
//    }];
//    UIView *lineView3 = [[UIView alloc]init];
//    lineView3.backgroundColor = BackColor;
//    lineView3.frame = CGRectMake(0, 49, screen_width - 40, 1);
//    [_nicknameW addSubview:lineView3];
    
    _regist = [UIButton buttonWithType:UIButtonTypeCustom];
    _regist.backgroundColor = BlueButtonColor;
    _regist.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_regist setTitle:SIMLocalizedString(@"KHBImmediateLearnBtn", nil) forState:UIControlStateNormal];
    [_regist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_regist setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    [_regist setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    _regist.layer.masksToBounds = YES;
    _regist.layer.cornerRadius = 50/4;
    [self.view addSubview:_regist];
    [_regist addTarget:self action:@selector(registClick) forControlEvents:UIControlEventTouchUpInside];
    [_regist mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_repeatW.mas_bottom).offset(40);
        make.height.mas_equalTo(50);
    }];
    
    _login = [UIButton buttonWithType:UIButtonTypeCustom];
    _login.titleLabel.font = FontRegularName(15);
    [_login setTitle:SIMLocalizedString(@"KHBgoLoginClick", nil) forState:UIControlStateNormal];
    [_login setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
    [_login addTarget:self action:@selector(logClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_login];
    [_login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(screen_width/3.0);
        make.top.mas_equalTo(_regist.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];

}
#pragma mark -- Event
// 点击注册按钮 注册功能 最后一步：判断密码并注册
- (void)registClick {
    // 正在加载框
    [MBProgressHUD cc_showLoading:nil];
    if (self.passW.text.length < 6) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_six_psw", nil)];
        return;
    }
    if (self.passW.text.length >18) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"KHBPSWLengthPlaceHolder", nil)];
        return;
    }
    if ([self.passW.text checkIsHaveNumAndLetter]==4)
    {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_kind_psw", nil)];
        return;
    }
    if (self.repeatW.text.length == 0) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_re_psw", nil)];
        return;
    }else {
        if (![self.passW.text isEqualToString:self.repeatW.text]) {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_twowrong_psw", nil)];
            return;
        }
    }
    
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    [dicM setObject:self.phoneNumber forKey:@"mobile"];
    [dicM setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"validationToken"] forKey:@"captcha"];
    [dicM setObject:self.passW.text forKey:@"password"];
    [dicM setObject:@"1" forKey:@"source"];
    [dicM setObject:@"3" forKey:@"step"];
    UIDevice *myDecive = [UIDevice currentDevice];
    [dicM setObject:myDecive.model forKey:@"loginEquipment"];
    if (self.thirdDic != nil) {
        [dicM setObject:self.thirdDic[@"platform"] forKey:@"platform"];
        [dicM setObject:self.thirdDic[@"openid"] forKey:@"openid"];
    }
    
    if (self.isQuick == YES) {
        // 快速注册
        [MainNetworkRequest captchaLoginRequestParams:dicM success:^(id success) {
            NSLog(@"stepThree %@",success);
            if ([success[@"code"] integerValue] == successCodeOK) {
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
                    
                    
                    NSLog(@"loginOneCompanycomcom %@ %@", self.currentUser.currentCompany.company_name, self.currentCompany.company_name);
                    NSLog(@"loginOneCompanycurrentUser:+++%@",self.currentUser);
                    
                    // 当前只有一个公司的时候 默认跳转到主页面
                    [self.navigationController dismissViewControllerAnimated:NO completion:^{
                        // 将现有页面dismiss掉 跳转到主页面
                        [windowRootViewController transitionToViewController:[[SIMTabBarViewController alloc] init] withAnmitionType:SIMTransitionTypePush];
                    }];
                    
                }
                
            }else {
                [MBProgressHUD cc_showText:success[@"msg"]];
            }
        } failure:^(id failure) {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
        }];
    }else {
        [MainNetworkRequest registerRequestParams:dicM success:^(id success) {
            NSLog(@"normalregisterSuccessDic%@",success);
            if ([success[@"code"] integerValue] == successCodeOK) {
                [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
                //            [MBProgressHUD cc_showSuccess:success[@"msg"]];
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
                    
                    
                    NSLog(@"loginOneCompanycomcom %@ %@", self.currentUser.currentCompany.company_name, self.currentCompany.company_name);
                    NSLog(@"loginOneCompanycurrentUser:+++%@",self.currentUser);
                    
                    // 当前只有一个公司的时候 默认跳转到主页面
                    [self.navigationController dismissViewControllerAnimated:NO completion:^{
                        // 将现有页面dismiss掉 跳转到主页面
                        [windowRootViewController transitionToViewController:[[SIMTabBarViewController alloc] init] withAnmitionType:SIMTransitionTypePush];
                    }];
                    
                }
                
            }else {
                [MBProgressHUD cc_showText:success[@"msg"]];
            }
        } failure:^(id failure) {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
        }];
    }
    

}


// 已有账号去登录
- (void)logClick {
    // 返回登录页 将现有对象释放 将根视图设为登录页
    [self dismissViewControllerAnimated:NO completion:^{
        UIViewController *loginVC = [[[SIMLoginMainViewController alloc] init] sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
         loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [windowRootViewController presentViewController:loginVC animated:YES completion:nil];
    }];
    
}

#pragma mark -- UITextFieldDelegate
// 随输入文字动态判断
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 过滤空格
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}
- (void)textFieldDidChanged:(UITextField *)textField
{
    [self subStringAllMethod:textField withLength:18];
}

@end
