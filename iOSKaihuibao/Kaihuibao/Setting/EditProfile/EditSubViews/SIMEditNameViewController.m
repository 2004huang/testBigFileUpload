//
//  SIMEditNameViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/6/1.
//  Copyright © 2017年 Ferris. All rights reserved.
//


#import "SIMEditNameViewController.h"
#import "SIMBaseInputTableViewCell.h"

@interface SIMEditNameViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    SIMBaseInputTableViewCell* _nickNameCell;
    UIBarButtonItem* _save;
}
@property (nonatomic,strong) SIMBaseTableView* tableView;
@property (nonatomic,assign) BOOL saveBtnOnce;
@end

@implementation SIMEditNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"SMineScreenName", nil);
    _saveBtnOnce = YES;
    
    [self setUpCells];
    
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    [self.view addSubview:self.tableView];
    self.tableView.scrollEnabled = NO;
    
    
    _save = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"NavBackSave", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
    _save.enabled = NO;
    self.navigationItem.rightBarButtonItem = _save;
   
}
- (void)saveBtnClick {
    if (self.saveBtnOnce == YES) {
        self.saveBtnOnce = NO;
        [self requestTheData];
    }
}
- (void)setUpCells
{
    _nickNameCell = [[SIMBaseInputTableViewCell alloc] init];
    _nickNameCell.textfield.textAlignment = NSTextAlignmentLeft;
    _nickNameCell.placeHolderStr = SIMLocalizedString(@"SNameNoEmptyPlaceHolder", nil);
    _nickNameCell.textfield.text = self.currentUser.nickname;
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
- (void)requestTheData {
    [MBProgressHUD cc_showLoading:nil];
        // 将姓名传到服务器
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    [dicM setObject:_nickNameCell.textfield.text forKey:@"nickname"];
    [dicM setObject:@"1" forKey:@"type"];
    [MainNetworkRequest setInfoRequestParams:dicM success:^(id success) {
        if ([success[@"code"] integerValue] == successCodeOK) {
            // 将正在加载框隐藏
            [MBProgressHUD cc_showSuccess:success[@"msg"]];
            // 重置本地的昵称名字
            self.currentUser.nickname = _nickNameCell.textfield.text;
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
            [MBProgressHUD cc_showText:SIMLocalizedString(@"ME_Setting_Fail", nil) ];
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

////  返回页面取消post
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [MainNetworkRequest cancelAllRequest];
//}

@end
