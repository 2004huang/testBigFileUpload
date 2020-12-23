//
//  SIMBaseCommonTableViewCell.h
//  Kaihuibao
//
//  Created by Ferris on 2017/4/3.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJOptionView.h"
@interface SIMBaseCommonTableViewCell : UITableViewCell
@property (strong,nonatomic,readonly) UIImageView *leftImageView;
@property (strong,nonatomic,readonly) UIImageView *avatarImageView;
@property (strong,nonatomic,readonly) UIImageView *deviceImageView;
@property (strong,nonatomic,readonly) UILabel *label;
@property (strong,nonatomic,readonly) UILabel *promptLabel;
@property (strong,nonatomic,readonly) UILabel *iconLabel;
@property (strong,nonatomic,readonly) UITextField *putin;
@property (strong,nonatomic,readonly) UILabel *numLab;
@property (strong,nonatomic,readonly) UITextView *textView;
@property (strong,nonatomic,readonly) JJOptionView *optionView;
-(instancetype)initWithTitle:(NSString*)title leftViewImage:(UIImage*)image;
-(instancetype)initWithTitle:(NSString*)title;
-(instancetype)initWithTitle:(NSString*)title prompt:(NSString*)prompt;
-(instancetype)initWithActionTitle:(NSString*)title;
-(instancetype)initWithTitle:(NSString *)title putin:(NSString *)putin;
-(instancetype)initWithTitle:(NSString *)title rightViewImage:(NSURL *)imageurl;
-(instancetype)initWithTitle:(NSString *)title expalinPrompt:(NSString *)prompt;
-(instancetype)initWithTitle:(NSString *)title leftputin:(NSString *)putin;
-(instancetype)initWithTitleWithAccessory:(NSString *)title;
-(instancetype)initWithLeftImage:(NSString *)imageIcon Title:(NSString *)title prompt:(NSString *)prompt;
-(instancetype)initWithLeftIcon:(NSString *)iconStr Title:(NSString *)title rightViewImage:(NSURL *)imageurl;
-(instancetype)initWithJSBTitle:(NSString *)title rightViewImage:(NSURL *)imageurl; // 健身包个人资料用
-(instancetype)initWithJSBTitleWithTextView:(NSString *)title withNumber:(NSString *)numCount; // 健身宝用的简介输入框
-(instancetype)initWithJSBTitle:(NSString *)title prompt:(NSString *)prompt;
-(instancetype)initWithTitle:(NSString *)title isChooseMore:(BOOL)isChooseMore optionViewArr:(NSArray *)arr viewController:(UIViewController<JJOptionViewDelegate> *)viewController;
@end
