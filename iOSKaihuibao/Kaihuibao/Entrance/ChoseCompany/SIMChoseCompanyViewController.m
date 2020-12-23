//
//  SIMChoseCompanyViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/4/9.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMChoseCompanyViewController.h"
#import "SIMChoseCompanyDetailController.h"

@interface SIMChoseCompanyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger currentIndex;
}
@property (nonatomic, strong) SIMBaseTableView *tableView;
@end

@implementation SIMChoseCompanyViewController

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
    currentIndex = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addsubViews];
}

- (void)addsubViews {
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
}
#pragma mark - TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.companyList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 100;
    }else{
        return CGFLOAT_MIN;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backV = [[UIView alloc] init];
    backV.backgroundColor = [UIColor whiteColor];
    backV.frame = CGRectMake(0, 0, screen_width, 90);
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 0, screen_width, 90);
    label.font = FontRegularName(26);
    label.textColor = ZJYColorHex(@"#000000");
    label.text = SIMLocalizedString(@"CompanyChose_title", nil);
    [backV addSubview:label];
    return backV;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *backV = [[UIView alloc] init];
    backV.backgroundColor = [UIColor whiteColor];
    backV.frame = CGRectMake(0, 0, screen_width, 100);
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 40, screen_width - 40, 44)];
    [button setTitle:SIMLocalizedString(@"CompanyChose_enter", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(enterTheCompanyBtn) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = FontRegularName(17);
    button.backgroundColor = BlueButtonColor;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 11;
    [backV addSubview:button];
    return backV;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.textColor = ZJYColorHex(@"#000000");
    cell.textLabel.font = FontRegularName(19);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self.companyList[indexPath.row] company_name];
    return cell;
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    SIMChoseCompanyDetailController *detailVC = [[SIMChoseCompanyDetailController alloc] init];
//    detailVC.company = self.companyList[indexPath.row];
//    [self.navigationController pushViewController:detailVC animated:YES];
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    currentIndex = indexPath.row;
    [self.tableView reloadData];
}
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (currentIndex==indexPath.row) {
        return UITableViewCellAccessoryCheckmark;
    }else {
        return UITableViewCellAccessoryNone;
    }
}
- (void)enterTheCompanyBtn {
    // 传给服务器一份切换公司的接口
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    [dicM setValue:@"2" forKeyPath:@"type"];
    NSString *companyid = [self.companyList[currentIndex] company_id];
    [dicM setValue:companyid forKeyPath:@"company_id"];
    UIDevice *myDecive = [UIDevice currentDevice];
    [dicM setObject:myDecive.model forKey:@"loginEquipment"];
    
    [MBProgressHUD cc_showLoading:nil];
    [MainNetworkRequest changeCompanyRequestParams:dicM success:^(id success) {
        if ([success[@"code"] integerValue] == successCodeOK) {
            NSLog(@"changeCompanySuccess %@",success);
            dispatch_async(dispatch_get_main_queue(), ^{
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
//                            UIWindow *window = [UIApplication sharedApplication].keyWindow; //获得主窗口
//window.rootViewController = [[SIMTabBarViewController alloc] init];
            }];
        });
            
            
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
    
}

@end
