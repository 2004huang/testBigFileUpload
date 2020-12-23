
//
//  SIMAdressNewViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/9/2.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMAdressNewViewController.h"

#import "SIMConverManView.h"
#import "XQButton.h"

#import <MessageUI/MessageUI.h>

@interface SIMAdressNewViewController ()<MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) UILabel *video;
@property (nonatomic, strong) UILabel *voice;
@property (nonatomic, strong) XQButton * takePhoneBtn;
@property (nonatomic, strong) XQButton * sendMessBtn;
@property (nonatomic, strong) XQButton * keepFitBtn;
@property (nonatomic, strong) XQButton * interConfBtn;
@property (nonatomic, strong) NSString *passWord;// 暂存自己的会议密码
@end


@implementation SIMAdressNewViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 导航透明
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar  setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
    [self.navigationController.navigationBar  setTranslucent:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = self.conts.nickname;
    [self addSubViews];
}

- (void)addSubViews {
    
    
    // 自定义返回按钮
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btn.frame= CGRectMake(0, 0, 40, 44);
//    [btn setImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    negativeSpacer.width = -20;
//    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, back, nil];
    
    
    SIMConverManView *conMan = [[SIMConverManView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    conMan.contant = self.conts;// 两种模型 这种是企业群组
    [self.view addSubview:conMan];
    
    
    _keepFitBtn = [[XQButton alloc] init];
    [_keepFitBtn setTitle:@"视频健身" forState:UIControlStateNormal];
    _keepFitBtn.tag = 1111;
    [_keepFitBtn addTarget:self action:@selector(buttonsClick:) forControlEvents:UIControlEventTouchUpInside];
    [_keepFitBtn setImage:[UIImage imageNamed:@"contants_subviews_keepfit"] forState:UIControlStateNormal];
    [self.view addSubview:_keepFitBtn];
    [_keepFitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(screen_width/2.0);
        make.height.mas_equalTo(kWidthScale(100));
    }];
    _interConfBtn = [[XQButton alloc] init];
    [_interConfBtn setTitle:@"视频通话" forState:UIControlStateNormal];
    _interConfBtn.tag = 1112;
    [_interConfBtn addTarget:self action:@selector(buttonsClick:) forControlEvents:UIControlEventTouchUpInside];
    [_interConfBtn setImage:[UIImage imageNamed:@"contants_subviews_video"] forState:UIControlStateNormal];
    [self.view addSubview:_interConfBtn];
    [_interConfBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(screen_width/2.0);
        make.height.mas_equalTo(kWidthScale(100));
    }];
    
    _takePhoneBtn = [[XQButton alloc] init];
    [_takePhoneBtn setTitle:@"拨打电话" forState:UIControlStateNormal];
    _takePhoneBtn.tag = 1113;
    [_takePhoneBtn addTarget:self action:@selector(buttonsClick:) forControlEvents:UIControlEventTouchUpInside];
    [_takePhoneBtn setImage:[UIImage imageNamed:@"contants_subviews_enterconf"] forState:UIControlStateNormal];
    [self.view addSubview:_takePhoneBtn];
    [_takePhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_keepFitBtn.mas_top);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(screen_width/2.0);
        make.height.mas_equalTo(kWidthScale(100));
    }];
    _sendMessBtn = [[XQButton alloc] init];
    [_sendMessBtn setTitle:@"发送短信" forState:UIControlStateNormal];
    _sendMessBtn.tag = 1114;
    [_sendMessBtn addTarget:self action:@selector(buttonsClick:) forControlEvents:UIControlEventTouchUpInside];
    [_sendMessBtn setImage:[UIImage imageNamed:@"contants_subviews_sendmessage"] forState:UIControlStateNormal];
    [self.view addSubview:_sendMessBtn];
    [_sendMessBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_interConfBtn.mas_top);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(screen_width/2.0);
        make.height.mas_equalTo(kWidthScale(100));
    }];
}

- (void)buttonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}


// 点击视频或者语音按钮
- (void)buttonsClick:(UIButton *)sender {
    if (sender.tag == 1111) {
        // 邀请健身
        // 发送短信 -- 不要了
        if ([MFMessageComposeViewController canSendText]) {
            [MBProgressHUD cc_showLoading:nil delay:3];
            NSString *messStr = [NSString stringWithFormat:@"%@:我正在使用与帅哥靓女视频健身，现在，你也一起来吧 %@",self.currentUser.nickname,[NSURL URLWithString:@"kaihuibao.net/5"]];
            [self showMessageView:@[self.conts.mobile] title:nil body:messStr];
        }else {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"MessageSendTest", nil)];
        }
        // 调用会议接口
//        [self transferVideoMethodWithUid:self.currentUser.uid name:self.currentUser.nickname token:[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"] confID:self.currentUser.self_conf psw:_passWord];
    }else if (sender.tag == 1112) {
        // 邀请开会
        // 发送短信 -- 不要了
        if ([MFMessageComposeViewController canSendText]) {
            [MBProgressHUD cc_showLoading:nil delay:3];
            NSString *messStr = [NSString stringWithFormat:@"%@:我已经节约了8000元的差旅费，现在请你也来体验。 %@",self.currentUser.nickname,[NSURL URLWithString:@"kaihuibao.net"]];
            [self showMessageView:@[self.conts.mobile] title:nil body:messStr];
        }else {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"MessageSendTest", nil)];
        }
    }else if (sender.tag == 1113) {
        // 拨打电话 -- 不要了
        NSString *phonestring = [NSString stringWithFormat:@"%@:%@",@"telprompt",self.conts.mobile];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:phonestring] options:@{} completionHandler:^(BOOL success) {
        }];
    }else if (sender.tag == 1114) {
        // 发送短信 -- 不要了
        if ([MFMessageComposeViewController canSendText]) {
            [MBProgressHUD cc_showLoading:nil delay:3];
            NSString *messStr = [NSString stringWithFormat:@"%@:我已经节约了8000元的差旅费，现在请你也来体验。 %@",self.currentUser.nickname,[NSURL URLWithString:@"kaihuibao.net"]];
            [self showMessageView:@[self.conts.mobile] title:nil body:messStr];
        }else {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"MessageSendTest", nil)];
        }
    }
    
}



-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.body = body;
        controller.messageComposeDelegate = self;
        controller.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
}
#pragma mark -- messageComposeDelegate
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            [MBProgressHUD cc_showSuccess:SIMLocalizedString(@"MessageSendSend", nil)];
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            [MBProgressHUD cc_showFail:SIMLocalizedString(@"MessageSendFail", nil)];
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            [MBProgressHUD cc_showSuccess:SIMLocalizedString(@"MessageSendCancel", nil)];
            break;
        default:
            break;
    }
}


@end
