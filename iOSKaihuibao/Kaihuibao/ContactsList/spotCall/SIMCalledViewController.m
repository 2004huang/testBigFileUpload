//
//  SIMCalledViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/4/13.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMCalledViewController.h"
#import "SIMButton.h"
#import "XQButton.h"
#import "SIMContants.h"
//#import <ImSDK/ImSDK.h>

@interface SIMCalledViewController ()<CLConferenceDelegate>
{
    NSInteger total;
    
}
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *detail;
@property (nonatomic, strong) XQButton *cutBtn;
@property (nonatomic, strong) SIMButton *cancel;
@property (nonatomic, strong) SIMButton *takeOn;
@property (nonatomic, strong) UIButton *putAway;
@property (nonatomic, strong) NSString *iconImage;
@property (nonatomic, strong) NSMutableArray *mutArray;// 被呼叫的时候需要查询对方头像
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) SIMContants *person;

@end

@implementation SIMCalledViewController
-(instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelCallMethod) name:CanclCallInConf object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downTheView) name:@"pushToDownView" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"totalisWhat %ld",total);
    total = 45;
    
    self.view.backgroundColor = ZJYColorHex(@"#313030");
    _mutArray = [[NSMutableArray alloc] init];

    [self initTopUI];
    [self initBottomUI];
    
    [self requestAllUser];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startTimer];
//    });
    
}
- (void)downTheView {
    
}

#pragma mark -- senderMethod
- (void)cutBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)cancelBtnClick {
    // 点击取消
    NSLog(@"点击取消,也就是拒绝");
    [MBProgressHUD cc_showText:SIMLocalizedString(@"CCallEND", nil)];
    [self cancelTheInviteTheConf];
//    [self responseInviteTheConf:ResponseConfInviteTypeRefuse];
    
}

- (void)takeonBtnClick {
    // 点击接听
    NSLog(@"点击接听");
    
//    [self responseInviteTheConf:ResponseConfInviteTypeAccept];
//    [SIMEnterConfTool responInviteWithConfID:[_confDescDic objectForKey:@"id"] inviteResult:ResponseConfInviteTypeAccept srcUserID:_srcUserID];
    

//    NSDictionary *myDictionary = @{@"srcUserID":_srcUserID,@"srcNickName":_srcNickName,@"confDescDic":_confDescDic};
//    [[NSNotificationCenter defaultCenter] postNotificationName:CallAccpectInConf object:nil userInfo:myDictionary];
    TIMConversation * c2c_conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:[self.dictionary objectForKey:@"mobile"]];
    NSDictionary *videoStr = @{@"type":@"calledCall"};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:videoStr options:NSJSONWritingPrettyPrinted error:nil];
    NSLog(@"视频被叫方接听通话JSON: %@", jsonData);
    TIMCustomElem * custom_elem = [[TIMCustomElem alloc] init];
    [custom_elem setData:jsonData];
    TIMMessage * msg = [[TIMMessage alloc] init];
    TIMOfflinePushInfo *offlineInfo = [[TIMOfflinePushInfo alloc] init];
    offlineInfo.desc = @"接听了通话";
    offlineInfo.ext = @"接听了通话";
    [msg setOfflinePushInfo:offlineInfo];
    [msg addElem:custom_elem];
    __weak typeof(self)weakSelf = self;
    [c2c_conversation sendMessage:msg succ:^(){
        NSLog(@"SendcustomMsg Succ");
        [weakSelf invalidateTheTimer];
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
//        NSDictionary *myDictionary = @{@"confID":weakSelf.confDescDic,@"nickname":weakSelf.srcNickName,@"uid":weakSelf.srcUserID};
        NSDictionary *myDictionary = @{@"confId":[weakSelf.dictionary objectForKey:@"confId"]};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CallAccpectInConf object:nil userInfo:myDictionary];
//        [SIMNewEnterConfTool enterTheMineConfWithCid:weakSelf.confDescDic psw:@"" confType:EnterConfTypeConf isJoined:NO needOpenLocalAudio:YES needOpenLocalVideo:YES viewController:self success:^(id  _Nonnull success) {
//            
//        } failure:^(id  _Nonnull failure) {
//            
//            [self dismissViewControllerAnimated:YES completion:^{
//                NSLog(@"totalisWhat2 %ld",total);
//            }];
//        } cidMessage:^(NSDictionary * _Nonnull confMessageDic) {
//            
//        }];
//        [SIMNewEnterConfTool enterTheMineConfWithCid:weakSelf.confDescDic psw:@"" confType:EnterConfTypeConf isJoined:NO viewController:weakSelf];
    }fail:^(int code, NSString * err) {
        NSLog(@"SendcustomMsg Failed:%d->%@", code, err);
    }];
}
- (void)putAwayBtnClick {
    // 点击收起
    NSLog(@"点击收起");
    
}
// 收到通知
- (void)cancelCallMethod {
    // 主叫取消
    [self invalidateTheTimer];
    [MBProgressHUD cc_showText:SIMLocalizedString(@"CCallOtherCut", nil)];
//    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"totalisWhat2 %ld",total);
            
        }];
//    });
    
}
// 被叫方点击了取消按钮
- (void)cancelTheInviteTheConf {
    TIMConversation * c2c_conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:[self.dictionary objectForKey:@"mobile"]];
    NSDictionary *videoStr = @{@"type":@"calledCancel"};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:videoStr options:NSJSONWritingPrettyPrinted error:nil];
    NSLog(@"视频被叫方取消通话JSON: %@", jsonData);
    TIMCustomElem * custom_elem = [[TIMCustomElem alloc] init];
    [custom_elem setData:jsonData];
    TIMMessage * msg = [[TIMMessage alloc] init];
    TIMOfflinePushInfo *offlineInfo = [[TIMOfflinePushInfo alloc] init];
    offlineInfo.desc = @"对方取消了视频通话";
    offlineInfo.ext = @"对方取消了视频通话";
    [msg setOfflinePushInfo:offlineInfo];
    [msg addElem:custom_elem];
    __weak typeof(self)weakSelf = self;
    [c2c_conversation sendMessage:msg succ:^(){
        NSLog(@"SendcustomMsg Succ");
        [weakSelf invalidateTheTimer];
        
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }fail:^(int code, NSString * err) {
        NSLog(@"SendcustomMsg Failed:%d->%@", code, err);
        [MBProgressHUD cc_showText:err];
        [weakSelf invalidateTheTimer];
        
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    
}

#pragma mark -- initUI
- (void)initBottomUI {
    _cancel = [[SIMButton alloc] init];
    _cancel.backgroundColor = ZJYColorHex(@"#313030");
    _cancel.titleLabel.font = FontRegularName(12);
    [_cancel setTitleColor:ZJYColorHex(@"#FBF4F1") forState:UIControlStateNormal];
    [_cancel setTitle:SIMLocalizedString(@"AlertCCancel", nil) forState:UIControlStateNormal];
    [_cancel setImage:[UIImage imageNamed:@"参考线+椭圆拷贝"] forState:UIControlStateNormal];
    [_cancel addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancel];

    _takeOn = [[SIMButton alloc] init];
    _takeOn.backgroundColor = ZJYColorHex(@"#313030");
    _takeOn.titleLabel.font = FontRegularName(12);
    [_takeOn setTitleColor:ZJYColorHex(@"#FBF4F1") forState:UIControlStateNormal];
    [_takeOn setTitle:SIMLocalizedString(@"CCallAccpect", nil) forState:UIControlStateNormal];
    [_takeOn setImage:[UIImage imageNamed:@"参考线+椭圆"] forState:UIControlStateNormal];
    [_takeOn addTarget:self action:@selector(takeonBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_takeOn];


    _cutBtn = [[XQButton alloc] init];
    _cutBtn.titleLabel.font = FontRegularName(12);
    [_cutBtn setTitleColor:ZJYColorHex(@"#FBF4F1") forState:UIControlStateNormal];
    [_cutBtn setTitle:SIMLocalizedString(@"CCallTransVideo", nil) forState:UIControlStateSelected];
    [_cutBtn setImage:[UIImage imageNamed:@"视频-互动"] forState:UIControlStateSelected];
    [_cutBtn setTitle:SIMLocalizedString(@"CCallTransVoice", nil) forState:UIControlStateNormal];
    [_cutBtn setImage:[UIImage imageNamed:@"转化视频和语音"] forState:UIControlStateNormal];

    [_cutBtn addTarget:self action:@selector(cutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cutBtn];


    [_cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-(isIPhoneXAll ? 49 : 15));
        make.right.mas_equalTo(self.view.mas_centerX).offset(-kWidthScale(57));
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(100);
    }];
    [_takeOn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-(isIPhoneXAll ? 49 : 15));
        make.left.mas_equalTo(self.view.mas_centerX).offset(kWidthScale(57));
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(100);
    }];
    [_cutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(_cancel.mas_top).offset(-30);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(120);
    }];
    
}


- (void)initTopUI {
    _putAway = [[UIButton alloc] init];
    [_putAway setImage:[UIImage imageNamed:@"关闭的按钮"] forState:UIControlStateNormal];
    [_putAway addTarget:self action:@selector(putAwayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_putAway];
    
    _icon = [[UIImageView alloc] init];
    _icon.layer.cornerRadius = 5;
    _icon.layer.masksToBounds = YES;
    _icon.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_icon];
    
    _name = [[UILabel alloc] init];
    _name.text = self.dictionary[@"nickname"];
    _name.textColor = ZJYColorHex(@"#FFFFFF");
    _name.font = [UIFont fontWithName:@"STHeitiTC-Light" size:23];
    _name.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_name];
    
    _detail = [[UILabel alloc] init];
    _detail.text = SIMLocalizedString(@"CCallInviteYCall", nil);
    _detail.textColor = ZJYColorHex(@"#C6C6C6");
    _detail.font = [UIFont fontWithName:@"STHeitiTC-Light" size:15];
    _detail.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_detail];
    
    [_putAway mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(isIPhoneXAll ? 82 : 60);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(30);
    }];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(isIPhoneXAll ? kWidthScale(120) + 24 : kWidthScale(120));
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(100);
    }];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_icon.mas_bottom).offset(kWidthScale(35));
        make.height.mas_equalTo(20);
    }];
    [_detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_name.mas_bottom).offset(kWidthScale(15));
        make.height.mas_equalTo(15);
    }];
    
}

//- (void)responseInviteTheConf:(ResponseConfInviteType)responeType {
////    [SIMEnterConfTool responInviteWithConfID:[_confDescDic objectForKey:@"id"] inviteResult:responeType srcUserID:_srcUserID];
//
//    [self invalidateTheTimer];
//
//    [self dismissViewControllerAnimated:YES completion:^{
//
//    }];
//
//}
- (void)enterConfMethod {
    
//    if (![SIMEnterConfTool  avauthorizationStatusWithViewController:self]) return;
    // 调用会议接口
    NSLog(@"currentThreadiswhat %@",[NSThread currentThread]);
//    [SIMEnterConfTool callTheVideoMethodWithUid:self.currentUser.uid name:self.currentUser.nickname token:[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"] confID:[_confDescDic objectForKey:@"id"] psw:[_confDescDic objectForKey:@"participantkey"] viewController:self];
}
//#pragma mark -- 入会议SDK
//
//-(void)conferenceApiDelegateOnEnterConfWithType:(EnterConfType)type {
//
//    if (ERR_NOERROR == type) {
//        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];// 隐藏加载框
////        UIViewController *vc =self.presentingViewController;
////
////        while ([vc isKindOfClass:[SIMCalledViewController class]]) {
////            vc = vc.presentingViewController;
////        }
////        [vc dismissViewControllerAnimated:YES completion:nil];
//
//        NSLog(@"进会成功");
//    }else if (ERR_CONF_NOTEXIST == type) {
//        [MBProgressHUD cc_showText:@"无此会议ID"];
//    }else if (ERR_CONF_INVALIDPASSWORD == type) {
//        [MBProgressHUD cc_showText:@"账号或者密码错误"];
//    }else if (ERR_CONF_ALREADYLOCK == type) {
//        [MBProgressHUD cc_showText:@"会议被锁定"];
//    }else if (ERR_CONF_KICK == type) {
//        [MBProgressHUD cc_showText:@"您被请出会议"];
//    }else if (ERR_HAS_NOT_LOGIN == type) {
//        [MBProgressHUD cc_showText:@"您未登录！请退出账号并重新登录"];
//    }else if (ERR_HTTP_TIMEOUT == type) {
//        [MBProgressHUD cc_showText:@"请求超时"];
//    }else {
//        [MBProgressHUD cc_showText:[NSString stringWithFormat:@"进会失败%ld，请检查相关设置",(long)type]];
//    }
//}
//// 踢出会议
//- (void)conferenceApiDelegateOnConfMsgWithType:(ConfMsgType)type  data:(NSDictionary *)data {
//    NSLog(@"datadatadata %@",data);
//    if (type == ConfMsgTypeBeKickedOut) {
//        NSLog(@"被踢出会议");
//        //        [self logoutRequest];
//    }else if (type == ConfMsgTypeExitConf) {
//        NSLog(@"退出会议");
////        UIViewController *vc =self.presentingViewController;
////
////        while ([vc isKindOfClass:[SIMCalledViewController class]]) {
////            vc = vc.presentingViewController;
////        }
////        [vc dismissViewControllerAnimated:YES completion:nil];
//
//    }
//    UIViewController *vc =self.presentingViewController;
//
//    while ([vc isKindOfClass:[SIMCalledViewController class]]) {
//        vc = vc.presentingViewController;
//    }
//    [vc dismissViewControllerAnimated:YES completion:nil];
//
//
//}
//- (void)exitConference:(NSError *)error {
//    UIViewController *vc =self.presentingViewController;
//
//    while ([vc isKindOfClass:[SIMCalledViewController class]]) {
//        vc = vc.presentingViewController;
//    }
//    [vc dismissViewControllerAnimated:YES completion:nil];
//}

// 定时器 及重发方法
-(void)startTimer
{
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(overrunnPrompt) userInfo:nil repeats:YES];
    
//    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(overrunnPrompt) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
//    [timer fire];
//    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
}

- (void)overrunnPrompt {
//    if (total == 10) {
//        NSLog(@"对方手机可能不在身边，建议稍后再试");
//        [MBProgressHUD cc_showText:@"对方手机可能不在身边，建议稍后再试"];
//
//    }
    NSLog(@"totaltotal %ld",total);
//    _detail.text = [NSString stringWithFormat:@"%lds邀请你进行视频通话...",(long)total];
    if (total == 0) {
        NSLog(@"连接超时");
//        [timer setFireDate:[NSDate distantFuture]];
//        timer = nil;
//        [timer invalidate];
        
        [MBProgressHUD cc_showText:SIMLocalizedString(@"CCallConnectTimeOut", nil)];
        // 调用挂断接口
//        [self responseInviteTheConf:ResponseConfInviteTypeTimeout];
        
        return;
    }
    total --;
    
}


// 请求企业联系人数据
- (void)requestAllUser {
    [[TIMFriendshipManager sharedInstance] getUsersProfile:@[[self.dictionary objectForKey:@"mobile"]] forceUpdate:NO succ:^(NSArray * arr) {
        for (TIMUserProfile * profile in arr) {
            NSLog(@"腾讯云IM user=%@", profile.faceURL);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString iconGetString:profile.faceURL]] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
                _icon.contentMode = UIViewContentModeScaleAspectFill;
           });
        }
        
    }fail:^(int code, NSString * err) {
        
        NSLog(@"腾讯云IM GetFriendsProfile fail: code=%d err=%@", code, err);
        
    }];
//    [MainNetworkRequest userListRequestParams:nil success:^(id success) {
//        NSLog(@"successusercontactlist  %@",success);
//        if ([success[@"code"] integerValue] == successCodeOK) {
//            [_mutArray removeAllObjects];
//            NSDictionary *dicData = success[@"data"];
//            for (NSDictionary *dic in dicData[@"member_list"]) {
//                SIMContants *userContant = [[SIMContants alloc] initWithDictionary:dic];
//                [_mutArray addObject:userContant];
//            }
//            for (SIMContants *cons in _mutArray) {
//                if ([cons.uid isEqualToString:_srcUserID]) {
//                    _person = cons;
//                    _iconImage = cons.avatar;
//                    NSLog(@"iconImageiconImage%@",_iconImage);
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        if (cons.avatar.length > 0 && ![cons.avatar isEqualToString:@"/assets/img/avatar.png"]) {
//                            NSString *urlString = kApiBaseUrl;
//                            [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlString,cons.avatar]]];
//                            _icon.contentMode = UIViewContentModeScaleAspectFill;
//                        }
//                    });
//                    return ;
//                }
//            }
//        }else {
//            [MBProgressHUD cc_showText:success[@"msg"]];
//        }
//    } failure:^(id failure) {
//    }];
    
}

- (void)invalidateTheTimer {
    NSLog(@"调用了invalidateTheTimer");
    if (_timer != nil) {
        [_timer setFireDate:[NSDate distantFuture]];
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self invalidateTheTimer];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"alreadyPushTheCalledPage"];
    [[NSUserDefaults standardUserDefaults] synchroinzeCurrentUser];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"调用了viewWillDisappear");
}

@end
