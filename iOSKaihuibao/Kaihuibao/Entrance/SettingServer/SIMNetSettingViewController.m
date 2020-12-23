//
//  SIMNetSettingViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/8/25.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMNetSettingViewController.h"
#import "SIMBaseCommonTableViewCell.h"
#import "JJOptionView.h"
#import "SIMAddMember.h"
@interface SIMNetSettingViewController ()<UITableViewDelegate,UITableViewDataSource,JJOptionViewDelegate>
@property (strong,nonatomic) SIMBaseTableView* tableView;// 基础表格
@property (strong,nonatomic) SIMBaseCommonTableViewCell* hostCell;
@property (strong,nonatomic) SIMBaseCommonTableViewCell* portCell;
@property (strong,nonatomic) NSString *httpStr;
@property (strong,nonatomic) NSString *hostStr;
@property (strong,nonatomic) NSString *portStr;
@property (strong,nonatomic) NSArray *httpArr;
@property (strong,nonatomic) JJOptionView *optionView;
@end

@implementation SIMNetSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"KHBSettingService", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    SIMAddMember *adressOne = [[SIMAddMember alloc] initWithDictionary:@{@"id":@"1",@"name":@"http"}];
    SIMAddMember *adressTwo = [[SIMAddMember alloc] initWithDictionary:@{@"id":@"2",@"name":@"https"}];
    _httpArr = @[adressOne,adressTwo];
    
    // 设置默认值 如果当前未点击修改 仍是这个值
    _httpStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"NEWHttpNetString"];
    if (_httpStr == nil) {
        _httpStr = [_httpArr[0] name];
    }
    
    _hostStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"NEWHostNetString"];
    NSString *pro = [[NSUserDefaults standardUserDefaults] objectForKey:@"NEWPortNetString"];
    
    if (pro == nil ||pro.length==0) {
        _portStr = pro;
    }else {
        _portStr = [pro substringFromIndex:1];
    }
    
    // 取消按钮及响应方法
    UIBarButtonItem* cancel = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"AlertCBack", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    cancel.tintColor = BlueButtonColor;
    self.navigationItem.leftBarButtonItem = cancel;
    
    // 如果是私有云 加一个恢复默认服务器
    if (![self.cloudVersion.cloud_server boolValue]) {
        UIBarButtonItem* defaultBtn = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"KHBReDefaultSer", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnClick)];
        defaultBtn.tintColor = BlueButtonColor;
        self.navigationItem.rightBarButtonItem = defaultBtn;
    }
    
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    
}
- (void)doneBtnClick {
    // 恢复默认值 并且存到本地
    self.httpStr = DefaultApiBaseHttp;
    self.hostStr = DefaultApiBaseHost;
    self.portStr = DefaultApiBasePort;
    [self.tableView reloadData];
    [[NSUserDefaults standardUserDefaults] setObject:self.httpStr forKey:@"NEWHttpNetString"];
    [[NSUserDefaults standardUserDefaults] setObject:self.hostStr forKey:@"NEWHostNetString"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",self.portStr] forKey:@"NEWPortNetString"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"resultisChangeTheServer2 %@ %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"NEWHostNetString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"NEWHttpNetString"]);
    
}
- (void)cancelBtnClick {
    if ([self.cloudVersion.cloud_server boolValue]) {
        // 公有云直接返回
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        // 私有云如果不输入服务器给提示
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"NEWHttpNetString"] == nil || [[NSUserDefaults standardUserDefaults] objectForKey:@"NEWHostNetString"] == nil) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"您尚未设置服务器" message:@"请点击设置Local Server设置您的服务器" preferredStyle:UIAlertControllerStyleAlert];
            [alertC addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCKnow", nil) style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertC animated:YES completion:nil];
        }else {
            // 私有云输入服务器那么重新查询公私有开关
            [self searchISPrivateMethod];
        }
        
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 50)];
    _optionView = [[JJOptionView alloc] initWithFrame:CGRectMake(kWidthScale(20), 10, kWidthScale(80), 30)];
    _optionView.title = _httpStr;
    _optionView.isMoreChoose = NO;
    _optionView.dataSource = _httpArr;
    _optionView.delegate = self;
    [backView addSubview:_optionView];
    return backView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 125;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *backV = [[UIView alloc] init];
    backV.backgroundColor = TableViewBackgroundColor;
    backV.frame = CGRectMake(0, 0, screen_width, 125);
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.frame = CGRectMake(15, 0, screen_width-30, 60);
    label.font = FontRegularName(14);
    label.textColor = GrayPromptTextColor;
    [backV addSubview:label];
    label.text = SIMLocalizedString(@"KHBReDefaultSerExplain", nil);
    
    UIButton* alterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    alterButton.backgroundColor = BlueButtonColor;
    alterButton.titleLabel.font = FontRegularName(18);
    [alterButton setTitle:SIMLocalizedString(@"KHBAlterBtn", nil) forState:UIControlStateNormal];
    [alterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [alterButton setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    [alterButton setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    alterButton.layer.masksToBounds = YES;
    alterButton.layer.cornerRadius = 45/4;
    [alterButton addTarget:self action:@selector(alterTheServer) forControlEvents:UIControlEventTouchUpInside];
    [backV addSubview:alterButton];
    
    [alterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).offset(kWidthScale(10));
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
    }];
    
    return backV;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0) {
        _hostCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"KHBPutinAdress", nil) leftputin:_hostStr];
        _hostCell.putin.placeholder = @"";
        return _hostCell;
    }else if(indexPath.row == 1) {
        _portCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"KHBPutinPort", nil) leftputin:_portStr];
        _portCell.putin.placeholder = @"";
        return _portCell;
    }else {
        return nil;
    }
}

- (void)alterTheServer {
    if (_hostCell.putin.text.length == 0) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_WRONG_AdressAndPort", nil)];
    }else if (![self regexMatchWithStr:_hostCell.putin.text regex:@"[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]"]) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_WRONG_AdressAndPort", nil)];
    }else if ([_portCell.putin.text integerValue]>65535) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_WRONG_AdressAndPort", nil)];
    }else if ([_portCell.putin.text integerValue] < 1 && _portCell.putin.text.length != 0) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_WRONG_AdressAndPort", nil)];
    }else {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_repsw_success", nil)];
        // 点击修改按钮
        _hostStr = _hostCell.putin.text;
        _portStr = _portCell.putin.text;
//        [self.tableView reloadData];
        // 将用户更改的地址 存到本地
        [[NSUserDefaults standardUserDefaults] setObject:_httpStr forKey:@"NEWHttpNetString"];
        [[NSUserDefaults standardUserDefaults] setObject:_hostStr forKey:@"NEWHostNetString"];
        if (_portStr == nil || _portStr.length==0) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",_portStr] forKey:@"NEWPortNetString"];
        }else {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@":%@",_portStr] forKey:@"NEWPortNetString"];
        }
        NSLog(@"_httpStr_httpStrkApiBaseUrl  %@",kApiBaseUrl);
        [[NSUserDefaults standardUserDefaults] synchronize];
        if ([self.cloudVersion.cloud_server boolValue]) {
            // 公有云直接返回
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            // 私有云如果不输入服务器给提示
            [self searchISPrivateMethod];
        }
    }
}

// 正则谓词
-(BOOL)regexMatchWithStr:(NSString *)str regex:(NSString *)regex{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:str];
}
- (void)optionView:(JJOptionView *)optionView selectedIndex:(NSInteger)selectedIndex {
    NSLog(@"optionView %@",optionView);
    _httpStr = [_httpArr[selectedIndex] name];
    NSLog(@"selectedIndex %ld %@",selectedIndex,_httpStr);
}

- (void)searchISPrivateMethod {
    [MBProgressHUD cc_showLoading:nil];
    [MainNetworkRequest searchIsPrivateRequestParams:nil success:^(id success) {
        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
        // 成功
        if ([success[@"code"] integerValue] == successCodeOK) {
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
            NSLog(@"self.cloudVersionprivate %@",self.cloudVersion);
            
            if ([self.cloudVersion.cloud_server boolValue]) {
                // 公有界面
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
