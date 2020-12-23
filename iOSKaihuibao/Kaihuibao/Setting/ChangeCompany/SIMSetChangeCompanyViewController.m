//
//  SIMSetChangeCompanyViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/4/9.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMSetChangeCompanyViewController.h"

@interface SIMSetChangeCompanyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger currentIndex;
}
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSMutableArray *listArr;

@end

@implementation SIMSetChangeCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"CompanyChose_change_title", nil);
    _listArr = [NSMutableArray array];
    [self searchTheCompanyListRequest];
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight =0;
    self.tableView.estimatedSectionHeaderHeight =0;
    self.tableView.estimatedSectionFooterHeight =0;
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"NavBackCancelTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    self.navigationItem.leftBarButtonItem = cancel;
    
}
- (void)cancelBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, screen_width - 30, 35)];
    label.text = SIMLocalizedString(@"CompanyChose_MineCompany", nil);
    label.textColor = TableViewHeaderColor;
    label.font = FontRegularName(13);
    [view addSubview:label];
    return view;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
    }
    cell.textLabel.font = FontRegularName(16);
    cell.textLabel.textColor = BlackTextColor;
    cell.textLabel.text = [_listArr[indexPath.row] company_name];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_listArr.count <= 1) {
        [self addActionSheetOneCompany];
    }else {
        currentIndex = indexPath.row;
        [self.tableView reloadData];
        [self addActionSheet:_listArr[currentIndex]];
    }
}
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (currentIndex==indexPath.row) {
        return UITableViewCellAccessoryCheckmark;
    }else {
        return UITableViewCellAccessoryNone;
    }
}
- (void)addActionSheet:(SIMCompany *)company {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:SIMLocalizedString(@"CompanyChose_enter", nil) message:company.company_name preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCOk", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self changeTheCompanyIDRequest:company];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:action];
    [alertC addAction:action3];
    [self presentViewController:alertC animated:YES completion:nil];
}
- (void)addActionSheetOneCompany {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:SIMLocalizedString(@"ChangeCompanyErrorTitle", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCKnow", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:action3];
    [self presentViewController:alertC animated:YES completion:nil];
}

// 查询公司列表的请求
- (void)searchTheCompanyListRequest {
    
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    [dicM setValue:@"1" forKeyPath:@"type"];
    
    [MBProgressHUD cc_showLoading:nil];
    [MainNetworkRequest changeCompanyRequestParams:dicM success:^(id success) {
        if ([success[@"code"] integerValue] == successCodeOK) {
            NSLog(@"searchCompanyListSuccess %@",success);
            [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
            
            for (NSDictionary *dic in success[@"data"]) {
                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
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
                [_listArr addObject:comp];
            }
            
            for (int i = 0; i < _listArr.count; i++) {
                if ([self.currentUser.currentCompany.company_id isEqualToString:[_listArr[i] company_id]]) {
                    currentIndex = i;
                }
            }
            
            [self.tableView reloadData];
            
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
    
}

- (void)changeTheCompanyIDRequest:(SIMCompany *)company {
    // 传给服务器一份切换公司的接口
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    [dicM setValue:@"2" forKeyPath:@"type"];
    [dicM setValue:company.company_id forKeyPath:@"company_id"];
    UIDevice *myDecive = [UIDevice currentDevice];
    [dicM setObject:myDecive.model forKey:@"loginEquipment"];
    
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
            
            NSLog(@"enterChangecompanycomcom %@ %@", self.currentUser.currentCompany.company_name, self.currentCompany.company_name);
            NSLog(@"enterChangeCompanycurrentUser:+++%@",self.currentUser);
            
            [self resetTabbarController];// 重新载入tabbar整个框架
            
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
    
}
// 重新载入tabbar整个框架 仿照企业微信直接选中tabbar第一个 同切换国际化语言的写法
- (void)resetTabbarController {
    [self.navigationController popToRootViewControllerAnimated:NO];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SIMTabBarViewController *tabVC = [[SIMTabBarViewController alloc] init];
    delegate.window.rootViewController = tabVC;
    tabVC.selectedIndex = 0;
}
@end
