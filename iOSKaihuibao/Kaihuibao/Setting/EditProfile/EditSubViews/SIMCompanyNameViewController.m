//
//  SIMCompanyNameViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/11/6.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMCompanyNameViewController.h"
#import "SIMBaseInputTableViewCell.h"

@interface SIMCompanyNameViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    SIMBaseInputTableViewCell* _nickNameCell;
    UIBarButtonItem* _save;
}
@property (nonatomic,strong) SIMBaseTableView* tableView;
@property (nonatomic,assign) BOOL saveBtnOnce; // 防止按钮多次被点击的约束值

@end

@implementation SIMCompanyNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"SMineDataCompany", nil);
    _saveBtnOnce = YES;
    
    [self setUpCells];
    
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    [self.view addSubview:self.tableView];
    self.tableView.scrollEnabled = NO;
    

    _save = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"NavBackSave", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
    self.navigationItem.rightBarButtonItem = _save;
}
- (void)saveBtnClick {
    if (self.saveBtnOnce == YES) {
        self.saveBtnOnce = NO;
        [self sendTheCompanyData];
    }
}
- (void)setUpCells
{
    _nickNameCell = [[SIMBaseInputTableViewCell alloc] init];
    _nickNameCell.textfield.textAlignment = NSTextAlignmentLeft;
    _nickNameCell.placeHolderStr = SIMLocalizedString(@"SCompanyNoEmptyPlaceHolder", nil);
    _nickNameCell.textfield.text =   self.currentUser.currentCompany.company_name;
    _nickNameCell.textfield.font = FontRegularName(16);
    _nickNameCell.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nickNameCell.textfield.delegate = self;
    _nickNameCell.textfield.keyboardType = UIKeyboardTypeDefault;
    [_nickNameCell.textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}


#pragma mark - UITableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _nickNameCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)sendTheCompanyData {
    [MBProgressHUD cc_showLoading:nil];
    // 将姓名传到服务器
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    [dicM setObject:@"2" forKey:@"type"];
    [dicM setObject:_nickNameCell.textfield.text forKey:@"company_name"];
    NSLog(@"companyNameDicM%@",dicM);
    [MainNetworkRequest setInfoRequestParams:dicM success:^(id success) {
        
        if ([success[@"code"] integerValue] == successCodeOK) {
            [MBProgressHUD cc_showSuccess:success[@"msg"]];
            // 重置本地的公司名字
            self.currentUser.currentCompany.company_name = _nickNameCell.textfield.text;
            self.currentCompany.company_name = _nickNameCell.textfield.text;
            [self.currentCompany synchroinzeCurrentCompany];
            [self.currentUser synchroinzeCurrentUser];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
        _saveBtnOnce = YES;
    } failure:^(id failure) {
        NSError *error = failure;
        // 取消网络用 如果是取消了 不提示失败的弹框
        if (error.code == -999) {
            [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
        }else {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"ME_Setting_Fail", nil)];
        }
        _saveBtnOnce = YES;
    }];
}


#pragma mark - UITextFieldClick
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _nickNameCell.textfield) {
        if (textField.text.length <= 0) {
            _save.enabled = NO;
        }else {
            _save.enabled = YES;
        }
        [self subStringAllMethod:textField withLength:kMinLength];
    }
    
}
#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    
//    if(textField == _nickNameCell.textfield){
//        if ([self isInputRuleAndBlank:string] || [string isEqualToString:@""]) {//当输入符合规则和退格键时允许改变输入框
//            return YES;
//        } else {
//            return NO;
//        }
//    }
    return YES;
}




@end
