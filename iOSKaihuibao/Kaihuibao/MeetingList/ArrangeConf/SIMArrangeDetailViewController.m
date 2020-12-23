//
//  SIMArrangeDetailViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/22.
//  Copyright © 2017年 Ferris. All rights reserved.
//
#define kAlphaNum  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

#import "SIMArrangeDetailViewController.h"

#import "SIMBaseInputTableViewCell.h"
#import "SIMBaseCommonTableViewCell.h"
#import "SIMBaseSwitchTableViewCell.h"

#import "SIMRepeatViewController.h"
#import "SIMConfModelViewController.h"
#import "SIMContentLabViewController.h"
#import "ConfMessageViewController.h"
#import "SIMConfDocSelectViewController.h"

#import "SIMConfDocModel.h"
#import "BJDatePickerView.h"
#import "SIMJPickerView.h"
#import "NSDate+SIMConvenient.h"

@interface SIMArrangeDetailViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,SIMRepeatViewDelegate,SIMContentLabdelegate,ConfModelDelegate,ConfDocSelectDelegate>
{
    SIMBaseInputTableViewCell * _nickNameCell;
    SIMBaseCommonTableViewCell *_startCell;
    SIMBaseCommonTableViewCell *_hourCell;
    SIMBaseCommonTableViewCell *_repeatCell;
    SIMBaseCommonTableViewCell *_explainCell;// 课程说明
    SIMBaseCommonTableViewCell *_passwordCell;
    SIMBaseCommonTableViewCell *_mainPSWCell;

    NSInteger serialIndex;//
    
    NSDate *dat;// 时间的变量
    NSInteger intt;// 时长的秒数
    NSString *datePut; // 转化后的时间
    NSString *currentDateStr;// 转化的结束时间
    NSString *timeString;// 编辑页面用时间
    
    NSArray<NSArray<UITableViewCell*>*>* _cells;
    BOOL rigt;// 防止安排会议按钮点击多次
//    NSString *firstStr;
}
@property (nonatomic,strong) SIMBaseTableView *tableView;
@property(nonatomic,strong) BJDatePickerView *datePickerView;
@property(nonatomic, strong) SIMJPickerView *pickerView;
@property (nonatomic, assign) NSInteger textLocation;//这里声明一个全局属性，用来记录输入位置
@property (nonatomic, strong) UIButton *start;
@property (nonatomic, strong) SIMBaseCommonTableViewCell *confModelCell;
@property (nonatomic, strong) SIMBaseSwitchTableViewCell *hostManVideoCell;
//@property (nonatomic, strong) SIMBaseSwitchTableViewCell *hostManAudioCell;
@property (nonatomic, strong) SIMBaseSwitchTableViewCell *joinManVideoCell;
//@property (nonatomic, strong) SIMBaseSwitchTableViewCell *joinManAudioCell;
@property (nonatomic, strong) SIMBaseCommonTableViewCell *confDocCell;
@property (nonatomic, strong) NSString *chooseConfModel;
@property (nonatomic, strong) NSMutableArray *chooseArr;
@property (nonatomic, strong) NSArray *docIDArr;
@property (nonatomic, strong) NSArray *repeatArr;

@end

@implementation SIMArrangeDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    rigt = YES;
    
    NSLog(@"teachModelStr %@ %@",self.teachIDStr,self.teachNameStr);
    
    [self deflautConfModelSerailIndex];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickViewWillChangeFrame:) name:@"pickviewWillChange" object:nil];
    [self addDatas];

    NSLog(@"hhhhhharrangeConf %@",self.arrangeConf.confModeStr);
//    firstStr = SIMLocalizedString(@"MMessEditConf", nil);
    
    // 创建单元格
    [self setUpCells];
    
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, BottomSaveH + 20)];

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
    // 教学模式和会议区分的地方
    NSString *nameStr;
    NSString *timelenghtStr;
    NSString *explainStr;
    NSString *passwordStr;
    NSString *confmodelStr;
    NSString *confdocStr;
    if (self.teachIDStr != nil && [self.teachorConfStr isEqualToString:@"teaching"]) {
        nameStr = SIMLocalizedString(@"MArrangeConfIS_class", nil);
        timelenghtStr = SIMLocalizedString(@"MMessTimeLength_class", nil);
        explainStr = SIMLocalizedString(@"MMessTimeExplain_class", nil);
        passwordStr = SIMLocalizedString(@"MArrangePSW_class", nil);
        confmodelStr = SIMLocalizedString(@"ConfModeTitle_class", nil);
        confdocStr = SIMLocalizedString(@"ConfDocTitle_class", nil);
    }else {
        nameStr = SIMLocalizedString(@"MArrangeConfIS", nil);
        timelenghtStr = SIMLocalizedString(@"MMessTimeLength", nil);
        explainStr = SIMLocalizedString(@"MMessTimeExplain", nil);
        passwordStr = SIMLocalizedString(@"MArrangePSW", nil);
        confmodelStr = SIMLocalizedString(@"ConfModeTitle", nil);
        confdocStr = SIMLocalizedString(@"ConfDocTitle", nil);
    }
    _nickNameCell = [[SIMBaseInputTableViewCell alloc] init];
    _nickNameCell.placeHolderStr = [NSString stringWithFormat:@"%@%@",self.currentUser.nickname,nameStr];
    _nickNameCell.textfield.delegate = self;
    _nickNameCell.textfield.font = FontRegularName(16);
    [_nickNameCell.textfield addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    _startCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"MArrangeStarTime", nil) prompt:SIMLocalizedString(@"MArrangeStarChoose", nil)];
    _hourCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:timelenghtStr prompt:SIMLocalizedString(@"MArrangeStarChoose", nil)];
    _repeatCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"MArrangeConfRepeat", nil) prompt:SIMLocalizedString(@"MArrangeStarChoose", nil)];
    _explainCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:explainStr prompt:@""];
    
    _passwordCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:passwordStr putin:nil];
    _passwordCell.putin.delegate=self;
    _passwordCell.putin.keyboardType =  UIKeyboardTypeASCIICapable;
    [_passwordCell.putin addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _mainPSWCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"MEMineConfMainPSW", nil) putin:nil];
    _mainPSWCell.putin.placeholder = @"abcd";
    _mainPSWCell.putin.delegate=self;
    _mainPSWCell.putin.keyboardType =  UIKeyboardTypeASCIICapable;
    [_mainPSWCell.putin addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _hostManVideoCell = [[SIMBaseSwitchTableViewCell alloc] init];
    _hostManVideoCell.titleLab.text = SIMLocalizedString(@"ConfModeMainVideo", nil);
    
//    _hostManAudioCell = [[SIMBaseSwitchTableViewCell alloc] init];
//    _hostManAudioCell.titleLab.text = SIMLocalizedString(@"ConfModeMainAudio", nil);
    
    _joinManVideoCell = [[SIMBaseSwitchTableViewCell alloc] init];
    _joinManVideoCell.titleLab.text = SIMLocalizedString(@"ConfModeJoinVideo", nil);
    
//    _joinManAudioCell = [[SIMBaseSwitchTableViewCell alloc] init];
//    _joinManAudioCell.titleLab.text = SIMLocalizedString(@"ConfModeJoinAudio", nil);
    _confModelCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:confmodelStr prompt:SIMLocalizedString(@"MArrangeStarChoose", nil)];
    _confDocCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:confdocStr prompt:SIMLocalizedString(@"MArrangeStarChoose", nil)];
    
    if (self.arrangeConf != nil) {// 编辑
        _nickNameCell.textfield.text = self.arrangeConf.name;
        
        // 日期赋值
        dat = [NSString dateTranformDateFromTimeStr:self.arrangeConf.startTime withformat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *timeStr = [NSString dateTranformDayTimeStrFromTimeStr:dat];
        _startCell.promptLabel.text = timeStr;
        // 时长赋值
        [self dateTransform];
        
        _hourCell.promptLabel.text = [NSString dateTimeInervalToEndFromStart:self.arrangeConf.startTime withEnd:self.arrangeConf.stopTime];
        _repeatCell.promptLabel.text = [NSString transTheRepeatType:self.arrangeConf.repeat];
        
        _passwordCell.putin.text = self.arrangeConf.normalPassword;
        _mainPSWCell.putin.text = self.arrangeConf.mainPassword;
        _explainCell.promptLabel.text = self.arrangeConf.detail;
        
        
        _confModelCell.promptLabel.text = self.arrangeConf.confModeStr;
        NSMutableArray *namearr = [NSMutableArray array];
        NSMutableArray *idarr = [NSMutableArray array];
        for (SIMConfDocModel *model in self.arrangeConf.confdocList) {
            [namearr addObject:model.name];
            [idarr addObject:model.docId];
        }
        _confDocCell.promptLabel.text = [namearr componentsJoinedByString:@","];
        NSLog(@"arrarr%@",[namearr componentsJoinedByString:@","]);
        _docIDArr = idarr;
        
        _hostManVideoCell.switchButton.on = self.arrangeConf.mainVideo;
//        _hostManAudioCell.switchButton.on = self.arrangeConf.mainAudio;
        _joinManVideoCell.switchButton.on = self.arrangeConf.participantVideo;
//        _joinManAudioCell.switchButton.on = self.arrangeConf.participantAudio;
        
        if ([self.arrangeConf.confMode isEqualToString:@"intercom"]) {
            // 对讲模式
//            _hostManAudioCell.userInteractionEnabled = NO;
//            _hostManAudioCell.titleLab.textColor = GrayPromptTextColor;
            _hostManVideoCell.userInteractionEnabled = NO;
            _hostManVideoCell.titleLab.textColor = GrayPromptTextColor;
//            _joinManAudioCell.userInteractionEnabled = NO;
//            _joinManAudioCell.titleLab.textColor = GrayPromptTextColor;
            _joinManVideoCell.userInteractionEnabled = NO;
            _joinManVideoCell.titleLab.textColor = GrayPromptTextColor;
        }else if ([self.arrangeConf.confMode isEqualToString:@"mainBroadcast"] || [self.arrangeConf.confMode isEqualToString:@"mainCamera"]){
//            _hostManAudioCell.userInteractionEnabled = YES;
//            _hostManAudioCell.titleLab.textColor = BlackTextColor;
            _hostManVideoCell.userInteractionEnabled = YES;
            _hostManVideoCell.titleLab.textColor = BlackTextColor;
//            _joinManAudioCell.userInteractionEnabled = NO;
//            _joinManAudioCell.titleLab.textColor = GrayPromptTextColor;
            _joinManVideoCell.userInteractionEnabled = NO;
            _joinManVideoCell.titleLab.textColor = GrayPromptTextColor;
        }else {
            // 自由视角
//            _hostManAudioCell.userInteractionEnabled = YES;
//            _hostManAudioCell.titleLab.textColor = BlackTextColor;
            _hostManVideoCell.userInteractionEnabled = YES;
            _hostManVideoCell.titleLab.textColor = BlackTextColor;
//            _joinManAudioCell.userInteractionEnabled = YES;
//            _joinManAudioCell.titleLab.textColor = BlackTextColor;
            _joinManVideoCell.userInteractionEnabled = YES;
            _joinManVideoCell.titleLab.textColor = BlackTextColor;
        }
        
        self.chooseConfModel = self.arrangeConf.confMode;
    }else {// 安排一场会议
        
        // 默认显示时间为当前时间
        dat = [NSDate date];
        NSString *dateHour = [NSString dateTranformDayTimeStrFromTimeStr:dat];
        
        _startCell.promptLabel.text = dateHour;
        // 时长
        intt = 60*60;
        _hourCell.promptLabel.text = [NSString stringWithFormat:@"1 %@",SIMLocalizedString(@"TimeHour", nil)];
        // 重复
        _repeatCell.promptLabel.text = SIMLocalizedString(@"MArrangeConfRepeat_Never", nil);
        
        _hostManVideoCell.switchButton.on = YES;
//        _hostManAudioCell.switchButton.on = YES;
        _joinManVideoCell.switchButton.on = YES;
//        _joinManAudioCell.switchButton.on = YES;
        
        if (self.teachIDStr != nil && self.teachNameStr != nil) {
            // 教学模式 只有安排 是显示教学对应的名字但是不传会议模式
            _confModelCell.promptLabel.text = self.teachNameStr;
            _confModelCell.userInteractionEnabled = NO;
            _confModelCell.accessoryType = UITableViewCellAccessoryNone;
            
        }else {
            _confModelCell.promptLabel.text = [_chooseArr[serialIndex] name];
            self.chooseConfModel = [_chooseArr[serialIndex] serial];
        }
    }
    
    
    if (self.cloudVersion.webFileUrl.length > 0) {
        _cells = @[@[_nickNameCell],@[_confModelCell,_confDocCell],@[_startCell,_hourCell,_repeatCell,_explainCell],@[_passwordCell,_mainPSWCell],@[_hostManVideoCell,_joinManVideoCell]];
    }else {
        _cells = @[@[_nickNameCell],@[_confModelCell],@[_startCell,_hourCell,_repeatCell,_explainCell],@[_passwordCell,_mainPSWCell],@[_hostManVideoCell,_joinManVideoCell]];
    }
    
    
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
}


#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _passwordCell.putin || textField == _mainPSWCell.putin) {
        NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
        if (![string isEqualToString:tem]) {
            return NO;
        }
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
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (void)startBtnClick {
    if (rigt == YES) {
        rigt = NO;
        [self confRequestData];// 会议模型没值 那么是安排一场会议
    }
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
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [_pickerView hidden];
             [self.datePickerView show];
            // 选中时间
            __weak typeof(self) wself = self;
            [_datePickerView datePickerViewDidSelected:^(NSString *date,NSDate *dateOne) {
                // 选择时间选择器时候将date字符串赋值给label 格式已经在里面封装好 并且将nsdate 作为成员变量 方便编辑会议时候用
                 __strong typeof(wself) sself = wself;
                sself->_startCell.promptLabel.text = date;
                sself->dat = dateOne;
            }];
        }else if (indexPath.row == 1) {
            [_pickerView hidden];
            [self.datePickerView showHour];
            // 选中小时
            __weak typeof(self) wself = self;
            [_datePickerView datePickerViewDidSelected:^(NSString *date,NSDate *dateOne) {
                // 选择时间选择器时候将date字符串赋值给label 格式已经在里面封装好 并且将nsdate的小时和分钟拿出来作为成员变量 方便编辑会议时候用
                __strong typeof(wself) sself = wself;
                sself->_hourCell.promptLabel.text = date;
                NSDate *dat2 = dateOne;
                sself->intt = [dat2 hour] * 3600 + [dat2 minute] * 60;
            }];
        }else if (indexPath.row == 2) {
            SIMRepeatViewController *repeatVC = [[SIMRepeatViewController alloc] init];
            repeatVC.delegate = self;// 遵守代理 重复页面传值
            repeatVC.arr = _repeatArr;
            NSString *tagStr = _repeatCell.promptLabel.text;
            repeatVC.index = [_repeatArr indexOfObject:tagStr];
            [self.navigationController pushViewController:repeatVC animated:YES];
        }else if (indexPath.row == 3) {
            // 课程说明页面
            SIMContentLabViewController *labContVC = [[SIMContentLabViewController alloc] init];
            labContVC.delegate = self;
            labContVC.classStr = _explainCell.promptLabel.text;
            [self.navigationController pushViewController:labContVC animated:YES];
        }
        
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //  会议模式选择
            SIMConfModelViewController *confModeVC = [[SIMConfModelViewController alloc] init];
            confModeVC.delegate = self;// 遵守代理 重复页面传值
            confModeVC.confArr = self.chooseArr;
            confModeVC.tagStr = _confModelCell.promptLabel.text;
            [self.navigationController pushViewController:confModeVC animated:YES];
        }else {
            // 会议文档
            SIMConfDocSelectViewController *confDocVC = [[SIMConfDocSelectViewController alloc] init];
            confDocVC.delegate = self;
            confDocVC.docIDArr = _docIDArr;
            [self.navigationController pushViewController:confDocVC animated:YES];
        }
        
    }
}
// 点击会议重复周期回传值
- (void)inputString:(NSString *)textStr index:(NSInteger)indexTag{
    _repeatCell.promptLabel.text = textStr;
}
// 课程说明回传值
- (void)contentConfString:(NSString *)content {
    _explainCell.promptLabel.text = content;
}
// 会议文档回传值
- (void)confDocSelectAlreadyArr:(NSArray *)seletArr {
    
    NSMutableArray *nameArr = [NSMutableArray array];
    NSMutableArray *idArr = [NSMutableArray array];
    for (SIMConfDocModel *model in seletArr) {
        [nameArr addObject:model.name];
        [idArr addObject:model.docId];
    }
    _docIDArr = idArr;
    NSString *promptStr = [nameArr componentsJoinedByString:@","];
    _confDocCell.promptLabel.text = promptStr;
}
// 会议模式的回传值
- (void)confModeModel:(ConfModelModel *)modelModel type:(NSInteger)type {
    _confModelCell.promptLabel.text = modelModel.name;
    if ([modelModel.serial isEqualToString:@"intercom"]) {
//        self.hostManAudioCell.userInteractionEnabled = NO;
//        self.hostManAudioCell.titleLab.textColor = GrayPromptTextColor;
//        self.hostManAudioCell.switchButton.on = NO;
        self.hostManVideoCell.userInteractionEnabled = NO;
        self.hostManVideoCell.titleLab.textColor = GrayPromptTextColor;
        self.hostManVideoCell.switchButton.on = NO;
//        self.joinManAudioCell.userInteractionEnabled = NO;
//        self.joinManAudioCell.titleLab.textColor = GrayPromptTextColor;
//        self.joinManAudioCell.switchButton.on = NO;
        self.joinManVideoCell.userInteractionEnabled = NO;
        self.joinManVideoCell.titleLab.textColor = GrayPromptTextColor;
        self.joinManVideoCell.switchButton.on = NO;
    }else if ([modelModel.serial isEqualToString:@"mainBroadcast"] || [modelModel.serial isEqualToString:@"mainCamera"]) {
//        self.hostManAudioCell.userInteractionEnabled = YES;
//        self.hostManAudioCell.titleLab.textColor = BlackTextColor;
        //                weakSelf.hostManAudioCell.switchButton.on = YES;
        self.hostManVideoCell.userInteractionEnabled = YES;
        self.hostManVideoCell.titleLab.textColor = BlackTextColor;
        //                weakSelf.hostManVideoCell.switchButton.on = YES;
//        self.joinManAudioCell.userInteractionEnabled = NO;
//        self.joinManAudioCell.titleLab.textColor = GrayPromptTextColor;
//        self.joinManAudioCell.switchButton.on = NO;
        self.joinManVideoCell.userInteractionEnabled = NO;
        self.joinManVideoCell.titleLab.textColor = GrayPromptTextColor;
        self.joinManVideoCell.switchButton.on = NO;
    }else {
//        self.hostManAudioCell.userInteractionEnabled = YES;
//        self.hostManAudioCell.titleLab.textColor = BlackTextColor;
        //                weakSelf.hostManAudioCell.switchButton.on = YES;
        self.hostManVideoCell.userInteractionEnabled = YES;
        self.hostManVideoCell.titleLab.textColor = BlackTextColor;
        //                weakSelf.hostManVideoCell.switchButton.on = YES;
//        self.joinManAudioCell.userInteractionEnabled = YES;
//        self.joinManAudioCell.titleLab.textColor = BlackTextColor;
        //                weakSelf.hostManVideoCell.switchButton.on = YES;
        self.joinManVideoCell.userInteractionEnabled = YES;
        self.joinManVideoCell.titleLab.textColor = BlackTextColor;
    }
    self.chooseConfModel = modelModel.serial;
}

// 安排请求
- (void)confRequestData {
    // 传递参数字典
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    NSString *trimedString = [_nickNameCell.textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimedString.length == 0) {
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
    [dicM setValue:[NSNumber numberWithBool:_hostManVideoCell.switchButton.isOn] forKey:@"mainVideo"];
//    [dicM setValue:[NSNumber numberWithBool:_hostManAudioCell.switchButton.isOn] forKey:@"mainAudio"];
    [dicM setValue:[NSNumber numberWithBool:_joinManVideoCell.switchButton.isOn] forKey:@"participantVideo"];
//    [dicM setValue:[NSNumber numberWithBool:_joinManAudioCell.switchButton.isOn] forKey:@"participantAudio"];
    
//    if ([self.confModelCell.promptLabel.text isEqualToString:self.chooseArr[0]]) {
//        self.chooseConfModel = @"freeCamera";
//    }else if ([self.confModelCell.promptLabel.text isEqualToString:self.chooseArr[1]]) {
//        self.chooseConfModel = @"mainBroadcast";
//    }else if ([self.confModelCell.promptLabel.text isEqualToString:self.chooseArr[2]]) {
//        self.chooseConfModel = @"mainCamera";
//    }else  if ([self.confModelCell.promptLabel.text isEqualToString:self.chooseArr[3]]){
//        self.chooseConfModel = @"intercom";
//    }
    // 将数组转化成json 并过滤掉字符
    if (_docIDArr.count > 0) {
        NSString *jsonString = [NSString ObjectTojsonString:_docIDArr];
        [dicM setValue:jsonString forKey:@"confdoc"];
    }
    if (self.teachIDStr != nil && self.teachNameStr != nil) {
        [dicM setObject:self.teachIDStr forKey:@"advanced_mode_id"];
    }else {
        [dicM setObject:self.chooseConfModel forKey:@"confMode"];
    }
    NSLog(@"arrangeDicdicM%@",dicM);
    // 正在加载框
    [MBProgressHUD cc_showLoading:nil];
    [MainNetworkRequest createConfInfoRequestParams:dicM success:^(id success) {
        NSLog(@"succccessDic%@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [MBProgressHUD cc_showSuccess:success[@"msg"]];
            // 发送安排会议刷新通知
            [[NSNotificationCenter defaultCenter] postNotificationName:EditConfSuccess object:nil];
            // 跳转
            ConfMessageViewController *mess = [[ConfMessageViewController alloc] init];
            ArrangeConfModel *confMess = [[ArrangeConfModel alloc] initWithDictionary:success[@"data"]];
            mess.confMessID = confMess.cid;
            mess.confMess = confMess;
            mess.teachIDStr = self.teachIDStr;
            mess.teachorConfStr = self.teachorConfStr;
            mess.popType = YES;
            [self.navigationController pushViewController:mess animated:YES];
//            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
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
    NSString *trimedString = [_nickNameCell.textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimedString.length == 0) {
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
    
//    if ([self.confModelCell.promptLabel.text isEqualToString:self.chooseArr[0]]) {
//        self.chooseConfModel = @"freeCamera";
//    }else if ([self.confModelCell.promptLabel.text isEqualToString:self.chooseArr[1]]) {
//        self.chooseConfModel = @"mainBroadcast";
//    }else if ([self.confModelCell.promptLabel.text isEqualToString:self.chooseArr[2]]) {
//        self.chooseConfModel = @"mainCamera";
//    }else  if ([self.confModelCell.promptLabel.text isEqualToString:self.chooseArr[3]]){
//        self.chooseConfModel = @"intercom";
//    }
    
    // 将数组转化成json 并过滤掉字符
//    if (_docIDArr.count > 0) {
        NSString *jsonString = [NSString ObjectTojsonString:_docIDArr];
        [dicM setValue:jsonString forKey:@"confdoc"];
//    }
    
    [dicM setObject:self.chooseConfModel forKey:@"confMode"];
    [dicM setValue:[NSNumber numberWithBool:_hostManVideoCell.switchButton.isOn] forKey:@"mainVideo"];
//    [dicM setValue:[NSNumber numberWithBool:_hostManAudioCell.switchButton.isOn] forKey:@"mainAudio"];
    [dicM setValue:[NSNumber numberWithBool:_joinManVideoCell.switchButton.isOn] forKey:@"participantVideo"];
//    [dicM setValue:[NSNumber numberWithBool:_joinManAudioCell.switchButton.isOn] forKey:@"participantAudio"];
    NSLog(@"editArragePutOnDic %@",dicM);
    // 正在加载框
    [MBProgressHUD cc_showLoading:nil];
    [MainNetworkRequest editConfListRequestParams:dicM success:^(id success) {
        NSLog(@"editArrageDic %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            
            [MBProgressHUD cc_showText:success[@"msg"]];
            // 发送安排会议刷新通知
            [[NSNotificationCenter defaultCenter] postNotificationName:EditConfSuccess object:nil];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
        rigt = YES;
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
        rigt = YES;
    }];
}

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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.datePickerView hidden];
    [self.datePickerView hiddenHour];
//    [_pickerView hidden];
    [self.datePickerView removeFromSuperview];
    
}
#pragma mark -UITextField Delegate Method
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
// 选择器视图
//-(SIMJPickerView *)pickerView{
//    if (!_pickerView) {
//        _pickerView = [[SIMJPickerView alloc] init];
//    }
//    return _pickerView;
//}
// 选择器视图
-(BJDatePickerView *)datePickerView{
    if (!_datePickerView) {
        _datePickerView=[BJDatePickerView shareDatePickerView];
    }
    return _datePickerView;
}
//- (void)pickViewWillChangeFrame:(NSNotification *)notification {
//    NSDictionary *info = [notification userInfo];
//    NSString *pickType = [info objectForKey:@"picktype"];
//    if ([pickType isEqualToString:@"show"]) {
//        [UIView animateWithDuration:0.25 animations:^{
//            self.tableView.height -= 260;
//        }];
//        NSLog(@"yOffsetyOffsetshow %lf",self.tableView.height);
//    }else if ([pickType isEqualToString:@"hide"]) {
//        [UIView animateWithDuration:0.25 animations:^{
//            self.tableView.height += 260;
//        }];
//        NSLog(@"yOffsetyOffsethide %lf",self.tableView.height);
//    }
//
//
//}
#pragma mark 监听键盘事件
//- (void)keyboardWillChangeFrame:(NSNotification *)notification{
//    [_pickerView hidden];
//    NSDictionary *info = [notification userInfo];
//    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
//    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
//    NSLog(@"yOffsetyOffset %lf",yOffset);
//    [UIView animateWithDuration:duration animations:^{
//        self.tableView.height += yOffset;
//    }];
//}
//// 移除监听
//- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

- (void)addDatas {
    _chooseArr = [NSMutableArray array];

//    if ([self.cloudVersion.freeCamera boolValue]) {
        ConfModelModel *model1 = [[ConfModelModel alloc] initWithDictionary:@{@"serial":@"freeCamera",@"name":SIMLocalizedString(@"ConfModelFreeCamaraTitle", nil),@"detail":SIMLocalizedString(@"ConfModelFreeCamaraDetail", nil)}];
        [_chooseArr addObject:model1];
//    }
//    if ([self.cloudVersion.mainBroadcast boolValue]) {
        ConfModelModel *model2 = [[ConfModelModel alloc] initWithDictionary:@{@"serial":@"mainBroadcast",@"name":SIMLocalizedString(@"ConfModelMainBroadcastTitle", nil),@"detail":SIMLocalizedString(@"ConfModelMainBroadcastDetail", nil)}];
        [_chooseArr addObject:model2];
//    }
//    if ([self.cloudVersion.mainCamera boolValue]) {
        ConfModelModel *model3 = [[ConfModelModel alloc] initWithDictionary:@{@"serial":@"mainCamera",@"name":SIMLocalizedString(@"ConfModelMainCameraTitle", nil),@"detail":SIMLocalizedString(@"ConfModelMainCameraDetail", nil)}];
        [_chooseArr addObject:model3];
//    }
    if ([self.cloudVersion.intercom boolValue]) {
        ConfModelModel *model4 = [[ConfModelModel alloc] initWithDictionary:@{@"serial":@"intercom",@"name":SIMLocalizedString(@"ConfModelIntercomTitle", nil),@"detail":SIMLocalizedString(@"ConfModelIntercomDetail", nil)}];
        [_chooseArr addObject:model4];
    }
//    if ([self.cloudVersion.EHSfieldOperation boolValue]) {
//        ConfModelModel *model5 = [[ConfModelModel alloc] initWithDictionary:@{@"serial":@"EHSfieldOperation",@"name":SIMLocalizedString(@"ConfModelEHSfieldOperationTitle", nil),@"detail":SIMLocalizedString(@"ConfModelEHSfieldOperationDetail", nil)}];
//        [_chooseArr addObject:model5];
//    }
    if ([self.cloudVersion.voiceSeminar boolValue]) {
        ConfModelModel *model6 = [[ConfModelModel alloc] initWithDictionary:@{@"serial":@"voiceSeminar",@"name":SIMLocalizedString(@"ConfModelVoiceSeminarTitle", nil),@"detail":SIMLocalizedString(@"ConfModelVoiceSeminarDetail", nil)}];
        [_chooseArr addObject:model6];
    }
//    if ([self.cloudVersion.trainingConference boolValue]) {
//        ConfModelModel *model7 = [[ConfModelModel alloc] initWithDictionary:@{@"serial":@"trainingConference",@"name":SIMLocalizedString(@"ConfModelTrainingConferenceTitle", nil),@"detail":SIMLocalizedString(@"ConfModelTrainingConferenceDetail", nil)}];
//        [_chooseArr addObject:model7];
//    }
    
    
    _repeatArr = @[SIMLocalizedString(@"MArrangeConfRepeat_Never", nil),SIMLocalizedString(@"MArrangeConfRepeat_Day", nil),SIMLocalizedString(@"MArrangeConfRepeat_Week", nil),SIMLocalizedString(@"MArrangeConfRepeat_TwoWeek", nil),SIMLocalizedString(@"MArrangeConfRepeat_Month", nil)];
}
- (void)setSerialStr:(NSInteger)serialStr {
    _serialStr = serialStr;
    if (self.arrangeConf == nil) {// 安排
        if (_serialStr == 10001) {
            serialIndex = 0;
        }else if (_serialStr == 10002) {
            serialIndex = 1;
        }else if (_serialStr == 10003) {
            serialIndex = 2;
        }else if (_serialStr == 10004) {
            serialIndex = 3;
        }else if (_serialStr == 10005) {
            serialIndex = 4;
        }else if (_serialStr == 10006) {
            serialIndex = 5;
        }else if (_serialStr == 10007) {
            serialIndex = 0;
        }else if (_serialStr == 10008) {
            serialIndex = 0;
        }
        
    }
    
}
- (void)deflautConfModelSerailIndex {
    if (self.arrangeConf == nil && _serialStr == 0) {// 安排并且不是固定模式
        // 按照后台开关接口里配置项
        if ([self.cloudVersion.defaultConfMode isEqualToString:@"freeCamera"]) {
            serialIndex = 0;
        }else if ([self.cloudVersion.defaultConfMode isEqualToString:@"mainBroadcast"]) {
            serialIndex = 1;
        }else if ([self.cloudVersion.defaultConfMode isEqualToString:@"mainCamera"]) {
            serialIndex = 2;
        }else if ([self.cloudVersion.defaultConfMode isEqualToString:@"intercom"]) {
            serialIndex = 3;
        }else if ([self.cloudVersion.defaultConfMode isEqualToString:@"EHSfieldOperation"]) {
            serialIndex = 4;
        }else if ([self.cloudVersion.defaultConfMode isEqualToString:@"voiceSeminar"]) {
            serialIndex = 5;
        }else if ([self.cloudVersion.defaultConfMode isEqualToString:@"trainingConference"]) {
            serialIndex = 0;
        }
        
    }
}
@end


