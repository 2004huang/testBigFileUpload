//
//  SIMQuickLoginViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/4/26.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMQuickLoginViewController.h"

#import "SIMChoseCompanyViewController.h"
#import "SIMLastViewController.h"

@interface SIMQuickLoginViewController ()
{
    NSInteger total;
//    NSString *typeSTR;
//    NSString *phoneNumber;
}
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *codeW;
@property (nonatomic, strong) UIButton *logBtn;
@property (nonatomic, strong) UIButton *areaCode;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SIMQuickLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubUIs];
}
// 初始化UI
- (void)addSubUIs {
    // 输入手机号框
    _phoneTF = [[UITextField alloc] init];
    _phoneTF.placeholder = SIMLocalizedString(@"KHBPhoneNumPlaceHolder", nil);
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
    
    // 输入验证码框 以及发送验证码按钮
    _codeW = [[UITextField alloc] init];
//    _codeW.keyboardType = UIKeyboardTypeNumberPad;
    _codeW.placeholder = SIMLocalizedString(@"KHBCodePlaceHolder", nil);
    _codeW.textAlignment = NSTextAlignmentLeft;
    [_codeW addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 125, 30)];
    _areaCode = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 125, 30)];
    _areaCode.userInteractionEnabled = YES;
    _areaCode.layer.cornerRadius = 5;
    _areaCode.layer.masksToBounds = YES;
    _areaCode.layer.borderColor = BlackTextColor.CGColor;
    _areaCode.layer.borderWidth = 0.5;
    [_areaCode addTarget:self action:@selector(areaClick) forControlEvents:UIControlEventTouchUpInside];
    [_areaCode setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [_areaCode setTitle:SIMLocalizedString(@"JSBLoginGetTheCode", nil) forState:UIControlStateNormal];
    _areaCode.titleLabel.font = FontRegularName(14);
    _areaCode.titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_areaCode];
    _codeW.rightViewMode = UITextFieldViewModeAlways;
    _codeW.rightView = view;
    
    // 登录的大按钮
    _logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _logBtn.titleLabel.font = FontRegularName(18);
    [_logBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_logBtn setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [_logBtn setBackgroundColor:BlueButtonColor];
    if (self.thirdDic != nil) {
        [_logBtn setTitle:SIMLocalizedString(@"ThirdLoginContactPhoneTitle", nil) forState:UIControlStateNormal];
    }else {
        [_logBtn setTitle:SIMLocalizedString(@"KHBLogin", nil) forState:UIControlStateNormal];
    }
    [_logBtn setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    
    [_logBtn addTarget:self action:@selector(registloginClick) forControlEvents:UIControlEventTouchUpInside];
    _logBtn.layer.masksToBounds = YES;
    _logBtn.layer.cornerRadius = 11;
    [self.view addSubview:_logBtn];
    [_logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidthScale(10));
        make.right.mas_equalTo(-kWidthScale(10));
        make.top.mas_equalTo(lineView2.mas_bottom).offset(kWidthScale(15));
        make.height.mas_equalTo(44);
    }];
    
}

#pragma mark --Event

- (void)registloginClick {
    [MBProgressHUD cc_showLoading:nil];
    NSString *codeStr = self.codeW.text;
    NSString *phoneStr = self.phoneTF.text;
    
    if (codeStr.length == 0) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_Please_puinCode", nil)];
        return ;
    }
//    if (![phoneStr isEqualToString:phoneNumber]) {
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_WRONG_VALIDATION_CODE", nil)];
//        return ;
//    }
    // 先验证验证码 再跳转
    NSMutableDictionary *dicM =[[NSMutableDictionary alloc] init];
    [dicM setObject:phoneStr forKey:@"mobile"];
    [dicM setObject:codeStr forKey:@"captcha"];
    [dicM setObject:@"2" forKey:@"step"];
//    if ([typeSTR isEqualToString:@"login"]) {
        UIDevice *myDecive = [UIDevice currentDevice];
        [dicM setObject:myDecive.model forKey:@"loginEquipment"];
        if (self.thirdDic != nil) {
            [dicM setObject:self.thirdDic[@"platform"] forKey:@"platform"];
            [dicM setObject:self.thirdDic[@"openid"] forKey:@"openid"];
        }
        
//    }
    
    [MainNetworkRequest captchaLoginRequestParams:dicM success:^(id success) {
        NSLog(@"stepTwo %@ %@",success,dicM);
        if ([success[@"code"] integerValue] == successCodeOK) {
            
            [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
            // 将验证码 保存起来token 用作下次注册的验证 防止验证码重复（现在不是了 但是还是这么写吧 省的传值了）
            [[NSUserDefaults standardUserDefaults] setObject:codeStr forKey:@"validationToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // 跳转下一页 并将本页的手机号传值下一页
            [self invalidateTheTimer];
            
            // 如果是直接登录
            NSDictionary *dic = success[@"data"];
            
            if ([dic[@"login_type"] isEqualToString:@"register"]) {
                // 注册
                SIMLastViewController *last = [[SIMLastViewController alloc] init];
                last.phoneNumber = phoneStr;
                if (self.thirdDic != nil) {
                    last.thirdDic = self.thirdDic;
                }
                last.isQuick = YES;
                [self.navigationController pushViewController:last animated:YES];
            }else {
                // 登录
                [self goLogin:dic];
            }
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
}
- (void)goLogin:(NSDictionary *)dic {
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
}
- (void)areaClick {
    // 正在加载框
    [MBProgressHUD cc_showLoading:nil];
    NSString *phoneNum = _phoneTF.text;
    if (phoneNum.length != 11) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_WRONG_PhoneNumber", nil)];
        return ;
    }
    if (![phoneNum checkTel]) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_WRONG_PhoneNumber", nil)];
        return;
    }
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    [dicM setObject:phoneNum forKey:@"mobile"];
    [dicM setObject:@"1" forKey:@"step"];
    
    [MainNetworkRequest captchaLoginRequestParams:dicM success:^(id success) {
        NSLog(@"stepOne%@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            
            [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];

//            NSDictionary *dd = success[@"data"];
//            typeSTR = dd[@"login_type"]; // 暂存登录类型 为了加那个设备类型参数
            // 手机号验证成功 发送验证码
            [self sendTheArea:phoneNum];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
}
- (void)sendTheArea:(NSString *)phoneNum {
    [MBProgressHUD cc_showLoading:nil];
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    [dicM setObject:phoneNum forKey:@"mobile"];
    [dicM setObject:@"login" forKey:@"event"]; // 这里的login为固定值 为快速登陆的固定值
    
    [MainNetworkRequest sendSmsValidationRequestParams:dicM success:^(id success) {
        NSLog(@"stepOnePointFive %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [MBProgressHUD cc_showText:success[@"msg"]];
            // 发送成功  开启定时器
            [self startTimer];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
        
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}

// 定时器 及重发方法
-(void)startTimer
{
    total = 60;
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(changeChongFaBtn) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
- (void)changeChongFaBtn{
    
    if (total == 0) {
        [self invalidateTheTimer];
        
        self.areaCode.userInteractionEnabled = YES;
        [self.areaCode setTitle:SIMLocalizedString(@"KHBcodeReObtain", nil) forState:UIControlStateNormal];
        [self.areaCode setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
        return;
    }
    total --;
    _areaCode.userInteractionEnabled = NO;
    [self.areaCode setTitle:[NSString stringWithFormat:@"%@（%lds）", SIMLocalizedString(@"KHBcodeReObtainMinute", nil), (long)total + 1 ] forState:UIControlStateNormal];
    [self.areaCode setTitleColor:BlackTextColor forState:UIControlStateNormal];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self invalidateTheTimer];
    
}

- (void)invalidateTheTimer {
    if (nil != _timer) {
        [_timer setFireDate:[NSDate distantFuture]];
        [_timer invalidate];
        _timer = nil;
    }
    NSLog(@"销毁了timer也也");
}
#pragma mark -- UITextFieldDelegate
- (void)textFieldDidChanged:(UITextField *)textField
{
    if (textField == _phoneTF) {
        [self subStringAllMethod:textField withLength:11];
    }else if (textField == _codeW) {
        [self subStringAllMethod:textField withLength:6];
    }
}


@end
