//
//  SIMRegisterViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/21.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMRegisterViewController.h"
#import "SIMMediumViewController.h"
#import "SIMTextField.h"
#import "SIMLoginMainViewController.h"
#import "SIMEntranceViewController.h"
#import "SIMBaseCommonTableViewCell.h"
#import "SIMTempCompanyViewController.h"

#define BackColor ZJYColorHex(@"#E5E5E5")
@interface SIMRegisterViewController ()
{
    BOOL i;
}
@property (nonatomic, strong) UIView *headerV;
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UITextField *phoneNum;
@property (nonatomic, strong) UIButton *nextTep;
@property (nonatomic, strong) UIButton *login;
@property (nonatomic, strong) UIImageView *selectImage;
@property (nonatomic, strong) UILabel *afreeLab;
@property (nonatomic, strong) UILabel *worldLab;
@property (nonatomic, strong) UILabel *privacyLab;

//@property (strong,nonatomic) SIMBaseTableView* tableView;// 基础表格

@end

@implementation SIMRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"KHBRegister", nil);
    i = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"NavBackCancelTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    cancel.tintColor = BlueButtonColor;
    self.navigationItem.leftBarButtonItem = cancel;
   
    [self addsubViews];
}
- (void)cancelBtnClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)addsubViews {
//    _headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height/2 + 36)];
//    _headerV.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:_headerV];
    
    // 顶部图片
    _header = [[UIImageView alloc] init];
    _header.image = [UIImage imageNamed:[SIMInternationalController getLanPicNameWithPicName:@"register_111_new"]];
    _header.contentMode = UIViewContentModeScaleAspectFit;
    _header.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_header];
    [_header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(kWidthScale(175));
    }];
    
    // 输入框底部的线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = BackColor;
//    lineView.frame = CGRectMake(20, screen_height/2-64-30, screen_width - 40, 1);
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(screen_height/2-StatusNavH-30);
        make.height.mas_equalTo(1);
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
        make.bottom.mas_equalTo(lineView.mas_top);
        make.height.mas_equalTo(45);
    }];
    
    // 点击下一步按钮
    _nextTep = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextTep.frame = CGRectMake(15, screen_height/2-64, screen_width-30, 45);
    _nextTep.backgroundColor = BlueButtonColor;
    _nextTep.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_nextTep setTitle:SIMLocalizedString(@"KHBNextStepBtn", nil) forState:UIControlStateNormal];
    [_nextTep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextTep setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    [_nextTep setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [_nextTep addTarget:self action:@selector(registClick) forControlEvents:UIControlEventTouchUpInside];
    _nextTep.layer.masksToBounds = YES;
    _nextTep.layer.cornerRadius = 45/4;
    [self.view addSubview:_nextTep];
    
    // 去登陆按钮
    _login = [UIButton buttonWithType:UIButtonTypeCustom];
    _login.titleLabel.textAlignment = NSTextAlignmentRight;
    _login.titleLabel.font = FontRegularName(12);
    // 设置同一button上的字体不同 颜色也不同
    NSMutableAttributedString *st1 = [[NSMutableAttributedString alloc] initWithString:SIMLocalizedString(@"KHBgoLoginClick", nil)];
    [st1 addAttributes:@{NSFontAttributeName:FontRegularName(12),
                         NSForegroundColorAttributeName:TableViewHeaderColor} range:NSMakeRange(0, 5)];
    [_login setAttributedTitle:st1 forState:UIControlStateNormal];
    _login.titleLabel.textColor = BlueButtonColor;
    [_login addTarget:self action:@selector(logClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_login];
    [_login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_nextTep.mas_bottom).offset(10);
        make.height.mas_equalTo(15);
    }];
    
    _selectImage = [[UIImageView alloc] init];
    _selectImage.userInteractionEnabled = YES;
    // 默认为勾选状态
    _selectImage.image = [UIImage imageNamed:@"register_select_after"];
    [self.view addSubview:_selectImage];
    [_selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(15);
        make.top.mas_equalTo(_nextTep.mas_bottom).offset(10);
        make.height.mas_equalTo(15);
    }];
    
    _afreeLab = [[UILabel alloc] init];
    _afreeLab.userInteractionEnabled = YES;
    _afreeLab.text = SIMLocalizedString(@"KHBagreeAndReadClick", nil);
    _afreeLab.textAlignment = NSTextAlignmentLeft;
    _afreeLab.textColor = TableViewHeaderColor;
    _afreeLab.font = FontRegularName(12);
    [self.view addSubview:_afreeLab];
    [_afreeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_selectImage.mas_right).offset(10);
        make.centerY.mas_equalTo(_selectImage);
    }];
    
    _privacyLab = [[UILabel alloc] init];
    _privacyLab.userInteractionEnabled = YES;
    _privacyLab.text = SIMLocalizedString(@"KHBseverceAndListPrivateClick", nil);
    _privacyLab.textAlignment = NSTextAlignmentLeft;
    _privacyLab.textColor = BlueButtonColor;
    _privacyLab.font = FontRegularName(12);
    [self.view addSubview:_privacyLab];
    [_privacyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_afreeLab.mas_right).offset(0.5);
        make.centerY.mas_equalTo(_selectImage);
    }];
    
    UILabel *andLab = [[UILabel alloc] init];
    andLab.text = @"，";
    andLab.textAlignment = NSTextAlignmentLeft;
    andLab.textColor = BlackTextColor;
    andLab.font = FontRegularName(12);
    [self.view addSubview:andLab];
    [andLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_privacyLab.mas_right).offset(0.5);
        make.centerY.mas_equalTo(_selectImage);
    }];
    
    _worldLab = [[UILabel alloc] init];
    _worldLab.userInteractionEnabled = YES;
    _worldLab.text = SIMLocalizedString(@"KHBseverceAndListClick", nil);
    _worldLab.textAlignment = NSTextAlignmentLeft;
    _worldLab.textColor = BlueButtonColor;
    _worldLab.font = FontRegularName(12);
    [self.view addSubview:_worldLab];
    [_worldLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(andLab.mas_right).offset(0.5);
        make.centerY.mas_equalTo(_selectImage);
    }];
    UITapGestureRecognizer *tapP = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick3)];
    [_privacyLab addGestureRecognizer:tapP];
    
    UITapGestureRecognizer *tapWorld = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick2)];
    [_worldLab addGestureRecognizer:tapWorld];
    
    UITapGestureRecognizer *tapFeer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    UITapGestureRecognizer *tapSelect = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [_selectImage addGestureRecognizer:tapSelect];
    [_afreeLab addGestureRecognizer:tapFeer];
    
    
//    [self.view addSubview:_headerV];
    

}

#pragma mark -- Event
// 点击条款的手势
- (void)tapClick {
    i = !i;
    if (i == YES) {
        _selectImage.image = [UIImage imageNamed:@"register_select_after"];
        _nextTep.enabled = YES;
        _nextTep.backgroundColor = BlueButtonColor;
    }else {
        _selectImage.image = [UIImage imageNamed:@"register_select"];
        _nextTep.enabled = NO;
        _nextTep.backgroundColor = EnableButtonColor;
    }
}

- (void)tapClick3 {
    // 跳转到链接页面
    SIMTempCompanyViewController *webVC = [[SIMTempCompanyViewController alloc] init];
    webVC.navigationItem.title = SIMLocalizedString(@"KHBseverceAndListPrivateClick", nil);
    webVC.webStr = [NSString stringWithFormat:@"%@%@",kApiBaseUrl,self.cloudVersion.privacy_path];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)tapClick2 {
    // 跳转到链接页面
    SIMTempCompanyViewController *webVC = [[SIMTempCompanyViewController alloc] init];
    webVC.navigationItem.title = SIMLocalizedString(@"KHBseverceAndListClick", nil);
    webVC.webStr = [NSString stringWithFormat:@"%@%@",kApiBaseUrl,self.cloudVersion.terms_path];
    [self.navigationController pushViewController:webVC animated:YES];
}

// 点击下一步 -- 注册功能 第一步：验证手机号
- (void)registClick {
    // 正在加载框
    NSString *phoneNum = self.phoneNum.text;
    [MBProgressHUD cc_showLoading:nil];
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
    
    [MainNetworkRequest registerRequestParams:dicM success:^(id success) {
        NSLog(@"vaphonesuccessDic%@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            // 跳转
            [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
            SIMMediumViewController *medium = [[SIMMediumViewController alloc] init];
            medium.phoneNumber = phoneNum;
            [self.navigationController pushViewController:medium animated:YES];
           
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
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
- (void)textFieldDidChanged:(UITextField *)textField
{
    [self subStringAllMethod:textField withLength:11];
}

@end
