//
//  SIMNewLoginViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/4/29.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMNewLoginViewController.h"

#import "SIMRecoverViewController.h"
#import "SIMRegisterViewController.h"
#import "SIMChoseCompanyViewController.h"
#import "SIMEditProfileViewController.h"

@interface SIMNewLoginViewController ()<UITextFieldDelegate>
{
    BOOL logBtnOnce;
}
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *codeW;
@property (nonatomic, strong) UIButton *logBtn;
@property (nonatomic, strong) UIButton *areaCode;
@end

@implementation SIMNewLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    logBtnOnce = YES;
    [self addSubUIs];
}
// 初始化UI
- (void)addSubUIs {
    // 输入手机号框
    _phoneTF = [[UITextField alloc] init];
    if ([self.cloudVersion.username_prompt isEqualToString:@"mobile"]) {
        _phoneTF.placeholder = SIMLocalizedString(@"KHBPhoneNumPlaceHolder", nil);
    }else {
        _phoneTF.placeholder = SIMLocalizedString(@"KHBAccountPlaceHolder", nil);
    }
    _phoneTF.textAlignment = NSTextAlignmentLeft;
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_phoneTF addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_phoneTF];
    [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidthScale(25));
        make.right.mas_equalTo(-kWidthScale(25));
        make.top.mas_equalTo(kWidthScale(50));
        make.height.mas_equalTo(45);
        
    }];
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = ZJYColorHex(@"#EDEDED");
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidthScale(10));
        make.right.mas_equalTo(-kWidthScale(10));
        make.top.mas_equalTo(_phoneTF.mas_bottom).mas_offset(kWidthScale(1));
        make.height.mas_equalTo(1);
    }];
    
    // 输入密码 以及发送验证码按钮
    _codeW = [[UITextField alloc] init];
//    _codeW.keyboardType = UIKeyboardTypeASCIICapable;
    _codeW.placeholder = SIMLocalizedString(@"KHBPasswordPlaceHolder", nil);
    _codeW.textAlignment = NSTextAlignmentLeft;
    _codeW.secureTextEntry = YES;
    _codeW.delegate = self;
    [_codeW addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    _codeW.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_codeW];
    [_codeW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.and.right.mas_equalTo(_phoneTF);
        make.top.mas_equalTo(lineView.mas_bottom).mas_offset(kWidthScale(1));
    }];
    
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = ZJYColorHex(@"#EDEDED");
    [self.view addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.and.right.mas_equalTo(lineView);
        make.top.mas_equalTo(_codeW.mas_bottom).mas_offset(kWidthScale(1));
    }];
    
    
    // 登录的大按钮
    _logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _logBtn.titleLabel.font = FontRegularName(18);
    [_logBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_logBtn setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [_logBtn setBackgroundColor:BlueButtonColor];
    [_logBtn setTitle:SIMLocalizedString(@"KHBLogin", nil) forState:UIControlStateNormal];
    [_logBtn setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    [_logBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    _logBtn.layer.masksToBounds = YES;
    _logBtn.layer.cornerRadius = 11;
    [self.view addSubview:_logBtn];
    [_logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidthScale(10));
        make.right.mas_equalTo(-kWidthScale(10));
        make.top.mas_equalTo(lineView2.mas_bottom).offset(kWidthScale(15));
        make.height.mas_equalTo(44);
    }];
    
    if ([self.cloudVersion.forget_password boolValue]) {
        // 忘记密码按钮
        UIButton *recoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        recoverButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [recoverButton setTitleColor:BlueButtonColor forState:UIControlStateNormal];
        [recoverButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        recoverButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [recoverButton setTitle:SIMLocalizedString(@"KHBForgetPassword", nil) forState:UIControlStateNormal];
        recoverButton.titleLabel.font = FontRegularName(14);
        [self.view addSubview:recoverButton];
        [recoverButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
            make.right.mas_equalTo(_logBtn).offset(-10);
            make.top.mas_equalTo(_logBtn.mas_bottom).offset(15);
        }];
        [recoverButton addTarget:self action:@selector(recover:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    if ([self.cloudVersion.registerBtn boolValue]) {
        // 去注册按钮
        UIButton *registButton = [UIButton buttonWithType:UIButtonTypeCustom];
        registButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [registButton setTitleColor:BlueButtonColor forState:UIControlStateNormal];
        [registButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        registButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [registButton setTitle:SIMLocalizedString(@"KHBGoRegister", nil) forState:UIControlStateNormal];
        registButton.titleLabel.font = FontRegularName(14);
        [self.view addSubview:registButton];
        [registButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
            make.left.mas_equalTo(_logBtn).offset(10);
            make.top.mas_equalTo(_logBtn.mas_bottom).offset(15);
        }];
        [registButton addTarget:self action:@selector(regist:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

#pragma mark - Event
// --登录--
- (void)login:(UIButton*)sender
{
    [MBProgressHUD cc_showLoading:nil];
    NSString* phoneNum = _phoneTF.text;
    NSString* password = _codeW.text;
    [_phoneTF resignFirstResponder];
    [_codeW resignFirstResponder];
    
    if (phoneNum.length == 0) {
        if ([self.cloudVersion.username_prompt isEqualToString:@"mobile"]) {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"KHBPhoneNumPlaceHolder", nil)];
        }else {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"KHBAccountPlaceHolder", nil)];
        }
        
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
    // 新增的手机号长度需要时11位 但是去掉了判断手机号的正则（因为好多小号不是手机号的格式）
    if (phoneNum.length != 11) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_WRONG_PhoneNumber", nil)];
        logBtnOnce = YES;
        return;
    }
    
    
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
//                [self dismissViewControllerAnimated:NO completion:^{
//                    // 将现有页面dismiss掉 跳转到主页面
//                    [windowRootViewController transitionToViewController:[[SIMTabBarViewController alloc] init] withAnmitionType:SIMTransitionTypePush];
//                }];
                
                            // 将现有页面dismiss掉
                dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.navigationController dismissViewControllerAnimated:NO completion:^{
                                            
                                            // 跳转到主页面
                                            [windowRootViewController transitionToViewController:[[SIMTabBarViewController alloc] init] withAnmitionType:SIMTransitionTypePush];
//                                            dispatch_async(dispatch_get_main_queue(), ^{
//                                            SIMTabBarViewController *tabbarVC = [[SIMTabBarViewController alloc] init];
//                                            [[[UIApplication sharedApplication] delegate] window].rootViewController = tabbarVC;
//                                                });
//                window.rootViewController = [[SIMTabBarViewController alloc] init];
//                                            [self.navigationController pushViewController:[[SIMTabBarViewController alloc] init] animated:nil];
                                        }];
                    
                    });
                        
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
        logBtnOnce = YES;
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_theNet", nil)];
        logBtnOnce = YES;
    }];
    
}

// 忘记密码按钮响应方法
- (void)recover:(UIButton *)sender {
    SIMRecoverViewController *recover = [[SIMRecoverViewController alloc] init];
    [self.navigationController pushViewController:recover animated:YES];
}
// 注册按钮响应方法
- (void)regist:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        UIViewController* registerNavigationViewController = [[[SIMRegisterViewController alloc] init] sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
         registerNavigationViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [windowRootViewController presentViewController:registerNavigationViewController animated:YES completion:nil];
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
    if (textField == _phoneTF) {
        [self subStringAllMethod:textField withLength:11];
    }else if (textField == _codeW) {
        [self subStringAllMethod:textField withLength:18];
    }
}


@end
