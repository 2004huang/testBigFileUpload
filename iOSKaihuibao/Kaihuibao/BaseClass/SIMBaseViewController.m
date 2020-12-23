//
//  SIMBaseViewController.m
//  Kaihuibao
//
//  Created by Ferris on 2017/3/29.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"
#import "SIMShareTool.h"
#import "SIMShareFromChooseViewController.h"

#import <CinLanMedia/CLConference.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface SIMBaseViewController ()<CLConferenceDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIViewController *viewController;

@end

@implementation SIMBaseViewController
-(instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reConnectSecever:) name:connectSeverce object:nil];
        
        
    }
    return self;
}
- (void)reConnectSecever:(NSNotification *)notification {
    
}
- (void)speakStart:(NSNotification *)notification {
    NSLog(@"收到讲话通知");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}
/**
 *  总方法
 */
- (void)subStringAllMethod:(UITextField *)textField withLength:(int)minLength {
    NSString *toBeString = textField.text;
//    if (![self isInputRuleAndBlank:toBeString]) {//处理在系统输入法简体拼音下可选择表情的情况
//        textField.text = [self disable_emoji:toBeString];
//        return;
//    }
    
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 获取当前键盘输入模式
    //        NSLog(@"%@",lang);
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入,第三方输入法（搜狗）所有模式下都会显示“zh-Hans”
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            NSString *getStr = [self getSubString:toBeString withLength:minLength];
            if(getStr && getStr.length > 0) {
                textField.text = getStr;
            }
        }
    }else{
        NSString *getStr = [self getSubString:toBeString withLength:minLength];
        if(getStr && getStr.length > 0) {
            textField.text= getStr;
        }
    }
}


/**
 *  获得 kMinLength长度的字符
 */
-(NSString *)getSubString:(NSString*)string withLength:(int)minLength
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [string dataUsingEncoding:encoding];
    NSInteger length = [data length];
    if (length > minLength) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_NAME_length_fail", nil)];
        NSData *data1 = [data subdataWithRange:NSMakeRange(0, minLength)];
        NSString *content = [[NSString alloc] initWithData:data1 encoding:encoding];// 当截取kMinLength长度字符时把中文字符截断返回的content会是nil
        if (!content || content.length == 0) {
            data1 = [data subdataWithRange:NSMakeRange(0, minLength - 1)];
            content =  [[NSString alloc] initWithData:data1 encoding:encoding];
        }
        return content;
    }
    return nil;
    
}
// 这里是后期补充的内容:九宫格判断 和汉字和字母除符号
- (BOOL)isInputRuleAndBlank:(NSString *)str {
    
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d\\s]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    // 这里是后期补充的内容:九宫格判断
    if (!isMatch) {
        NSString *other = @"➋➌➍➎➏➐➑➒";
        unsigned long len=str.length;
        for(int i=0;i<len;i++)
        {
            unichar a=[str characterAtIndex:i];
            if(!((isalpha(a))
                 ||(isalnum(a))
                 ||((a=='_') || (a == '-'))
                 ||((a >= 0x4e00 && a <= 0x9fa6))
                 ||([other rangeOfString:str].location != NSNotFound)
                 ))
                return NO;
        }
        return YES;
        
    }
    return isMatch;
}

/**
 *  过滤字符串中的emoji
 */
- (NSString *)disable_emoji:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

- (BOOL)shouldAutorotate
{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"deallocNSStringFromClass %@", NSStringFromClass([self class]));
}


- (void)exitConference:(NSError * _Nullable)error {
    NSLog(@"退出会议");
    
    self.tabBarController.tabBar.tintColor = TabbarBtnSelectColor;
    self.tabBarController.tabBar.unselectedItemTintColor = TabbarBtnNormalColor;
    
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].statusBarHidden = NO;
}
- (void)confInviteWithVC:(UIViewController *)vc invatationType:(ConfInvitationType)invatationType url:(NSString *)url {
    
    NSString *shareContent = [NSString stringWithFormat:@"%@ %@ %@ ",self.currentUser.nickname,@"邀请您参加一场会议，点击链接即可入会",url];
    switch (invatationType) {
        case ConfInvitationTypeSMS:
            {
                //  短信
                [self showMessageViewbody:shareContent viewController:vc];
//                [[SIMShareTool shareInstace] showMessageViewbody:shareContent viewController:vc];
            }
            break;
        case ConfInvitationTypeCTC:
        {
            // The contact 联系人
            // 分享到企业联系人
            if ([self.cloudVersion.im boolValue]) {
                SIMShareFromChooseViewController *shareVC = [[SIMShareFromChooseViewController alloc] init];
                shareVC.shareText = shareContent;
                shareVC.isConfVC = YES;
                //            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:shareVC];
                UIViewController *viewcontroller = [shareVC sim_wrappedByNavigationViewControllerClass:[SIMBaseNavigationViewController class]];
                viewcontroller.modalPresentationStyle = UIModalPresentationFullScreen;
                [vc presentViewController:viewcontroller animated:YES completion:nil];
                //            [self presentViewController:shareVC animated:YES completion:nil];
                //            [vc.navigationController pushViewController:shareVC animated:YES];
            }else {
                [MBProgressHUD cc_showText:@"没有开通此功能"];
            }
            
        }
            break;
        case ConfInvitationTypeWEC:
        {
            // WeChat
            NSString *title = SIMLocalizedString(@"MMessEditConf", nil);
            NSString * sharedStr = [NSString stringWithFormat:@"%@%@",SIMLocalizedString(@"MMessEditConfOne", nil),title];
            NSString *messStr = SIMLocalizedString(@"ShareConfInviteToWechat", nil);
            NSString *titleStr = [NSString stringWithFormat:@"\n%@ %@ %@",self.currentUser.nickname,SIMLocalizedString(@"MMessageWechatTitle", nil),sharedStr];
            
            [[SIMShareTool shareInstace] shareToWeChatWithShareStr:messStr shareImage:@"share_meeting" urlStr:url ShareTitle:titleStr];
        }
            break;
        case ConfInvitationTypeURL:
        {
            // URL 拷贝
            [[SIMShareTool shareInstace] sendPasteboardActiontitle:shareContent];// 调用复制到剪贴板
        }
            break;
        
        default:
            break;
    }
    

}
/**
 会议清晰度修改回调
 
 @param resolution 会议视频清晰度
 */
- (void)ConfResolutionChanged:(ConfResolution)resolution {
    NSLog(@"resolutionresolution %ld",resolution);
//    [[NSUserDefaults standardUserDefaults] setInteger:resolution forKey:@"confConfig.resolution"];
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"confConfig.resolution.isset"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
会议速记
*/
- (void)confShorthandContent:(id)content {
    NSLog(@"confShorthandContent %@",content);
    NSDictionary *dic = (NSDictionary *)content;
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    [dicM setObject:dic[@"conf_id"] forKey:@"conf_id"];
    [dicM setObject:dic[@"user_id"] forKey:@"record_user_id"];
    [dicM setObject:dic[@"nickname"] forKey:@"record_user_name"];
    [dicM setObject:dic[@"srcText"] forKey:@"src_text"];
    [dicM setObject:dic[@"srcLanCode"] forKey:@"src_lan_code"];
    if (dic[@"tarText"] == nil) {
        [dicM setObject:@"" forKey:@"tar_text"];
    }else {
        [dicM setObject:dic[@"tarText"] forKey:@"tar_text"];
    }
    if (dic[@"tarLanCode"] == nil) {
        [dicM setObject:@"" forKey:@"tar_lan_code"];
    }else {
        [dicM setObject:dic[@"tarLanCode"] forKey:@"tar_lan_code"];
    }
    [dicM setObject:dic[@"ts"] forKey:@"time"];
    
    NSLog(@"confShorthandDicM %@",dicM);
    [MainNetworkRequest shorthandRecordRequestParams:dicM success:^(id success) {
        NSLog(@"shorthandDetailloadsuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
//            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

// 通过短信发送邀请
- (void)showMessageViewbody:(NSString *)body viewController:(UIViewController *)viewController {
    _viewController = viewController;
    [MBProgressHUD cc_showLoading:nil];
    
    if( [MFMessageComposeViewController canSendText] )
    {
        
        
        
        
        
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
//        controller.recipients = phones;
        controller.body = body;
        controller.messageComposeDelegate = self;
//        controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [viewController presentViewController:controller animated:YES completion:nil];
//        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
    }else {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"MessageSendTest", nil)];
    }
    
}
// 通过短信发送邀请 需要输入手机号的 后加的
- (void)showMessageViewWithRecipients:(NSArray<NSString *> *)recipients body:(NSString *)body viewController:(UIViewController *)viewController {
    _viewController = viewController;
    [MBProgressHUD cc_showLoading:nil];
    
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = recipients;
        controller.body = body;
        controller.messageComposeDelegate = self;
//        controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [viewController presentViewController:controller animated:YES completion:nil];
        //        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
    }else {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"MessageSendTest", nil)];
    }
    
}
// 通过邮件发送邀请
- (void)sendEmailActiontitle:(NSString *)title viewController:(UIViewController *)viewController {
    _viewController = viewController;
    if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
        // 邮件服务器
        MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
        // 设置邮件代理
        [mailCompose setMailComposeDelegate:self];
        
        // 设置邮件主题
        [mailCompose setSubject:SIMLocalizedString(@"MMailSendTest", nil)];
        
        // 设置收件人
        [mailCompose setToRecipients:nil];
        
        // 是否为HTML格式
        [mailCompose setMessageBody:title isHTML:NO];
        
        // 弹出邮件发送视图
        mailCompose.modalPresentationStyle = UIModalPresentationFullScreen;
        [viewController presentViewController:mailCompose animated:YES completion:nil];
    }else {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"MailSendTest", nil)];
    }
}
// 复制到剪贴板
- (void)sendPasteboardActiontitle:(NSString *)title {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = title;
    [MBProgressHUD cc_showSuccess:SIMLocalizedString(@"PaseboardToSended", nil)];
}

#pragma mark -- messageComposeDelegate
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
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
    [_viewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -- mailComposeDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            [MBProgressHUD cc_showSuccess:SIMLocalizedString(@"MailSendCancel", nil)];
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            [MBProgressHUD cc_showSuccess:SIMLocalizedString(@"MailSendSave", nil)];
            break;
        case MFMailComposeResultSent: // 用户点击发送
            [MBProgressHUD cc_showSuccess:SIMLocalizedString(@"MailSendSend", nil)];
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            [MBProgressHUD cc_showText:SIMLocalizedString(@"MailSendFail", nil)];
            break;
        default:
            break;
    }
    // 关闭邮件发送视图
    [_viewController dismissViewControllerAnimated:YES completion:nil];
}


@end
