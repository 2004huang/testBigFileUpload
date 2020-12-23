//
//  SIMAccountCompanyViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/10/19.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMAccountCompanyViewController.h"
#import "SIMBaseCommonTableViewCell.h"
#import "SIMJPickerView.h"
#import "SIMAddMember.h"
#import "SIMAddChooseDepartViewController.h"
typedef NS_ENUM(NSInteger, MyButtonType) {
    MyButtonTypeSave = 1001,
    MyButtonTypeSaveOneMore,
};

@interface SIMAccountCompanyViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,JJOptionViewDelegate,AddChooseDepartDelegate>
{
    SIMBaseCommonTableViewCell * _nickNameCell;
    SIMBaseCommonTableViewCell * _phoneCell;
    SIMBaseCommonTableViewCell * _companyCell;
//    SIMBaseCommonTableViewCell * _roleCell;
    SIMBaseCommonTableViewCell * _departmentCell;
//    SIMBaseCommonTableViewCell * _passWordCell;
//    SIMBaseCommonTableViewCell * _emailCell;
    SIMBaseCommonTableViewCell * _introductCell;
//    SIMBaseCommonTableViewCell *_sendMessCell;
    BOOL i;
    
    
//    NSString *sss;
//    BOOL isScroll;
//    UIPickerView *pickerView;
//    UIView *_backView;
//    UIToolbar *pickerDateToolbar;
    UIBarButtonItem* done;
    
    NSArray<NSArray<UITableViewCell*>*>* _cells;
}
@property (strong,nonatomic) SIMBaseTableView* tableView;
@property (nonatomic, strong) UIButton *gotoBuy;
@property (strong,nonatomic) NSMutableArray *roleArray;
@property (strong,nonatomic) NSMutableArray *departArr;
@property (strong,nonatomic) NSMutableArray *choseArr;
@property (strong,nonatomic) NSMutableArray *listAry;
//@property (nonatomic, strong) UIButton *start;
//@property (nonatomic, strong) UIButton *inAdd;
//@property (nonatomic, strong) UIView* footerView;
@property(nonatomic, strong) SIMJPickerView *pickerView;
@property(nonatomic, assign) NSInteger ind;
@property (strong,nonatomic) NSString *rolePid;
@property (strong,nonatomic) NSString *departPid;
@property(nonatomic, strong) SIMBaseCommonTableViewCell *roleCell;

@end


@implementation SIMAccountCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"CCAddTheMemberTitle", nil);
    i = YES;
    _roleArray = [NSMutableArray array];
    _departArr = [NSMutableArray array];
    _choseArr = [NSMutableArray array];
    _listAry = [NSMutableArray array];
//    listAry = @[SIMLocalizedString(@"CCMemberAddPage_boy", nil),SIMLocalizedString(@"CCMemberAddPage_girl", nil)];
//    [self setUpCells];
    [self getAllArrayDatas];
    [self addUISubviews];
    
    UIBarButtonItem* cancel = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"NavBackCancelTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    self.navigationItem.leftBarButtonItem = cancel;
    
    done = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"NavBackSave", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
    self.navigationItem.rightBarButtonItem = done;
}
- (void)cancelBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)saveBtnClick {
    // 弹出提示框
    [self addAlertViewControllerBottom];
}
- (void)addUISubviews {
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    [self.view addSubview:self.tableView];
    
//    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, screen_height - BottomSaveH - 80, screen_width, 80)];
//    [self.view addSubview:footerView];
//    _gotoBuy = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, screen_width - 30, 45)];
//    [_gotoBuy setTitle:SIMLocalizedString(@"AlertCSaveAndAdd", nil) forState:UIControlStateNormal];
//    [_gotoBuy setBackgroundColor:BlueButtonColor];
//    [_gotoBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_gotoBuy setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
//    [_gotoBuy setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
//    _gotoBuy.titleLabel.font = FontRegularName(17);
//    _gotoBuy.layer.masksToBounds = YES;
//    _gotoBuy.layer.cornerRadius = 8;
//    [_gotoBuy addTarget:self action:@selector(startBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [footerView addSubview:_gotoBuy];
}
- (void)setUpCells
{
   
    _nickNameCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"SMineDataName", nil) leftputin:@""];
    _nickNameCell.putin.delegate = self;
    [_nickNameCell.putin addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    if ([self.cloudVersion.username_type isEqualToString:@"string"]) {
        _phoneCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"KHBAccount", nil) leftputin:@""];
    }else {
        _phoneCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"CCMemberAddPage_phone", nil) leftputin:@""];
        _phoneCell.putin.keyboardType = UIKeyboardTypeNumberPad;
        _phoneCell.putin.delegate = self;
        [_phoneCell.putin addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    _companyCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"ChangeCompanyTitle", nil) leftputin:@""];
//    _roleCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:@"角色" isChooseMore:NO optionViewArr:_roleArray viewController:self];
    _roleCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"CCOwenMess_Role", nil) prompt:@""];
//    for (SIMAddMember *mem in _departArr) {
//        NSLog(@"mem.isSelect22 %d",mem.isSelect);
//    }
//    _departmentCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:@"部门" isChooseMore:YES optionViewArr:_departArr viewController:self];
    _departmentCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"CCOwenMess_Devel", nil) prompt:@""];
    
    _introductCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"SSettingInfo_post", nil) leftputin:@""];
    _introductCell.putin.delegate = self;
    _introductCell.putin.placeholder = SIMLocalizedString(@"CCMemberAddPage_Choose", nil);
    
    _cells = @[@[_nickNameCell,_phoneCell,_roleCell,_departmentCell,_introductCell]];

}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cells.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cells[section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == _cells.count - 1) {
        return 100;
    }else {
        return 0.01;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == _cells.count - 1) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 100)];
        UILabel *afreeLab = [[UILabel alloc] init];
        afreeLab.userInteractionEnabled = YES;
        afreeLab.text = @"默认初始密码：123456\n如果所添加的手机号在本系统注册过，密码不会被修改";
        afreeLab.textAlignment = NSTextAlignmentLeft;
        afreeLab.textColor = TableViewHeaderColor;
        afreeLab.numberOfLines = 0;
        afreeLab.font = FontRegularName(14);
        [footView addSubview:afreeLab];
        [afreeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
        return footView;
    }else {
        return nil;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cells[indexPath.section][indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        // 选择角色弹出选择器
        __weak typeof(self) weakSelf = self;
        if (_listAry.count > 0) {
            self.pickerView.dataSource = _listAry.mutableCopy;
            self.pickerView.selectStr = _listAry[_ind];
            [self.pickerView show];
            self.pickerView.callBlock = ^(NSString * _Nonnull pickDate) {
                weakSelf.roleCell.promptLabel.text = pickDate;
                weakSelf.ind = [weakSelf.listAry indexOfObject:pickDate];
                weakSelf.rolePid = [NSString stringWithFormat:@"%@",[weakSelf.roleArray[weakSelf.ind] pid]];
            };
        }else {
            [MBProgressHUD cc_showText:@"没有角色，请前去后台添加"];
        }
        
    }else if (indexPath.row == 3) {
        SIMAddChooseDepartViewController *chooseVC = [[SIMAddChooseDepartViewController alloc] init];
        chooseVC.dataSource = _departArr;
        chooseVC.choseIndexArr = self.choseArr;
        chooseVC.delegate = self;
        [self.navigationController pushViewController:chooseVC animated:YES];
    }
    
}
#pragma mark -- AddChooseDepartDelegate
- (void)optionChooseArr:(NSArray *)chooseArr {
    NSLog(@"selectedchoosePidArr %@",chooseArr);
    NSMutableArray *arrM = [NSMutableArray array];
    NSMutableArray *pidarrM = [NSMutableArray array];
    for (SIMAddMember *person in chooseArr) {
        [arrM addObject:person.title];
        [pidarrM addObject:person.pid];
    }
    NSString *string = [arrM componentsJoinedByString:@","];
    NSString *pidstring = [pidarrM componentsJoinedByString:@","];

    _departmentCell.promptLabel.text = string;
    _departPid = pidstring;
//    [_choseArr removeAllObjects];
//    [_choseArr addObjectsFromArray:chooseArr];
//    _choseArr = [NSMutableArray arrayWithArray:chooseArr];
}

#pragma mark -- JJOptionViewDelegate
- (void)optionView:(JJOptionView *)optionView selectedIndex:(NSInteger)selectedIndex {
    if (optionView == _roleCell.optionView) {
        _rolePid = [NSString stringWithFormat:@"%@",[_roleArray[selectedIndex] pid]];
    }
    NSLog(@"optionViewdeflaut %@",optionView);
    NSLog(@"selectedIndexdeflaut %@",_rolePid);
}
- (void)optionView:(JJOptionView *)optionView chooseArr:(NSString *)choosePidArr {
    NSLog(@"optionViewchoose %@",optionView);
    NSLog(@"selectedchoosePidArr %@",choosePidArr);
    if (optionView == _departmentCell.optionView) {
        _departPid = choosePidArr;
    }
}

//- (void)startBtn:(UIButton*)sender {
//    if (sender.tag == MyButtonTypeSave) {
//        // 保存
//        [self registClickWithCleanStr:NO];
//    }else if (sender.tag == MyButtonTypeSaveOneMore) {
//        // 保存并继续添加
//        [self registClickWithCleanStr:YES];
//    }
//}
- (void)getAllArrayDatas {
    [MainNetworkRequest userPublicinfoRequestParams:nil success:^(id success) {
        NSLog(@"roleanddepartmentlistsuccess%@",success);
        // 成功
        if ([success[@"code"] integerValue] == successCodeOK) {
            [_departArr removeAllObjects];
            [_roleArray removeAllObjects];
            NSDictionary *dataDic = success[@"data"];
            for (NSDictionary *dic in dataDic[@"dp_list"]) {
                SIMAddMember *member = [[SIMAddMember alloc] initWithDictionary:dic];
                [_departArr addObject:member];
            }
            for (NSDictionary *dic in dataDic[@"role_list"]) {
                SIMAddMember *member = [[SIMAddMember alloc] initWithDictionary:dic];
                [_roleArray addObject:member];
                [_listAry addObject:member.name];
            }
            [self setUpCells];
            [self.tableView reloadData];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}


- (void)creatRequestWithCleanStr:(BOOL)isClean {
    // 传递参数字典
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    [dicM setValue:_nickNameCell.putin.text forKey:@"nickname"];
    [dicM setValue:_phoneCell.putin.text forKey:@"mobile"];
    [dicM setValue:_rolePid forKey:@"role"];
    [dicM setValue:_departPid forKey:@"department"];
    [dicM setValue:_introductCell.putin.text forKey:@"position"];
    [dicM setValue:@"1" forKey:@"source"];

    NSLog(@"useraddsuccessdicM %@",dicM);

    [MainNetworkRequest userCreateRequestParams:dicM success:^(id success) {
        NSLog(@"useraddsuccess%@",success);
        // 成功
        if ([success[@"code"] integerValue] == successCodeOK) {
            [MBProgressHUD cc_showSuccess:success[@"msg"]];
            if (isClean) {
                _rolePid = nil;
                _ind = 0;
                _departPid = nil;
                [_choseArr removeAllObjects];
                for (SIMAddMember *mem in _departArr) {
                    mem.isSelect = NO;
//                    NSLog(@"mem.isSelect22 %d",mem.isSelect);
                }
                [self setUpCells];
                [self.tableView reloadData];
            }else {
                [self.navigationController popViewControllerAnimated:YES];
            }
            // 发送列表刷新通知
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshCompanyContactData object:nil];

        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}

- (void)registClickWithCleanStr:(BOOL)isClean {
    
    if (_nickNameCell.putin.text.length <= 0) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"CCMemberAddPage_Sign", nil)];
        return ;
    }
    if (_phoneCell.putin.text.length <= 0) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"KHBAccountPlaceHolder", nil)];
        return ;
    }
    if (![self.cloudVersion.username_type isEqualToString:@"string"]) {
        if (![_phoneCell.putin.text checkTel]) {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_WRONG_PhoneNumber", nil)];
            return;
        }
    }
    NSLog(@"_rolePid%@ _departPid%@",_rolePid,_departPid);
    if (_rolePid.length <= 0) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"AddMemberChooseTheRole", nil)];
        return ;
    }
    [self creatRequestWithCleanStr:isClean];
}



#pragma mark - UITextFieldClick
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _nickNameCell.putin) {
        
        [self subStringAllMethod:textField withLength:kMinLength];
    }else if (textField == _phoneCell.putin) {
        [self subStringAllMethod:textField withLength:11];
    }
    
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}


#pragma mark -- UIAlertViewController
- (void)addAlertViewControllerBottom {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCSave", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self registClickWithCleanStr:NO];
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCSaveAndAdd", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self registClickWithCleanStr:YES];
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    //    [action3 setValue:[UIColor redColor] forKey:@"_titleTextColor"];
    [alertC addAction:action];
    [alertC addAction:action2];
    [alertC addAction:action3];
    alertC.popoverPresentationController.sourceView = self.view;
//    alertC.popoverPresentationController.sourceRect = done.frame;
    alertC.popoverPresentationController.barButtonItem = done;
    alertC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    [self presentViewController:alertC animated:YES completion:nil];
}


// 选择器视图
-(SIMJPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[SIMJPickerView alloc] init];
    }
    return _pickerView;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_pickerView hidden];
}


@end
