//
//  SIMShareTool.h
//  Kaihuibao
//
//  Created by mac126 on 2019/4/10.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SIMShareTool : NSObject


+ (instancetype)shareInstace;


/**
 调用系统的发送短信的方法 带界面

 @param body 短信内容 现在用到的就是这个 将文字和链接拼接好
 @param viewController 当前需要发短信弹出的VC
 */
- (void)showMessageViewbody:(NSString *)body viewController:(UIViewController *)viewController;


/**
 调用系统的发送短信的方法 带界面 需要接受方手机号

 @param recipients 接收方手机号
 @param body 短信内容 现在用到的就是这个 将文字和链接拼接好
 @param viewController 当前需要发短信弹出的VC
 */
- (void)showMessageViewWithRecipients:(NSArray<NSString *> *)recipients body:(NSString *)body viewController:(UIViewController *)viewController;

/**
 调用系统的发送邮件的方法 带界面

 @param title 邮件的正文内容 将文字和链接拼接好
 @param viewController 当前需要发邮件弹出的VC
 */
- (void)sendEmailActiontitle:(NSString *)title viewController:(UIViewController *)viewController;

/**
 调用系统的复制到剪贴板的功能

 @param title 需要复制到剪贴板的内容
 */
- (void)sendPasteboardActiontitle:(NSString *)title;


/**
 无UI快速分享到微信

 @param shareStr 分享的内容
 @param shareImage 分享用图片
 @param urlstr 分享的URL
 @param shareTitle 分享的标题
 */
- (void)shareToWeChatWithShareStr:(NSString *)shareStr shareImage:(NSString *)shareImage urlStr:(NSString *)urlstr ShareTitle:(NSString *)shareTitle;

/**
 无UI快速分享到QQ

 @param shareStr 分享的内容
 @param shareImage 分享用图片
 @param urlstr 分享的URL
 @param shareTitle 分享的标题
 */
- (void)shareToQQWithShareStr:(NSString *)shareStr shareImage:(NSString *)shareImage urlStr:(NSString *)urlstr ShareTitle:(NSString *)shareTitle;


- (void)shareContentMethodWithShareStr:(NSString *)shareStr shareImage:(NSString *)shareImage urlStr:(NSString *)urlstr ShareTitle:(NSString *)shareTitle viewController:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
