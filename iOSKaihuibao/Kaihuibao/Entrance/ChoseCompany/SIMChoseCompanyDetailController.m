//
//  SIMChoseCompanyDetailController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/4/9.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMChoseCompanyDetailController.h"
#import "SIMChoseCompany.h"

@interface SIMChoseCompanyDetailController ()
@property (nonatomic, strong) SIMChoseCompany *headerView;
@end

@implementation SIMChoseCompanyDetailController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:ZJYColorHex(@"#f4f3f3")]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addHeaderSubviews];
}
- (void)addHeaderSubviews {
    UIView *headerBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 210)];
    headerBack.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerBack];
    
    UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(20, 20, screen_width - 40, 170)];
    [headerBack addSubview:shadowView];
    shadowView.layer.shadowColor = GrayPromptTextColor.CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(2, 2);
    shadowView.layer.shadowOpacity = 0.3;
    shadowView.layer.shadowRadius = 5.0;
    shadowView.layer.cornerRadius = 5.0;
    shadowView.clipsToBounds = NO;
    
    _headerView = [[SIMChoseCompany alloc] initWithFrame:CGRectMake(0, 0, screen_width - 40, 170)];
    _headerView.companyModel = self.company;
    [shadowView addSubview:_headerView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 240, screen_width - 40, 44)];
    [button setTitle:SIMLocalizedString(@"CompanyChose_enter", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(enterTheCompanyBtn) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = FontRegularName(17);
    button.backgroundColor = BlueButtonColor;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 11;
    [self.view addSubview:button];
}
- (void)enterTheCompanyBtn {
    // 传给服务器一份切换公司的接口
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    [dicM setValue:@"2" forKeyPath:@"type"];
    [dicM setValue:self.company.company_id forKeyPath:@"company_id"];
    
    [MBProgressHUD cc_showLoading:nil];
    [MainNetworkRequest changeCompanyRequestParams:dicM success:^(id success) {
        if ([success[@"code"] integerValue] == successCodeOK) {
            NSLog(@"changeCompanySuccess %@",success);
            [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
            
            NSDictionary *dic = success[@"data"];
            
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
            
            
            
            // 将现有页面dismiss掉
            [self.navigationController dismissViewControllerAnimated:NO completion:^{
                // 跳转到主页面
                [windowRootViewController transitionToViewController:[[SIMTabBarViewController alloc] init] withAnmitionType:SIMTransitionTypePush];
//                windowRootViewController = [[SIMTabBarViewController alloc] init];
            }];
            
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
    
}


@end
