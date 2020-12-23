//
//  SIMReUserInfoViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/11/9.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMReUserInfoViewController.h"
#import "SIMBaseCommonTableViewCell.h"

@interface SIMReUserInfoViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    SIMBaseCommonTableViewCell* _nickNameCell;
    SIMBaseCommonTableViewCell * _compNameCell;
    SIMBaseCommonTableViewCell * _postCell;
    SIMBaseCommonTableViewCell * _countCell;
    
    UIBarButtonItem* _cancel;
    
    UIView* footerView;
    NSArray<NSArray<UITableViewCell*>*>* _cells;
}
@property (nonatomic, strong) UIButton *start;
@property (nonatomic,strong) SIMBaseTableView* tableView;
//@property(nonatomic, strong) SIMBaseCommonTableViewCell *explainCell;

@end

@implementation SIMReUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"SSettingInfo", nil);
    
    [self setUpCells];
    
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    [self.view addSubview:self.tableView];
    
    
    self.navigationItem.hidesBackButton = YES;
}
- (void)setUpCells
{
    _nickNameCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"SMineDataName", nil) leftputin:@""];
    _nickNameCell.putin.delegate = self;
    [_nickNameCell.putin addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
    _compNameCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"SSettingInfo_company", nil) leftputin:@""];
    _compNameCell.putin.delegate = self;
    [_compNameCell.putin addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _postCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"SSettingInfo_post", nil) leftputin:@""];
    _postCell.putin.delegate = self;
    [_postCell.putin addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _countCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"SSettingInfo_count", nil) leftputin:@""];
    _countCell.putin.delegate = self;
    _countCell.putin.keyboardType = UIKeyboardTypeNumberPad;
    [_countCell.putin addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
//    _explainCell = [[SIMBaseCommonTableViewCell alloc] initWithJSBTitleWithTextView:@"需求" withNumber:@"0/30"];
//    _explainCell.textView.delegate = self;
    
    _cells = @[@[_nickNameCell],@[_compNameCell,_postCell]];
}

#pragma mark - UITableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 250;
    }else {
        return CGFLOAT_MIN;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 250)];
        
        _start = [UIButton buttonWithType:UIButtonTypeCustom];
        [_start setTitle:SIMLocalizedString(@"AlertCSave", nil) forState:UIControlStateNormal];
        _start.titleLabel.font = FontRegularName(17);
        [_start setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _start.backgroundColor = BlueButtonColor;
        [_start setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_start setBackgroundImage:[UIImage imageWithColor:GrayPromptTextColor] forState:UIControlStateHighlighted];
        _start.layer.cornerRadius = 11;
        _start.layer.masksToBounds = YES;
        [footerView addSubview:self.start];
        [_start addTarget:self action:@selector(sendTheOtherInfo) forControlEvents:UIControlEventTouchUpInside];
    
        
        UILabel *labelOne = [[UILabel alloc] init];
        labelOne.textColor = BlueButtonColor;
        labelOne.textAlignment = NSTextAlignmentLeft;
        labelOne.text = SIMLocalizedString(@"SSettingInfo_TestOne", nil);
        labelOne.font = FontRegularName(15);
        labelOne.numberOfLines = 0;
        [footerView addSubview:labelOne];
        
        UILabel *labelTwo = [[UILabel alloc] init];
        labelTwo.textColor = TableViewHeaderColor;
        labelTwo.textAlignment = NSTextAlignmentLeft;
        labelTwo.text = SIMLocalizedString(@"SSettingInfo_TestTwo", nil);
        labelTwo.font = FontRegularName(12);
        labelTwo.numberOfLines = 0;
        [footerView addSubview:labelTwo];
        
        
        
        [_start mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(55);
            make.height.mas_equalTo(44);
        }];
        
        [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(_start.mas_bottom).offset(10);
        }];
        
        [labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(labelOne.mas_bottom).offset(5);
        }];
        
        
        return footerView;
    }else {
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cells.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cells[section].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cells[indexPath.section][indexPath.row];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)sendTheOtherInfo {
    if (_nickNameCell.putin.text.length <= 0) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"SSettingInfo_name", nil)];
        return ;
    }
    
    if (_compNameCell.putin.text.length <= 0) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"SSettingInfo_companyPlace", nil)];
        return ;
    }
    if (_postCell.putin.text.length <= 0) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"SSettingInfo_postPlace", nil)];
        return ;
    }
    
    [MBProgressHUD cc_showLoading:nil];
    // 将姓名传到服务器
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    [dicM setValue:_nickNameCell.putin.text forKey:@"nickname"];
    [dicM setObject:_postCell.putin.text forKey:@"position"];
    [dicM setObject:_compNameCell.putin.text forKey:@"company_name"];
    NSLog(@"infoPostiondicM%@",dicM);
    [MainNetworkRequest perfactUserInfoRequestParams:dicM success:^(id success) {
        NSLog(@"infoPostiondicMsuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
            
            // 重置本地的公司名字
            self.currentUser.currentCompany.company_name = _compNameCell.putin.text;
            self.currentCompany.company_name = _compNameCell.putin.text;
            self.currentUser.nickname = _nickNameCell.putin.text;
            self.currentUser.position = _postCell.putin.text;
            
            [self.currentCompany synchroinzeCurrentCompany];
            [self.currentUser synchroinzeCurrentUser];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ME_Setting_Fail", nil)];
        
    }];
    
}

#pragma mark - UITextFieldClick
- (void)textFieldDidChange:(UITextField *)textField
{
    [self subStringAllMethod:textField withLength:kMinLength];

    
}
#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    
//    if(textField == _nickNameCell.putin){
//        if ([self isInputRuleAndBlank:string] || [string isEqualToString:@""]) {//当输入符合规则和退格键时允许改变输入框
//            return YES;
//        } else {
//            return NO;
//        }
//    }
    return YES;
}


@end
