//
//  SIMPassWViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/6/1.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMPassWViewController.h"
#import "SIMBaseInputTableViewCell.h"
@interface SIMPassWViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    SIMBaseInputTableViewCell* _oldCell;
    SIMBaseInputTableViewCell* _newCell;
    SIMBaseInputTableViewCell* _repeatCell;
    NSArray<NSArray<UITableViewCell*>*>* _cells;
//    BOOL saveBtnOnce;
}
@property (nonatomic,strong) SIMBaseTableView* tableView;
@property (nonatomic,assign) BOOL saveBtnOnce;
@end

@implementation SIMPassWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"SChangePSW", nil);
    _saveBtnOnce = YES;
    
     [self setUpCells];
    
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    [self.view addSubview:self.tableView];
    self.tableView.scrollEnabled = NO;
   
    UIBarButtonItem* save = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"NavBackSave", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
    self.navigationItem.rightBarButtonItem = save;
}
- (void)saveBtnClick {
    if (self.saveBtnOnce == YES) {
        self.saveBtnOnce = NO;
        [self requestTheData];
    }
}
- (void)setUpCells
{
    _oldCell = [[SIMBaseInputTableViewCell alloc] init];
    _oldCell.placeHolderStr = SIMLocalizedString(@"SChangePSW_OldPH", nil);
    _oldCell.textfield.secureTextEntry = YES;
    _oldCell.textfield.textAlignment = NSTextAlignmentLeft;
    _oldCell.textfield.font = FontRegularName(16);
    _oldCell.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _newCell = [[SIMBaseInputTableViewCell alloc] init];
    _newCell.placeHolderStr = SIMLocalizedString(@"SChangePSW_NewPH", nil);
    _newCell.textfield.secureTextEntry = YES;
    _newCell.textfield.textAlignment = NSTextAlignmentLeft;
    _newCell.textfield.font = FontRegularName(16);
    _newCell.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _repeatCell = [[SIMBaseInputTableViewCell alloc] init];
    _repeatCell.placeHolderStr = SIMLocalizedString(@"KHBPSWRightPlaceHolder", nil);
    _repeatCell.textfield.secureTextEntry = YES;
    _repeatCell.textfield.textAlignment = NSTextAlignmentLeft;
    _repeatCell.textfield.font = FontRegularName(16);
    _repeatCell.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _oldCell.textfield.keyboardType = UIKeyboardTypeDefault;
    _oldCell.textfield.delegate = self;
    [_oldCell.textfield addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    _newCell.textfield.keyboardType = UIKeyboardTypeDefault;
    _newCell.textfield.delegate = self;
    [_newCell.textfield addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    _repeatCell.textfield.keyboardType = UIKeyboardTypeDefault;
    _repeatCell.textfield.delegate = self;
    [_repeatCell.textfield addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    _cells = @[@[_oldCell,_newCell,_repeatCell]];
    
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
    return [_cells[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cells[indexPath.section][indexPath.row];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)requestTheData {
    // 正在加载框
    [MBProgressHUD cc_showLoading:nil];
    if (_newCell.textfield.text.length < 6) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_six_psw", nil)];
        _saveBtnOnce = YES;
        return;
    }
    if (_repeatCell.textfield.text.length == 0) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_re_psw", nil)];
        _saveBtnOnce = YES;
        return;
    }else {
        if (![_newCell.textfield.text isEqualToString:_repeatCell.textfield.text]) {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_twowrong_psw", nil) ];
            _saveBtnOnce = YES;
            return;
        }
    }
    if ([_newCell.textfield.text checkIsHaveNumAndLetter]==4)
    {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_kind_psw", nil)];
        _saveBtnOnce = YES;
        return;
    }
    if (_newCell.textfield.text.length >18) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"KHBPSWLengthPlaceHolder", nil)];
        _saveBtnOnce = YES;
        return;
    }
    
    // 改的密码上传
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    [dicM setObject:@"3" forKey:@"type"];
    [dicM setObject:_oldCell.textfield.text forKey:@"old_password"];
    [dicM setObject:_newCell.textfield.text forKey:@"new_password"];
    [dicM setObject:_repeatCell.textfield.text forKey:@"confirm_password"];
    
    [MainNetworkRequest setInfoRequestParams:dicM success:^(id success) {
        NSLog(@"success %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [MBProgressHUD cc_showSuccess:success[@"msg"]];
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
#pragma mark -- UITextFieldDelegate
// 随输入文字动态判断
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 过滤空格
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}
- (void)textFieldDidChanged:(UITextField *)textField
{
    [self subStringAllMethod:textField withLength:18];
}
@end
