//
//  SIMLiveViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/8/3.
//  Copyright © 2017年 Ferris. All rights reserved.
//
#define kAlphaNum  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kAlpha      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define kNumbers     @"0123456789"
#define kNumbersPeriod  @"0123456789."

#import "SIMLiveViewController.h"
#import "SIMBaseInputTableViewCell.h"
#import "SIMBaseCommonTableViewCell.h"
#import "SIMBaseSwitchTableViewCell.h"

#import "BJDatePickerView.h"
#import "NSDate+SIMConvenient.h"


@interface SIMLiveViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    SIMBaseInputTableViewCell * _nickNameCell;
    SIMBaseCommonTableViewCell *_startCell;
    SIMBaseCommonTableViewCell *_hourCell;
    SIMBaseCommonTableViewCell *_passwordCell;
    SIMBaseSwitchTableViewCell *_audioCell;
    NSDate *dat;// 时间的变量
    NSInteger intt;// 时长的秒数
    NSString *datePut; // 转化后的时间
    NSString *currentDateStr;// 转化的结束时间
    NSArray<NSArray<UITableViewCell*>*>* _cells;
}
@property (nonatomic,strong) SIMBaseTableView *tableView;
@property(nonatomic,strong) BJDatePickerView *datePickerView;
@end

@implementation SIMLiveViewController
// 选择器视图
-(BJDatePickerView *)datePickerView{
    if (!_datePickerView) {
        _datePickerView=[BJDatePickerView shareDatePickerView];
    }
    return _datePickerView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建直播";
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem* cancel = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"NavBackCancelTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    self.navigationItem.leftBarButtonItem = cancel;
    
    UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
    self.navigationItem.rightBarButtonItem = done;
    // 创建单元格
    [self setUpCells];

}
- (void)saveBtnClick {
    // 上传服务器
    [MBProgressHUD cc_showText:@"提交成功"];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)cancelBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setUpCells
{
    _nickNameCell = [[SIMBaseInputTableViewCell alloc] init];
    _nickNameCell.placeHolderStr = [NSString stringWithFormat:@"%@的直播",self.currentUser.nickname];
    _nickNameCell.textfield.delegate = self;
    [_nickNameCell.textfield addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    _startCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:@"开始时间" prompt:@"请选择"];
    _hourCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:@"直播时长" prompt:@"请选择"];
    
    _passwordCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:@"直播密码" putin:nil];
    _passwordCell.putin.delegate=self;
    _passwordCell.putin.delegate=self;
    _passwordCell.putin.keyboardType =  UIKeyboardTypeASCIICapable;
    [_passwordCell.putin addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _audioCell = [[SIMBaseSwitchTableViewCell alloc] init];
    _audioCell.titleLab.text = @"自动录制";
    _audioCell.switchButton.on = YES;
    
    // 安排直播
    // 默认显示时间为当前时间
    dat = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
    if (dat.hour < 13) {
        [outputFormatter setDateFormat:@"今天 上午 hh:mm"];
    }else if (dat.hour >= 13) {
        [outputFormatter setDateFormat:@"今天 下午 hh:mm"];
    }
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [outputFormatter setLocale:locale];
    NSString *dateHour = [outputFormatter stringFromDate:dat];
    _startCell.promptLabel.text = dateHour;
    // 时长
    intt = 60*60;
    _hourCell.promptLabel.text = @"1 小时";
    
    _cells = @[@[_nickNameCell],@[_startCell,_hourCell],@[_passwordCell],@[_audioCell]];
    
    [self.tableView reloadData];
}

#pragma mark - UITextFieldClick
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _passwordCell.putin) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
            [MBProgressHUD cc_showText:@"设置会议密码不超过6位"];
        }
    }
}
#pragma mark-- UITextFieldDelegate
//在输入时，调用下面那个方法来判断输入的字符串是否含有表情
- (void)textFieldDidChanged:(UITextField *)textField
{
    [self subStringAllMethod:textField withLength:kMinLength];
}
#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    
    if (textField == _passwordCell.putin) {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
        NSString *filtered =
        [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
    }
//    else if(textField == _nickNameCell.textfield){
//        if ([self isInputRuleAndBlank:string] || [string isEqualToString:@""]) {//当输入符合规则和退格键时允许改变输入框
//            return YES;
//        } else {
//            return NO;
//        }
//    }
    return YES;
}


#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self.datePickerView show];
            // 选中时间
            [_datePickerView datePickerViewDidSelected:^(NSString *date,NSDate *dateOne) {
                // 选择时间选择器时候将date字符串赋值给label 格式已经在里面封装好 并且将nsdate 作为成员变量 方便编辑会议时候用
                _startCell.promptLabel.text = date;
                dat = dateOne;
            }];
        }else if (indexPath.row == 1) {
            [self.datePickerView showHour];
            // 选中小时
            [_datePickerView datePickerViewDidSelected:^(NSString *date,NSDate *dateOne) {
                // 选择时间选择器时候将date字符串赋值给label 格式已经在里面封装好 并且将nsdate的小时和分钟拿出来作为成员变量 方便编辑会议时候用
                _hourCell.promptLabel.text = date;
                NSDate *dat2 = dateOne;
                intt = [dat2 hour] * 3600 + [dat2 minute] * 60;
            }];
        }
    }
}
@end
