//
//  SIMContentLabViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/10/18.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMContentLabViewController.h"

@interface SIMContentLabViewController ()<UITextViewDelegate>
{
    UITextView *_tev;
    UIBarButtonItem *_rbut;
}
@end

@implementation SIMContentLabViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tev becomeFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"MArrangeConfExplain", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    _rbut=[[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"NavBackSave", nil) style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    self.navigationItem.rightBarButtonItem=_rbut;
    _rbut.enabled = NO;
    
    UILabel *label=[[UILabel alloc] init];
    label.textColor = TableViewHeaderColor;
    label.text = SIMLocalizedString(@"MArrangeConfExplainTest", nil);
    label.font = FontRegularName(14);
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(10);
    }];
    
    _tev = [[UITextView alloc] init];
    _tev.delegate = self;
    _tev.backgroundColor = ZJYColorHex(@"#eeeeee");
    _tev.font = FontRegularName(15);
    _tev.layer.borderColor = ZJYColorHex(@"#d2d2d2").CGColor;
    _tev.layer.borderWidth = 0.5;
    _tev.layer.cornerRadius = 5;
    _tev.layer.masksToBounds = YES;
    [self.view addSubview:_tev];
    [_tev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(150);
    }];
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    _tev.text = self.classStr;
    _rbut.enabled = YES;
}
//按钮的响应方法
-(void)finish
{
    [self.delegate contentConfString:_tev.text];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- UITextFieldDelegate
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    // 文字内容空 则完成按钮不可点击
//    NSUInteger length = textView.text.length - range.length + text.length;
//    if (length > 0) {
//        _rbut.enabled = YES;
//    } else {
//        _rbut.enabled = NO;
//    }
//    return YES;
//}

@end
