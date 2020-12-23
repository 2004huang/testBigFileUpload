//
//  SIMRecoverViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/22.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMRecoverViewController.h"
#import "SIMReMedViewController.h"
#import "SIMTextField.h"
#import "SIMLoginMainViewController.h"

#define BackColor ZJYColorHex(@"#E5E5E5")
@interface SIMRecoverViewController ()
//{
//    BOOL i;
//    NSMutableArray *areaArr;
//    NSMutableArray *codeArr;
//}
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UITextField *phoneNum;
@property (nonatomic, strong) UIButton *nextTep;
//@property (nonatomic, strong) UILabel *areaCode;
@property (nonatomic, strong) UIButton *login;
//@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SIMRecoverViewController

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"KHBForgetPassword", nil);
    
    self.view.backgroundColor = ZJYColorHex(@"#FAFAFA");
   
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"NavBackCancelTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    cancel.tintColor = BlueButtonColor;
    self.navigationItem.leftBarButtonItem = cancel;
    
    
    [self addsubViews];
}
- (void)cancelBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addsubViews {
    
    _header = [[UIImageView alloc] init];
    _header.image = [UIImage imageNamed:[SIMInternationalController getLanPicNameWithPicName:@"register_4_new"]];
    _header.backgroundColor = ZJYColorHex(@"#FAFAFA");
    _header.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_header];
    [_header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(kWidthScale(175));
    }];
    
    // 手机号输入框
    _phoneNum = [[UITextField alloc] init];
    _phoneNum.placeholder = SIMLocalizedString(@"KHBPhoneNumPlaceHolder", nil);
    _phoneNum.textAlignment = NSTextAlignmentCenter;
    _phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    [_phoneNum addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_phoneNum];
    [_phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(_header.mas_bottom).mas_offset(kWidthScale(35));
        make.height.mas_equalTo(kWidthScale(50));
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = BackColor;
    lineView.frame = CGRectMake(20, kWidthScale(260), screen_width - 40, 1);
    [self.view addSubview:lineView];
    
    
    _nextTep = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextTep.backgroundColor = BlueButtonColor;
    _nextTep.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_nextTep setTitle:SIMLocalizedString(@"KHBNextStepBtn", nil) forState:UIControlStateNormal];
    [_nextTep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextTep setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    [_nextTep setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [_nextTep addTarget:self action:@selector(registClick) forControlEvents:UIControlEventTouchUpInside];
    _nextTep.layer.masksToBounds = YES;
    _nextTep.layer.cornerRadius = 50/4;
    [self.view addSubview:_nextTep];
    [_nextTep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_phoneNum.mas_bottom).offset(40);
        make.height.mas_equalTo(50);
    }];
    
}

#pragma mark -- Event

// 点击下一步 忘记密码：第一步 验证手机号是否注册了
- (void)registClick {
    [MBProgressHUD cc_showLoading:nil];
    NSString *phoneNum = self.phoneNum.text;
    
    if (phoneNum.length != 11) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_WRONG_PhoneNumber", nil)];
        return;
    }
    if (![phoneNum checkTel]) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_WRONG_PhoneNumber", nil)];
        return;
    }
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    [dicM setObject:phoneNum forKey:@"mobile"];
    [dicM setObject:@"1" forKey:@"step"];
    
    [MainNetworkRequest recoverPasswordRequestParams:dicM success:^(id success) {
        
        NSLog(@"recoverPhonesuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
//            if([success[@"available"] intValue]==0){
                // 注册了才可以跳转改密码
                // 将正在加载框隐藏
                [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
                SIMReMedViewController *medium = [[SIMReMedViewController alloc] init];
                medium.phoneNumber = phoneNum;
                [self.navigationController pushViewController:medium animated:YES];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        
       [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}

#pragma mark -- UITextFieldDelegate
//// 随输入文字动态判断
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (textField == _phoneNum) {
//        //  最多输入11位
//        NSUInteger length = textField.text.length - range.length + string.length;
//        if (length > 11) {
//            textField.text = [textField.text substringToIndex:11];
//            return NO;
//        }
//    }
//    return YES;
//}
- (void)textFieldDidChanged:(UITextField *)textField
{
    [self subStringAllMethod:textField withLength:11];
}


@end
