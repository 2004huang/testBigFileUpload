//
//  SIMBaseViewController.h
//  Kaihuibao
//
//  Created by Ferris on 2017/3/29.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIMBaseViewController : UIViewController
/**
 *  总方法
 */
- (void)subStringAllMethod:(UITextField *)textField withLength:(int)minLength;
/**
 *  获得 kMinLength长度的字符
 */
-(NSString *)getSubString:(NSString*)string withLength:(int)minLength;
/**
 *  这里是后期补充的内容:九宫格判断 和汉字和字母除符号
 */
- (BOOL)isInputRuleAndBlank:(NSString *)str;
/**
 *  过滤字符串中的emoji
 */
- (NSString *)disable_emoji:(NSString *)text;


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


@end
