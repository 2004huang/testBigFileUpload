//
//  SIMShareTool.m
//  Kaihuibao
//
//  Created by mac126 on 2019/4/10.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMShareTool.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareSheetConfiguration.h>
#import <ShareSDKUI/ShareSDKUI.h>

#import "SIMAdressBookViewController.h"

@interface SIMShareTool()<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIViewController *viewController;

@end

static SIMShareTool *_instance = nil;

@implementation SIMShareTool
+ (instancetype)shareInstace {
    if (_instance) {
        return _instance;
    }
    return [[SIMShareTool alloc] init];
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

// 无UI快速分享到微信
- (void)shareToWeChatWithShareStr:(NSString *)shareStr shareImage:(NSString *)shareImage urlStr:(NSString *)urlstr ShareTitle:(NSString *)shareTitle {

    NSMutableDictionary *shareParams = [[NSMutableDictionary alloc] init];
    [shareParams SSDKSetupShareParamsByText:shareStr
                                     images:[UIImage imageNamed:shareImage]
                                        url:[NSURL URLWithString:urlstr]
                                      title:shareTitle
                                       type:SSDKContentTypeAuto];
    
    //进行分享
    [ShareSDK share:SSDKPlatformTypeWechat //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [MBProgressHUD cc_showText:SIMLocalizedString(@"AlertCShareSuccess", nil)];
                 
                 break;
             }
             case SSDKResponseStateFail:
             {
                 NSString *errorStr;
                 if (error.code == 208) {
                     NSLog(@"error%@",error);
                     errorStr = [NSString stringWithFormat:@"%@",SIMLocalizedString(@"AdressBookShareERROR", nil)];
                 }else {
                     errorStr = [NSString stringWithFormat:@"%@",SIMLocalizedString(@"AlertCShareFail", nil)];
                 }
                 [MBProgressHUD cc_showText:[NSString stringWithFormat:@"%@ %@",SIMLocalizedString(@"AlertCShareFail", nil),errorStr]];
                 break;
             }
             default:
                 break;
         }
         
     }];
}
// 无UI快速分享到QQ
- (void)shareToQQWithShareStr:(NSString *)shareStr shareImage:(NSString *)shareImage urlStr:(NSString *)urlstr ShareTitle:(NSString *)shareTitle {
    
    NSMutableDictionary *shareParams = [[NSMutableDictionary alloc] init];
    [shareParams SSDKSetupShareParamsByText:shareStr
                                     images:[UIImage imageNamed:shareImage]
                                        url:[NSURL URLWithString:urlstr]
                                      title:shareTitle
                                       type:SSDKContentTypeAuto];
    
    //进行分享
    [ShareSDK share:SSDKPlatformTypeQQ //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [MBProgressHUD cc_showText:SIMLocalizedString(@"AlertCShareSuccess", nil)];
                 
                 break;
             }
             case SSDKResponseStateFail:
             {
                 NSString *errorStr;
                 if (error.code == 208) {
                     NSLog(@"error%@",error);
                     errorStr = [NSString stringWithFormat:@"%@",SIMLocalizedString(@"AdressBookShareERROR", nil)];
                 }else {
                     errorStr = [NSString stringWithFormat:@"%@",SIMLocalizedString(@"AlertCShareFail", nil)];
                 }
                 [MBProgressHUD cc_showText:[NSString stringWithFormat:@"%@ %@",SIMLocalizedString(@"AlertCShareFail", nil),errorStr]];
                 break;
             }
             default:
                 break;
         }
         
     }];
}

- (void)shareContentMethodWithShareStr:(NSString *)shareStr shareImage:(NSString *)shareImage urlStr:(NSString *)urlstr ShareTitle:(NSString *)shareTitle viewController:(UIViewController *)viewController {
    _viewController = viewController;
    
    SSUIPlatformItem *itemMessage = [[SSUIPlatformItem alloc] init];
    itemMessage.iconNormal = [UIImage imageNamed:@"share_dx.png"];//默认版显示的图标
    itemMessage.iconSimple = [UIImage imageNamed:@"share_dx.png"];//简洁版显示的图标
    itemMessage.platformName = SIMLocalizedString(@"ShareInContant", nil);
    itemMessage.platformId = SIMLocalizedString(@"ShareInContant", nil);
    //添加点击事件
    [itemMessage addTarget:self action:@selector(costomPlatFormClick:)];
    
    NSArray * platforms =@[@(SSDKPlatformSubTypeQQFriend),
                           @(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),itemMessage];
    
    NSMutableDictionary *shareParams = [[NSMutableDictionary alloc] init];
    [shareParams SSDKSetupShareParamsByText:shareStr
                                     images:[UIImage imageNamed:shareImage]
                                        url:[NSURL URLWithString:urlstr]
                                      title:shareTitle
                                       type:SSDKContentTypeAuto];
    
    // 创建这个view容器是为了ipad上可以弹出框
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(10, screen_height - 120, screen_width - 20, 100)];
    [self.viewController.view addSubview:view];
    
    [ShareSDK showShareActionSheet:view customItems:platforms shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [MBProgressHUD cc_showText:SIMLocalizedString(@"AlertCShareSuccess", nil)];
                
                break;
            }
            case SSDKResponseStateFail:
            {
                NSString *errorStr;
                if (error.code == 105) {
                    NSLog(@"error%@",error);
                    errorStr = [NSString stringWithFormat:@"%@",SIMLocalizedString(@"AdressBookShareERROR", nil)];
                }else {
                    errorStr = [NSString stringWithFormat:@"%@",SIMLocalizedString(@"AlertCShareFail", nil)];
                }
                [MBProgressHUD cc_showText:[NSString stringWithFormat:@"%@ %@",SIMLocalizedString(@"AlertCShareFail", nil),errorStr]];
                break;
            }
            default:
                break;
        }
        
    }];
}

- (void)costomPlatFormClick:(SSUIPlatformItem *)item
{
    //自定义item被点击的处理逻辑
    SIMAdressBookViewController *adressBook = [[SIMAdressBookViewController alloc] init];
    adressBook.shareType = 1001;// 开会为1001
//    [self.viewController.navigationController pushViewController:adressBook animated:YES];
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [root.navigationController pushViewController:adressBook animated:YES];
    
    NSLog(@"点击了通讯录%s,---->%@",__func__,item.platformId);
}

@end
