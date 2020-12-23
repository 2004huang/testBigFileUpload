//
//  SIMMyRoomViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/6.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMMyRoomViewController.h"

#import "SIMHeaderConfView.h"
#import "SIMSendView.h"

#import "SIMMyConf.h"
#import "ArrangeConfModel.h"
#import "EditMyConfViewController.h"
#import "SIMConfIDQRCodeViewController.h"
#import "SIMTempCompanyViewController.h"

#import "SIMShareTool.h"
#import "SIMMyServiceVideo.h"
#import "SIMShareFromChooseViewController.h"

@interface SIMMyRoomViewController ()<CLConferenceDelegate>
{
    NSString *liveAdressHost;
    NSString *liveAdressPort;
    UIButton *edit;
}
@property (nonatomic, strong) SIMHeaderConfView *header;
@property (nonatomic, strong) SIMSendView *sendView;

@property (nonatomic, strong) ArrangeConfModel *myConf;
// 会议的
@property (nonatomic, strong) NSString *firstStr;
@property (nonatomic, strong) NSString *shareStr;
@property (nonatomic, strong) NSString *urlshareStr;
@end

@implementation SIMMyRoomViewController
-(instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestEditData2) name:EditMyConfSuccess object:nil];// 个人会议
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addSubViews];
    
    // 请求会议详情
    [self requestEditData2];
    
    edit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    edit.titleLabel.font = FontRegularName(15);
    [edit setTitle:SIMLocalizedString(@"NavBackEdit", nil) forState:UIControlStateNormal];
    [edit addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    [self editBtnCan:NO titleColor:GrayPromptTextColor];
    
    UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithCustomView:edit];
    self.navigationItem.rightBarButtonItem = done;
    
}

- (void)addSubViews {
    // 会议默认1
    _header = [[SIMHeaderConfView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 210)];
    _header.signType = @"1";
    [self.view addSubview:_header];
    
    __weak typeof (self)weakSelf = self;
    _header.btnClick = ^{
        [SIMNewEnterConfTool enterTheMineConfWithCid:weakSelf.currentUser.self_conf psw:@"" confType:EnterConfTypeConf isJoined:NO viewController:weakSelf];
    };
    _header.lookClick = ^{
        // 跳转到链接页面
//        SIMTempCompanyViewController *tempVC = [[SIMTempCompanyViewController alloc] init];
//        tempVC.navigationItem.title = @"观看直播";
//        NSString * urlsharedStr = weakSelf.urlshareStr;
//        tempVC.webStr = urlsharedStr;
//#if TypeXviewPrivate
//        tempVC.mainShare = YES;
//#endif
//        [weakSelf.navigationController pushViewController:tempVC animated:YES];
        
       NSString *firstStr = SIMLocalizedString(@"MMessEditLive", nil);
        NSString * sharedStr = [NSString stringWithFormat:@"%@%@",SIMLocalizedString(@"MMessEditConfOne", nil),firstStr];
        [weakSelf addActionSheetWithShareStr:sharedStr nameStr:firstStr urlStr:weakSelf.urlshareStr];
    };
    NSMutableArray *arrM = [NSMutableArray array];
    if ([self.cloudVersion.wechat boolValue]) {
        [arrM addObject:@{@"title":SIMLocalizedString(@"WeChatSend", nil),@"icon":@"wechatSend",@"serial":@"1001"}];
    }
    if ([self.cloudVersion.email boolValue]) {
        [arrM addObject:@{@"title":SIMLocalizedString(@"NewEmailSend", nil),@"icon":@"mail",@"serial":@"1002"}];
    }
    if ([self.cloudVersion.message boolValue]) {
        [arrM addObject:@{@"title":SIMLocalizedString(@"NewMessageSend", nil),@"icon":@"SMS",@"serial":@"1003"}];
    }
    if ([self.cloudVersion.pasteBoard boolValue]) {
        [arrM addObject:@{@"title":SIMLocalizedString(@"PaseboardSend", nil),@"icon":@"link",@"serial":@"1004"}];
    }
    [arrM addObject:@{@"title":SIMLocalizedString(@"ErweimaSendTitle", nil),@"icon":@"main_扫码入会",@"serial":@"1005"}];
    
    if (arrM.count > 0) {
        // 下面邀请部分的view
        _sendView = [[SIMSendView alloc] initWithFrame:CGRectMake(0, 210, screen_width, 150)];
        
        _sendView.array = arrM;
        
        _sendView.indexTagBlock = ^(NSInteger btnserial) {
            NSString *shareContent = [NSString stringWithFormat:SIMLocalizedString(@"ShareConfInviteOnePart", nil),weakSelf.currentUser.nickname,weakSelf.myConf.name,weakSelf.myConf.name,weakSelf.myConf.startTime,weakSelf.currentUser.nickname,weakSelf.urlshareStr];
            NSString *wechatContent = [NSString stringWithFormat:SIMLocalizedString(@"ShareConfInviteOnePartWechat", nil),weakSelf.myConf.name,weakSelf.myConf.startTime,weakSelf.currentUser.nickname,weakSelf.urlshareStr];
            if (btnserial == 1001) {
                
                NSString *titleStr = [NSString stringWithFormat:@"\n%@ %@ %@",weakSelf.currentUser.nickname,SIMLocalizedString(@"MMessageWechatTitle", nil),weakSelf.shareStr];
                
                [[SIMShareTool shareInstace] shareToWeChatWithShareStr:wechatContent shareImage:@"share_meeting" urlStr:weakSelf.urlshareStr ShareTitle:titleStr];
                
            }else if (btnserial == 1002) {
                // 邮件邀请
                [weakSelf sendEmailActiontitle:shareContent viewController:weakSelf];// 调用发送邮件
            }else if (btnserial == 1003) {
                [weakSelf showMessageViewbody:shareContent viewController:weakSelf];
//                [[SIMShareTool shareInstace] showMessageViewbody:shareContent viewController:weakSelf];// 调用发送短信
            }else if (btnserial == 1004) {
                [[SIMShareTool shareInstace] sendPasteboardActiontitle:shareContent];// 调用复制到剪贴板
            }else if (btnserial == 1005) {
                // 二维码保存
                SIMConfIDQRCodeViewController *qrcodeVC = [[SIMConfIDQRCodeViewController alloc] init];
                qrcodeVC.confURL = weakSelf.urlshareStr;
                [weakSelf.navigationController pushViewController:qrcodeVC animated:YES];
            }
        };
        [self.view addSubview:_sendView];
    }
//    UILabel *bottomLab = [[UILabel alloc] init];
//    bottomLab.text = SIMLocalizedString(@"ConfModesOptionsExplainContent", nil);
//    bottomLab.textColor = GrayPromptTextColor;
//    bottomLab.font = FontRegularName(17);
//    bottomLab.numberOfLines = 0;
//    bottomLab.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:bottomLab];
//    [bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(30);
//        make.right.mas_equalTo(-30);
//        make.bottom.mas_equalTo(-(BottomSaveH + 50));
//    }];
    
}
// 请求编辑页面数据 会议详情接口
- (void)requestEditData2 {
    
    [MainNetworkRequest confDetailRequestParams:@{@"cid":self.currentUser.self_conf,@"advice":@"all"} success:^(id success) {
        
        NSLog(@"succenewsssuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            // 保存模型
            _myConf = [[ArrangeConfModel alloc] initWithDictionary:success[@"data"]];
            // 保存到本地
            NSData * dat = [NSJSONSerialization dataWithJSONObject:success[@"data"] options:NSJSONWritingPrettyPrinted error:nil];
            [[NSUserDefaults standardUserDefaults] setObject:dat forKey:@"MYCONF"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSLog(@"success111%@",success);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self editBtnCan:YES titleColor:BlueButtonColor];
                _header.confM = _myConf;
                // 组成分享会议的完整连接
                NSString *title = SIMLocalizedString(@"MMessEditConf", nil);
                _firstStr = [[NSString alloc] initWithString:title];
                _shareStr = [NSString stringWithFormat:@"%@%@",SIMLocalizedString(@"MMessEditConfOne", nil),title];
                
        //        _urlshareStr = [NSString stringWithFormat:@"%@/admin/conference/joinmeeting?server=%@&port=%@&name=zc_test&token=11111&cid=%@&cp=%@&sm=web&anon=1&role=&ref=%@&data=&timetap=%@",urlString,webHostStr,webPortStr,self.currentUser.self_conf,self.myConf.normalPassword,[NSString stringWithFormat:@"iOS%@",app_Version],[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]];
//                _urlshareStr = [NSString stringWithFormat:@"%@&ref=%@&timetap=%@",self.myConf.roomUrl,[NSString stringWithFormat:@"iOS%@",getApp_Version],[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]];
                _urlshareStr = self.myConf.roomUrl;
                
//                if (liveAdressPort.length > 0) {
//                    _urlLiveStr = [NSString stringWithFormat:@"%@:%@?cid=%@",liveAdressHost,liveAdressPort,self.currentUser.self_conf];
//                }else {
//                    _urlLiveStr = [NSString stringWithFormat:@"%@?cid=%@",liveAdressHost,self.currentUser.self_conf];
//                }
            });
            
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
    }];

}

- (void)editClick {
    // 跳转编辑会议页面
    EditMyConfViewController *editVC = [[EditMyConfViewController alloc] init];
    editVC.isLive = self.isLive;
    editVC.myConf = self.myConf;
    [self.navigationController pushViewController:editVC animated:YES];
}
- (void)editBtnCan:(BOOL)isEdit titleColor:(UIColor *)titleColor{
    _header.convenceBtn.enabled = isEdit;
    [_header.convenceBtn setBackgroundColor:titleColor];
    edit.enabled = isEdit;
    [edit setTitleColor:titleColor forState:UIControlStateNormal];
    _header.lookLiving.enabled = isEdit;
}


#pragma mark -- UIAlertViewDelegate
- (void)addActionSheetWithShareStr:(NSString *)shareStr nameStr:(NSString *)namestr urlStr:(NSString *)urlstr{

//    NSString *shareContent;
//    NSString *wechatContent;
    
    NSString *shareContent = [NSString stringWithFormat:SIMLocalizedString(@"ShareConfInviteOnePart", nil),self.currentUser.nickname,self.myConf.name,self.myConf.name,self.myConf.startTime,self.currentUser.nickname,self.urlshareStr];
    NSString *wechatContent = [NSString stringWithFormat:SIMLocalizedString(@"ShareConfInviteOnePartWechat", nil),self.myConf.name,self.myConf.startTime,self.currentUser.nickname,self.urlshareStr];
    
//    if (self.teachIDStr != nil && [self.teachorConfStr isEqualToString:@"teaching"]) {
//        shareContent = [NSString stringWithFormat:SIMLocalizedString(@"ShareConfInviteOnePart_class", nil),self.currentUser.nickname,self.confMess.name,self.confMess.name,self.confMess.startTime,self.currentUser.nickname,urlstr];
//        wechatContent = [NSString stringWithFormat:SIMLocalizedString(@"ShareConfInviteOnePart_classWechat", nil),self.confMess.name,self.confMess.startTime,self.currentUser.nickname,urlstr];
//    }else {
//        shareContent = [NSString stringWithFormat:SIMLocalizedString(@"ShareConfInviteOnePart", nil),self.currentUser.nickname,self.confMess.name,self.confMess.name,self.confMess.startTime,self.currentUser.nickname,urlstr];
//        wechatContent = [NSString stringWithFormat:SIMLocalizedString(@"ShareConfInviteOnePartWechat", nil),self.confMess.name,self.confMess.startTime,self.currentUser.nickname,urlstr];
//    }
    NSLog(@"shareContentshareContent %@",shareContent);
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"WeChatSend", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 直接去微信分享
//        [self shareToWeChatWithShareStr:shareStr nameStr:namestr urlStr:urlstr];
//        NSString *messStr = [NSString stringWithFormat:@"%@ %@ %@ ",SIMLocalizedString(@"MMessageWechatSubject", nil),_confMess.name,SIMLocalizedString(@"MMessageWechatContant", nil)];

        NSString *titleStr = [NSString stringWithFormat:@"\n%@ %@ %@",self.currentUser.nickname,SIMLocalizedString(@"MMessageWechatTitle", nil),shareStr];

        [[SIMShareTool shareInstace] shareToWeChatWithShareStr:wechatContent shareImage:@"share_meeting" urlStr:urlstr ShareTitle:titleStr];

    }];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"MessageSend", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [self showMessageViewbody:shareContent viewController:self];
//        [[SIMShareTool shareInstace] showMessageViewbody:shareContent viewController:self];// 调用发送短信
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"MailSend", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self sendEmailActiontitle:shareContent viewController:self];// 调用发送邮件
    }];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"ShareToDepartMemberTitle", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 分享到企业联系人
        SIMShareFromChooseViewController *shareVC = [[SIMShareFromChooseViewController alloc] init];
        shareVC.shareText = shareContent;
        [self.navigationController pushViewController:shareVC animated:YES];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"PaseboardToSend", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[SIMShareTool shareInstace] sendPasteboardActiontitle:shareContent];// 调用复制到剪贴板
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [action4 setValue:RedButtonColor forKey:@"_titleTextColor"];

    if ([self.cloudVersion.wechat boolValue]) {
        [alertC addAction:action0];
    }
    if ([self.cloudVersion.message boolValue]) {
        [alertC addAction:action1];
    }
    if ([self.cloudVersion.email boolValue]) {
        [alertC addAction:action2];
    }
    if ([self.cloudVersion.im boolValue]) {
        [alertC addAction:action5];
    }
    if ([self.cloudVersion.pasteBoard boolValue]) {
        [alertC addAction:action3];
    }
    [alertC addAction:action4];
//    alertC.popoverPresentationController.sourceView = footerView;
//    alertC.popoverPresentationController.sourceRect = _inAdd.frame;
    alertC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    [self presentViewController:alertC animated:YES completion:nil];
}


@end
