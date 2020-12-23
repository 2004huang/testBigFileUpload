//
//  SIMNewConverViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 2018/1/31.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMNewConverViewController.h"
#import "SIMDingTableViewCell.h"
#import "SIMDingHeader.h"

#import <ContactsUI/ContactsUI.h>
#import "UIButton+Position.h"

#import "SIMCallingViewController.h"
//#import "XYDJViewController.h"
//#import "ZXUserModel.h"
//#import "SIMMessageFMDB.h"
#import "SIMMyConf.h"
#import "SIMWXpayViewController.h"

@interface SIMNewConverViewController ()<UITableViewDelegate,UITableViewDataSource,CNContactPickerDelegate,CNContactViewControllerDelegate>
{
    UIBarButtonItem* cancel;
    NSArray *allArr;
}
@property (strong,nonatomic) UITableView* tableView;
@property (strong,nonatomic) SIMDingHeader* dingHeader;
@property (nonatomic, strong) UIButton * button;
@property (nonatomic, strong) UIButton * voicebutton;
@property (nonatomic, strong) UIButton * chatButton;
@property(nonatomic,strong) CNContactStore *contactStore;// 添加到系统通讯录
@property (nonatomic, strong) NSString *passWord;// 暂存自己的会议密码

@end

static NSString *reuse = @"SIMDingTableViewCell";

@implementation SIMNewConverViewController
//-(instancetype)init
//{
//    if (self = [super init]) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterConfMethod)   name:CallResultConf object:nil];
//    }
//    return self;
//}
//
//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDataSources]; // 数据
    [self initSubViews];    // 初始化基本控件
    [self addBottomViews];  // 初始化底部控件
    
}
- (void)initDataSources {
    
    // 如果是点击通讯录的界面过来的话 那么没有更多按钮
//    if (!self.adress) {
        
    cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"09联系人列表_03"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    
        self.navigationItem.rightBarButtonItem = cancel;
//    }
    
    if(self.person != nil){
        self.title = self.person.nickname;//上一页人名
        NSLog(@"uidtwo%@",self.person.uid);
    }
//    else if(self.department != nil){
//        self.title = self.department.nickname;
//        NSLog(@"uidthree%@",self.department.uid);
//    }else if(self.adress != nil){
//        self.title = self.adress.nickname;
//        NSLog(@"uidthree%@",self.adress.nickname);
//    }
    [self initTheTableViewDatas];
}
- (void)backClick {
    [self addActionSheet];
}

- (void)initSubViews {
    self.view.backgroundColor = [UIColor whiteColor];
    // 创建表格
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height-StatusNavH) style:UITableViewStylePlain];
//    _tableView.backgroundColor = TableViewBackgroundColor;
    [self.tableView setSeparatorColor:ZJYColorHex(@"#eeeeee")];
    
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 125)];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[SIMDingTableViewCell class] forCellReuseIdentifier:reuse];
    
    self.tableView.estimatedRowHeight =0;
    self.tableView.estimatedSectionHeaderHeight =0;
    self.tableView.estimatedSectionFooterHeight =0;
    
    UIView *headerBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 195)];
    headerBack.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerBack;
    
    UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(15, 15, screen_width - 30, 165)];
    [headerBack addSubview:shadowView];
    shadowView.layer.shadowColor = GrayPromptTextColor.CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(2, 2);
    shadowView.layer.shadowOpacity = 0.3;
    shadowView.layer.shadowRadius = 5.0;
    shadowView.layer.cornerRadius = 5.0;
    shadowView.clipsToBounds = NO;
    
    _dingHeader = [[SIMDingHeader alloc] initWithFrame:CGRectMake(0, 0, screen_width - 30, 165)];
    if (self.person != nil) {
        _dingHeader.contant = self.person;// 将model传给自定义视图
    }
//    if (self.department != nil) {
//        _dingHeader.depart = self.department;// 两种模型 这种是企业群组
//    }
//    if (self.adress != nil) {
//        _dingHeader.adress = self.adress;// 两种模型 这种是从通讯录里获取的联系人
//    }
    [shadowView addSubview:_dingHeader];
}

#pragma mark -- UITableViewDelegate
//设置页眉高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        if (self.person.isContant) {
            return CGFLOAT_MIN;
        }else {
            return 8;
        }
    }
    return CGFLOAT_MIN;
}

//设置页眉的子视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *vieww = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 50)];
    vieww.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, screen_width-40, 50)];
//        label.text = self.departAllArr.count == 0 ? @"" : @"企业通讯录";
    NSString *comStr;
    if (self.person.company_name.length>0) {
        comStr = [NSString stringWithFormat:@"%@(%@)",SIMLocalizedString(@"CCCompanyMess", nil),self.person.company_name];
    }else {
        comStr = SIMLocalizedString(@"CCCompanyMess", nil);
    }
    NSArray *titleArr;
    if (self.person.isContant) {
        titleArr = @[SIMLocalizedString(@"CCOwenMess", nil)];
    }else {
        titleArr = @[comStr,SIMLocalizedString(@"CCOwenMess", nil)];
    }
    label.text = titleArr[section];
    label.font = [UIFont boldSystemFontOfSize:17];
    label.textColor = ZJYColorHex(@"#191f25");
    [vieww addSubview:label];
    return vieww;

}

//设置分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return allArr.count;
}
//分区中行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allArr[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (void)initTheTableViewDatas {
    NSArray *sectionOne;
    NSArray *sectionTwo;
    // 这里是各种 展示表格 如果没有就隐藏 没有就显示 以后可以在优化
    if (self.person != nil) {
        if (self.person.department_name.length > 0) {
            sectionOne = @[@{@"title":SIMLocalizedString(@"SMineDataName", nil),@"detail":self.person.nickname},@{@"title":SIMLocalizedString(@"CCOwenMess_TELE", nil),@"detail":self.person.mobile},@{@"title":SIMLocalizedString(@"CCOwenMess_Devel", nil),@"detail":self.person.department_name}];
        }else {
            sectionOne = @[@{@"title":SIMLocalizedString(@"SMineDataName", nil),@"detail":self.person.nickname},@{@"title":SIMLocalizedString(@"CCOwenMess_TELE", nil),@"detail":self.person.mobile}];
        }
        if (self.person.email.length > 0) {
            if (self.person.conf.length > 0) {
                sectionTwo = @[@{@"title":SIMLocalizedString(@"CCOwenMess_PHONE", nil),@"detail":self.person.mobile},@{@"title":SIMLocalizedString(@"CCOwenMess_Email", nil),@"detail":self.person.email},@{@"title":SIMLocalizedString(@"CCOwenMess_ConfID", nil),@"detail":self.person.conf}];
            }else {
               sectionTwo = @[@{@"title":SIMLocalizedString(@"CCOwenMess_PHONE", nil),@"detail":self.person.mobile},@{@"title":SIMLocalizedString(@"CCOwenMess_Email", nil),@"detail":self.person.email}];
            }
        }else {
            if (self.person.conf.length > 0) {
                sectionTwo = @[@{@"title":SIMLocalizedString(@"CCOwenMess_PHONE", nil),@"detail":self.person.mobile},@{@"title":SIMLocalizedString(@"CCOwenMess_ConfID", nil),@"detail":self.person.conf}];
            }else {
                sectionTwo = @[@{@"title":SIMLocalizedString(@"CCOwenMess_PHONE", nil),@"detail":self.person.mobile}];
            }
        }
        if (_person.isContant) {
            allArr = @[sectionTwo];
        }else {
            allArr = @[sectionOne,sectionTwo];
        }
        
    }
//    if (self.department != nil) {
//        sectionTwo = @[@{@"title":@"姓名",@"detail":self.department.nickname}];
//        allArr = @[sectionTwo];
//    }
    
//    if (self.adress != nil) {
//        sectionTwo = @[@{@"title":SIMLocalizedString(@"CCOwenMess_PHONE", nil),@"detail":self.adress.mobile}];
//        allArr = @[sectionTwo];
//    }
    
}

//设置单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMDingTableViewCell *dingCell = [tableView dequeueReusableCellWithIdentifier:reuse];
    dingCell.titleLabel.text = [allArr[indexPath.section][indexPath.row] objectForKey:@"title"];
    dingCell.detailLabel.text = [allArr[indexPath.section][indexPath.row] objectForKey:@"detail"];

    return dingCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -- UIAlertViewDelegate
- (void)addActionSheet {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:SIMLocalizedString(@"CCCreateNewContant", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveNewContact];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"CCCreateToNowContant", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveExistContact];
    }];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [action4 setValue:RedButtonColor forKey:@"_titleTextColor"];
    [alertC addAction:action];
    [alertC addAction:action2];
    
    // 用户不可以删除联系人 是外部联系人时候可以删除
    if (self.person.isContant) {
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"CCDeleteContant", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 删除联系人
            NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.person.mobile,@"mobile",@"1",@"kind", nil];
            
            [MainNetworkRequest contractorDeleteRequestParams:dicM success:^(id success) {
//                NSDictionary *success = [NSJSONSerialization JSONObjectWithData:success options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"deleteContantsuccess%@",success);
                if ([success[@"status"] isEqualToString:@"ok"]) {
                    // 发送列表刷新通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshContactData object:nil];
                    
                    [MBProgressHUD cc_showText:SIMLocalizedString(@"CCDeleteContant_success", nil)];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    
                }else if([success[@"status"] isEqualToString:@"ERROR_NOT_CONTRACTOR"]) {
                    [MBProgressHUD cc_showFail:SIMLocalizedString(@"CCDeleteContant_notFriend", nil)];
                }
            } failure:^(id failure) {
                [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
            }];
            
        }];
        [alertC addAction:action3];
    }
//    else {
//        
//        UIAlertAction *action3 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"CCDeleteContant", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            // 删除用户
//            NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.person.uid,@"uid", nil];
//            
//            [MainNetworkRequest userDeleteRequestParams:dicM success:^(id success) {
//                
//                NSLog(@"deleteusersuccess%@",success);
//                if ([success[@"code"] integerValue] == successCodeOK) {
//                    // 发送列表刷新通知
////                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshContactData object:nil];
//                    
//                    [MBProgressHUD cc_showSuccess:success[@"msg"]];
//                    [self.navigationController popViewControllerAnimated:YES];
//                    
//                    
//                }
//            } failure:^(id failure) {
//                [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
//            }];
//            
//        }];
//        [alertC addAction:action3];
//    }
    [alertC addAction:action4];
    alertC.popoverPresentationController.barButtonItem = cancel;
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark -- CNContactViewController
- (void)saveNewContact{
    
    CNMutableContact *contact = [[CNMutableContact alloc] init];
    //2.为contact赋值
    [self setValue4Contact:contact existContect:NO];
    //3.创建新建好友页面
    CNContactViewController *controller = [CNContactViewController viewControllerForNewContact:contact];
    //代理内容根据自己需要实现
    controller.delegate = self;
    //4.跳转
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
    navigation.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
    
}
//保存现有联系人实现
- (void)saveExistContact{
    //1.跳转到联系人选择页面，注意这里没有使用UINavigationController
    CNContactPickerViewController *controller = [[CNContactPickerViewController alloc] init];
    controller.delegate = self;
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}
#pragma mark - CNContactViewControllerDelegate
- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact{
    [viewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - CNContactPickerDelegate

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        
        CNMutableContact *c = [contact mutableCopy];
        
        [weakSelf setValue4Contact:c existContect:YES];
        
        CNContactViewController *controller = [CNContactViewController viewControllerForNewContact:c];
        controller.delegate = weakSelf;
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
        navigation.modalPresentationStyle = UIModalPresentationFullScreen;
        [weakSelf presentViewController:navigation animated:YES completion:^{
        }];
    }];
}


//设置要保存的contact对象
- (void)setValue4Contact:(CNMutableContact *)contact existContect:(BOOL)exist{
    if(self.person != nil){
        //为contact赋值
        NSLog(@"uidtwo%@",self.person.uid);
        
        if (!exist) {
            //名字和头像
            if (self.person.nickname.length > 0 ) {
                contact.familyName = [self.person.nickname substringToIndex:1];
                contact.givenName = [self.person.nickname substringFromIndex:1];
            }
            //        UIImage *logo = [UIImage imageNamed:@"..."];
            //        NSData *dataRef = UIImagePNGRepresentation(logo);
            //        contact.imageData = dataRef;
        }
        //电话
        CNLabeledValue *phoneNumber = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile value:[CNPhoneNumber phoneNumberWithStringValue:self.person.mobile]];
        if (!exist) {
            contact.phoneNumbers = @[phoneNumber];
        }
        //现有联系人情况
        else{
            if ([contact.phoneNumbers count] >0) {
                NSMutableArray *phoneNumbers = [[NSMutableArray alloc] initWithArray:contact.phoneNumbers];
                [phoneNumbers addObject:phoneNumber];
                contact.phoneNumbers = phoneNumbers;
            }else{
                contact.phoneNumbers = @[phoneNumber];
            }
        }
        //邮箱:CNLabeledValue *mail = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:self.poiData4Save.mail];
    }
}

- (void)addBottomViews {
//    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, screen_height - 64 - kWidthScale(20), screen_width, kWidthScale(20))];
//    bottomView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:bottomView];
    UIImageView *mag = [[UIImageView alloc] initWithFrame:CGRectMake(0, screen_height - kWidthScale(75) - StatusNavH, screen_width, kWidthScale(75))];
    mag.image = [UIImage imageNamed:@"contantviewBack2"];
    [self.view addSubview:mag];
    
    // 视频按钮
    _button = [[UIButton alloc] init];
    [_button setTitle:SIMLocalizedString(@"CGVideoClick", nil) forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(videoClick) forControlEvents:UIControlEventTouchUpInside];
    if ([self.person.uid isEqualToString:self.currentUser.uid]) {
        // 这里如果是自己的话 那么置灰 不让点击
        _button.userInteractionEnabled = NO;
        [_button setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"unnormalContantVideo"] forState:UIControlStateNormal];
    }else {
        // 除了自己以外都可以使用按钮
        _button.userInteractionEnabled = YES;
        [_button setTitleColor:ZJYColorHex(@"#3296fa") forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"normalContantVideo"] forState:UIControlStateNormal];
    }
    _button.titleLabel.font = FontRegularName(11);
    [self.view addSubview:_button];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-(isIPhoneXAll ? kWidthScale(15) + BottomSaveH : kWidthScale(15)));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(70);
    }];
    [_button verticalImageAndTitle:5];
    
    // 语音按钮
    _voicebutton = [[UIButton alloc] init];
    [_voicebutton setTitle:SIMLocalizedString(@"CGVoiceClick", nil) forState:UIControlStateNormal];
    if ([self.person.uid isEqualToString:self.currentUser.uid]) {
        // 这里如果是自己的话 那么置灰 不让点击
        _voicebutton.userInteractionEnabled = NO;
        [_voicebutton setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
        [_voicebutton setImage:[UIImage imageNamed:@"unnormalContantPhone"] forState:UIControlStateNormal];
    }else {
        // 除了自己以外都可以使用按钮
        _voicebutton.userInteractionEnabled = YES;
        [_voicebutton setTitleColor:ZJYColorHex(@"#3296fa") forState:UIControlStateNormal];
        [_voicebutton setImage:[UIImage imageNamed:@"normalContantPhone"] forState:UIControlStateNormal];
    }
    _voicebutton.titleLabel.font = FontRegularName(11);
    [_voicebutton addTarget:self action:@selector(videoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_voicebutton];
    [_voicebutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-(isIPhoneXAll ? kWidthScale(15) + BottomSaveH : kWidthScale(15)));
        make.left.mas_equalTo(_button.mas_right).offset(20);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(70);
    }];
    [_voicebutton verticalImageAndTitle:5];
    
    // 聊天按钮
    _chatButton = [[UIButton alloc] init];
    [_chatButton setTitle:SIMLocalizedString(@"CGMessageClick", nil) forState:UIControlStateNormal];
    if ([self.person.uid isEqualToString:self.currentUser.uid]) {
        // 这里如果是自己的话 那么置灰 不让点击
        _chatButton.userInteractionEnabled = NO;
        [_chatButton setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
        [_chatButton setImage:[UIImage imageNamed:@"unnormalContantMessage"] forState:UIControlStateNormal];
//        [_chatButton setTitleColor:ZJYColorHex(@"#3296fa") forState:UIControlStateNormal];
//        [_chatButton setImage:[UIImage imageNamed:@"normalContantMessage"] forState:UIControlStateNormal];
        
    }else {
        // 除了自己以外都可以使用按钮
        _chatButton.userInteractionEnabled = YES;
        [_chatButton setTitleColor:ZJYColorHex(@"#3296fa") forState:UIControlStateNormal];
        [_chatButton setImage:[UIImage imageNamed:@"normalContantMessage"] forState:UIControlStateNormal];
    }
    
    _chatButton.titleLabel.font = FontRegularName(11);
    [_chatButton addTarget:self action:@selector(messageClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_chatButton];
    [_chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-(isIPhoneXAll ? kWidthScale(15) + BottomSaveH : kWidthScale(15)));
        make.right.mas_equalTo(_button.mas_left).offset(-20);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(70);
    }];
    [_chatButton verticalImageAndTitle:5];
}
// 点击视频呼叫
- (void)videoClick {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    if (!manager.reachable) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ENTER_NETWORK_NO_CONNECT", nil)];
        return ;
    }
    
    // 区分上线与否 隐藏支付内容
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"] == YES) {
        // 上线了 显示支付相关
        [MainNetworkRequest canJoinTheMeetrequeset:nil typeId:@"IOS" signid:@"1" success:^(id success) {
            
            NSLog(@"canshowtheWechatDic%@",success);
            if ([success[@"status"] isEqualToString:@"ok"]) {
                //"yes":不跳窗，"no": 跳窗
                if ([success[@"is_pay"] isEqualToString:@"yes"]) {
                    SIMCallingViewController *callVC = [[SIMCallingViewController alloc] init];
                    if(self.person != nil){
                        callVC.person = self.person;//上一页人名
                        NSLog(@"uidtwo%@",self.person.uid);
                    }
                    callVC.kindOfCall = @"videoCall";
                    callVC.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self presentViewController:callVC animated:YES completion:nil];
                }else {
                    // 说明不是付费用户  那么进入支付
                    SIMWXpayViewController*payVC = [[SIMWXpayViewController alloc] init];
                    payVC.pageIndex = 0;
                    [self.navigationController pushViewController:payVC animated:YES];
                }
            }else {
                [MBProgressHUD cc_showText:SIMLocalizedString(@"ERR_CONF_NoConfIDRequest", nil)];
            }
            
        } failure:^(id failure) {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"ERR_CONF_NoConfIDRequest", nil)];
        }];
        
    }else {
        // 没上线 隐藏支付相关 没上线直接进会
        SIMCallingViewController *callVC = [[SIMCallingViewController alloc] init];
        if(self.person != nil){
            callVC.person = self.person;//上一页人名
            NSLog(@"uidtwo%@",self.person.uid);
        }
        callVC.kindOfCall = @"videoCall";
        callVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:callVC animated:YES completion:nil];
    }
    
    
}

// 语音呼叫
- (void)voiceClick {
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    if (!manager.reachable) {
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"ENTER_NETWORK_NO_CONNECT", nil)];
//        return ;
//    }
    [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_NowHavent_Function", nil)];
//    SIMCallingViewController *callVC = [[SIMCallingViewController alloc] init];
//    if(self.person != nil){
//        callVC.person = self.person;//上一页人名
//        NSLog(@"uidtwo%@",self.person.uid);
//    }
//    else if(self.adress != nil){
//
//        callVC.adress = self.adress;
//        NSLog(@"uidthree%@",self.adress.nickname);
//    }
//    callVC.kindOfCall = @"voiceCall";
////    [self.navigationController pushViewController:callVC animated:NO];
//    [self presentViewController:callVC animated:YES completion:nil];
}
- (void)messageClick {
//    NSArray *arrDatas =  [[SIMMessageFMDB sharedData] selectDataChat];
//    // 是为了刷新那个未读个数
//    for (ZXMessageModel *mm in arrDatas) {
//        if ([mm.fromMan isEqualToString:self.person.mobile]) {
//            ZXUserModel *item1 = [[ZXUserModel alloc] init];
//            item1.fromMan = self.person.mobile;
//            item1.messageCount = 0;
//            [[SIMMessageFMDB sharedData] updateDataChatCount:item1];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTheChatVC" object:nil];
//            
//            break ;
//        }
//        
//    }
//    
//    XYDJViewController *djVC = [[XYDJViewController alloc] init];
//    djVC.person = self.person;
//    [self.navigationController pushViewController:djVC animated:YES];
    
}

@end
