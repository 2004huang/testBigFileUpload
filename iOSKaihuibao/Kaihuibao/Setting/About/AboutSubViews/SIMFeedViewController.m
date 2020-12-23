//
//  SIMFeedViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/25.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMFeedViewController.h"

@interface SIMFeedViewController ()
{
    UITextView *tev;
}
@end

@implementation SIMFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"SSendFeedPage", nil);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rbut=[[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"NavBackSend", nil) style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    self.navigationItem.rightBarButtonItem=rbut;
    
    UILabel *label=[[UILabel alloc] init];
    label.textColor = TableViewHeaderColor;
    label.text = SIMLocalizedString(@"SSendFeedPageTest", nil);
    label.font = FontRegularName(14);
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    tev = [[UITextView alloc] init];
    tev.backgroundColor = ZJYColorHex(@"#eeeeee");
    tev.font = FontRegularName(15);
    tev.layer.borderColor = ZJYColorHex(@"#d2d2d2").CGColor;
    tev.layer.borderWidth = 0.5;
    tev.layer.cornerRadius = 5;
    tev.layer.masksToBounds = YES;
    [self.view addSubview:tev];
    [tev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(250);
    }];

    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
 
}
//按钮的响应方法
-(void)finish
{
    [MBProgressHUD cc_showLoading:nil];
    // 将文字发给服务器
    NSString *temptext = [tev.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; //去除空格
    NSString *textString = [temptext stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//去除Tab,Enter,Blank
    if (textString.length==0) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"SSendFeed_not_empty", nil)];
        return;
    }
    
    // 改的密码上传
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    [dicM setObject:textString forKey:@"content"];
    
    [MainNetworkRequest sendFeedBackRequestParams:dicM success:^(id success) {
        NSLog(@"feedSendsuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [MBProgressHUD cc_showSuccess:success[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
