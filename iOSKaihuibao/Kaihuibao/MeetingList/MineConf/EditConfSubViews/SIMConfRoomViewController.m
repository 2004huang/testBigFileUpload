//
//  SIMConfRoomViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/6/1.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMConfRoomViewController.h"
#import "SIMBaseInputTableViewCell.h"
@interface SIMConfRoomViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    
}
@property (nonatomic,strong) SIMBaseTableView* tableView;
@property (nonatomic,strong) SIMBaseInputTableViewCell* nickNameCell;
@property (nonatomic,strong) UIBarButtonItem* save;

@end

@implementation SIMConfRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"MEMineConfName", nil);
    [self setUpCells];
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    [self.view addSubview:self.tableView];
    
    _save = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"NavBackSave", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnClick)];
    self.navigationItem.rightBarButtonItem = _save;

}
- (void)doneBtnClick {
    if (self.nickNameCell.textfield.text.length>32) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"MEMineConfNameLength", nil)];
    }else {
        self.myConf.name = _nickNameCell.textfield.text;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)setUpCells
{
    _nickNameCell = [[SIMBaseInputTableViewCell alloc] init];
    _nickNameCell.textfield.textAlignment = NSTextAlignmentLeft;
    _nickNameCell.textfield.font = FontRegularName(16);
    _nickNameCell.placeHolderStr = SIMLocalizedString(@"MEMineConfNamePlaceHolder", nil);
    _nickNameCell.textfield.text = self.myConf.name;
    _nickNameCell.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
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
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UILabel* promptLabel = [[UILabel alloc] init];
    [promptLabel setText:SIMLocalizedString(@"MEMineConfNameExplain", nil)];
    promptLabel.numberOfLines = 0;
    promptLabel.textAlignment = NSTextAlignmentLeft;
    promptLabel.font = FontRegularName(15);
    promptLabel.textColor = GrayPromptTextColor;
    [footerView addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(20);
    }];
    return footerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _nickNameCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
//        NSString *toBeString = textField.text;
////        if (![self isInputRuleAndBlank:toBeString]) {//处理在系统输入法简体拼音下可选择表情的情况
////            textField.text = [self disable_emoji:toBeString];
////            return;
////        }
//
//        NSString *lang = [[textField textInputMode] primaryLanguage]; // 获取当前键盘输入模式
//        //        NSLog(@"%@",lang);
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
