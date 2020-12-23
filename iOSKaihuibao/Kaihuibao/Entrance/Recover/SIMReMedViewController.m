//
//  SIMReMedViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/6/6.
//  Copyright © 2017年 Ferris. All rights reserved.
//
#define BackColor ZJYColorHex(@"#E5E5E5")

#import "SIMReMedViewController.h"
#import "SIMReLastViewController.h"
#import "SIMTextField.h"
#import "SIMLoginMainViewController.h"

@interface SIMReMedViewController ()
{
    NSInteger total;
}
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) SIMTextField *codeW;
@property (nonatomic, strong) UIButton *regist;
@property (nonatomic, strong) UIButton *login;
@property (nonatomic, strong) UIButton *areaCode;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SIMReMedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"KHBForgetPassword", nil);
    
    self.view.backgroundColor = ZJYColorHex(@"#FAFAFA");
    [self addsubViews];
    [self sendTheArea];
}
- (void)addsubViews {
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
    [_areaCode addTarget:self action:@selector(areaClick) forControlEvents:UIControlEventTouchUpInside];
    [_areaCode setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
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
    
    
}
#pragma mark --Event
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
    [self.areaCode setTitle:[NSString stringWithFormat:@"%lds %@",(long)total + 1 , SIMLocalizedString(@"KHBcodeReObtainMinute", nil)] forState:UIControlStateNormal];
    [self.areaCode setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
}

// 点击发送验证码
- (void)areaClick {
    [self sendTheArea];
}
- (void)sendTheArea {
    // 正在加载框
    [MBProgressHUD cc_showLoading:nil];
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    [dicM setObject:self.phoneNumber forKey:@"mobile"];
    [dicM setObject:@"resetpwd" forKey:@"event"];
    [MainNetworkRequest sendSmsValidationRequestParams:dicM success:^(id success) {
        
        NSLog(@"hahahsuccess%@",success);
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
// 点击下一步
- (void)registClick {
    // 正在加载框
    [MBProgressHUD cc_showLoading:nil];
    if (self.codeW.text.length == 0) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_Please_puinCode", nil)];
        return ;
    }
    // 先验证验证码 再跳转
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    [dicM setObject:self.phoneNumber forKey:@"mobile"];
    [dicM setObject:self.codeW.text forKey:@"captcha"];
    [dicM setObject:@"2" forKey:@"step"];
    
    [MainNetworkRequest recoverPasswordRequestParams:dicM success:^(id success) {
        
        NSLog(@"recoverPhonesuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            // 将正在加载框隐藏
            [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
            // 将token存入本地 验证验证码 
            [[NSUserDefaults standardUserDefaults] setObject:self.codeW.text forKey:@"validationToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self invalidateTheTimer];
            
            
            SIMReLastViewController *last = [[SIMReLastViewController alloc] init];
            last.phoneNumber = self.phoneNumber;
            [self.navigationController pushViewController:last animated:YES];
            
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
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
}
#pragma mark -- UITextFieldDelegate
//// 随输入文字动态判断
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (textField == _codeW) {
//        //  最多输入6位
//        NSUInteger length = textField.text.length - range.length + string.length;
//        if (length > 6) {
//            textField.text = [textField.text substringToIndex:6];
//            return NO;
//        }
//    }
//    return YES;
//}
- (void)textFieldDidChanged:(UITextField *)textField
{
    [self subStringAllMethod:textField withLength:6];
}

@end
