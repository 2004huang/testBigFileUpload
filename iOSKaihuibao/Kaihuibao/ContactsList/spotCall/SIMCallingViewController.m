//
//  SIMCallingViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/4/12.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMCallingViewController.h"
#import "SIMButton.h"
#import "XQButton.h"

@interface SIMCallingViewController ()<CLConferenceDelegate>
{
    NSInteger total;
}
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *detail;
@property (nonatomic, strong) XQButton *cutBtn;
@property (nonatomic, strong) SIMButton *cancel;
@property (nonatomic, strong) NSString *passWord;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SIMCallingViewController
-(instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responeCallResult:)   name:CallResponResult object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    total = 40;
    self.view.backgroundColor = ZJYColorHex(@"#313030");
    
    // 呼叫界面出来的时候 存一下这个呼叫界面出现的状态 以防止其他人员乎进
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"alreadyPushTheCallingPage"];
    [[NSUserDefaults standardUserDefaults] synchroinzeCurrentUser];

    [self videoIsCalling];
    [self initTopUI];
    [self initBottomUI];
    //    if ([_kindOfCall isEqualToString:@"videoCall"]) {
    [self requestAllUser];
    [self startTimer];
    //    }else if ([_kindOfCall isEqualToString:@"voiceCall"]) {
    //        [self voiceIsCalling];
    //    }
}

#pragma mark -- senderMethod
- (void)cutBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    //    [self videoIsCalling];
    
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
    
    
    _cutBtn = [[XQButton alloc] init];
    _cutBtn.titleLabel.font = FontRegularName(12);
    [_cutBtn setTitleColor:ZJYColorHex(@"#FBF4F1") forState:UIControlStateNormal];
    if ([_kindOfCall isEqualToString:@"videoCall"]) {
        [_cutBtn setTitle:SIMLocalizedString(@"CCallTransVoice", nil) forState:UIControlStateNormal];
        [_cutBtn setImage:[UIImage imageNamed:@"转化视频和语音"] forState:UIControlStateNormal];
        [_cutBtn setTitle:SIMLocalizedString(@"CCallTransVideo", nil) forState:UIControlStateSelected];
        [_cutBtn setImage:[UIImage imageNamed:@"视频-互动"] forState:UIControlStateSelected];
        
    }else if ([_kindOfCall isEqualToString:@"voiceCall"]) {
        [_cutBtn setTitle:SIMLocalizedString(@"CCallTransVideo", nil) forState:UIControlStateNormal];
        [_cutBtn setImage:[UIImage imageNamed:@"视频-互动"] forState:UIControlStateNormal];
        [_cutBtn setTitle:SIMLocalizedString(@"CCallTransVoice", nil) forState:UIControlStateSelected];
        [_cutBtn setImage:[UIImage imageNamed:@"转化视频和语音"] forState:UIControlStateSelected];
        
    }
    [_cutBtn addTarget:self action:@selector(cutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_cutBtn];
    //    [_cutBtn verticalImageAndTitle:20];
    //    CGSize imageSize = _cutBtn.imageView.frame.size;
    //    CGSize titleSize = _cutBtn.titleLabel.frame.size;
    //    CGFloat totalHeight = (imageSize.height + titleSize.height + 10);
    //    _cutBtn.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    //    _cutBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -(totalHeight - titleSize.height), 0);
    
    
    [_cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-(isIPhoneXAll ? 49 : 15));
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(80);
    }];
    [_cutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(_cancel.mas_top).offset(-30);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(120);
    }];
    
}


- (void)initTopUI {
    _icon = [[UIImageView alloc] init];
    _icon.layer.cornerRadius = 5;
    _icon.layer.masksToBounds = YES;
    _icon.backgroundColor = [UIColor whiteColor];
//    if (self.person.avatar.length > 0) {
//        [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString iconGetString:self.person.avatar]] placeholderImage:[UIImage imageNamed:@"avatar"]];
//        _icon.contentMode = UIViewContentModeScaleAspectFill;
//    }else {
//        _icon.image = [UIImage imageNamed:@"avatar"];
//    }
    [self.view addSubview:_icon];
    
    _name = [[UILabel alloc] init];
    _name.text = _person.nickname;
    _name.textColor = ZJYColorHex(@"#FFFFFF");
    _name.font = [UIFont fontWithName:@"STHeitiTC-Light" size:23];
    [self.view addSubview:_name];
    
    _detail = [[UILabel alloc] init];
    _detail.text = SIMLocalizedString(@"CCallWaiting", nil);
    _detail.textColor = ZJYColorHex(@"#C6C6C6");
    _detail.font = [UIFont fontWithName:@"STHeitiTC-Light" size:15];
    [self.view addSubview:_detail];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(isIPhoneXAll ? 84 : 60);
        make.height.mas_equalTo(80);
        make.width.mas_equalTo(80);
    }];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_icon.mas_right).offset(15);
        make.top.mas_equalTo(_icon).offset(15);
        make.height.mas_equalTo(20);
    }];
    [_detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_icon.mas_right).offset(15);
        make.top.mas_equalTo(_name.mas_bottom).offset(15);
        make.height.mas_equalTo(15);
    }];
    
}
- (void)requestAllUser {
    [[TIMFriendshipManager sharedInstance] getUsersProfile:@[self.person.username] forceUpdate:NO succ:^(NSArray * arr) {
        for (TIMUserProfile *profile in arr) {
            NSLog(@"腾讯云IM user=%@ %@", profile.faceURL,self.person.username);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString iconGetString:profile.faceURL]] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
                _icon.contentMode = UIViewContentModeScaleAspectFill;
            });
        }
        
    }fail:^(int code, NSString * err) {
        
        NSLog(@"腾讯云IM GetFriendsProfile fail: code=%d err=%@", code, err);
        
    }];
    
}
// 呼叫视频
- (void)videoIsCalling {
    //     _passWord = [SIMNewEnterConfTool passWordFromUserDefaults];
//    if (![SIMEnterConfTool  avauthorizationStatusWithViewController:self]) return;
    
    // 呼叫不进会
    //    [SIMEnterConfTool inviteJoinTheConfWithConfID:self.currentUser.self_conf inviteUserId:_person.uid inviteUserName:_person.nickname thenQuickEnterConfWithUserId:self.currentUser.uid userName:self.currentUser.nickname token:[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"] confPsd:_passWord viewController:self];
    // 呼叫不进会
    NSLog(@"_passWord_passWord111  %@",_passWord);
//    [SIMEnterConfTool inviteJoinConfWithConfID:self.currentUser.self_conf confPsd:_passWord title:self.currentUser.conf_name canRefuseInvite:YES inviteUserId:_person.uid andUserName:_person.nickname withDelegateVC:self];
    
}
// 呼叫语音
- (void)voiceIsCalling {
    
}
- (void)cancelBtnClick {
    // 点击取消
    //    [SIMEnterConfTool cancelInviteJoinConfWithConfID:self.currentUser.self_conf inviteUserID:_person.uid];
   
    TIMConversation * c2c_conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:self.person.username];
    NSDictionary *videoStr = @{@"type":@"mainCancel"};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:videoStr options:NSJSONWritingPrettyPrinted error:nil];
    NSLog(@"视频取消JSON: %@", jsonData);
    TIMCustomElem * custom_elem = [[TIMCustomElem alloc] init];
    [custom_elem setData:jsonData];
    TIMMessage * msg = [[TIMMessage alloc] init];
   
    TIMOfflinePushInfo *offlineInfo = [[TIMOfflinePushInfo alloc] init];
    offlineInfo.desc = @"主叫方取消了视频通话";
    offlineInfo.ext = @"主叫方取消了视频通话";
    [msg setOfflinePushInfo:offlineInfo];
    [msg addElem:custom_elem];
    __weak typeof(self)weakSelf = self;
    [c2c_conversation sendMessage:msg succ:^(){
        NSLog(@"SendcustomMsg Succ");
        [MBProgressHUD cc_showText:SIMLocalizedString(@"CCallCancel", nil)];
        [weakSelf invalidateTheTimer];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }fail:^(int code, NSString * err) {
        NSLog(@"SendcustomMsg Failed:%d->%@", code, err);
        [MBProgressHUD cc_showText:err];
    }];
    
}

- (void)responeCallResult:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    if ([userInfo[@"type"] isEqualToString:@"calledCancel"]) {
        if ([userInfo[@"reason"] intValue] == 1) {
            // 对方忙
            [MBProgressHUD cc_showText:SIMLocalizedString(@"CConfInviteTypeBusy", nil)];
        }else {
            // 对方取消了视频通话
            [MBProgressHUD cc_showText:SIMLocalizedString(@"CConfInviteTypeRefuse", nil)];
        }
        
        [self timerInvalidateAndDismissVC];
    }else if ([userInfo[@"type"] isEqualToString:@"calledCall"]) {
        [self invalidateTheTimer];
        [self dismissViewControllerAnimated:NO completion:nil];
//        // 对方同意了视频通话
//        [SIMNewEnterConfTool enterTheMineConfWithCid:self.currentUser.self_conf psw:@"" confType:EnterConfTypeConf isJoined:NO needOpenLocalAudio:YES needOpenLocalVideo:YES viewController:self success:^(id  _Nonnull success) {
//
//        } failure:^(id  _Nonnull failure) {
//            [self timerInvalidateAndDismissVC];
//        } cidMessage:^(NSDictionary * _Nonnull confMessageDic) {
//
//        }];
    }else {
        [self timerInvalidateAndDismissVC];
    }
    
//    [SIMNewEnterConfTool enterTheMineConfWithCid:self.currentUser.self_conf psw:@"" confType:EnterConfTypeConf isJoined:NO viewController:self];
    
}
//- (void)exitConference:(NSError *)error {
//    UIViewController *vc =self.presentingViewController;
//    
//    while ([vc isKindOfClass:[SIMCallingViewController class]]) {
//        vc = vc.presentingViewController;
//    }
//    [vc dismissViewControllerAnimated:YES completion:nil];
//}

//- (void)responeCallResult:(NSNotification *)notification {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        // SIMMainMeetingViewController的登录回调里面收到的结果
//        NSString *resultCallType = [[notification userInfo] valueForKey:@"resultType"];
//        NSInteger inviteResult = [resultCallType integerValue];
//        //    NSDictionary *myDictionary = @{@"resultType":[NSString stringWithFormat:@"%ld",nInviteResult],@"userList":userList};
//        NSLog(@"callingresultCallType%@",resultCallType);
//
//        if (ResponseConfInviteTypeAccept == inviteResult) {
//            [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];// 隐藏加载框
//            NSLog(@"邀请成功即将入会");
//            // 发进入会议的通知
////            [[NSNotificationCenter defaultCenter] postNotificationName:CallResultConf object:nil];
//            [self invalidateTheTimer];
//            [self enterConfMethod];
//
//        }else if (ResponseConfInviteTypeRefuse == inviteResult) {
//            [MBProgressHUD cc_showText:SIMLocalizedString(@"CConfInviteTypeRefuse", nil)];
//            [self timerInvalidateAndDismissVC];
//        }else if (ResponseConfInviteTypeTimeout == inviteResult) {
//            [MBProgressHUD cc_showText:SIMLocalizedString(@"CConfInviteTypeTimeout", nil)];
//            [self timerInvalidateAndDismissVC];
//        }else if (ResponseConfInviteTypeOther == inviteResult) {
//            [MBProgressHUD cc_showText:SIMLocalizedString(@"CConfInviteTypeOther", nil)];
//            [self timerInvalidateAndDismissVC];
//        }else if (ResponseConfInviteTypeBusy == inviteResult) {
//            [MBProgressHUD cc_showText:SIMLocalizedString(@"CConfInviteTypeBusy", nil)];
//            [self timerInvalidateAndDismissVC];
//        }
////        else if (ResponseConfInviteTypeNoLine == inviteResult) {
////            [MBProgressHUD cc_showText:SIMLocalizedString(@"CConfInviteTypeNoLine", nil)];
////            [self timerInvalidateAndDismissVC];
////        }
////
//        else {
//            [MBProgressHUD cc_showText:[NSString stringWithFormat:@"%@ %@",SIMLocalizedString(@"CConfInviteType_Others", nil),resultCallType]];
//            [self timerInvalidateAndDismissVC];
//        }
//
//    });
//
//}
- (void)timerInvalidateAndDismissVC {
    // 将呼叫界面dismiss
    [self invalidateTheTimer];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
//    });
    
    
}

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
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            NSLog(@"对方手机可能不在身边，建议稍后再试");
    //            [MBProgressHUD cc_showText:@"对方手机可能不在身边，建议稍后再试"];
    //        });
    //
    //    }

//    _detail.text = [NSString stringWithFormat:@"正在等待对方接受邀请... %lds",(long)total];
    if (total == 0) {
        NSLog(@"对方手机可能不在身边");
        [self invalidateTheTimer];

        [MBProgressHUD cc_showText:SIMLocalizedString(@"CCallNonePhone", nil)];

        return;
    }
    total --;

}


- (void)enterConfMethod {
//        NSLog(@"_passWord_passWord000  %@",_passWord);
//        if (![SIMEnterConfTool  avauthorizationStatusWithViewController:self]) return;
//        // 调用会议接口
//        [SIMEnterConfTool callTheVideoMethodWithUid:self.currentUser.uid name:self.currentUser.nickname token:[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"] confID:self.currentUser.self_conf psw:_passWord viewController:self];
}

#pragma mark -- 入会议SDK

//-(void)conferenceApiDelegateOnEnterConfWithType:(EnterConfType)type {
//
//    if (ERR_NOERROR == type) {
//        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];// 隐藏加载框
//        NSLog(@"进会成功");
//
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
//// 结束会议
//- (void)conferenceApiDelegateOnConfMsgWithType:(ConfMsgType)type data:(NSDictionary *)data {
//    NSLog(@"datadatadata %@",data);
//    if (type == ConfMsgTypeBeKickedOut) {
//        NSLog(@"被踢出会议");
//
//        //        [self logoutRequest];
//    }else if (type == ConfMsgTypeExitConf) {
//        NSLog(@"退出会议");
////        UIViewController *vc =self.presentingViewController;
////
////        while (vc != nil) {
////            if ([vc isKindOfClass:[SIMCallingViewController class]]) {
////                vc = vc.presentingViewController;
////
////            }
////        }
////        [vc dismissViewControllerAnimated:YES completion:nil];
//
////                [self dismissViewControllerAnimated:YES completion:nil];
//    }
//    UIViewController *vc =self.presentingViewController;
//
//    while ([vc isKindOfClass:[SIMCallingViewController class]]) {
//        vc = vc.presentingViewController;
//    }
//    [vc dismissViewControllerAnimated:YES completion:nil];
//}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self invalidateTheTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 呼叫界面消失 可是是对方拒了 或者自己取消 或者接听进会了 这个时候移除呼叫状态（不够完善！！但是可以拦截一部分其他人的呼叫）
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"alreadyPushTheCallingPage"];
    [[NSUserDefaults standardUserDefaults] synchroinzeCurrentUser];
    NSLog(@"调用了viewWillDisappear");
}


- (void)invalidateTheTimer {
    if (nil != _timer) {
        [_timer setFireDate:[NSDate distantFuture]];
        [_timer invalidate];
        _timer = nil;
     }
}




@end
