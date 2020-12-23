//
//  SIMServerCenterDetailViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2020/5/28.
//  Copyright © 2020 Ferris. All rights reserved.
//
#define Button_Height 103    // 高
#define Button_Width 100      // 宽
#define Start_X  (screen_width - Button_Width * 3)/3           // 第一个按钮的X坐标

#define Width_Space (screen_width - Button_Width * 3)/6        // 2个按钮之间的横间距
#define Height_Space 10.0f      // 竖间距


#import "SIMServerCenterDetailViewController.h"
#import "SIMTempCompanyViewController.h"
#import "SIMServerPicViewController.h"

@interface SIMServerCenterDetailViewController ()<CLConferenceDelegate>
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *detailLab;
@property (nonatomic, strong) NSArray *btnArr;
@property (nonatomic, strong) NSDictionary *dicAll;

@end

@implementation SIMServerCenterDetailViewController

-(instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterTheConf:) name:@"SEVERCENTERENTERCONF" object:nil];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getDatas:self.serial];
}
- (void)enterTheConf:(NSNotification *)notification {
    NSString *confid = [[notification userInfo] valueForKey:@"confId"];
    if (confid != nil) {
        [SIMNewEnterConfTool enterTheMineConfWithCid:confid psw:@"" confType:EnterConfTypeConf isJoined:NO viewController:self];
    }
    
}


- (void)addUISubViews:(NSDictionary *)dic {
    self.navigationItem.title = dic[@"title"];
    
    _img = [[UIImageView alloc] init];
//    _img.backgroundColor = ZJYColorHex(@"#eeeeee");
    _img.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_img];
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kWidthScale(50));
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(kWidthScale(280));
        make.height.mas_equalTo(kWidthScale(150));
    }];
    // 主标题label
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = FontRegularName(15);
    _titleLab.textColor = BlackTextColor;
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_img.mas_bottom).offset(kWidthScale(30));
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
    }];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = ZJYColorHex(@"#eeeeee");
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLab.mas_bottom).offset(kWidthScale(40));
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(1);
    }];
    
    _detailLab = [[UILabel alloc] init];
    _detailLab.font = FontRegularName(15);
    _detailLab.textColor = BlackTextColor;
    _detailLab.numberOfLines = 0;
    _detailLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_detailLab];
    [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).offset(kWidthScale(30));
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
    }];
    [_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiBaseUrl,dic[@"image"]]] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    _titleLab.text = dic[@"title"];
    _detailLab.text = dic[@"explanation"];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    CGFloat Start_Y = _detailLab.bottom + kWidthScale(25);        // 第一个按钮的Y坐标
    
    _btnArr = dic[@"botton_buttons"];
    for (int i = 0 ; i < _btnArr.count; i++) {
        NSInteger index = i % 3;
        NSInteger page = i / 3;
        NSDictionary *dic = _btnArr[i];
        UIButton *btn = [[UIButton alloc] init];
        [btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiBaseUrl,dic[@"picture"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageWithColor:ZJYColorHex(@"#eeeeee")] options:SDWebImageAllowInvalidSSLCertificates];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btn.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        btn.tag = i;
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}
- (void)btnClick:(UIButton *)sender {
    NSDictionary *dic = _btnArr[sender.tag];
    if ([dic[@"jump_type"] isEqualToString:@"conf"]) {
        SIMServerPicViewController *picVC = [[SIMServerPicViewController alloc] init];
        picVC.dic = self.dicAll;
        picVC.conf_id = dic[@"conf_id"];
        picVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:picVC animated:YES completion:nil];
    }else if ([dic[@"jump_type"] isEqualToString:@"url"]) {
        // 跳转到链接页面
        SIMTempCompanyViewController *webVC = [[SIMTempCompanyViewController alloc] init];
        webVC.navigationItem.title = @"详情";
        webVC.webStr = dic[@"url"];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}
- (void)getDatas:(NSString *)serial {
    [MainNetworkRequest servicecenterinfoRequestParams:@{@"id":self.serial} success:^(id success) {
        NSLog(@"severCenterdetailListsuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            NSDictionary *dic = success[@"data"];
            _dicAll = dic;
            [self addUISubViews:dic];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
