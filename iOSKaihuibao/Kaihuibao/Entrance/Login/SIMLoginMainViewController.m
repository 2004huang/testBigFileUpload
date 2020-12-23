//
//  SIMLoginMainViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/4/26.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMLoginMainViewController.h"

#import "SIMNewLoginViewController.h"
#import "SIMQuickLoginViewController.h"
#import "SIMChoseCompanyViewController.h"

#import "SIMLoginSegment.h"
#import "UIButton+Position.h"
#import "WXApi.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import "TencentOpenAPI/TencentOAuth.h"

@interface SIMLoginMainViewController ()<UIScrollViewDelegate,TencentSessionDelegate>

@property (nonatomic, strong) UIScrollView *baseScrollView;// 滚动视图
@property (nonatomic, strong) SIMNewLoginViewController *loginVC; // 会议的VC
@property (nonatomic, strong) SIMQuickLoginViewController *quickLogVC;// 聊天VC

@property (nonatomic, strong) SIMLoginSegment *segmentView;
@property (nonatomic, strong) NSMutableArray <UIViewController *> *subViewControllers;
@property (nonatomic, strong) UIButton *wechatBtn;
@property (nonatomic, strong) UIButton *qqBtn;
@property (nonatomic,strong) TencentOAuth *tencentOAuth;
@property (nonatomic,strong) NSMutableArray *pageCountArr;

@end

@implementation SIMLoginMainViewController
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
    NSLog(@"thirdloginmaindealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _pageCountArr = [[NSMutableArray alloc] init];
    if ([self.cloudVersion.password_login boolValue]) {
        [_pageCountArr addObject:SIMLocalizedString(@"NewLoginWithPassWord", nil)];
    }
    if ([self.cloudVersion.captcha_login boolValue]) {
        [_pageCountArr addObject:SIMLocalizedString(@"NewLoginWithCode", nil)];
    }
    _subViewControllers = [[NSMutableArray alloc] init];
    [self addHeaderImageView];// 添加头部视图
    if (_pageCountArr.count >= 2) {
        [self.view addSubview:self.segmentView];// 添加分段控制器
    }
    [self addScrollViews];// 添加滚动子视图
    
    if ([self.cloudVersion.third_login boolValue]) {
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
    UIView *headerV = [[UIView alloc] init];
    headerV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerV];
    
    UILabel *textLab = [[UILabel alloc] init];
    textLab.text = SIMLocalizedString(@"NewMainLoginTitle", nil);
    textLab.textColor = BlueButtonColor;
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.font = FontMediumName(22);
    [headerV addSubview:textLab];
    
    [headerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(70);
    }];
    
    [textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
}
// 导航视图
- (SIMLoginSegment *)segmentView {
    if (!_segmentView) {
        self.segmentView = [[SIMLoginSegment alloc] initWithTitles:_pageCountArr frame:CGRectMake(0, 70, screen_width, 40)];
        __weak typeof(self) weakSelf = self;
        [self.segmentView setDidClickAtIndex:^(NSInteger index){
            [weakSelf navigationDidSelectedControllerIndex:index];
        }];
    }
    return _segmentView;
}
- (void)addScrollViews {
    _baseScrollView = [[UIScrollView alloc] init];
    if (_pageCountArr.count >= 2) {
        _baseScrollView.frame = CGRectMake(0, 110, screen_width, self.view.frame.size.height - 110 - StatusNavH- BottomSaveH - kWidthScale(150));
    }else {
        _baseScrollView.frame = CGRectMake(0, 70, screen_width, self.view.frame.size.height - 70 - StatusNavH - BottomSaveH - kWidthScale(150));
    }
    _baseScrollView.bounces = NO;
    _baseScrollView.delegate = self;
    _baseScrollView.scrollEnabled = NO;
    _baseScrollView.pagingEnabled = YES;
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_baseScrollView];
    
   
    _baseScrollView.contentSize = CGSizeMake(screen_width * _pageCountArr.count, _baseScrollView.frame.size.height);
    if (_pageCountArr.count >= 2) {
        _loginVC = [[SIMNewLoginViewController alloc] init];
        _loginVC.view.frame = CGRectMake(0, 0, screen_width, _baseScrollView.frame.size.height);
        [self addChildViewController:_loginVC];
        [_baseScrollView addSubview:_loginVC.view];
        
        [self.subViewControllers addObject:_loginVC];
    }else {
        if ([self.cloudVersion.password_login boolValue]) {
            _loginVC = [[SIMNewLoginViewController alloc] init];
            _loginVC.view.frame = CGRectMake(0, 0, screen_width, _baseScrollView.frame.size.height);
            [self addChildViewController:_loginVC];
            [_baseScrollView addSubview:_loginVC.view];
            
            [self.subViewControllers addObject:_loginVC];
        }
        if ([self.cloudVersion.captcha_login boolValue]) {
            _quickLogVC = [[SIMQuickLoginViewController alloc] init];
            _quickLogVC.view.frame = CGRectMake(0, 0, screen_width, _baseScrollView.frame.size.height);
            [self addChildViewController:_quickLogVC];
            [_baseScrollView addSubview:_quickLogVC.view];
            [self.subViewControllers addObject:_quickLogVC];
        }
    }
     
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 实时计算当前位置,实现和titleView上的按钮的联动
    [self.segmentView scrollToIndex:scrollView.contentOffset.x];
    NSInteger indexT = scrollView.contentOffset.x / screen_width;
    [self addOtherSubViews:indexT];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.segmentView canSelectedWidthIndex:scrollView.contentOffset.x];
    NSInteger indexT = scrollView.contentOffset.x / screen_width;
    [self addOtherSubViews:indexT];
}

#pragma mark - PrivateMethod
- (void)navigationDidSelectedControllerIndex:(NSInteger)index {
    [_baseScrollView setContentOffset:CGPointMake((_baseScrollView.frame.size.width)*index, 0) animated:NO];
    
}

- (void)addOtherSubViews:(NSInteger)indexT {
    if (indexT == 1) {
        BOOL ishave = [self.subViewControllers containsObject:_quickLogVC];
        if (!ishave) {
            _quickLogVC = [[SIMQuickLoginViewController alloc] init];
            _quickLogVC.view.frame = CGRectMake(screen_width, 0, screen_width, _baseScrollView.frame.size.height);
            [self addChildViewController:_quickLogVC];
            [_baseScrollView addSubview:_quickLogVC.view];
            [self.subViewControllers addObject:_quickLogVC];
            
        }else {
            
        }
        
    }
}
- (void)addBottomViews {
    // 微信登录按钮
    _wechatBtn = [[UIButton alloc] init];
    [_wechatBtn addTarget:self action:@selector(threePlatClick:) forControlEvents:UIControlEventTouchUpInside];
    [_wechatBtn setImage:[UIImage imageNamed:@"微信登录"] forState:UIControlStateNormal];
    _wechatBtn.tag = 1001;
    [self.view addSubview:_wechatBtn];
    // QQ登录按钮
    _qqBtn = [[UIButton alloc] init];
    [_qqBtn setImage:[UIImage imageNamed:@"QQ登录"] forState:UIControlStateNormal];
    _qqBtn.tag = 1002;
    [_qqBtn addTarget:self action:@selector(threePlatClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_qqBtn];
    
    if([WXApi isWXAppInstalled] && [QQApiInterface isQQInstalled]) {
        [_wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-(isIPhoneXAll ? kWidthScale(60) + BottomSaveH : kWidthScale(60)));
            make.right.mas_equalTo(self.view.mas_centerX).offset(-20);
            make.size.mas_equalTo(kWidthScale(50));
        }];
        [_qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_centerX).offset(20);
            make.bottom.mas_equalTo(-(isIPhoneXAll ? kWidthScale(60) + BottomSaveH : kWidthScale(60)));
            make.size.mas_equalTo(kWidthScale(50));
        }];
    }else if ([WXApi isWXAppInstalled] && ![QQApiInterface isQQInstalled]) {
        [_wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-(isIPhoneXAll ? kWidthScale(60) + BottomSaveH : kWidthScale(60)));
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(kWidthScale(50));
        }];
    }else if (![WXApi isWXAppInstalled] && [QQApiInterface isQQInstalled]) {
        [_qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-(isIPhoneXAll ? kWidthScale(60) + BottomSaveH : kWidthScale(60)));
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(kWidthScale(50));
        }];
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
//- (void)getUserInfoResponse:(APIResponse *)response {
//    NSLog(@"QQjsonResponse %@",response.jsonResponse);
//}
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

