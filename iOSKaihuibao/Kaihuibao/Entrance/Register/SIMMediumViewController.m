//
//  SIMMediumViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/6/5.
//  Copyright © 2017年 Ferris. All rights reserved.
//
#define BackColor ZJYColorHex(@"#E5E5E5")

#import "SIMMediumViewController.h"
#import "SIMLastViewController.h"
#import "SIMTextField.h"
#import "SIMLoginMainViewController.h"
@interface SIMMediumViewController ()
{
    NSInteger total;
    NSTimer *timer;
}
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) SIMTextField *codeW;
@property (nonatomic, strong) UIButton *regist;
@property (nonatomic, strong) UIButton *login;
@property (nonatomic, strong) UIButton *areaCode;

@end

@implementation SIMMediumViewController
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = SIMLocalizedString(@"KHBRegister", nil);
    self.view.backgroundColor = ZJYColorHex(@"#FAFAFA");
    
    [self addsubViews];
    [self sendTheArea];
}
- (void)addsubViews {
    // 这是头部注册 这个是个图片 如果OEM需要改这里颜色也得改
    _header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kWidthScale(190))];
    _header.image = [UIImage imageNamed:[SIMInternationalController getLanPicNameWithPicName:@"register_2_new"]];
    _header.backgroundColor = ZJYColorHex(@"#FAFAFA");
    _header.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_header];
    
    _codeW = [[SIMTextField alloc] init];
    _codeW.placeholder = SIMLocalizedString(@"KHBCodePlaceHolder", nil);
//    _codeW.keyboardType = UIKeyboardTypeNumberPad;
    [_codeW addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_codeW];
    [_codeW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(_header.mas_bottom).mas_offset(kWidthScale(20));
        make.height.mas_equalTo(50);
    }];
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = BackColor;
    lineView.frame = CGRectMake(0, 49, screen_width - 40, 1);
    [_codeW addSubview:lineView];
    
    _areaCode = [[UIButton alloc] initWithFrame:CGRectMake(0, screen_width - kWidthScale(100), kWidthScale(100), 50)];
    _areaCode.userInteractionEnabled = YES;
    [_areaCode setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
    [_areaCode addTarget:self action:@selector(areaClick) forControlEvents:UIControlEventTouchUpInside];
    [_areaCode setTitle:SIMLocalizedString(@"KHBcodeObtainClick", nil) forState:UIControlStateNormal];
    _areaCode.titleLabel.font = FontRegularName(13);
    _areaCode.titleLabel.textAlignment = NSTextAlignmentCenter;
    _codeW.rightViewMode = UITextFieldViewModeAlways;
    _codeW.rightView = _areaCode;
    UIView *lineShort = [[UIView alloc]init];
    lineShort.backgroundColor = BackColor;
    lineShort.frame = CGRectMake(0, 5, 1, 40);
    [_areaCode addSubview:lineShort];
    
    _regist = [UIButton buttonWithType:UIButtonTypeCustom];
    _regist.backgroundColor = BlueButtonColor;
    _regist.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_regist setTitle:SIMLocalizedString(@"KHBNextStepBtn", nil) forState:UIControlStateNormal];
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
        make.top.mas_equalTo(_codeW.mas_bottom).offset(40);
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
// 点击发送验证码 -- 注册功能 第二步：发送验证码
- (void)areaClick {
    [self sendTheArea];
}
- (void)sendTheArea {
    // 正在加载框
    [MBProgressHUD cc_showLoading:nil];
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    [dicM setObject:self.phoneNumber forKey:@"mobile"];
    [dicM setObject:@"register" forKey:@"event"];
    
    [MainNetworkRequest sendSmsValidationRequestParams:dicM success:^(id success) {
        NSLog(@"vayanzhengmasuccessDic%@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [MBProgressHUD cc_showText:success[@"msg"]];
            
            [self startTimer];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
        
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}
// 点击下一步按钮 -- 注册功能 第三步：验证验证码
- (void)registClick {
    [MBProgressHUD cc_showLoading:nil];
    if (self.codeW.text.length == 0) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_Please_puinCode", nil)];
        return ;
    }
    // 先验证验证码 再跳转
    NSMutableDictionary *dicM =[[NSMutableDictionary alloc] init];
    [dicM setObject:self.phoneNumber forKey:@"mobile"];
    [dicM setObject:self.codeW.text forKey:@"captcha"];
    [dicM setObject:@"2" forKey:@"step"];
    
    [MainNetworkRequest registerRequestParams:dicM success:^(id success) {
        NSLog(@"vayanzhengmasuccessDic%@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
//
//    [MainNetworkRequest judgementSmsValidationRequestParams:dicM success:^(id success) {
            [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
            // 将验证码 保存起来token 用作下次注册的验证 防止验证码重复（现在不是了 但是还是这么写吧 省的传值了）
            [[NSUserDefaults standardUserDefaults] setObject:self.codeW.text forKey:@"validationToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // 跳转下一页 并将本页的手机号传值下一页
            [self invalidateTheTimer];
            SIMLastViewController *last = [[SIMLastViewController alloc] init];
            last.phoneNumber = self.phoneNumber;
            last.isQuick = NO;
            [self.navigationController pushViewController:last animated:YES];
                
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
}

// 创建定时器
-(void)startTimer
{
    total = 60;
//    timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(changeChongFaBtn) userInfo:nil repeats:YES];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeChongFaBtn) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
// 定时器结束 重新发送
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
    [self.areaCode setTitle:[NSString stringWithFormat:@"%lds %@",(long)total + 1 , SIMLocalizedString(@"KHBcodeReObtainMinute", nil)] forState:UIControlStateNormal];
    [self.areaCode setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
}
// 已有账号去登录
- (void)logClick {
    // 返回登录页 将现有对象释放 将根视图设为登录页
    [self invalidateTheTimer];
    
    [self dismissViewControllerAnimated:NO completion:^{
        UIViewController *loginVC = [[[SIMLoginMainViewController alloc] init] sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
         loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [windowRootViewController presentViewController:loginVC animated:YES completion:nil];
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self invalidateTheTimer];
}
- (void)invalidateTheTimer {
    if (nil != timer) {
        [timer setFireDate:[NSDate distantFuture]];
        [timer invalidate];
        timer = nil;
    }
}
#pragma mark -- UITextFieldDelegate

- (void)textFieldDidChanged:(UITextField *)textField
{
    [self subStringAllMethod:textField withLength:6];
}
@end
