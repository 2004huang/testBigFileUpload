//
//  SIMContactDetailViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/5/13.
//  Copyright © 2019年 Ferris. All rights reserved.
//
//#define Button_Height (IS_IPAD?150:kWidthScale(100))    // 高
//#define Button_Width screen_width/2      // 宽
//#define Start_Y screen_height - StatusNavH - Button_Height*2          // 第一个按钮的Y坐标
#define Button_Height 80.0f    // 高
#define Button_Width 80.0f      // 宽
#define Start_X  (screen_width - Button_Width * 4)/5           // 第一个按钮的X坐标
#define Start_Y 0.0f          // 第一个按钮的Y坐标
#define Width_Space (screen_width - Button_Width * 4)/5        // 2个按钮之间的横间距
#define Height_Space 15.0f      // 竖间距


#import "SIMContactDetailViewController.h"
#import "UIButton+Position.h"
#import "SIMShareTool.h"
#import "SIMNCustomListController.h"
//#import "XYDJViewController.h"
//#import "ZXUserModel.h"
//#import "SIMMessageFMDB.h"
//#import <ImSDK/ImSDK.h>
#import "SIMCallingViewController.h"
#import "ChatViewController.h"

@interface SIMContactDetailViewController ()<CLConferenceDelegate>
@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) NSMutableArray *labArr;
@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, strong) UIView *backView;
@end


@implementation SIMContactDetailViewController

-(instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responeCallResult:)   name:CallResponResult object:nil];
    }
    return self;
}
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBarTintColor:ZJYColorHex(@"#272938")];
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    self.navigationController.navigationBar.titleTextAttributes=
//    @{NSForegroundColorAttributeName:[UIColor whiteColor],
//      NSFontAttributeName:FontRegularName(18)};
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:ZJYColorHex(@"#272938")]];
//
//}
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTintColor:NewBlackTextColor];
//    self.navigationController.navigationBar.titleTextAttributes=
//    @{NSForegroundColorAttributeName:NewBlackTextColor,
//      NSFontAttributeName:FontRegularName(18)};
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:ZJYColorHex(@"#f4f3f3")]];
//}
//- (void)backClick {
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTintColor:BlueButtonColor];
//    self.navigationController.navigationBar.titleTextAttributes=
//    @{NSForegroundColorAttributeName:NewBlackTextColor,
//      NSFontAttributeName:FontRegularName(18)};
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:ZJYColorHex(@"#f4f3f3")]];
////    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    [self.navigationController popViewControllerAnimated:YES];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.person.nickname;
//    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"returnicon"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
//    self.navigationItem.leftBarButtonItem = backBtn;
//    [self addTopView];
    [self addLabelDatas];
    [self addsubviewUI];
    if ([self.cloudVersion.im boolValue]) {
        [self addBottomUI];
    }else {
        [self addOneBottomUI];
    }
    [self addDatas];
    //    self.view.backgroundColor = ZJYColorHex(@"#272938");
}
//- (void)addTopView {
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, StatusNavH)];
//    backView.backgroundColor = ZJYColorHex(@"#272938");
//    [self.view addSubview:backView];
//    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.left.mas_equalTo(0);
//        make.height.mas_equalTo(StatusNavH);
//        make.top.mas_equalTo(0);
//    }];
//
//    UIButton *leftBtn = [[UIButton alloc] init];
//    [leftBtn setImage:[UIImage imageNamed:@"returnicon"] forState:UIControlStateNormal];
//    leftBtn.tintColor = [UIColor whiteColor];
//    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
//    [backView addSubview:leftBtn];
//    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(15);
//        make.height.mas_equalTo(NavH);
//        make.width.mas_equalTo(50);
//        make.top.mas_equalTo(StatusBarH);
//    }];
//
//    UILabel *name = [[UILabel alloc] init];
//    name.text = self.person.nickname;
//    name.textColor = [UIColor whiteColor];
//    [backView addSubview:name];
//    [name mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(0);
//        make.height.mas_equalTo(NavH);
//        make.top.mas_equalTo(StatusBarH);
//    }];
//}
- (void)addLabelDatas {
    _labArr = [NSMutableArray array];
    if (self.person.nickname.length > 0) {
        [_labArr addObject:[NSString stringWithFormat:@"%@：%@",SIMLocalizedString(@"SMineDataName", nil),self.person.nickname]];
    }
    if (self.person.mobile.length > 0) {
        [_labArr addObject:[NSString stringWithFormat:@"%@：%@",SIMLocalizedString(@"CCOwenMess_TELE", nil),self.person.mobile]];
    }
    if (self.person.companyName.length > 0) {
        [_labArr addObject:[NSString stringWithFormat:@"%@：%@",SIMLocalizedString(@"CCOwenMess_Company", nil),self.person.companyName]];
    }
    if (self.person.departmentName.count > 0) {
        NSMutableArray *depArr = [NSMutableArray array];
        for (NSString *string in self.person.departmentName) {
            if (![string isKindOfClass:[NSNull class]]) {
                [depArr addObject:string];
            }
        }
        if (depArr.count > 0) {
            NSString *text = [depArr componentsJoinedByString:@","];
            [_labArr addObject:[NSString stringWithFormat:@"%@：%@",SIMLocalizedString(@"CCOwenMess_Devel", nil),text]];
        }
    }
    if (self.person.position.length > 0) {
        [_labArr addObject:[NSString stringWithFormat:@"%@：%@",SIMLocalizedString(@"SSettingInfo_post", nil),self.person.position]];
    }
//    NSLog(@"postion %@",self.person.position);
}
- (void)addDatas {
    NSString *name = self.person.nickname;
    [_iconBtn setTitle:[NSString firstCharactorWithString:name] forState:UIControlStateNormal];
    if (self.person.avatar.length > 0 && ![self.person.avatar isEqualToString:@"/assets/img/avatar.png"]) {
//            [_iconBtn setTitle:@"" forState:UIControlStateNormal];
            [_iconBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiBaseUrl,self.person.avatar]] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
        _iconBtn.backgroundColor = [UIColor whiteColor];
    }else {
        // 取人名首字母
        _iconBtn.backgroundColor = BlueButtonColor;
        if ([_iconBtn sd_currentImageURL]) {
            [_iconBtn setImage:nil forState:UIControlStateNormal];
        }
        
    }
}

- (void)addsubviewUI {
    CGFloat iconHeight = kWidthS(90);
    _iconBtn = [[UIButton alloc] init];
    _iconBtn.frame = CGRectMake(screen_width/2 - iconHeight/2 , kWidthScale(40), iconHeight, iconHeight);
    _iconBtn.layer.cornerRadius = kWidthS(30);
    _iconBtn.layer.masksToBounds = YES;
    [_iconBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _iconBtn.titleLabel.font = FontRegularName(25);
    _iconBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _iconBtn.contentMode = UIViewContentModeScaleAspectFit;
    _iconBtn.backgroundColor = BlueButtonColor;
    [self.view addSubview:_iconBtn];
    
}
- (void)addOneBottomUI {
    _backView = [[UIView alloc] init];
    [self.view addSubview:_backView];
    _backView.frame = CGRectMake(0 , _iconBtn.bottom + kWidthScale(40), screen_width, Start_Y + Button_Height);
    
    UIButton *aBt = [[UIButton alloc] init];
    [aBt setTitle:SIMLocalizedString(@"CGVoiceClick", nil) forState:UIControlStateNormal];
    [aBt setImage:[UIImage imageNamed:@"newcontact_btn语音通话"] forState:UIControlStateNormal];
    aBt.frame = CGRectMake(Start_X,Start_Y, Button_Width, Button_Height);
    aBt.titleLabel.font = FontRegularName(13);
    aBt.titleLabel.textAlignment = NSTextAlignmentCenter;
    if ([self.person.mobile isEqual:[NSNull null]] || self.person.mobile == nil || self.person.mobile.length <= 0) {
        aBt.enabled = NO;
        [aBt setTitleColor:EnableButtonColor forState:UIControlStateNormal];
    }else {
        [aBt setTitleColor:BlueButtonColor forState:UIControlStateNormal];
        aBt.enabled = YES;
    }
    [_backView addSubview:aBt];
    [aBt addTarget:self action:@selector(callPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    [aBt verticalImageAndTitle:10];
    [self addLineView];
    
}
- (void)callPhoneNumber {
    NSString *phonestring = [NSString stringWithFormat:@"telprompt:%@",self.person.mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phonestring] options:@{} completionHandler:^(BOOL success) {}];
}

- (void)addBottomUI {
    NSArray *arr;
    if ((self.person.uid.length > 0 && [self.person.uid isEqualToString:self.currentUser.uid])) {
        // 如果是自己那么都是禁止点击的
        arr = @[@{@"name":SIMLocalizedString(@"CGVideoClick", nil),@"pic":@"newcontact_btn视频通话",@"enableStaus":@(NO)},
                @{@"name":SIMLocalizedString(@"CGMessageClick", nil),@"pic":@"newcontact_btn聊天",@"enableStaus":@(NO)},
                @{@"name":SIMLocalizedString(@"CGVoiceClick", nil),@"pic":@"newcontact_btn语音通话",@"enableStaus":@(NO)},
                @{@"name":SIMLocalizedString(@"CGShareScreenClick", nil),@"pic":@"newcontact_btn屏幕共享",@"enableStaus":@(NO)}];
    }else {
        if (self.person.isUser) {
            // 是注册用户
            if (self.person.isFriend) {
                // 是好友 这里聊天区分如果是好友也是一个公司的那么是可用 否则不可用
                arr = @[@{@"name":SIMLocalizedString(@"CGVideoClick", nil),@"pic":@"newcontact_btn视频通话",@"enableStaus":@(YES)},
                        @{@"name":SIMLocalizedString(@"CGMessageClick", nil),@"pic":@"newcontact_btn聊天",@"enableStaus":@(YES)},
                        @{@"name":SIMLocalizedString(@"CGVoiceClick", nil),@"pic":@"newcontact_btn语音通话",@"enableStaus":[self.person.mobile isEqual:[NSNull null]] || self.person.mobile==nil || self.person.mobile.length <= 0?@(NO):@(YES)},
                        @{@"name":SIMLocalizedString(@"CGShareScreenClick", nil),@"pic":@"newcontact_btn屏幕共享",@"enableStaus":@(NO)}];
            }else {
                // 不是好友
                arr = @[@{@"name":SIMLocalizedString(@"CGVideoClick", nil),@"pic":@"newcontact_btn视频通话",@"enableStaus":(self.person.isCompany?@(YES):@(NO))},
                        @{@"name":SIMLocalizedString(@"CGMessageClick", nil),@"pic":@"newcontact_btn聊天",@"enableStaus":(self.person.isCompany?@(YES):@(NO))},
                        @{@"name":SIMLocalizedString(@"CGVoiceClick", nil),@"pic":@"newcontact_btn语音通话",@"enableStaus":[self.person.mobile isEqual:[NSNull null]] || self.person.mobile==nil || self.person.mobile.length <= 0?@(NO):@(YES)},
                        @{@"name":SIMLocalizedString(@"CCAddTheFriendsTitle", nil),@"pic":@"newcontact_btn邀请注册",@"enableStaus":[self.person.mobile isEqual:[NSNull null]] || self.person.mobile==nil || self.person.mobile.length <= 0?@(NO):@(YES)}];
            }
        }else {
            // 不是注册用户
            arr = @[@{@"name":SIMLocalizedString(@"CGVideoClick", nil),@"pic":@"newcontact_btn视频通话",@"enableStaus":@(NO)},
                    @{@"name":SIMLocalizedString(@"CGMessageClick", nil),@"pic":@"newcontact_btn聊天",@"enableStaus":@(NO)},
                    @{@"name":SIMLocalizedString(@"CGVoiceClick", nil),@"pic":@"newcontact_btn语音通话",@"enableStaus":[self.person.mobile isEqual:[NSNull null]] || self.person.mobile==nil || self.person.mobile.length <= 0?@(NO):@(YES)},
                    @{@"name":SIMLocalizedString(@"CGInviteRegistClick", nil),@"pic":@"newcontact_btn邀请注册",@"enableStaus":[self.person.mobile isEqual:[NSNull null]] || self.person.mobile==nil || self.person.mobile.length <= 0?@(NO):@(YES)}];
        }
    }
    
    if (self.buttonArray.count > 0) {
        [self.buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    NSUInteger rowNum = (arr.count + 3) / 4; // 行数
    _backView = [[UIView alloc] init];
    [self.view addSubview:_backView];
    _backView.frame = CGRectMake(0 , _iconBtn.bottom + kWidthScale(40), screen_width, Start_Y + Button_Height* rowNum + Height_Space* (rowNum-1));
    
    for (int i = 0 ; i < arr.count; i++) {
        NSInteger index = i % 4;
        NSInteger page = i / 4;
        
        UIButton *aBt = [[UIButton alloc] init];
        [aBt setTitle:arr[i][@"name"] forState:UIControlStateNormal];
        [aBt setImage:[UIImage imageNamed:arr[i][@"pic"]] forState:UIControlStateNormal];
        aBt.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        aBt.tag = i;
        aBt.titleLabel.font = FontRegularName(13);
        aBt.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_backView addSubview:aBt];
        [aBt addTarget:self action:@selector(aBtClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArray addObject:aBt];
        aBt.enabled = [arr[i][@"enableStaus"] boolValue];
        if (aBt.isEnabled) {
            [aBt setTitleColor:BlueButtonColor forState:UIControlStateNormal];
        }else {
            [aBt setTitleColor:EnableButtonColor forState:UIControlStateNormal];
        }
        [aBt verticalImageAndTitle:10];
        
    }
    [self addLineView];
//    for (int i = 0 ; i < 4; i++) {
//        NSInteger index = i % 2;
//        NSInteger page = i / 2;
//
//        UIButton *aBt = [[UIButton alloc] init];
//        aBt.layer.borderColor = ZJYColorHex(@"e3e3e4").CGColor;
//        aBt.layer.borderWidth = 0.5;
//        aBt.backgroundColor = [UIColor whiteColor];
//        [aBt setTitle:arr[i][@"name"] forState:UIControlStateNormal];
//        [aBt setImage:[UIImage imageNamed:arr[i][@"pic"]] forState:UIControlStateNormal];
//        aBt.frame = CGRectMake(index * Button_Width, page * Button_Height + Start_Y, Button_Width, Button_Height);
//        aBt.tag = i;
//        aBt.titleLabel.font = FontRegularName(12);
//        aBt.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [self.view addSubview:aBt];
//        [aBt addTarget:self action:@selector(aBtClick:) forControlEvents:UIControlEventTouchUpInside];
//        aBt.enabled = [arr[i][@"enableStaus"] boolValue];
//        if (aBt.isEnabled) {
//            [aBt setTitleColor:BlackTextColor forState:UIControlStateNormal];
//        }else {
//            [aBt setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
//        }
//        [aBt verticalImageAndTitle:10];
//        [self.buttonArray addObject:aBt];
//    }
}
- (void)addLineView {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _backView.bottom + 15, screen_width, 1)];
    line.backgroundColor = ZJYColorHex(@"#eeeeee");
    [self.view addSubview:line];
    
    for (int i = 0 ; i < _labArr.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = _labArr[i];
        label.frame = CGRectMake(25, i * kWidthS(30) +line.bottom + kWidthScale(30), screen_width - 50, kWidthS(30));
        label.font = FontRegularName(16);
        label.textColor = BlackTextColor;
        [self.view addSubview:label];
    }
}
- (void)aBtClick:(UIButton *)sender {
    switch (sender.tag) {
        case 0: {
            NSLog(@"点击了视频通话的按钮");
            AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
            if (!manager.isReachable) {
                [MBProgressHUD cc_showText:SIMLocalizedString(@"ENTER_NETWORK_NO_CONNECT", nil)];
                return ;
            }
            [self videoCalledMethod];
            
        }
            
            break;
        case 1:
            NSLog(@"点击了聊天的按钮");
            [self messageClickMethod];
            break;
        case 2: {//通话
            NSString *phonestring = [NSString stringWithFormat:@"telprompt:%@",self.person.mobile];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phonestring] options:@{} completionHandler:^(BOOL success) {}];
        }
            break;
        case 3: {
            if (self.person.isUser) {
                // 是注册用户
                if (!self.person.isFriend) {
                    // 不是好友
                    NSLog(@"点击了添加好友");
                    [self addContractorRequest];
                }
            }else {
                // 不是注册用户
                NSString *shareStr = [NSString stringWithFormat:SIMLocalizedString(@"NewAdressBookShareTitle", nil),kApiBaseUrl,@"/admin/downloadcenter/index"];
                [[SIMShareTool shareInstace] showMessageViewWithRecipients:@[self.person.mobile] body:shareStr viewController:self];// 调用发送短信
            }
        }
            break;
        default:
            break;
    }
}
- (void)videoCalledMethod {
    [MBProgressHUD cc_showLoading:nil];
    TIMConversation * c2c_conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:self.person.username];
    NSDictionary *videoStr = @{@"type":@"mainCall",@"nickname":self.currentUser.nickname,@"confId":self.currentUser.self_conf};
    //            NSString *jsonStr = [self convertToJsonData:videoStr];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:videoStr options:NSJSONWritingPrettyPrinted error:nil];
    //            NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"视频JSON: %@", jsonData);
    TIMCustomElem * custom_elem = [[TIMCustomElem alloc] init];
    [custom_elem setData:jsonData];
    TIMMessage * msg = [[TIMMessage alloc] init];
    TIMOfflinePushInfo *offlineInfo = [[TIMOfflinePushInfo alloc] init];
    offlineInfo.desc = @"您收到了一个视频会议邀请";
    offlineInfo.ext = @"您收到了一个视频会议邀请";
    [msg setOfflinePushInfo:offlineInfo];
    [msg addElem:custom_elem];
    __weak typeof(self)weakSelf = self;
    [c2c_conversation sendMessage:msg succ:^(){
        NSLog(@"SendcustomMsg Succ");
        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
        
        SIMCallingViewController *callVC = [[SIMCallingViewController alloc] init];
        if(weakSelf.person != nil){
            callVC.person = weakSelf.person;//上一页人名
            NSLog(@"uidtwo%@",weakSelf.person.uid);
        }
        callVC.kindOfCall = @"videoCall";
        callVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [weakSelf presentViewController:callVC animated:YES completion:nil];
        
    }fail:^(int code, NSString * err) {
        NSLog(@"SendcustomMsg Failed:%d->%@", code, err);
        [MBProgressHUD cc_showText:err];
    }];
}
- (void)responeCallResult:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    if ([userInfo[@"type"] isEqualToString:@"calledCall"]) {
        // 对方同意了视频通话
        [SIMNewEnterConfTool enterTheMineConfWithCid:self.currentUser.self_conf psw:@"" confType:EnterConfTypeConf isJoined:NO viewController:self];
//        [SIMNewEnterConfTool enterTheMineConfWithCid:self.currentUser.self_conf nickname:@"" confType:EnterConfTypeConf isJoined:NO needOpenLocalAudio:YES needOpenLocalVideo:YES viewController:self success:^(id  _Nonnull success) {
//
//        } failure:^(id  _Nonnull failure) {
//
//        } cidMessage:^(NSDictionary * _Nonnull confMessageDic) {
//
//        }];
    }
    
}
// 添加联系人数据
- (void)addContractorRequest {
    [MBProgressHUD cc_showLoading:nil];
    NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.person.mobile ,@"mobile", nil];
    
    [MainNetworkRequest contractorAddRequestParams:dicM success:^(id success) {
        NSLog(@"AddContantsuccess%@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [MBProgressHUD cc_showText:success[@"msg"]];
            self.person.isFriend = YES;
            [self addBottomUI];
            // 发送列表刷新通知
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshCompanyContactData object:nil];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}

- (void)messageClickMethod {
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:BlueButtonColor];
    self.navigationController.navigationBar.titleTextAttributes=
    @{NSForegroundColorAttributeName:NewBlackTextColor,
      NSFontAttributeName:FontRegularName(18)};
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:ZJYColorHex(@"#f4f3f3")]];
    
//    NSArray *arrDatas =  [[SIMMessageFMDB sharedData] selectDataChat];
//    // 是为了刷新那个未读个数
//    for (ZXMessageModel *mm in arrDatas) {
//        if ([mm.fromMan isEqualToString:self.person.mobile]) {
//            ZXUserModel *item1 = [[ZXUserModel alloc] init];
//            item1.fromMan = self.person.mobile;
//            item1.messageCount = 0;
//            [[SIMMessageFMDB sharedData] updateDataChatCount:item1];
//            break ;
//        }
//    }
//    XYDJViewController *djVC = [[XYDJViewController alloc] init];
//    djVC.person = self.person;
//    [self.navigationController pushViewController:djVC animated:YES];
    TConversationCellData *data = [[TConversationCellData alloc] init];
    data.convId = self.person.username;
    data.convType = TConv_Type_C2C;
    data.title = self.person.nickname;
    ChatViewController *chat = [[ChatViewController alloc] init];
    chat.conversation = data;
    [self.navigationController pushViewController:chat animated:YES];
    
}
-(NSString *)convertToJsonData:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}
- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
