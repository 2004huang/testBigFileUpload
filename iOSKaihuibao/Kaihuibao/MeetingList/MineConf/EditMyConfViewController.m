//
//  EditMyConfViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/24.
//  Copyright © 2017年 Ferris. All rights reserved.
//
#define kAlphaNum  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

#import "EditMyConfViewController.h"
#import "SIMConfDocModel.h"

#import "SIMBaseCommonTableViewCell.h"
#import "SIMBaseSwitchTableViewCell.h"

#import "SIMConfRoomViewController.h"
#import "SIMConfModelViewController.h"
#import "SIMConfDocSelectViewController.h"

//#import "SIMJPickerView.h"


@interface EditMyConfViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SIMConfRoomViewdelegate,ConfModelDelegate,ConfDocSelectDelegate>
{
    SIMBaseCommonTableViewCell * _confIDCell;
    SIMBaseCommonTableViewCell * _confNameCell;
    SIMBaseCommonTableViewCell *_passwordCell;
    SIMBaseCommonTableViewCell *_mainPSWCell;
    
    NSArray<NSArray<UITableViewCell*>*>* _cells;
    BOOL editBtnOnce;
    
}
@property (nonatomic, strong) SIMBaseCommonTableViewCell *confModelCell;
@property (nonatomic, strong) SIMBaseCommonTableViewCell *confDocCell;
@property (nonatomic, strong) SIMBaseSwitchTableViewCell *hostManVideoCell;
//@property (nonatomic, strong) SIMBaseSwitchTableViewCell *hostManAudioCell;
@property (nonatomic, strong) SIMBaseSwitchTableViewCell *joinManVideoCell;
//@property (nonatomic, strong) SIMBaseSwitchTableViewCell *joinManAudioCell;
@property (nonatomic, strong) NSString *chooseConfModel;
@property (nonatomic,strong) SIMBaseTableView* tableView;
@property (nonatomic, strong) NSMutableArray *chooseArr;
@property (nonatomic, strong) NSArray *docIDArr;
//@property(nonatomic, strong) SIMJPickerView *pickerView;

@end

@implementation EditMyConfViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _confNameCell.promptLabel.text = self.myConf.name;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickViewWillChangeFrame:) name:@"pickviewWillChange" object:nil];
    
    self.title = SIMLocalizedString(@"MEditMineMeeting", nil);
//    _chooseArr = [NSMutableArray arrayWithObjects:@"自由视角",@"与主持人广播视频一致",@"与主持人视角一致",@"对讲模式", nil];
    [self addDatas];
    
    editBtnOnce = YES;
    [self setUpCells];
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    [self.view addSubview:self.tableView];
    
    // 点击导航栏完成按钮
    UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"NavBackComplete", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnClick)];
    self.navigationItem.rightBarButtonItem = done;
    
    UIBarButtonItem* cancel = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"NavBackCancelTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    self.navigationItem.leftBarButtonItem = cancel;
    
}
- (void)cancelBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)doneBtnClick {
    if (editBtnOnce == YES) {
        editBtnOnce = NO;
        // 直播不可以编辑提交 所以为no是会议可以
        [self requestData];// 点击完成 发送数据
    }
}
- (void)setUpCells
{
    
    NSString *idStr;
    NSString *nameStr;
    NSString *pswStr;
    NSString *idstring;
//    if (self.isLive) {
//        // 直播
//        idStr = SIMLocalizedString(@"MEMineLiveID", nil);
//        nameStr = SIMLocalizedString(@"MEMineLiveName", nil);
//        pswStr = SIMLocalizedString(@"MEMineLivePSW", nil);
//        idstring = self.myConf.live_id;
//
//    }else {// 会议
        idStr = SIMLocalizedString(@"MEMineConfID", nil);
        nameStr = SIMLocalizedString(@"MEMineConfName", nil);
        pswStr = SIMLocalizedString(@"MEMineConfPSW", nil);
        idstring = self.currentUser.self_conf;
//    }
    _confIDCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:idStr prompt:[NSString transTheConfIDToTheThreeApart:idstring]];
    _confIDCell.accessoryType = UITableViewCellAccessoryNone;
    _confIDCell.userInteractionEnabled = NO;
    
    _confNameCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:nameStr prompt:@"点击设置"];

    _passwordCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:pswStr putin:nil];
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
    
    _confModelCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"ConfModeTitle", nil) prompt:SIMLocalizedString(@"MArrangeStarChoose", nil)];
    _confDocCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"ConfDocTitle", nil) prompt:SIMLocalizedString(@"MArrangeStarChoose", nil)];
    // 将userdefaults里的编辑会议模型拿出来 是二进制 转化为字典 赋值给我的会议模型 用上也解析好的数据放在本地 本页使用本地赋值
//    NSData *daa  = [[NSUserDefaults standardUserDefaults] objectForKey:@"MYCONF"];
//    NSString *strin = [[NSString alloc] initWithData:daa encoding:NSUTF8StringEncoding];
//    NSData *datastr = [strin dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:datastr options:NSJSONReadingMutableLeaves error:nil];
//    _myConf = [[SIMMyConf alloc] initWithDictionary:dic];
    if (self.myConf != nil) {
        // 除了个人会议号 之外都是可改的
        _confNameCell.promptLabel.text = self.myConf.name;
        _passwordCell.putin.text = self.myConf.normalPassword;
        _mainPSWCell.putin.text = self.myConf.mainPassword;
        
        _confModelCell.promptLabel.text = self.myConf.confModeStr;
        
        NSMutableArray *namearr = [NSMutableArray array];
        NSMutableArray *idarr = [NSMutableArray array];
        for (SIMConfDocModel *model in self.myConf.confdocList) {
            [namearr addObject:model.name];
            [idarr addObject:model.docId];
        }
        _confDocCell.promptLabel.text = [namearr componentsJoinedByString:@","];
        NSLog(@"arrarr%@",[namearr componentsJoinedByString:@","]);
        _docIDArr = idarr;
        
        _hostManVideoCell.switchButton.on = self.myConf.mainVideo;
//        _hostManAudioCell.switchButton.on = self.myConf.mainAudio;
        _joinManVideoCell.switchButton.on = self.myConf.participantVideo;
//        _joinManAudioCell.switchButton.on = self.myConf.participantAudio;
        if ([self.myConf.confMode isEqualToString:@"intercom"]) {
            // 对讲模式
//            _hostManAudioCell.userInteractionEnabled = NO;
//            _hostManAudioCell.titleLab.textColor = GrayPromptTextColor;
            _hostManVideoCell.userInteractionEnabled = NO;
            _hostManVideoCell.titleLab.textColor = GrayPromptTextColor;
//            _joinManAudioCell.userInteractionEnabled = NO;
//            _joinManAudioCell.titleLab.textColor = GrayPromptTextColor;
            _joinManVideoCell.userInteractionEnabled = NO;
            _joinManVideoCell.titleLab.textColor = GrayPromptTextColor;
        }else if ([self.myConf.confMode isEqualToString:@"mainBroadcast"] || [self.myConf.confMode isEqualToString:@"mainCamera"]){
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
        
        self.chooseConfModel = self.myConf.confMode;
    
        
    }else {
        // 默认值
        _confNameCell.promptLabel.text = @"点击设置";
        _passwordCell.putin.text = nil;
        _hostManVideoCell.switchButton.on = YES;
//        _hostManAudioCell.switchButton.on = YES;
        _joinManVideoCell.switchButton.on = YES;
//        _joinManAudioCell.switchButton.on = YES;
        
        _confModelCell.promptLabel.text = [_chooseArr[0] name];
        self.chooseConfModel = [_chooseArr[0] serial];
    }
    if (self.cloudVersion.webFileUrl.length > 0) {
        _cells = @[@[_confIDCell,_confNameCell],@[_passwordCell,_mainPSWCell],@[_hostManVideoCell,_joinManVideoCell],@[_confModelCell,_confDocCell]];
    }else {
        _cells = @[@[_confIDCell,_confNameCell],@[_passwordCell,_mainPSWCell],@[_hostManVideoCell,_joinManVideoCell],@[_confModelCell]];
    }
    
    
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 15;
    }else {
        return 20;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (self.isLive) {
//        // 直播 都不可以点击 提示去会议室改
//        [MBProgressHUD cc_showText:@"请前去您的个人会议室编辑该条目"];
//    }else {
        // 会议可以正常
        if (indexPath.section == 0) {
            if (indexPath.row == 1) {
                // 会议室名称
                SIMConfRoomViewController *room = [[SIMConfRoomViewController alloc] init];
                room.myConf = self.myConf;
                room.delegate = self;// 遵守代理将设置的会议室名称传值回来
                [self.navigationController pushViewController:room animated:YES];
            }
        }else if (indexPath.section == 3) {
            
            if (indexPath.row == 0) {
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
//            self.pickerView.dataSource = _chooseArr;
//            if (self.myConf != nil) {
//                self.pickerView.selectStr = self.myConf.confModeStr;
//            }else {
//                self.pickerView.selectStr = _chooseArr[0];
//            }
//
//            [self.pickerView show];
//            __weak typeof(self) weakSelf = self;
//            self.pickerView.callBlock = ^(NSString * _Nonnull pickDate) {
//                weakSelf.confModelCell.promptLabel.text = pickDate;
//
//                if ([pickDate isEqualToString:weakSelf.chooseArr[0]]) {
//                    weakSelf.hostManAudioCell.userInteractionEnabled = YES;
//                    weakSelf.hostManAudioCell.titleLab.textColor = BlackTextColor;
//                    //                weakSelf.hostManAudioCell.switchButton.on = YES;
//                    weakSelf.hostManVideoCell.userInteractionEnabled = YES;
//                    weakSelf.hostManVideoCell.titleLab.textColor = BlackTextColor;
//                    //                weakSelf.hostManVideoCell.switchButton.on = YES;
//                    weakSelf.joinManAudioCell.userInteractionEnabled = YES;
//                    weakSelf.joinManAudioCell.titleLab.textColor = BlackTextColor;
//                    //                weakSelf.hostManVideoCell.switchButton.on = YES;
//                    weakSelf.joinManVideoCell.userInteractionEnabled = YES;
//                    weakSelf.joinManVideoCell.titleLab.textColor = BlackTextColor;
//                }else if ([pickDate isEqualToString:weakSelf.chooseArr[3]]) {
//                    weakSelf.hostManAudioCell.userInteractionEnabled = NO;
//                    weakSelf.hostManAudioCell.titleLab.textColor = GrayPromptTextColor;
//                    weakSelf.hostManAudioCell.switchButton.on = NO;
//                    weakSelf.hostManVideoCell.userInteractionEnabled = NO;
//                    weakSelf.hostManVideoCell.titleLab.textColor = GrayPromptTextColor;
//                    weakSelf.hostManVideoCell.switchButton.on = NO;
//                    weakSelf.joinManAudioCell.userInteractionEnabled = NO;
//                    weakSelf.joinManAudioCell.titleLab.textColor = GrayPromptTextColor;
//                    weakSelf.joinManAudioCell.switchButton.on = NO;
//                    weakSelf.joinManVideoCell.userInteractionEnabled = NO;
//                    weakSelf.joinManVideoCell.titleLab.textColor = GrayPromptTextColor;
//                    weakSelf.joinManVideoCell.switchButton.on = NO;
//                }else {
//                    weakSelf.hostManAudioCell.userInteractionEnabled = YES;
//                    weakSelf.hostManAudioCell.titleLab.textColor = BlackTextColor;
//                    //                weakSelf.hostManAudioCell.switchButton.on = YES;
//                    weakSelf.hostManVideoCell.userInteractionEnabled = YES;
//                    weakSelf.hostManVideoCell.titleLab.textColor = BlackTextColor;
//                    //                weakSelf.hostManVideoCell.switchButton.on = YES;
//                    weakSelf.joinManAudioCell.userInteractionEnabled = NO;
//                    weakSelf.joinManAudioCell.titleLab.textColor = GrayPromptTextColor;
//                    weakSelf.joinManAudioCell.switchButton.on = NO;
//                    weakSelf.joinManVideoCell.userInteractionEnabled = NO;
//                    weakSelf.joinManVideoCell.titleLab.textColor = GrayPromptTextColor;
//                    weakSelf.joinManVideoCell.switchButton.on = NO;
//                }
//            };
            
        }
//    }
}

// 设置会议  上传
- (void)requestData {
    
    // 传递参数字典
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    [dicM setValue:_confNameCell.promptLabel.text forKey:@"name"];
    [dicM setValue:_passwordCell.putin.text forKey:@"normalPassword"];
    if (_mainPSWCell.putin.text.length == 0) {
        [dicM setValue:@"abcd" forKey:@"mainPassword"];
    }else {
        [dicM setValue:_mainPSWCell.putin.text forKey:@"mainPassword"];//主席密码设置为默认
    }
    [dicM setValue:self.myConf.startTime forKey:@"startTime"];
    [dicM setValue:self.myConf.stopTime forKey:@"stopTime"];
    [dicM setValue:self.myConf.repeat forKey:@"repeat"];
    [dicM setValue:self.myConf.detail forKey:@"detail"];
    [dicM setValue:self.currentUser.self_conf forKey:@"cid"]; // 编辑的话 是要有这个cid的
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
//
    // 将数组转化成json 并过滤掉字符
//    if (_docIDArr.count > 0) {
        NSString *jsonString = [NSString ObjectTojsonString:_docIDArr];
        [dicM setValue:jsonString forKey:@"confdoc"];
//    }
    
    [dicM setObject:self.chooseConfModel forKey:@"confMode"];
    NSLog(@"editArragePutOnDic %@",dicM);
    
    // 正在加载框
    [MBProgressHUD cc_showLoading:nil];
    [MainNetworkRequest editConfListRequestParams:dicM success:^(id success) {
        NSLog(@"editArrageDic %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            
            [MBProgressHUD cc_showText:success[@"msg"]];
            // 保存到本地
            NSData * dat = [NSJSONSerialization dataWithJSONObject:dicM options:NSJSONWritingPrettyPrinted error:nil];
            [[NSUserDefaults standardUserDefaults] setObject:dat forKey:@"MYCONF"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 发送编辑个人会议的刷新列表的通知
            
            [[NSNotificationCenter defaultCenter] postNotificationName:EditConfSuccess object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:EditMyConfSuccess object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
        editBtnOnce = YES;
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
        editBtnOnce = YES;
    }];
}

// 传值代理方法
- (void)contentString:(NSString *)content {
    _confNameCell.promptLabel.text = content;
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
        // 对讲
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
        // 主持人
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
        // 自由and另两种
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
#pragma mark - UITextFieldClick
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _passwordCell.putin || textField == _mainPSWCell.putin) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
            [MBProgressHUD cc_showText:SIMLocalizedString(@"MEMineConfPSWLength", nil)];
        }
    }
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
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

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [_pickerView hidden];
//
//}
//
//// 选择器视图
//-(SIMJPickerView *)pickerView{
//    if (!_pickerView) {
//        _pickerView = [[SIMJPickerView alloc] init];
//    }
//    return _pickerView;
//}

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
//#pragma mark 监听键盘事件
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
    
}

@end
