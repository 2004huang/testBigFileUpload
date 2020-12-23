//
//  SIMEnterConfMessageViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/11/18.
//  Copyright © 2019 Ferris. All rights reserved.
//

#define Start_X (screen_width - Button_Width * 2)/3           // 第一个按钮的X坐标
#define Start_Y kWidthScale(160)          // 第一个按钮的Y坐标
#define Width_Space (screen_width - Button_Width * 2)/3        // 2个按钮之间的横间距
#define Height_Space 15.0f      // 竖间距
#define Button_Height kWidthScale(75)    // 高
#define Button_Width kWidthScale(80)      // 宽


#import "SIMEnterConfMessageViewController.h"
#import "SIMMeetBtn.h"
#import "SIMShareTool.h"
#import "SIMEntranceViewController.h"
#import "SIMLoginMainViewController.h"

@interface SIMEnterConfMessageViewController ()

@end

@implementation SIMEnterConfMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知";
    UIBarButtonItem *leftbtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    self.navigationItem.leftBarButtonItem = leftbtn;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 40, screen_width - 50, 100)];
    label.textColor = BlackTextColor;
    label.font = FontRegularName(17);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = @"好友的会议室试用已到期，快通知他，一起进行远程视频面对面沟通吧~~";
    [self.view addSubview:label];
    
    NSMutableArray *arrM = [NSMutableArray array];
    [arrM addObject:@{@"title":@"消息通知",@"icon":@"share_消息通知"}];
    if ([self.cloudVersion.wechat boolValue]) {
        [arrM addObject:@{@"title":@"微信通知",@"icon":@"main_wechat"}];
    }
    if ([self.cloudVersion.message boolValue]) {
        [arrM addObject:@{@"title":@"短信通知",@"icon":@"main_SMS"}];
    }
    if ([self.cloudVersion.email boolValue]) {
        [arrM addObject:@{@"title":@"邮件通知",@"icon":@"main_mail"}];
    }
    
    
    for (int i = 0 ; i < arrM.count; i++) {
        NSInteger index = i % 2;
        NSInteger page = i / 2;
        // 按钮
        SIMMeetBtn *aBt = [[SIMMeetBtn alloc] init];
        [aBt setTitle:[arrM[i] objectForKey:@"title"] forState:UIControlStateNormal];
        [aBt setImage:[UIImage imageNamed:[arrM[i] objectForKey:@"icon"]] forState:UIControlStateNormal];
        aBt.imageView.contentMode = UIViewContentModeCenter;
        aBt.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        
        aBt.titleLabel.font = FontRegularName(16);
        aBt.titleLabel.textAlignment = NSTextAlignmentCenter;
        [aBt setTitleColor:ZJYColorHex(@"#6b6868") forState:UIControlStateNormal];
        [self.view addSubview:aBt];
        aBt.tag = i + 100;
        [aBt addTarget:self action:@selector(aBtClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)aBtClick:(UIButton *)sender {
    NSString *titleStr = @"你有一个好友通知";
    NSString *messStr = @"您的会议室权益已经到期，导致无法加入您的会议室，请前去开会宝app充值或者开通计划。";
    NSString *urlstr = [NSString stringWithFormat:@"https://www.kaihuibao.net"];
    NSString *shareStr = [NSString stringWithFormat:@"%@%@",messStr,urlstr];
    switch (sender.tag) {
        case 100:
        {
            // 调用复制到剪贴板
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            
            pasteboard.string = shareStr;
            NSString *tokenStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
            if (tokenStr.length <= 0) {
                // 未登录
                // 消息通知
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"通知信息，已复制到粘贴板，请先登录然后去通知他吧" preferredStyle:UIAlertControllerStyleAlert];
                [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"JSBNextConfirmClick", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController dismissViewControllerAnimated:NO completion:^{
                        // 未登录
                        SIMEntranceViewController *vc = (SIMEntranceViewController *)windowRootViewController;
                        [vc.presentedViewController dismissViewControllerAnimated:NO completion:^{
                            
                        }];
                        UIViewController *loginNavigationViewController = [[[SIMLoginMainViewController alloc] init] sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
                        loginNavigationViewController.modalPresentationStyle = UIModalPresentationFullScreen;
                        [vc presentViewController:loginNavigationViewController animated:YES completion:nil];
                            
                    }];
                }]];
                [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

                }]];
                [self presentViewController:alertView animated:YES completion:nil];
                
                
            }else {
                // 登录后
                // 消息通知
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"通知信息，已复制到粘贴板，快去通知他吧" preferredStyle:UIAlertControllerStyleAlert];
                [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"JSBNextConfirmClick", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController dismissViewControllerAnimated:NO completion:^{
                        // 登录后
                        SIMTabBarViewController *tabVc = (SIMTabBarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
                        UINavigationController *selectedNavc = (UINavigationController *)tabVc.selectedViewController;
                        [selectedNavc popToRootViewControllerAnimated:NO];
                        [tabVc setSelectedIndex:3];
                    }];
                }]];
                [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

                }]];
                [self presentViewController:alertView animated:YES completion:nil];
            }
            
        }
            break;
        case 101:
        {
            // 微信添加
            [[SIMShareTool shareInstace] shareToWeChatWithShareStr:messStr shareImage:@"share_khbicon" urlStr:urlstr ShareTitle:titleStr];
            
        }
            break;
        case 102:
        {
            // 短信添加
//            [[SIMShareTool shareInstace] showMessageViewbody:shareStr viewController:self];
            [self showMessageViewbody:shareStr viewController:self];
        }
            break;
        case 103:
        {
            // 调用发送邮件
            [self sendEmailActiontitle:shareStr viewController:self];
        }
            break;
        
        default:
            break;
    }
}

- (void)leftBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
