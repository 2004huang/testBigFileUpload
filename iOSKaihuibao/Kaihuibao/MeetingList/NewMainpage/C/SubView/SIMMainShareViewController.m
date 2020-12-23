//
//  SIMMainShareViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/7/23.
//  Copyright © 2019 Ferris. All rights reserved.
//
#define Start_X (screen_width - Button_Width * 5)/6           // 第一个按钮的X坐标
#define Start_Y kWidthScale(300)          // 第一个按钮的Y坐标
#define Width_Space (screen_width - Button_Width * 5)/6        // 2个按钮之间的横间距
#define Height_Space 15.0f      // 竖间距
#define Button_Height kWidthScale(75)    // 高
#define Button_Width kWidthScale(65)      // 宽

#import "SIMMainShareViewController.h"
#import "SIMMeetBtn.h"
#import "SIMShareTool.h"
#import <Photos/Photos.h>
#import "UIButton+RCCImagePosition.h"

@interface SIMMainShareViewController ()
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) NSArray *array;

@end

@implementation SIMMainShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"ShareTheDownLoadTitle", nil);
    _imageV = [[UIImageView alloc] init];
    
#if TypeXviewPrivate
    _imageV.image = [UIImage imageNamed:@"scanErWeiMa_onzoom"];
#else
    _imageV.image = [UIImage imageNamed:@"scanErWeiMa"];
#endif

    [self.view addSubview:_imageV];
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(kWidthScale(50));
        make.height.mas_equalTo(kWidthScale(230));
        make.width.mas_equalTo(kWidthScale(210));
    }];
    NSMutableArray *arrM = [NSMutableArray array];
    if ([self.cloudVersion.wechat boolValue]) {
        [arrM addObject:@{@"title":SIMLocalizedString(@"WeChatSend", nil),@"icon":@"main_wechat"}];
    }
    if ([self.cloudVersion.email boolValue]) {
        [arrM addObject:@{@"title":SIMLocalizedString(@"NewEmailSend", nil),@"icon":@"main_mail"}];
    }
    if ([self.cloudVersion.message boolValue]) {
        [arrM addObject:@{@"title":SIMLocalizedString(@"NewMessageSend", nil),@"icon":@"main_SMS"}];
    }
    if ([self.cloudVersion.pasteBoard boolValue]) {
        [arrM addObject:@{@"title":SIMLocalizedString(@"PaseboardSend", nil),@"icon":@"main_复制链接"}];
    }
    [arrM addObject:@{@"title":SIMLocalizedString(@"SaveToThePhotoAlbum", nil),@"icon":@"main_本地保存"}];
    _array = arrM.copy;
    
    NSMutableArray * btArr = [NSMutableArray array];
    for (int i = 0 ; i < _array.count; i++) {
        // 按钮
//        SIMMeetBtn *aBt = [[SIMMeetBtn alloc] init];
        UIButton *aBt = [[UIButton alloc] init];
        [aBt setTitle:[_array[i] objectForKey:@"title"] forState:UIControlStateNormal];
        [aBt setImage:[UIImage imageNamed:[_array[i] objectForKey:@"icon"]] forState:UIControlStateNormal];
        aBt.imageView.contentMode = UIViewContentModeCenter;
        aBt.titleLabel.font = FontRegularName(14);
        aBt.titleLabel.textAlignment = NSTextAlignmentCenter;
        [aBt setTitleColor:ZJYColorHex(@"#6b6868") forState:UIControlStateNormal];
//        aBt.bounds = CGRectMake(0, 0, Button_Width, Button_Height);
        [aBt setImagePosition:RCCImagePositionTop spacing:10];
        
        [self.view addSubview:aBt];
        [aBt addTarget:self action:@selector(aBtClick:) forControlEvents:UIControlEventTouchUpInside];
        [btArr addObject:aBt];
    }
    
    [btArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:15 tailSpacing:15];
    [btArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageV.mas_bottom).offset(30.0);
    }];
}


- (void)aBtClick:(UIButton *)sender {
    NSString *titleStr = SIMLocalizedString(@"ShareContactInviteToWechatText", nil);
    NSString *messStr = @"点击免费下载";
    
#if TypeXviewPrivate
    NSString *urlstr = [NSString stringWithFormat:@"https://www.vymeet.com/download.html"];
#else
    NSString *urlstr = [NSString stringWithFormat:@"https://a.app.qq.com/o/simple.jsp?pkgname=com.kaihuibao.khb"];
#endif

    NSString *shareStr = [NSString stringWithFormat:@"%@%@%@",titleStr,messStr,urlstr];
    
    SIMMeetBtn * bt = (SIMMeetBtn *)sender;
    NSString * btTitleStr = bt.titleLabel.text;
    if ([btTitleStr isEqualToString:SIMLocalizedString(@"WeChatSend", nil)]) {
        // 微信添加
        [[SIMShareTool shareInstace] shareToWeChatWithShareStr:messStr shareImage:@"share_khbicon" urlStr:urlstr ShareTitle:titleStr];
    }else if ([btTitleStr isEqualToString:SIMLocalizedString(@"NewEmailSend", nil)]){
        // 调用发送邮件
        [self sendEmailActiontitle:shareStr viewController:self];

    }else if ([btTitleStr isEqualToString:SIMLocalizedString(@"NewMessageSend", nil)]){
        // 短信添加
        [self showMessageViewbody:shareStr viewController:self];

    }else if ([btTitleStr isEqualToString:SIMLocalizedString(@"PaseboardSend", nil)]){
        // 调用复制到剪贴板
        [[SIMShareTool shareInstace] sendPasteboardActiontitle:urlstr];

    }else if ([btTitleStr isEqualToString:SIMLocalizedString(@"SaveToThePhotoAlbum", nil)]){
        // 保存图片
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusNotDetermined || status == PHAuthorizationStatusAuthorized) {
                #if TypeXviewPrivate
                    NSString * imgName = @"scanErWeiMa_onzoom";
                #else
                    NSString * imgName = @"scanErWeiMa";
                #endif
                   UIImageWriteToSavedPhotosAlbum([UIImage imageNamed:imgName], self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);//保存图片到相册
            }else {
                // 没有权限
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:SIMLocalizedString(@"Setting_Info_Picture", nil)  message:SIMLocalizedString(@"Setting_Info_PictureText", nil) preferredStyle:UIAlertControllerStyleAlert];
                [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCSet", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   //跳入当前App设置界面
                   NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                   if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                       [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:^(BOOL        success) {
                       }];
                   }
                }]];
                [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:alertView animated:YES completion:nil];
            }
        }];
    }
}



//- (void)aBtClick:(UIButton *)sender {
//    NSString *titleStr = SIMLocalizedString(@"ShareContactInviteToWechatText", nil);
//    NSString *messStr = @"点击免费下载";
//    NSString *urlstr = [NSString stringWithFormat:@"https://a.app.qq.com/o/simple.jsp?pkgname=com.kaihuibao.khb"];
//    NSString *shareStr = [NSString stringWithFormat:@"%@%@%@",titleStr,messStr,urlstr];
//    switch (sender.tag) {
//        case 100:
//            {
//                // 微信添加
//                [[SIMShareTool shareInstace] shareToWeChatWithShareStr:messStr shareImage:@"share_khbicon" urlStr:urlstr ShareTitle:titleStr];
//            }
//            break;
//        case 101:
//        {
//            // 调用发送邮件
//            [self sendEmailActiontitle:shareStr viewController:self];
//        }
//            break;
//        case 102:
//        {
//            [self showMessageViewbody:shareStr viewController:self];
//            // 短信添加
////            [[SIMShareTool shareInstace] showMessageViewbody:shareStr viewController:self];
//        }
//            break;
//        case 103:
//        {
//            // 调用复制到剪贴板
//            [[SIMShareTool shareInstace] sendPasteboardActiontitle:shareStr];
//        }
//            break;
//        case 104:
//        {
//            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
//                if (status == PHAuthorizationStatusNotDetermined || status == PHAuthorizationStatusAuthorized) {
//                    UIImageWriteToSavedPhotosAlbum([UIImage imageNamed:@"scanErWeiMa"], self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);//保存图片到相册
//                }else {
//                    // 没有权限
//                    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:SIMLocalizedString(@"Setting_Info_Picture", nil)  message:SIMLocalizedString(@"Setting_Info_PictureText", nil) preferredStyle:UIAlertControllerStyleAlert];
//                    [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCSet", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        //跳入当前App设置界面
//                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                        if( [[UIApplication sharedApplication]canOpenURL:url] ) {
//                            [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:^(BOOL        success) {
//                            }];
//                        }
//                    }]];
//                    [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//                    }]];
//                    [self presentViewController:alertView animated:YES completion:nil];
//
//                }
//            }];
//        }
//            break;
//
//        default:
//            break;
//    }
//
//
//}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil) {
        [MBProgressHUD cc_showText:@"成功保存到本地相册，请前去查看"];
    }
    else{
        ///图片未能保存到本地
        [MBProgressHUD cc_showText:@"保存失败，请稍后再试"];
    }
}


@end
