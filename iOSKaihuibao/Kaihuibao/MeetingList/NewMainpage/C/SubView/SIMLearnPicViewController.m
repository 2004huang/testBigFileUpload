//
//  SIMLearnPicViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2020/7/6.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import "SIMLearnPicViewController.h"
#import "SIMLearnPayViewController.h"

@interface SIMLearnPicViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *backImg;
@property (nonatomic, strong) UIButton *gotoBuy;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSDictionary *dic;
@end

@implementation SIMLearnPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self addUISubViews];
    if (self.typeStr == 5007) {
        [self footerViewRequestDatas:@"knowledge"];
    }else {
        [self footerViewRequestDatas:@"video"];
    }
    
}

- (void)addUISubViews {
    self.navigationItem.title = _dic[@"name"];
    CGFloat imghei = [_dic[@"height"] floatValue]/2.0;
    CGFloat hei = kWidthScale(imghei);
    NSLog(@"heiheihei %lf",hei);
    
    //添加滚动视图
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(screen_height - StatusNavH);
    }];
    // 添加空内容view
    UIView *contentView = [[UIView alloc] init];
    [_scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.mas_equalTo(0);
        make.width.mas_equalTo(_scrollView.mas_width);
    }];
    
    _backImg = [[UIImageView alloc] init];
//    _backImg.userInteractionEnabled = YES;
    _backImg.contentMode = UIViewContentModeScaleAspectFit;
    [contentView addSubview:_backImg];
    [_backImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiBaseUrl,_dic[@"image"]]] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    
    [_backImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(_scrollView.mas_width);
        make.height.mas_equalTo(hei);
    }];
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_backImg.mas_bottom).offset(10);
    }];
    
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"点击了去支付的按钮");
//
//    if ([[_dic[@"jump_pay"] stringValue] length] > 0) {
//        SIMLearnPayViewController *payVC = [[SIMLearnPayViewController alloc] init];
//        payVC.shareID = [_dic[@"jump_pay"] stringValue];
//        [self.navigationController pushViewController:payVC animated:YES];
//    }
//
//
//}

// 是否上线展示支付相关内容
- (void)footerViewRequestDatas:(NSString *)typeStr {
    [MainNetworkRequest commodityInfoRequestParams:@{@"commodity_type":typeStr} success:^(id success) {
        // 成功
        NSLog(@"commodityInfoSuccess  %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            _dic = [[NSDictionary alloc] initWithDictionary:success[@"data"]];
        
            [self addUISubViews];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}

@end
