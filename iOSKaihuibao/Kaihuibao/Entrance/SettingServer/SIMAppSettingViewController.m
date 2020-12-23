//
//  SIMAppSettingViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/9/25.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMAppSettingViewController.h"

#import "SIMBaseSwitchTableViewCell.h"
#import "SIMBaseCommonTableViewCell.h"

#import "SIMNetSettingViewController.h"
#import "SIMLanguageChooseViewController.h"
#import "SIMLocalListViewController.h"

@interface SIMAppSettingViewController ()<UITableViewDelegate,UITableViewDataSource,SIMLocalListDelegate>
{
    SIMBaseCommonTableViewCell* _languageCell;
//    SIMBaseSwitchTableViewCell* _localCell;
    SIMBaseSwitchTableViewCell* _overseaCell;
    SIMBaseCommonTableViewCell* _changeCell;
    SIMBaseCommonTableViewCell* _vesionCell;
    SIMBaseCommonTableViewCell *_repeatCell;
    
    NSArray *_cells;
    
}
@property (strong,nonatomic) NSString *httpStr;
@property (strong,nonatomic) NSString *hostStr;
@property (strong,nonatomic) NSString *portStr;
@property (nonatomic,strong) SIMBaseTableView* tableView;
@property (nonatomic,strong) NSArray *repeatArr;
@property (nonatomic,assign) BOOL ispop;

@end

@implementation SIMAppSettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = SIMLocalizedString(@"AlertCSet", nil);
    _repeatArr = @[@"中国",@"中国（香港）"];
    [self setUpCells];
    
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    [self.view addSubview:self.tableView];

    // 取消按钮及响应方法
    UIBarButtonItem* cancel = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"AlertCBack", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    cancel.tintColor = BlueButtonColor;
    self.navigationItem.leftBarButtonItem = cancel;
}
- (void)cancelBtnClick {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"NEWHttpNetString"] == nil || [[NSUserDefaults standardUserDefaults] objectForKey:@"NEWHostNetString"] == nil) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"您尚未设置服务器" message:@"请点击设置Local Server设置您的服务器" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCKnow", nil) style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertC animated:YES completion:nil];
    }else {
        if (self.ispop) {
            [self searchISPrivateMethod];
        }else {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }   
    }
}
- (void)setUpCells
{
    _languageCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"AppAllSetLanguage", nil) prompt:@""];
    
//    _localCell = [[SIMBaseSwitchTableViewCell alloc] init];
//    _localCell.titleLab.text = SIMLocalizedString(@"AppAllSetLocalServer", nil);
//    _localCell.switchButton.on = YES;
    
    // 打开用的是国际服务器 关闭是大陆服务器
    _overseaCell = [[SIMBaseSwitchTableViewCell alloc] init];
    _overseaCell.titleLab.text = SIMLocalizedString(@"AppAllSetOverseaServer", nil);
    BOOL isClose = [[NSUserDefaults standardUserDefaults] boolForKey:@"isChangeServerSwitchClose"];
    
    NSLog(@"isCloseisClose %d",isClose);
    _overseaCell.switchButton.on = !isClose;
    // 当控件值变化时触发changeColor方法
    [_overseaCell.switchButton addTarget:self action:@selector(changeOverseaServer:) forControlEvents:UIControlEventValueChanged];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"NEWServerText"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:_repeatArr[0] forKey:@"NEWServerText"]; // 这个是选择的国家文字
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSString *countryStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"NEWServerText"]; // 这个是选择的国家文字
    
    _repeatCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"AppAllSetLocation", nil) prompt:countryStr];
    
    _changeCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"AppAllSetServer", nil) prompt:@""];
    
    // 获取版本号
    _vesionCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"SShowAppVersion", nil) prompt:[NSString stringWithFormat:@"%@(%@)",getApp_Version,getApp_ownVersion]];
    _vesionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _vesionCell.accessoryType = UITableViewCellAccessoryNone;

    if (!isClose) {
        // 如果开关是yes
        _repeatCell.userInteractionEnabled = YES;
        _repeatCell.label.textColor = BlackTextColor;
        _changeCell.userInteractionEnabled = NO;
        _changeCell.label.textColor = GrayPromptTextColor;
    }else {
        _repeatCell.userInteractionEnabled = NO;
        _repeatCell.label.textColor = GrayPromptTextColor;
        _changeCell.userInteractionEnabled = YES;
        _changeCell.label.textColor = BlackTextColor;
    }
    if ([self.cloudVersion.many_languages boolValue]) {
        _cells = @[@[_languageCell],@[_overseaCell],@[_changeCell],@[_vesionCell]];
    }else {
        _cells = @[@[],@[_overseaCell],@[_changeCell],@[_vesionCell]];
    }
    
}
- (void)changeOverseaServer:(UISwitch *)sender {
    _ispop = YES;
    if(sender.isOn){
        // 如果开关打开 则为海外服务器 并且不可以修改服务器置灰不可以点击
        _repeatCell.userInteractionEnabled = YES;
        _repeatCell.label.textColor = BlackTextColor;
        _changeCell.userInteractionEnabled = NO;
        _changeCell.label.textColor = GrayPromptTextColor;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isChangeServerSwitchClose"];// 反向存 为了初始值时候 是yes
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSString *countryStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"NEWServerText"]; // 这个是选择的国家文字
        if ([_repeatArr indexOfObject:countryStr] == 0) {
            // 恢复默认值 并且存到本地
            self.httpStr = DefaultApiBaseHttp;
            self.hostStr = DefaultApiBaseHost;
            self.portStr = DefaultApiBasePort;
        }else {
            // 点击修改按钮
            self.httpStr = DefaultApiBaseHttp;
            self.hostStr = HKApiBaseHost;
            self.portStr = DefaultApiBasePort;
        }
        [[NSUserDefaults standardUserDefaults] setObject:self.httpStr forKey:@"NEWHttpNetString"];
        [[NSUserDefaults standardUserDefaults] setObject:self.hostStr forKey:@"NEWHostNetString"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",self.portStr] forKey:@"NEWPortNetString"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"resultisChangeTheServerChangeLoaction %@",kApiBaseUrl);
    }else{
        // 恢复默认值 并且存到本地 如果开关关闭 则为大陆服务器
        _repeatCell.userInteractionEnabled = NO;
        _repeatCell.label.textColor = GrayPromptTextColor;
        _changeCell.userInteractionEnabled = YES;
        _changeCell.label.textColor = BlackTextColor;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NEWHttpNetString"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NEWHostNetString"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NEWPortNetString"];
//        self.httpStr = DefaultApiBaseHttp;
//        self.hostStr = DefaultApiBaseHost;
//        self.portStr = DefaultApiBasePort;
//        //    [self.tableView reloadData];
//        [[NSUserDefaults standardUserDefaults] setObject:self.httpStr forKey:@"NEWHttpNetString"];
//        [[NSUserDefaults standardUserDefaults] setObject:self.hostStr forKey:@"NEWHostNetString"];
//        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",self.portStr] forKey:@"NEWPortNetString"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isChangeServerSwitchClose"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"resultisChangeTheServerChangeLoaction %@",kApiBaseUrl);
        
    }
//    BOOL isClose = [[NSUserDefaults standardUserDefaults] boolForKey:@"isChangeServerSwitchClose"];
//    NSLog(@"isCloseisClose %d",isClose);
}
#pragma mark - UITableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cells.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cells[section] count];;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }else {
        return 0.001;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cells[indexPath.section][indexPath.row];;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        // 多语言环境
        SIMLanguageChooseViewController *langVC = [[SIMLanguageChooseViewController alloc] init];
        langVC.pageType = @"unlog";
        [self.navigationController pushViewController:langVC animated:YES];
    }
//    if (indexPath.section == 2) {
//        SIMLocalListViewController *repeatVC = [[SIMLocalListViewController alloc] init];
//        repeatVC.delegate = self;// 遵守代理 重复页面传值
//        repeatVC.arr = _repeatArr;
//        NSString *tagStr = _repeatCell.promptLabel.text;
//        repeatVC.index = [_repeatArr indexOfObject:tagStr];
//        [self.navigationController pushViewController:repeatVC animated:YES];
//        _ispop = YES;
//    }
    if (indexPath.section == 2) {
        // 修改服务器
        SIMNetSettingViewController *netVC = [[SIMNetSettingViewController alloc] init];
        [self.navigationController pushViewController:netVC animated:YES];
        _ispop = YES;
    }
}

- (void)countryString:(NSString *)textStr index:(NSInteger)indexTag{
    _repeatCell.promptLabel.text = textStr;
    if (indexTag == 0) {
        // 恢复默认值 并且存到本地
        self.httpStr = DefaultApiBaseHttp;
        self.hostStr = DefaultApiBaseHost;
        self.portStr = DefaultApiBasePort;
    }else {
        // 点击修改按钮
        self.httpStr = DefaultApiBaseHttp;
        self.hostStr = HKApiBaseHost;
        self.portStr = DefaultApiBasePort;
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.httpStr forKey:@"NEWHttpNetString"];
    [[NSUserDefaults standardUserDefaults] setObject:self.hostStr forKey:@"NEWHostNetString"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",self.portStr] forKey:@"NEWPortNetString"];
    [[NSUserDefaults standardUserDefaults] setObject:textStr forKey:@"NEWServerText"]; // 这个是选择的国家文字
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"resultisChangeTheServerChangeLoaction %@",kApiBaseUrl);
}

// 如果是改了服务器地址 那么要重新查询这个是公有云还是私有云
- (void)searchISPrivateMethod {
    [MBProgressHUD cc_showLoading:nil];
    [MainNetworkRequest searchIsPrivateRequestParams:nil success:^(id success) {
        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
        // 成功
        if ([success[@"code"] integerValue] == successCodeOK) {
//            [MBProgressHUD cc_showText:SIMLocalizedString(@"ServceSettingSuccess", nil)];
//            NSLog(@"searchIsPrivateSuccess  %@",success);
            NSDictionary *dic = success[@"data"];
            NSString *version = dic[@"version"];
            NSMutableDictionary *dicMM = [[NSMutableDictionary alloc] initWithDictionary:dic[@"switches"]];
            NSDictionary *adressdic = dic[@"switches"][@"addressbook_show"];
            NSDictionary *invitationdic = dic[@"switches"][@"invitation"];
            [dicMM addEntriesFromDictionary:adressdic];
            [dicMM addEntriesFromDictionary:invitationdic];
            if (dic[@"confModeSwitches"] != nil) {
                [dicMM addEntriesFromDictionary:dic[@"confModeSwitches"]];
            }
            
            for (int i =0; i<dicMM.count; i++) {
                if ([[dicMM objectForKey:dicMM.allKeys[i]] isKindOfClass:[NSNumber class]]) {
                    NSString *key = dicMM.allKeys[i];
                    NSNumber *longn = [NSNumber numberWithLong:[[dicMM objectForKey:key] longValue]];
                    NSString *longss = [longn stringValue];
                    [dicMM removeObjectForKey:key];
                    [dicMM setObject:longss forKey:key];
                }
            }
            [dicMM setObject:version forKey:@"version"];
            if (dic[@"webFileUrl"] != nil) {
                [dicMM setObject:dic[@"webFileUrl"] forKey:@"webFileUrl"];
            }else {
                [dicMM setObject:@"" forKey:@"webFileUrl"];
            }
            if ([dic[@"switches"][@"shareDocument"] boolValue] == NO) {
                [dicMM setObject:@"" forKey:@"webFileUrl"];
            }
            SIMCloudVersion *cloudVersion = [[SIMCloudVersion alloc] initWithDictionary:dicMM];
            self.cloudVersion = cloudVersion;
            [self.cloudVersion synchroinzeCloudVersion];
            NSLog(@"self.cloudVersion %@",self.cloudVersion);
            if ([self.cloudVersion.cloud_server boolValue]) {
                // 此参数为yes 公有界面展示两个选择服务器 为no只展示填写服务器页面
                NSArray *repeatArr = @[@"中国",@"中国（香港）"];
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"NEWHostNetString"] isEqualToString:DefaultApiBaseHost]) {
                    // 是默认的地址
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isChangeServerSwitchClose"];
                    [[NSUserDefaults standardUserDefaults] setObject:repeatArr[0] forKey:@"NEWServerText"]; // 这个是选择的国家文字
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"NEWHostNetString"] isEqualToString:HKApiBaseHost]) {
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isChangeServerSwitchClose"];
                    [[NSUserDefaults standardUserDefaults] setObject:repeatArr[1] forKey:@"NEWServerText"]; // 这个是选择的国家文字
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }else {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isChangeServerSwitchClose"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }else {
                // 私有
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isChangeServerSwitchClose"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            if (self.refreshClick) {
                self.refreshClick();
            }
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}

@end
