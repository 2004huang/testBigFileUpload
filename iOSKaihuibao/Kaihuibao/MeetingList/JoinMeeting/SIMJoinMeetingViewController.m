//
//  SIMJoinMeetingViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/5/22.
//  Copyright © 2017年 Ferris. All rights reserved.
//
#define Start_X 10.0f + (screen_width - Button_Width * 4 - 20)/5           // 第一个按钮的X坐标
#define Start_Y 70.0f          // 第一个按钮的Y坐标
#define Width_Space (screen_width - Button_Width * 4 - 20)/5        // 2个按钮之间的横间距
#define Height_Space 15.0f      // 竖间距
#define Button_Height 75.0f    // 高
#define Button_Width 70.0f      // 宽

#import "SIMJoinMeetingViewController.h"

#import "SIMBaseInputTableViewCell.h"
#import "SIMBaseSwitchTableViewCell.h"
#import "SIMJoinNumTF.h"
#import "SIMMeetBtn.h"
#import "SIMShareTool.h"

@interface SIMJoinMeetingViewController () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,CLConferenceDelegate>
{
    // 更新过加入会议
    SIMBaseInputTableViewCell* _meetingNumberCell;
//    SIMBaseInputTableViewCell* _passWCell;
    SIMBaseInputTableViewCell* _nickNameCell;
//    SIMBaseSwitchTableViewCell* _unAutoAudioCell;
    SIMBaseSwitchTableViewCell* _closeVedioCell;
    
    NSInteger i;//定义全局变量
    UIView *_backView;
    UIToolbar *pickerDateToolbar;
    UITextField * passwordfiled;
    UIButton* _joinMeetingBT;
    UIButton* _downBT;
    UIPickerView *pickerView;
    NSMutableArray * listAry;
    
    NSString *sss;
    BOOL isScroll;
    UIButton* button;
}
@property (nonatomic,strong) SIMBaseTableView* tableView;
@property (nonatomic,strong) NSString *pasteStr;
@property (nonatomic,strong) NSString *string;
@property (nonatomic,assign) BOOL isHaveStr;
@property (nonatomic,strong) NSMutableArray *arrM;
@end

@implementation SIMJoinMeetingViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [_meetingNumberCell.joinTextfield becomeFirstResponder];
//    [self setUpCells];// 每次进入界面都刷新界面 为了退出视频回来界面依然更新 暂无回调所以写在这里
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"JoinTheMeetingDic"] != nil) {
        _downBT.hidden = NO;
    }else {
        _downBT.hidden = YES;
    }
    [self pickviewsDataSource];
//    [self.tableView reloadData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pickviewsDataSource];
    
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    [self.view addSubview:self.tableView];
    
    if ([self.navigationController isKindOfClass:[SIMBaseWhiteNavigationViewController class]]) {
        UIBarButtonItem* cancel = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"NavBackCancelTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
        cancel.tintColor = BlueButtonColor;
        self.navigationItem.leftBarButtonItem = cancel;
    }
    [self setUpCells];
    [self.tableView reloadData];
    [self addPickViews];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(posted:) name:UIMenuControllerWillHideMenuNotification object:nil];
}
- (void)cancelBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setUpCells
{
    _meetingNumberCell = [[SIMBaseInputTableViewCell alloc] initTwoTextF];
    _meetingNumberCell.joinTextfield.delegate = self;
    NSString *placeStr;
    if (self.isVideoServce) {
        placeStr = @"视频客服会议ID";
    }else {
        placeStr = SIMLocalizedString(@"MPutinConfIDPlaceHolderID", nil);
    }
    _meetingNumberCell.joinTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
//    [_meetingNumberCell.joinTextfield setValue:FontRegularName(16) forKeyPath:@"_placeholderLabel.font"];
    
    _meetingNumberCell.placeHolderTwoStr = placeStr;
    
    _meetingNumberCell.joinTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [_meetingNumberCell.joinTextfield addTarget:self action:@selector(textFieldDidEditing:) forControlEvents:UIControlEventEditingChanged];
    
    
    _nickNameCell = [[SIMBaseInputTableViewCell alloc] init];
    _nickNameCell.placeHolderStr = SIMLocalizedString(@"MJoinNamePlaceHolder", nil);
    _nickNameCell.textfield.delegate = self;
    [_nickNameCell.textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //  当用户没有昵称的时候 为设备名字
    if (self.currentUser.nickname != nil) {
        _nickNameCell.textfield.text = self.currentUser.nickname;
    }else {
        _nickNameCell.textfield.text = [UIDevice currentDevice].name;
    }
    _nickNameCell.textfield.font = FontRegularName(16);
    _nickNameCell.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nickNameCell.textfield.keyboardType = UIKeyboardTypeDefault;
    
    if (self.testCidRoom.length > 0) {
        _meetingNumberCell.joinTextfield.text = [NSString transTheConfIDWithSpaceToTheThreeApart:self.testCidRoom];
        _meetingNumberCell.joinTextfield.enabled = NO;
        if (!self.isVideoServce) {
            [_nickNameCell.textfield becomeFirstResponder];
        }
    }else {
        [_meetingNumberCell.joinTextfield becomeFirstResponder];
        // 布局界面的时候 判断本地有没有存储会议号 从而决定有没有下拉箭头
        _downBT = [[UIButton alloc] initWithFrame:CGRectMake(screen_width-kWidthS(30) - 30, 5, 30, 30)];
        [_downBT setImage:[UIImage imageNamed:@"join_gd"] forState:UIControlStateNormal];
        
        [_downBT addTarget:self action:@selector(downClick) forControlEvents:UIControlEventTouchUpInside];
        [_meetingNumberCell addSubview:_downBT];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"JoinTheMeetingDic"] != nil) {
            _downBT.hidden = NO;
        }else {
            _downBT.hidden = YES;
        }
    }
    
    
//    _unAutoAudioCell = [[SIMBaseSwitchTableViewCell alloc] init];
//    _unAutoAudioCell.switchButton.on = YES;
//    _unAutoAudioCell.titleLab.font = FontMediumName(16);
    
    _closeVedioCell = [[SIMBaseSwitchTableViewCell alloc] init];
    _closeVedioCell.switchButton.on = YES;
    _closeVedioCell.titleLab.font = FontMediumName(16);
    if (self.isLive) {
//        _unAutoAudioCell.titleLab.text = SIMLocalizedString(@"MJoinLiveTakeOnVoiceSwitch", nil);
        _closeVedioCell.titleLab.text = SIMLocalizedString(@"MJoinLiveTakeOnVideoSwitch", nil);
    }else {
//        _unAutoAudioCell.titleLab.text = SIMLocalizedString(@"MJoinTakeOnVoiceSwitch", nil);
        _closeVedioCell.titleLab.text = SIMLocalizedString(@"MJoinTakeOnVideoSwitch", nil);
    }
    
}

#pragma mark - UITextFieldDelegate
//- (void)paste:(UIMenuController *)menu
//{
//    NSLog(@"粘贴板的点击事件");
////    UIPasteboard *board = [UIPasteboard generalPasteboard];
//    _string = [UIPasteboard generalPasteboard].string;
//    if (_string.length > 0) {
//        NSString *tem = [[_string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
//        NSString *cutStr;
//        if (tem.length > 10) {
//            cutStr = [tem substringToIndex:11];
//        }else {
//            cutStr = tem;
//        }
//        _pasteStr = [NSString transTheConfIDWithSpaceToTheThreeApart:cutStr];
//
//    }
//}
- (void)posted:(NSNotification*)ss{
    NSLog(@"粘贴板的改变了1");
    if (_meetingNumberCell.joinTextfield.pasteStr.length > 0) {
//        _meetingNumberCell.joinTextfield.text = _pasteStr;
        _isHaveStr = YES;
        
        if (_meetingNumberCell.joinTextfield.pasteStr.length >= 11 && _nickNameCell.textfield.text.length > 0) {
            _joinMeetingBT.enabled = YES;
            _joinMeetingBT.backgroundColor = BlueButtonColor;
        }else {
            _joinMeetingBT.enabled = NO;
            _joinMeetingBT.backgroundColor = EnableButtonColor;
        }
        NSLog(@"hhhhstringstring %@ %@",_meetingNumberCell.joinTextfield.text,_nickNameCell.textfield.text);
    }
}
//- (void)postedHide:(NSNotification*)ss{
//    NSLog(@"粘贴板的改变了2");
//    NSLog(@"patestringstring %@",_string);
//
//}
-(void)textFieldDidEditing:(UITextField *)textField{
    if (textField == _meetingNumberCell.joinTextfield) {
//        if (_isHaveStr == YES) {
//            _isHaveStr = NO;
//            return ;
//        }
        NSLog(@"hhhhstringstringtextFieldDidEditing %@",textField.text);
        if (textField.text.length > i) {
            if (textField.text.length <= 12) {
                if (textField.text.length == 4 || textField.text.length == 8) {//输入
                    NSMutableString * str = [[NSMutableString alloc ] initWithString:textField.text];
                    [str insertString:@" " atIndex:(textField.text.length-1)];
                    textField.text = str;
                }
                
            }else {
                // 因为原来会议号有11位的 有12位的  所以加上空格之后是13位和14位 这里不一一判断截取了 只要是大于12位的都自己截取吧
                textField.text = [textField.text substringToIndex:13];
                //                [textField resignFirstResponder];
                //                if (textField.text.length == 4 || textField.text.length == 9 ) {//输入
                NSString *tem = [[textField.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
                NSMutableString * str = [[NSMutableString alloc ] initWithString:tem];
                [str insertString:@" " atIndex:3];
                [str insertString:@" " atIndex:8];
                textField.text = str;
                //                }
            }
//            if (textField.text.length >= 13 ) {//输入完成
//                textField.text = [textField.text substringToIndex:13];
//                [textField resignFirstResponder];
//            }
            i = textField.text.length;
            NSLog(@"lenghtstringstring %ld %@",i,textField.text);
        }else if (textField.text.length < i){//删除
            if (textField.text.length == 12) {
                
                NSString *tem = [[textField.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
//                NSString *textFieldStr =[textField.text stringByReplacingOccurrencesOfString:@" "withString:@""];
                NSMutableString * str = [[NSMutableString alloc ] initWithString:tem];
                [str insertString:@" " atIndex:3];
                [str insertString:@" " atIndex:7];
                textField.text = str;
            }
            if (textField.text.length == 4 || textField.text.length == 8) {
                textField.text = [NSString stringWithFormat:@"%@",textField.text];
                textField.text = [textField.text substringToIndex:(textField.text.length-1)];
            }
            i = textField.text.length;
        }
    }
}
// 点击圆叉按钮的方法 当一键清除了会议号文本框那么 加入按钮也置灰
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField == _meetingNumberCell.joinTextfield || textField == _nickNameCell.textfield) {
        _joinMeetingBT.enabled = NO;
        _joinMeetingBT.backgroundColor = EnableButtonColor;
    }return YES;
}

// 随输入文字动态判断
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _meetingNumberCell.joinTextfield) {
//        if (_isHaveStr == YES) {
//            _isHaveStr = NO;
//            return NO;
//        }
        NSLog(@"hhhhstringreplacementString %@",textField.text);
        [self validateNumber:string];
        if (button.isSelected == YES) {
            _meetingNumberCell.joinTextfield.text = [textField.text substringToIndex:0];
            return NO;
        }
        // 过滤空格
        NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
        if (![string isEqualToString:tem]) {
            return NO;
        }
        // 当会议号大于9 加入会议按钮可点 最多输入11位 --- 改了 现在最多还是9位 但是为了兼容以前的11位的
        NSUInteger length = textField.text.length - range.length + string.length;
        if (length >= 11 && _nickNameCell.textfield.text.length > 0) {//length >= 9
            _joinMeetingBT.enabled = YES;
            _joinMeetingBT.backgroundColor = BlueButtonColor;
        }else {
            _joinMeetingBT.enabled = NO;
            _joinMeetingBT.backgroundColor = EnableButtonColor;
            
        }
    }else if(textField == _nickNameCell.textfield) {
        NSUInteger length = textField.text.length - range.length + string.length;
        if (length > 0 && _meetingNumberCell.joinTextfield.text.length >= 11) {
            _joinMeetingBT.enabled = YES;
            _joinMeetingBT.backgroundColor = BlueButtonColor;
        }else {
            _joinMeetingBT.enabled = NO;
            _joinMeetingBT.backgroundColor = EnableButtonColor;
        }
    }
//    else if(textField == _passWCell.textfield){
//        // 密码为6位 只限中文和英文
//        if (range.length == 1 && string.length == 0) {
//            return YES;
//        }else if (_passWCell.textfield.text.length >= 6) {
//            _passWCell.textfield.text = [textField.text substringToIndex:6];
//            return NO;
//        }
//
//    }
    return YES;
}
#pragma mark - UITextFieldClick
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _nickNameCell.textfield) {
        [self subStringAllMethod:textField withLength:kMinLength];
//        NSString *toBeString = textField.text;
//        NSString *lang = [[textField textInputMode] primaryLanguage]; // 获取当前键盘输入模式
//        if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入,第三方输入法（搜狗）所有模式下都会显示“zh-Hans”
//            UITextRange *selectedRange = [textField markedTextRange];
//            //获取高亮部分
//            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//            //没有高亮选择的字，则对已输入的文字进行字数统计和限制
//            if(!position) {
//                NSString *getStr = [self getSubString:toBeString withLength:kMinLength];
//                if(getStr && getStr.length > 0) {
//                    textField.text = getStr;
//                }
//            }
//        }else{
//            NSString *getStr = [self getSubString:toBeString withLength:kMinLength];
//            if(getStr && getStr.length > 0) {
//                textField.text= getStr;
//            }
//        }
    }
    
}
- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
#pragma mark - UITableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 20)];
        UILabel* promptLabel = [[UILabel alloc] init];
        promptLabel.frame = CGRectMake(15, 0, screen_width, 20);
        promptLabel.text = SIMLocalizedString(@"MJoinMeetingChoose", nil);
        promptLabel.textAlignment = NSTextAlignmentLeft;
        promptLabel.textColor = TableViewHeaderColor;
        promptLabel.font = FontRegularName(12);
        [headView addSubview:promptLabel];
        return headView;
    }
    else
    {
        return nil;
    }
}
- (void)changeBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (!sender.selected) {
        [_meetingNumberCell.joinTextfield resignFirstResponder];
        _meetingNumberCell.joinTextfield.text = @"";
        _meetingNumberCell.joinTextfield.placeholder = SIMLocalizedString(@"MPutinConfIDPlaceHolderID", nil);
        _meetingNumberCell.joinTextfield.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [_meetingNumberCell.joinTextfield becomeFirstResponder];
    }else {
        [_meetingNumberCell.joinTextfield resignFirstResponder];
        _meetingNumberCell.joinTextfield.text = @"";
        _meetingNumberCell.joinTextfield.placeholder = SIMLocalizedString(@"MPutinConfIDPlaceHolderRoom", nil);
        _meetingNumberCell.joinTextfield.keyboardType = UIKeyboardTypeDefault;
        [_meetingNumberCell.joinTextfield becomeFirstResponder];
    }
    if (_meetingNumberCell.joinTextfield.text.length>0) {
        _joinMeetingBT.enabled = YES;
        _joinMeetingBT.backgroundColor = BlueButtonColor;
    }else {
        _joinMeetingBT.enabled = NO;
        _joinMeetingBT.backgroundColor = EnableButtonColor;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section==0)
    {
        UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 30)];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:SIMLocalizedString(@"MJoinMeetingTypeRoom", nil) forState:UIControlStateNormal];
        [button setTitle:SIMLocalizedString(@"MJoinMeetingTypeID", nil) forState:UIControlStateSelected];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = FontRegularName(15);
        [button setTitleColor:BlueButtonColor forState:UIControlStateNormal];
        [footerView addSubview:button];
//        [button addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
        return footerView;
    }
    else if(section==1)
    {
        UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 100)];
//        footerView.backgroundColor = [UIColor clearColor];
        _joinMeetingBT = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (self.isVideoServce) {
            [_joinMeetingBT setTitle:@"进入视频客服" forState:UIControlStateNormal];
        }else {
            [_joinMeetingBT setTitle:SIMLocalizedString(@"MJoinTheMeeting", nil) forState:UIControlStateNormal];
        }
        
        [_joinMeetingBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_joinMeetingBT setTitle:SIMLocalizedString(@"MJoinTheMeeting", nil) forState:UIControlStateDisabled];
        [_joinMeetingBT setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
        [_joinMeetingBT setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
        [_joinMeetingBT setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_joinMeetingBT addTarget:self action:@selector(joinMeetBtn) forControlEvents:UIControlEventTouchUpInside];
        _joinMeetingBT.titleLabel.font = FontRegularName(17);
//        if (_meetingNumberCell.joinTextfield.text.length>0) {
//            _joinMeetingBT.enabled = YES;
//            _joinMeetingBT.backgroundColor = BlueButtonColor;
//        }else {
//            _joinMeetingBT.enabled = NO;
//            _joinMeetingBT.backgroundColor = EnableButtonColor;
//        }
        if (self.testCidRoom.length > 0) {
            _joinMeetingBT.enabled = YES;
            _joinMeetingBT.backgroundColor = BlueButtonColor;
        }else {
            _joinMeetingBT.enabled = NO;
            _joinMeetingBT.backgroundColor = EnableButtonColor;
        }
        _joinMeetingBT.layer.masksToBounds = YES;
        _joinMeetingBT.layer.cornerRadius = 11;
        [footerView addSubview:_joinMeetingBT];
        UILabel* promptLabel = [[UILabel alloc] init];
        [promptLabel setText:SIMLocalizedString(@"MJoinMeetingExplainText2", nil)];
        promptLabel.numberOfLines = 0;
        promptLabel.textAlignment = NSTextAlignmentLeft;
        promptLabel.font = FontRegularName(12);
        promptLabel.textColor = GrayPromptTextColor;
        [footerView addSubview:promptLabel];
        [_joinMeetingBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(44);
        }];
        [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(_joinMeetingBT.mas_bottom).offset(20);
        }];
        return footerView;
        
    }else if (section == 2 && self.isVideoServce) {
        UIView *view = [self addFooterArr];
        return view;
    }else {
        return nil;
    }
}
- (UIView *)addFooterArr {
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 200)];
    UILabel* promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, screen_width - 40, 50)];
    [promptLabel setText:SIMLocalizedString(@"ShareVideoServceText", nil)];
    promptLabel.numberOfLines = 0;
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = FontRegularName(12);
    promptLabel.textColor = GrayPromptTextColor;
    [footerView addSubview:promptLabel];
    
    _arrM = [NSMutableArray array];
    if ([self.cloudVersion.wechat boolValue]) {
        [_arrM addObject:@{@"title":SIMLocalizedString(@"WeChatSend", nil),@"icon":@"wechatSend",@"serial":@"1001"}];
    }
    if ([self.cloudVersion.email boolValue]) {
        [_arrM addObject:@{@"title":SIMLocalizedString(@"NewEmailSend", nil),@"icon":@"mail",@"serial":@"1002"}];
    }
    if ([self.cloudVersion.message boolValue]) {
        [_arrM addObject:@{@"title":SIMLocalizedString(@"NewMessageSend", nil),@"icon":@"SMS",@"serial":@"1003"}];
    }
    if ([self.cloudVersion.pasteBoard boolValue]) {
        [_arrM addObject:@{@"title":SIMLocalizedString(@"PaseboardSend", nil),@"icon":@"link",@"serial":@"1004"}];
    }
    
    if (_arrM.count > 0) {
        for (int i = 0 ; i < _arrM.count; i++) {
            NSInteger index = i % 4;
            NSInteger page = i / 4;
            
            // 按钮
            SIMMeetBtn *aBt = [[SIMMeetBtn alloc] init];
            aBt.backgroundColor = TableViewBackgroundColor;
            [aBt setTitle:[_arrM[i] objectForKey:@"title"] forState:UIControlStateNormal];
            [aBt setImage:[UIImage imageNamed:[_arrM[i] objectForKey:@"icon"]] forState:UIControlStateNormal];
            aBt.imageView.contentMode = UIViewContentModeCenter;
            aBt.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
            
            aBt.titleLabel.font = FontRegularName(14);
            aBt.titleLabel.textAlignment = NSTextAlignmentCenter;
            [aBt setTitleColor:ZJYColorHex(@"#6b6868") forState:UIControlStateNormal];
            [footerView addSubview:aBt];
            aBt.tag = [[_arrM[i] objectForKey:@"serial"] integerValue];
            [aBt addTarget:self action:@selector(aBtClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return footerView;
}
- (void)aBtClick:(UIButton *)sender {
    
    NSString *shareUrlStr = [NSString stringWithFormat:@"%@/admin/conference/joinmeeting?m=%@&ref=%@&timetap=%@",kApiBaseUrl,self.testCidRoom,[NSString stringWithFormat:@"iOS%@",getApp_Version],[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]];
    NSString *shareContent = [NSString stringWithFormat:@"%@ %@ %@",@"视频客服会议：点击",shareUrlStr,@"视频会议链接，快速了解开会模式。"];
    if (sender.tag == 1001) {
        NSString *messStr = [NSString stringWithFormat:@"%@ %@ ",self.testCidRoom,@"视频客服会议室 点击即可开启或加入"];
        
        NSString *titleStr = [NSString stringWithFormat:@"\n%@ %@ %@",self.currentUser.nickname,SIMLocalizedString(@"MMessageWechatTitle", nil),@"视频客服会议，助你快速了解会议模式"];
        
        [[SIMShareTool shareInstace] shareToWeChatWithShareStr:messStr shareImage:@"share_meeting" urlStr:shareUrlStr ShareTitle:titleStr];
        
    }else if (sender.tag == 1002) {
        // 邮件邀请
        [self sendEmailActiontitle:shareContent viewController:self];// 调用发送邮件
    }else if (sender.tag == 1003) {
//        [[SIMShareTool shareInstace] showMessageViewbody:shareContent viewController:self];// 调用发送短信
        [self showMessageViewbody:shareContent viewController:self];
    }else if (sender.tag == 1004) {
        [[SIMShareTool shareInstace] sendPasteboardActiontitle:shareContent];// 调用复制到剪贴板
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        default:
            return 1;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 15;
            break;
        case 1:
            return 15;
            break;
        case 2:
            return 30;
            break;
        default:
            return CGFLOAT_MIN;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 40;
            break;
        case 1:
            return 120;
            break;
        case 2:
            return 200;
            break;
        default:
            return CGFLOAT_MIN;
            break;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        return _meetingNumberCell;
    }
    else if (indexPath.section==1)
    {
        return _nickNameCell;
    }
    else if (indexPath.section==2)
    {
        return _closeVedioCell;
    }else {
        return nil;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
// 进会
- (void)joinMeetBtn {
    [_meetingNumberCell.joinTextfield resignFirstResponder];
    [_nickNameCell.textfield resignFirstResponder];
    
    if (!_nickNameCell.textfield.text.length) {
        [MBProgressHUD cc_showFail:SIMLocalizedString(@"MJoinNamePlaceHolder", nil)];
        return;
    }
    NSString *cidText = _meetingNumberCell.joinTextfield.text;
    // 过滤空格
    NSString *noSpaceCidText = [[cidText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    
    NSString *webStr;
    if (self.webUrlStr != nil && self.webUrlStr.length > 0) {
        webStr = self.webUrlStr;
    }else {
        webStr = @"";
    }
    
    if ([self.navigationController isKindOfClass:[SIMBaseWhiteNavigationViewController class]]) {
        if (self.isJoinPage) {
            [SIMNewEnterConfTool enterTheMineConfWithCid:noSpaceCidText webstr:webStr nickname:_nickNameCell.textfield.text confType:EnterConfTypeConf isJoined:YES  needOpenLocalAudio:YES needOpenLocalVideo:_closeVedioCell.switchButton.isOn viewController:self success:^(id  _Nonnull success) {
            } failure:^(id  _Nonnull failure) {
            } cidMessage:^(NSDictionary * _Nonnull confMessageDic) {
                if (confMessageDic != nil) {
                    [self enterSuccessSaveTheData:confMessageDic];
                }
            }];
        }else {
            [SIMNewEnterConfTool quickEnterTheMineConfWithCid:noSpaceCidText psw:webStr name:_nickNameCell.textfield.text confType:EnterConfTypeConf  needOpenLocalAudio:YES needOpenLocalVideo:_closeVedioCell.switchButton.isOn viewController:self success:^(id  _Nonnull success) {
            } failure:^(id  _Nonnull failure) {
            } cidMessage:^(NSDictionary * _Nonnull confMessageDic) {
                if (confMessageDic != nil) {
                    [self enterSuccessSaveTheData:confMessageDic];
                }
            }];
        }
        
    }else {
        [SIMNewEnterConfTool enterTheMineConfWithCid:noSpaceCidText webstr:webStr  nickname:_nickNameCell.textfield.text confType:EnterConfTypeConf isJoined:YES  needOpenLocalAudio:YES needOpenLocalVideo:_closeVedioCell.switchButton.isOn viewController:self success:^(id  _Nonnull success) {
        } failure:^(id  _Nonnull failure) {
        } cidMessage:^(NSDictionary * _Nonnull confMessageDic) {
            if (confMessageDic != nil) {
                [self enterSuccessSaveTheData:confMessageDic];
            }
        }];
    }
}
// 保存成功进入的会议号
- (void)enterSuccessSaveTheData:(NSDictionary *)confMessage {
    NSString *cidStr = confMessage[@"conf_id"];
    NSString *nameStr = confMessage[@"name"];
    NSArray *tempArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"JoinTheMeetingDic"];
    NSMutableArray *dictempArr = [NSMutableArray arrayWithArray:tempArr];
    for (NSDictionary *dd in tempArr) {
        if ([dd[@"conf_id"] isEqualToString:cidStr]) {
            [dictempArr removeObject:dd];
        }
    }
    NSDictionary *newDic = @{@"conf_id":cidStr,@"nameStr":nameStr};
    [dictempArr insertObject:newDic atIndex:0];
    // 判断数组如果包含该会议号 那么久移除掉 为了之后的插入
    // 添加时候筛选重复的 查询时候也要筛选重复的 这样保证了以前的用户重复的没有过滤掉
//    if ([dictempArr containsObject:cidStr]) {
//        [dictempArr removeObject:cidStr];
//    }
    // 包不包含该会议号 都需要将该会议号插入到第一位 不包含直接插入 包含则先删除在插入 带着空格添加进去zoom也是这样的
//    [nowArr insertObject:cidStr atIndex:0];
    // 将新数组存到userdefaults
    [[NSUserDefaults standardUserDefaults] setObject:dictempArr forKey:@"JoinTheMeetingDic"];
    NSLog(@"dictempArrdictempArr %@",dictempArr);

}

- (void)pickviewsDataSource {
    NSArray *tempArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"JoinTheMeetingDic"];
    listAry = [NSMutableArray arrayWithArray:tempArr];
    NSLog(@"listArylistAry %@",listAry);
//    for (NSDictionary *dd in tempArr) {
//        NSString *spaceStr = [NSString transTheConfIDWithSpaceToTheThreeApart:dd[@"conf_id"]];
//        [dictempArr removeObject:dd];
//    }
//
//    for (NSString *cidStr in tempArr) {
//        NSString *spaceStr = [NSString transTheConfIDWithSpaceToTheThreeApart:cidStr];
//        [listAry addObject:spaceStr];
//    }
    [pickerView reloadAllComponents];
}
- (void)addPickViews {
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screen_height - 280, screen_width, 216)];
    pickerView.backgroundColor = [UIColor whiteColor];
    // 显示选中框
    pickerView.showsSelectionIndicator=YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [pickerView selectRow:0 inComponent:0 animated:YES];
    // 添加按钮
    pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, screen_height - 324, screen_width, 44)];
    [pickerDateToolbar sizeToFit];
    pickerDateToolbar.barTintColor = ZJYColorHex(@"#f7f7f7");
    pickerDateToolbar.tintColor = BlueButtonColor;
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"PickViewCleanAllCid", nil) style:UIBarButtonItemStylePlain target:self action:@selector(toolBarCanelClick)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"PickViewDone", nil) style:UIBarButtonItemStylePlain target:self action:@selector(toolBarDoneClick)];
    [pickerDateToolbar setItems:@[cancelBtn,flexSpace,doneBtn] animated:NO];
}
- (void)show {
    [_meetingNumberCell.joinTextfield resignFirstResponder];
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, StatusNavH, screen_width, screen_height-StatusNavH)];
    _backView.backgroundColor = ZJYColorHexWithAlpha(@"#949494", 0.4);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 添加到窗口
    [window addSubview:_backView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [_backView addGestureRecognizer:tap];
    [_backView addSubview:pickerView];
    [pickerView selectRow:0 inComponent:0 animated:YES];
    [_backView addSubview:pickerDateToolbar];
    [UIView animateWithDuration:0.25f animations:^{
        pickerDateToolbar.frame=CGRectMake(0, screen_height - 324, screen_width, 44);
        pickerView.frame = CGRectMake(0, screen_height - 280, screen_width, 216);
    }];
}
-(void)hidden{
    [UIView animateWithDuration:0.25f animations:^{
        pickerView.frame=CGRectMake(0, screen_height, screen_width, 216);
        pickerDateToolbar.frame = CGRectMake(0, screen_height, screen_width, 44);
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        [pickerView removeFromSuperview];
        [pickerDateToolbar removeFromSuperview];
    }];
}
-(void)toolBarCanelClick{
    // 清除所有的会议记录
    [listAry removeAllObjects];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"JoinTheMeetingDic"];
    [self hidden];
    _downBT.hidden = YES;
}
// 点击确认
-(void)toolBarDoneClick{
    
    _joinMeetingBT.enabled = YES;
    _joinMeetingBT.backgroundColor = BlueButtonColor;
    [_meetingNumberCell.joinTextfield resignFirstResponder];
    [_nickNameCell.textfield becomeFirstResponder];
    if (button.isSelected == YES) {
        button.selected = NO;
        _meetingNumberCell.joinTextfield.text = @"";
//        _meetingNumberCell.joinTextfield.enabled = YES;
        _meetingNumberCell.joinTextfield.placeholder = SIMLocalizedString(@"MPutinConfIDPlaceHolderID", nil);
        _meetingNumberCell.joinTextfield.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    if (isScroll == NO) {
        NSDictionary *nowDic = listAry[0];
        NSString *spaceStr = [NSString transTheConfIDWithSpaceToTheThreeApart:nowDic[@"conf_id"]];
        sss = spaceStr;
    }else {
        isScroll = NO;
    }
    _meetingNumberCell.joinTextfield.text = sss;
    [self hidden];
    
}
- (void)tapClick {
    [self hidden];
//    [self toolBarDoneClick];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hidden];
}
#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return screen_width;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return listAry.count;
}
#pragma Mark -- UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSDictionary *nowDic = [listAry objectAtIndex:row];
    NSString *spaceStr = [NSString transTheConfIDWithSpaceToTheThreeApart:nowDic[@"conf_id"]];
    sss = spaceStr;
//    _meetingNumberCell.joinTextfield.text = sss;
//    _joinMeetingBT.enabled = YES;
//    _joinMeetingBT.backgroundColor = BlueButtonColor;
    isScroll = YES;
}
//-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return [listAry objectAtIndex:row];
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSDictionary *nowDic = [listAry objectAtIndex:row];
    CGFloat width = screen_width;
    CGFloat rowheight = 40;
    
    UIView *pickCell = view;
    if (!pickCell) {
        pickCell = [[UIView alloc] init];
        pickCell.frame = CGRectMake(0.0f, 0.0f, width, rowheight);
        
        UILabel *namelabel = [[UILabel alloc] init];
        namelabel.textColor = [UIColor blackColor];
        namelabel.font = FontRegularName(18);
        namelabel.textAlignment  = NSTextAlignmentLeft;
        namelabel.text = nowDic[@"nameStr"];
        NSLog(@"nowDicnowDic %@",nowDic);
        
        UILabel *cidlabel = [[UILabel alloc] init];
        cidlabel.textColor = BlackTextColor;
        cidlabel.font = FontRegularName(18);
        cidlabel.textAlignment  = NSTextAlignmentRight;
        NSString *spaceStr = [NSString transTheConfIDWithSpaceToTheThreeApart:nowDic[@"conf_id"]];
        cidlabel.text = spaceStr;
        [pickCell addSubview:namelabel];
        [pickCell addSubview:cidlabel];
        [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(rowheight);
        }];
        [cidlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(rowheight);
        }];
    }
    return pickCell;
}
- (void)downClick {
    [_meetingNumberCell.joinTextfield resignFirstResponder];
//    [_passWCell.textfield resignFirstResponder];
    [_nickNameCell.textfield resignFirstResponder];
    [self show];
}

#pragma mark -UITextField Delegate Method
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



@end
