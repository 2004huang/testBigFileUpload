//
//  SIMFirstLoginPageViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/9/4.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMFirstLoginPageViewController.h"

#import "UIButton+RCCImagePosition.h"
#import "WXApi.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import "TencentOpenAPI/TencentOAuth.h"
#import "SIMQuickLoginViewController.h"
#import "SIMChoseCompanyViewController.h"
#import "SIMEntranceViewController.h"
#import "SIMLoginMainViewController.h"
#import "SIMTempCompanyViewController.h"

@interface SIMFirstLoginPageViewController ()<TencentSessionDelegate,UITextFieldDelegate>
{
    BOOL logBtnOnce;
    BOOL i;
    NSInteger current; // 记录当前选中的值
}
@property (nonatomic, strong) UIView *headerV;
@property (nonatomic, strong) UITextField *countryTF;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UIButton *nextTep;
@property (nonatomic, strong) UIButton *chooseLang;

@property (nonatomic, strong) UIImageView *selectImage;
@property (nonatomic, strong) UILabel *afreeLab;
@property (nonatomic, strong) UILabel *worldLab;
@property (nonatomic, strong) UILabel *privacyLab;

@property (nonatomic, strong) UIButton *wechatBtn;
@property (nonatomic, strong) UIButton *qqBtn;
@property (nonatomic,strong) TencentOAuth *tencentOAuth;

@property (nonatomic, strong) NSArray *arr;

@end

@implementation SIMFirstLoginPageViewController
-(instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWeiXinDataWithCode:) name:ThirdLoginGetData object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"firstPagethirdloginmaindealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    logBtnOnce = YES;
    i = YES;
    
//    _arr = @[@{@"type":@"followSystem",@"name":@"系统语言"},
//            @{@"type":@"zh-Hans",@"name":@"简体中文"},
//             @{@"type":@"zh-Hant",@"name":@"繁体中文"},
//            @{@"type":@"en",@"name":@"English"},
//            @{@"type":@"ja",@"name":@"Japanese"}];
    _arr = [SIMInternationalController getLanguageArr];
    
    // 从本地拿用户选了哪个（ 因为没有后台参与 并且需要用户手动选择语言而不是仅仅跟随系统）
    NSString *currentLang = [[NSUserDefaults standardUserDefaults] objectForKey:kLanguage];
    for (int i = 0; i < _arr.count; i++) {
        NSDictionary *dic = _arr[i];
        if ([[dic objectForKey:@"type"] isEqualToString:currentLang]) {
            current = i;
            break ;
        }
    }
//    if ([lll isEqualToString:@"ja"]) {
//        current = 4;
//    }else if ([lll isEqualToString:@"en"]) {
//        current = 3;
//    }else if ([lll isEqualToString:@"zh-Hant"]) {
//        current = 2;
//    }else if ([lll isEqualToString:@"zh-Hans"]) {
//        current = 1;
//    }else {
//        current = 0;
//    }
    [self addHeaderImageView];// 添加头部视图
    [self addSubUIs]; // 添加输入框按钮等视图
    
    if ([self.cloudVersion.wechat boolValue]) {
        [self addBottomViews];// 添加底部三方登录按钮
    }
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"returnicon"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    cancel.tintColor = BlueButtonColor;
    self.navigationItem.leftBarButtonItem = cancel;
}
- (void)cancelBtnClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)addHeaderImageView {
    _headerV = [[UIView alloc] init];
    _headerV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headerV];
    
    UILabel *textLab = [[UILabel alloc] init];
    textLab.text = SIMLocalizedString(@"NewMainLoginTitle", nil);
    textLab.textColor = BlueButtonColor;
//    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.font = FontMediumName(24);
    [_headerV addSubview:textLab];
    
    [_headerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(kWidthScale(100));
    }];
    [textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(kWidthScale(25));
        make.right.mas_equalTo(-kWidthScale(25));
    }];
}
// 初始化UI
- (void)addSubUIs {
    // 输入国家和地区
    _countryTF = [[UITextField alloc] init];
    _countryTF.placeholder = SIMLocalizedString(@"MArrangeStarChoose", nil);
    _countryTF.textAlignment = NSTextAlignmentLeft;
    _countryTF.delegate = self;
    [self.view addSubview:_countryTF];
    UILabel *countryLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 50)];
    countryLab.text = SIMLocalizedString(@"NewLogCountryTitle", nil);
    countryLab.textColor = BlackTextColor;
    countryLab.font = FontRegularName(17);
    countryLab.textAlignment = NSTextAlignmentLeft;
    _countryTF.leftViewMode = UITextFieldViewModeAlways;
    _countryTF.leftView = countryLab;
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 50)];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 37/2, 7, 13)];
    imageV.image = [UIImage imageNamed:@"通讯录页-箭头"];
    [rightView addSubview:imageV];
    _countryTF.rightViewMode = UITextFieldViewModeAlways;
    _countryTF.rightView = rightView;
    [_countryTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidthScale(25));
        make.right.mas_equalTo(-kWidthScale(25));
        make.top.mas_equalTo(_headerV.mas_bottom).offset(kWidthScale(5));
        make.height.mas_equalTo(50);
        
    }];
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = ZJYColorHex(@"#c7c7cb");
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidthScale(13));
        make.right.mas_equalTo(-kWidthScale(13));
        make.top.mas_equalTo(_countryTF.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
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
    UILabel *countLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 50)];
    countLab.text = @"+86";
    countLab.textColor = BlackTextColor;
    countLab.font = FontRegularName(17);
    countLab.textAlignment = NSTextAlignmentLeft;
    UIView *lineShort = [[UIView alloc]init];
    lineShort.backgroundColor = ZJYColorHex(@"#c7c7cb");
    lineShort.frame = CGRectMake(89, 25/2, 1, 25);
    [countLab addSubview:lineShort];
    _phoneTF.leftViewMode = UITextFieldViewModeAlways;
    _phoneTF.leftView = countLab;
    [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.and.right.mas_equalTo(_countryTF);
        make.top.mas_equalTo(lineView.mas_bottom).offset(kWidthScale(10));
    }];
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = BlueButtonColor;
    [self.view addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.and.right.mas_equalTo(lineView);
        make.top.mas_equalTo(_phoneTF.mas_bottom);
    }];
    
    _selectImage = [[UIImageView alloc] init];
    _selectImage.userInteractionEnabled = YES;
    // 默认为勾选状态
    _selectImage.image = [UIImage imageNamed:@"register_select_after"];
    [self.view addSubview:_selectImage];
    [_selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidthScale(15));
        make.width.mas_equalTo(15);
        make.top.mas_equalTo(lineView2.mas_bottom).offset(kWidthScale(15));
        make.height.mas_equalTo(15);
    }];
    
    _afreeLab = [[UILabel alloc] init];
    _afreeLab.userInteractionEnabled = YES;
    _afreeLab.text = SIMLocalizedString(@"KHBagreeAndReadClick", nil);
    _afreeLab.textAlignment = NSTextAlignmentLeft;
    _afreeLab.textColor = BlackTextColor;
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
    
    // 下一步的大按钮
    _nextTep = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextTep.titleLabel.font = FontRegularName(18);
    [_nextTep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextTep setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [_nextTep setBackgroundColor:BlueButtonColor];
    [_nextTep setTitle:SIMLocalizedString(@"KHBNextStepBtn", nil) forState:UIControlStateNormal];
    [_nextTep setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    [_nextTep addTarget:self action:@selector(nextPageClick) forControlEvents:UIControlEventTouchUpInside];
    _nextTep.layer.masksToBounds = YES;
    _nextTep.layer.cornerRadius = 11;
    [self.view addSubview:_nextTep];
    [_nextTep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidthScale(10));
        make.right.mas_equalTo(-kWidthScale(10));
        make.top.mas_equalTo(_selectImage.mas_bottom).offset(kWidthScale(30));
        make.height.mas_equalTo(44);
    }];
    
    // 多语言按钮
    _chooseLang = [UIButton buttonWithType:UIButtonTypeCustom];
    _chooseLang.titleLabel.font = FontRegularName(15);
    [_chooseLang setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [_chooseLang setTitle:[_arr[current] objectForKey:@"name"] forState:UIControlStateNormal];
    [_chooseLang setImage:[UIImage imageNamed:@"通讯录页-箭头展开"] forState:UIControlStateNormal];
    [_chooseLang addTarget:self action:@selector(chooseLangClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_chooseLang];
    [_chooseLang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kWidthScale(25));
        make.top.mas_equalTo(_nextTep.mas_bottom).offset(kWidthScale(18));
//        make.height.mas_equalTo(44);
    }];
    [_chooseLang setImagePosition:RCCImagePositionRight spacing:5];
    
}

// 添加底部三方登录UI
- (void)addBottomViews {
    if([WXApi isWXAppInstalled]) {
        NSLog(@"安装了微信");
        // 微信登录按钮
        _wechatBtn = [[UIButton alloc] init];
        [_wechatBtn addTarget:self action:@selector(threePlatClick:) forControlEvents:UIControlEventTouchUpInside];
        [_wechatBtn setImage:[UIImage imageNamed:@"微信登录"] forState:UIControlStateNormal];
        _wechatBtn.tag = 1001;
        [self.view addSubview:_wechatBtn];
        [_wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-(isIPhoneXAll ? kWidthScale(60) + BottomSaveH : kWidthScale(60)));
            make.right.mas_equalTo(self.view.mas_centerX).offset(-20);
            make.size.mas_equalTo(kWidthScale(50));
        }];
    }else {
        NSLog(@"没有安装了微信");
    }
    
    if ([QQApiInterface isQQInstalled]) {
        NSLog(@"安装了QQ");
        // QQ登录按钮
        _qqBtn = [[UIButton alloc] init];
        [_qqBtn setImage:[UIImage imageNamed:@"QQ登录"] forState:UIControlStateNormal];
        _qqBtn.tag = 1002;
        [_qqBtn addTarget:self action:@selector(threePlatClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_qqBtn];
        [_qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_centerX).offset(20);
            make.bottom.mas_equalTo(-(isIPhoneXAll ? kWidthScale(60) + BottomSaveH : kWidthScale(60)));
            make.size.mas_equalTo(kWidthScale(50));
        }];
    }else {
        NSLog(@"没有安装了QQ");
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"————————— %@ —————————",SIMLocalizedString(@"ThirdLoginOtherTitle", nil)];
    label.textColor = ZJYColorHex(@"#c7c7cc");
    label.font = FontRegularName(13);
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    if ([WXApi isWXAppInstalled]) {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_wechatBtn.mas_top).offset(-kWidthScale(20));
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];
    }else if([QQApiInterface isQQInstalled]) {
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_qqBtn.mas_top).offset(-kWidthScale(20));
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];
    }
}

#pragma mark -- UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField*)textField
{
    NSLog(@"点击了选择国家");
    // 跳转到链接页面
    SIMTempCompanyViewController *webVC = [[SIMTempCompanyViewController alloc] init];
    webVC.navigationItem.title = SIMLocalizedString(@"KHBseverceAndListClick", nil);
    webVC.webStr = [NSString stringWithFormat:@"%@%@",kApiBaseUrl,self.cloudVersion.terms_path];
    [self.navigationController pushViewController:webVC animated:YES];
    [_countryTF resignFirstResponder];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_countryTF resignFirstResponder];
    return YES;
}

#pragma mark -- Event
- (void)textFieldDidChanged:(UITextField *)textField
{
    if (textField == _phoneTF) {
        [self subStringAllMethod:textField withLength:11];
    }
}
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
- (void)nextPageClick {
    SIMLoginMainViewController *loginMainVC = [[SIMLoginMainViewController alloc] init];
    [self.navigationController pushViewController:loginMainVC animated:YES];
}
// 点击切换多语言
- (void)chooseLangClick {
    [self addActionSheet];
}
#pragma mark -- UIAlertViewDelegate
- (void)addActionSheet {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:SIMLocalizedString(@"NewLogChooseLanguage", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < _arr.count; i++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:[_arr[i] objectForKey:@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            if (i == 0) {
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLanguage];
//                [SIMInternationalController initUserLanguage]; //初始化应用语言
//                [SIMInternationalController setUserLanguage:@"followSystem"];
//            }else {
                [SIMInternationalController setUserLanguage:[_arr[i] objectForKey:@"type"]];
//            }
            [self.navigationController dismissViewControllerAnimated:NO completion:^{
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                SIMEntranceViewController *entanceVC = [[SIMEntranceViewController alloc] init];
                delegate.window.rootViewController = entanceVC;
            }];
            
        }];
        [alertC addAction:action];
    }
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:action0];
    alertC.popoverPresentationController.sourceView = self.view;
    alertC.popoverPresentationController.sourceRect = _chooseLang.frame;
    alertC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionRight;
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)threePlatClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1001:
            NSLog(@"点击了微信登录的按钮");
            [self weiXinLogin];
            break;
        case 1002:
            NSLog(@"点击了QQ登录的按钮");
            [self qqLogin];
            break;
        default:
            break;
    }
}
- (void)qqLogin {
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAPPID andDelegate:self];
    NSMutableArray *permission = [@[] mutableCopy];
    permission = [NSMutableArray arrayWithObjects:@"get_user_info",@"get_simple_userinfo",nil];
    [self.tencentOAuth authorize:permission inSafari:NO];
    
}
#pragma mark - TencentSessionDelegate
-(void)tencentDidNotNetWork {
    [MBProgressHUD cc_showText:SIMLocalizedString(@"AllNetWorkNONETitle", nil)];
}
-(void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled){
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ThirdLoginCancleTitle", nil)];
    }else{
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ThirdLoginFailTitle", nil)];
    }
}
- (void)tencentDidLogin {
    NSLog(@"qqloginwai  accessToken %@  openId %@  expirationDate %@",_tencentOAuth.accessToken,_tencentOAuth.openId,_tencentOAuth.expirationDate);
    if (_tencentOAuth.accessToken.length != 0) {
        NSLog(@"qqlogin  %@ == %@",_tencentOAuth.accessToken,_tencentOAuth.openId);
        //        [self.tencentOAuth getUserInfo];
        
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[_tencentOAuth.expirationDate timeIntervalSince1970]];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"qq",@"platform",_tencentOAuth.openId,@"openid",timeSp,@"expires_in",_tencentOAuth.accessToken,@"access_token", nil];
        NSLog(@"qquserinfodic %@",dic);
        [self getWeiXinOpenId:dic];
        
    }else {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ThirdLoginFailTitle", nil)];
    }
}

-(void)weiXinLogin
{
    if([WXApi isWXAppInstalled]) {
        //构造SendAuthReq结构体
        SendAuthReq* req =[[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"123";
        //第三方向微信终端发送一个SendAuthReq消息结构
//        [WXApi sendReq:req];
        [WXApi sendReq:req completion:^(BOOL success) {
            
        }];
    }
    else {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ThirdLoginNoWechatTitle", nil)];
    }
}

- (void)getWeiXinDataWithCode:(NSNotification *)notification {
    NSMutableDictionary *dic = [[notification userInfo] mutableCopy];
    NSLog(@"notifyuserinfodic %@",dic);
    [self getWeiXinOpenId:dic];
}

- (void)getWeiXinOpenId:(NSMutableDictionary *)dic {
    // 正在加载框
    [MBProgressHUD cc_showLoading:nil];
    UIDevice *myDecive = [UIDevice currentDevice];
    [dic setObject:myDecive.model forKey:@"loginEquipment"];
    [dic setObject:ThreePlantID forKey:@"app"];
    NSLog(@"successcodeGetOpenIDdic %@",dic);
    [MainNetworkRequest thirdLoginRequestParams:dic success:^(id success) {
        NSLog(@"successcodeGetOpenID %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
            NSDictionary *dic = success[@"data"];
            BOOL lindked = [dic[@"is_linked"] boolValue];
            
            if (lindked) {
                // 已经关联了 那么直接返回登录成功后的信息
                // 登录
                [self goLogin:dic];
                
            }else {
                // 没有关联 那么跳转到绑定手机号界面
                SIMQuickLoginViewController *linkVC = [[SIMQuickLoginViewController alloc] init];
                linkVC.navigationItem.title = SIMLocalizedString(@"ThirdLoginContactPhoneTitle", nil);
                linkVC.thirdDic = dic;
                [self.navigationController pushViewController:linkVC animated:YES];
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

@end
