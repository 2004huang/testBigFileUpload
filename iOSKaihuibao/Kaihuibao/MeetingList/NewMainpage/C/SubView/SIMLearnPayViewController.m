//
//  SIMLearnPayViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2020/7/6.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import "SIMLearnPayViewController.h"

@interface SIMLearnPayViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *backImg;
@property (nonatomic, strong) UIButton *gotoBuy;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *backView;

@end

@implementation SIMLearnPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"译员认证";
    [self addUISubViews];
    [self addDatas];
}
- (void)addDatas {
//    CGFloat hei = [_model.height floatValue]/2;
//    [_image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiBaseUrl,_model.image]] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
//     _scrollView.contentSize = CGSizeMake(screen_width, hei);
//    _backImg.frame = CGRectMake(0, 0, screen_width, hei);
    
}
- (void)addUISubViews {
    //添加滚动视图
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen_width,screen_height - StatusNavH - 50)];
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _backView = [[UIView alloc] init];
    [_scrollView addSubview:self.backView];
//    
//    NSUInteger rowNum = (arr.count + (_arrCount - 1)) / _arrCount;
//    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(10);
//        make.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(Start_Y + Button_Height* rowNum + Height_Space*(rowNum-1));
//        make.bottom.mas_equalTo(-20);
//    }];
    
    _backImg = [[UIImageView alloc] init];
    _backImg.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_backImg];
    
    _gotoBuy = [[UIButton alloc] init];
    [_gotoBuy setTitle:@"￥999/年 完成认证" forState:UIControlStateNormal];
    [_gotoBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_gotoBuy setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [_gotoBuy setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    _gotoBuy.backgroundColor = BlueButtonColor;
    [_gotoBuy addTarget:self action:@selector(pushTheNextPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_gotoBuy];
    [_gotoBuy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
}
- (void)pushTheNextPage {
    NSLog(@"点击了去支付的按钮");
}

@end
