//
//  SIMNewLiveViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/10/11.
//  Copyright © 2017年 Ferris. All rights reserved.
//
#define kAlphaNum  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"


#import "SIMNewLiveViewController.h"

#import "SIMBaseInputTableViewCell.h"
#import "SIMBaseCommonTableViewCell.h"

#import "SIMRepeatViewController.h"
#import "SIMContentLabViewController.h"

#import "BJDatePickerView.h"
#import "NSDate+SIMConvenient.h"


@interface SIMNewLiveViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,SIMRepeatViewDelegate,SIMContentLabdelegate>
{
    SIMBaseInputTableViewCell * _nickNameCell;
    SIMBaseCommonTableViewCell *_startCell;
    SIMBaseCommonTableViewCell *_hourCell;
    SIMBaseCommonTableViewCell *_repeatCell;
    SIMBaseCommonTableViewCell *_explainCell;
    SIMBaseCommonTableViewCell *_passwordCell;
    SIMBaseCommonTableViewCell *_mainPSWCell;
    NSDate *dat;// 时间的变量
    NSInteger intt;// 时长的秒数
    NSString *currentDateStr;// 转化的结束时间
    NSString *timeString;// 编辑页面用时间
    
    
    NSArray<NSArray<UITableViewCell*>*>* _cells;
    BOOL rigt;// 防止安排会议按钮点击多次
}
@property (nonatomic,strong) SIMBaseTableView *tableView;
@property(nonatomic,strong) BJDatePickerView *datePickerView;
@property (nonatomic, assign) NSInteger textLocation;//这里声明一个全局属性，用来记录输入位置

@end

@implementation SIMNewLiveViewController

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
    rigt = YES;
    // 创建单元格
    [self setUpCells];
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"NavBackComplete", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnClick)];
    
    self.navigationItem.rightBarButtonItem = done;
    
}
- (void)doneBtnClick {
    if (self.arrangeConf != nil) {
        if (rigt == YES) {
            rigt = NO;
            [self confEditData];// 会议模型有值 那么是编辑上传请求
        }
    }else {
        if (rigt == YES) {
            rigt = NO;
            [self confRequestData];// 会议模型没值 那么是安排一场会议
        }
        
    }
}
- (void)setUpCells
{
    _nickNameCell = [[SIMBaseInputTableViewCell alloc] init];
    _nickNameCell.placeHolderStr = [NSString stringWithFormat:@"%@%@",self.currentUser.nickname,SIMLocalizedString(@"MArrangeConfISLIVE", nil)];
    _nickNameCell.textfield.delegate = self;
    [_nickNameCell.textfield addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    NSString *firstStr = SIMLocalizedString(@"MMessEditLive", nil);
    
    _startCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"MArrangeStarTime", nil) prompt:SIMLocalizedString(@"MArrangeStarChoose", nil)];
    _hourCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:[NSString stringWithFormat:@"%@",SIMLocalizedString(@"MMessTimeLength", nil)] prompt:SIMLocalizedString(@"MArrangeStarChoose", nil)];
    _repeatCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"MArrangeConfRepeat", nil) prompt:SIMLocalizedString(@"MArrangeStarChoose", nil)];
    _explainCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:[NSString stringWithFormat:@"%@%@",firstStr,SIMLocalizedString(@"MArrangeConfExplain", nil)] prompt:@""];
    
    _passwordCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:[NSString stringWithFormat:@"%@%@",firstStr,SIMLocalizedString(@"MArrangePSW", nil)] putin:nil];
    _passwordCell.putin.delegate=self;
    _passwordCell.putin.delegate=self;
    _passwordCell.putin.keyboardType =  UIKeyboardTypeASCIICapable;
    [_passwordCell.putin addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _mainPSWCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"MEMineConfMainPSW", nil) putin:nil];
    _mainPSWCell.putin.placeholder = @"abcd";
    _mainPSWCell.putin.delegate=self;
    _mainPSWCell.putin.delegate=self;
    _mainPSWCell.putin.keyboardType =  UIKeyboardTypeASCIICapable;
    [_mainPSWCell.putin addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    if (self.arrangeConf != nil) {// 编辑
        _nickNameCell.textfield.text = self.arrangeConf.name;

        // 日期赋值
//            NSString *dateStart = self.arrangeConf.startTime;
//            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
//            [inputFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
//            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//            [inputFormatter setLocale:locale];
//            [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            NSDate* inputDate = [inputFormatter dateFromString:dateStart];
//            dat = inputDate;
//            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//            [outputFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
//            if ([inputDate isToday]) {
//                if (inputDate.hour < 13) {
//                    [outputFormatter setDateFormat:SIMLocalizedString(@"TimeTodayAM", nil)];
//                }else if (inputDate.hour >= 13) {
//                    [outputFormatter setDateFormat:SIMLocalizedString(@"TimeTodayPM", nil)];
//                }
//            }else if ([inputDate isTomorrow]){
//                if (inputDate.hour < 13) {
//                    [outputFormatter setDateFormat:SIMLocalizedString(@"TimeTomorrowAM", nil)];
//                }else if (inputDate.hour >= 13) {
//                    [outputFormatter setDateFormat:SIMLocalizedString(@"TimeTomorrowPM", nil)];
//                }
//            }else if ([inputDate isAfterTomorrow]){
//                if (inputDate.hour < 13) {
//                    [outputFormatter setDateFormat:SIMLocalizedString(@"TimeAfterTomorrowAM", nil)];
//                }else if (inputDate.hour >= 13) {
//                    [outputFormatter setDateFormat:SIMLocalizedString(@"TimeAfterTomorrowPM", nil)];
//                }
//            }else {
//                if (inputDate.hour < 13) {
//                    [outputFormatter setDateFormat:SIMLocalizedString(@"TimeYearANDdayAM", nil)];
//                }else if (inputDate.hour >= 13) {
//                    [outputFormatter setDateFormat:SIMLocalizedString(@"TimeYearANDdayPM", nil)];
//                }
//            }
//            NSLocale *locale2 = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//            [outputFormatter setLocale:locale2];
//            NSString *dateHour = [outputFormatter stringFromDate:inputDate];
        dat = [NSString dateTranformDateFromTimeStr:self.arrangeConf.startTime withformat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *timeStr = [NSString dateTranformDayTimeStrFromTimeStr:dat];
        _startCell.promptLabel.text = timeStr;
//            _startCell.promptLabel.text = dateHour;
        
        // 时长赋值
        [self dateTransform];
        
        _hourCell.promptLabel.text = [NSString dateTimeInervalToEndFromStart:self.arrangeConf.startTime withEnd:self.arrangeConf.stopTime];
        
        _repeatCell.promptLabel.text = [NSString transTheRepeatType:self.arrangeConf.repeat];
        _passwordCell.putin.text = self.arrangeConf.normalPassword;
        _mainPSWCell.putin.text = self.arrangeConf.mainPassword;
        _explainCell.promptLabel.text = self.arrangeConf.detail;
        
    }else {// 安排一场会议
        // 默认显示时间为当前时间
        dat = [NSDate date];
//        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//        [outputFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
//        if (dat.hour < 13) {
//            [outputFormatter setDateFormat:SIMLocalizedString(@"TimeTodayAM", nil)];
//        }else if (dat.hour >= 13) {
//            [outputFormatter setDateFormat:SIMLocalizedString(@"TimeTodayPM", nil)];
//        }
//        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//        [outputFormatter setLocale:locale];
//        NSString *dateHour = [outputFormatter stringFromDate:dat];
        NSString *dateHour = [NSString dateTranformDayTimeStrFromTimeStr:dat];
        _startCell.promptLabel.text = dateHour;
        // 时长
        intt = 60*60;
        _hourCell.promptLabel.text = [NSString stringWithFormat:@"1 %@",SIMLocalizedString(@"TimeHour", nil)];
        // 重复
        _repeatCell.promptLabel.text = SIMLocalizedString(@"MArrangeConfRepeat_Never", nil);
    }
    
    _cells = @[@[_nickNameCell],@[_startCell,_hourCell,_repeatCell,_explainCell],@[_passwordCell,_mainPSWCell]];
}
#pragma mark - UITextFieldClick
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _passwordCell.putin || textField == _mainPSWCell.putin) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
            [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_PSW_length_fail", nil)];
        }
    }
}
#pragma mark-- UITextFieldDelegate
//在输入时，调用下面那个方法来判断输入的字符串是否含有表情
- (void)textFieldDidChanged:(UITextField *)textField
{
    [self subStringAllMethod:textField withLength:kMaxLength];
//    NSString *toBeString = textField.text;
//    NSString *lang = [[textField textInputMode] primaryLanguage]; // 获取当前键盘输入模式
//    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入,第三方输入法（搜狗）所有模式下都会显示“zh-Hans”
//        UITextRange *selectedRange = [textField markedTextRange];
//        //获取高亮部分
//        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
//        if(!position) {
//            NSString *getStr = [self getSubString:toBeString withLength:kMinLength+6];
//            if(getStr && getStr.length > 0) {
//                textField.text = getStr;
//            }
//        }
//    }else{
//        NSString *getStr = [self getSubString:toBeString withLength:kMinLength+6];
//        if(getStr && getStr.length > 0) {
//            textField.text= getStr;
//        }
//    }
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    
    if (textField == _passwordCell.putin || textField == _mainPSWCell.putin) {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
        NSString *filtered =
        [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
    }
    return YES;
}


#pragma mark - UITableView
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
            __weak typeof(self) wself = self;
            [_datePickerView datePickerViewDidSelected:^(NSString *date,NSDate *dateOne) {
                __strong typeof(wself) sself = wself;
                // 选择时间选择器时候将date字符串赋值给label 格式已经在里面封装好 并且将nsdate 作为成员变量 方便编辑会议时候用
                sself->_startCell.promptLabel.text = date;
                sself->dat = dateOne;
            }];
        }else if (indexPath.row == 1) {
            [self.datePickerView showHour];
            // 选中小时
            __weak typeof(self) wself = self;
            [_datePickerView datePickerViewDidSelected:^(NSString *date,NSDate *dateOne) {
                __strong typeof(wself) sself = wself;
                // 选择时间选择器时候将date字符串赋值给label 格式已经在里面封装好 并且将nsdate的小时和分钟拿出来作为成员变量 方便编辑会议时候用
                sself->_hourCell.promptLabel.text = date;
                NSDate *dat2 = dateOne;
                sself->intt = [dat2 hour] * 3600 + [dat2 minute] * 60;
            }];
        }else if (indexPath.row == 2) {
            SIMRepeatViewController *repeatVC = [[SIMRepeatViewController alloc] init];
            repeatVC.delegate = self;// 遵守代理 重复页面传值
            repeatVC.tagStr = _repeatCell.promptLabel.text;
            [self.navigationController pushViewController:repeatVC animated:YES];
        }else if (indexPath.row == 3) {
            // 课程说明页面
            SIMContentLabViewController *labContVC = [[SIMContentLabViewController alloc] init];
            labContVC.delegate = self;
            labContVC.classStr = _explainCell.promptLabel.text;
            [self.navigationController pushViewController:labContVC animated:YES];
        }
    }
}
// 点击重复回传值
- (void)inputString:(NSString *)textStr index:(NSInteger)indexTag{
    _repeatCell.promptLabel.text = textStr;
}
// 课程说明回传值
- (void)contentConfString:(NSString *)content {
    _explainCell.promptLabel.text = content;
}
// 安排请求
- (void)confRequestData {
    // 传递参数字典
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    if (_nickNameCell.textfield.text.length == 0) {
        [dicM setValue:_nickNameCell.textfield.placeholder forKey:@"name"];
    }else {
        [dicM setValue:_nickNameCell.textfield.text forKey:@"name"];
    }
    [dicM setValue:_passwordCell.putin.text forKey:@"normalPassword"];
    if (_mainPSWCell.putin.text.length == 0) {
        [dicM setValue:@"abcd" forKey:@"mainPassword"];
    }else {
        [dicM setValue:_mainPSWCell.putin.text forKey:@"mainPassword"];//主席密码设置为默认
    }
    [dicM setValue:[NSString dateTranformTimeStrFromDate:dat withformat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"startTime"];
//    [self dateTransform:intt];
    NSDate *dateStop = [NSDate dateWithTimeInterval:intt sinceDate:dat];
    NSString *stopStr = [NSString dateTranformTimeStrFromDate:dateStop withformat:@"yyyy-MM-dd HH:mm:ss"];
    [dicM setValue:stopStr forKey:@"stopTime"];
    [dicM setValue:[NSString transTheRepeatTypeToUpload:_repeatCell.promptLabel.text] forKey:@"repeat"];
    [dicM setValue:_explainCell.promptLabel.text forKey:@"detail"];
    //    [dicM setValue:@"1" forKey:@"sign"]; // 会议的sign是1 支付加上之后估计还要用的
    NSLog(@"arrangeDicdicM%@",dicM);
    
    // 正在加载框
    [MBProgressHUD cc_showLoading:nil];
    [MainNetworkRequest createConfInfoRequestParams:dicM success:^(id success) {
        NSLog(@"succccessDic%@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [MBProgressHUD cc_showSuccess:success[@"msg"]];
            [self.tabBarController setSelectedIndex:3];
            [self setUpCells];
            [self.tableView reloadData];
            // 发送直播列表刷新通知
            [[NSNotificationCenter defaultCenter] postNotificationName:EditLiveSuccess object:nil];
        }
        rigt = YES;
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
        rigt = YES;
    }];
}
// 编辑请求
- (void)confEditData {
    // 传递参数字典
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    if (_nickNameCell.textfield.text.length == 0) {
        [dicM setValue:_nickNameCell.textfield.placeholder forKey:@"name"];
    }else {
        [dicM setValue:_nickNameCell.textfield.text forKey:@"name"];
    }
    [dicM setValue:_passwordCell.putin.text forKey:@"normalPassword"];
    if (_mainPSWCell.putin.text.length == 0) {
        [dicM setValue:@"abcd" forKey:@"mainPassword"];
    }else {
        [dicM setValue:_mainPSWCell.putin.text forKey:@"mainPassword"];//主席密码设置为默认
    }
    [dicM setValue:[NSString dateTranformTimeStrFromDate:dat withformat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"startTime"];
//    [self dateTransform:intt];
    NSDate *dateStop = [NSDate dateWithTimeInterval:intt sinceDate:dat];
    NSString *stopStr = [NSString dateTranformTimeStrFromDate:dateStop withformat:@"yyyy-MM-dd HH:mm:ss"];
    [dicM setValue:stopStr forKey:@"stopTime"];
    [dicM setValue:[NSString transTheRepeatTypeToUpload:_repeatCell.promptLabel.text] forKey:@"repeat"];
    [dicM setValue:_explainCell.promptLabel.text forKey:@"detail"];
    [dicM setValue:self.cidStr forKey:@"cid"]; // 编辑的话 是要有这个cid的
    //    [dicM setValue:@"1" forKey:@"sign"]; // 会议的sign是1 支付加上之后估计还要用的
    NSLog(@"editArragePutOnDic %@",dicM);
    
    // 正在加载框
    [MBProgressHUD cc_showLoading:nil];
    [MainNetworkRequest editConfListRequestParams:dicM success:^(id success) {
        NSLog(@"editArrageDic %@",dicM);
        if ([success[@"code"] integerValue] == successCodeOK) {
            
            [MBProgressHUD cc_showSuccess:success[@"msg"]];
            // 发送安排会议刷新通知
            [[NSNotificationCenter defaultCenter] postNotificationName:EditLiveSuccess object:nil];
            // 跳转
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        rigt = YES;
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
        rigt = YES;
    }];
}

//- (void)dateTransform:(NSInteger )timeStr {
//    
//    NSDate *date2 = [NSDate dateWithTimeInterval:timeStr sinceDate:dat];
//    //实例化一个NSDateFormatter对象
//    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//    [outputFormatter setLocale:locale];
//    [outputFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
//    //设定时间格式,这里可以设置成自己需要的格式
//    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    // 将localeDate 转为 yyyy-MM-dd HH:mm:ss
//    currentDateStr = [outputFormatter stringFromDate:date2];
//    
//}
// 将结束时间和开始时间比较转化为会议时长
- (void)dateTransform {
    NSString *dateStart = self.arrangeConf.startTime;
    NSString *dateStop = self.arrangeConf.stopTime;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [inputFormatter setLocale:locale];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* startDate = [inputFormatter dateFromString:dateStart];
    NSDate* stopDate = [inputFormatter dateFromString:dateStop];
    
    NSTimeInterval time = [stopDate timeIntervalSinceDate:startDate];
    
    intt = time;
}
- (void)dealloc {
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.datePickerView hidden];
    [self.datePickerView hiddenHour];
    [self.datePickerView removeFromSuperview];
}


@end
