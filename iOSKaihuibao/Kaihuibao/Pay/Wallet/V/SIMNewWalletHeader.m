//
//  SIMNewWalletHeader.m
//  Kaihuibao
//
//  Created by mac126 on 2020/2/25.
//  Copyright © 2020 Ferris. All rights reserved.
//
#define Button_Width (screen_width - 20)/2     // 宽

#import "SIMNewWalletHeader.h"
@interface SIMNewWalletHeader()

@property (nonatomic, strong) UIImageView *backImg;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *title;
//@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *tempButtonArray;
@end
@implementation SIMNewWalletHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        
        self.buttonArray = [[NSMutableArray alloc] init];
        self.tempButtonArray = [[NSMutableArray alloc] init];
        
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = BlueButtonColor;
        _backView.layer.cornerRadius = 8;
        _backView.layer.masksToBounds = YES;
        [self addSubview:_backView];
       
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(12);
            make.bottom.mas_equalTo(-35);
        }];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 10, screen_width, 10)];
        bottomView.backgroundColor = ZJYColorHex(@"#f7f7f9");
        [self addSubview:bottomView];
        
    }return self;
}
- (void)setBalanceCount:(NSString *)balanceCount {
    _balanceCount = balanceCount;
    NSString *priceStr = [NSString stringWithFormat:@"￥%@",_balanceCount];
    NSArray *arr = @[SIMLocalizedString(@"MineBalanceTitle", nil)];
    NSArray *priceArr = @[@"￥0.00",priceStr];
    NSArray *buttonTitles = @[SIMLocalizedString(@"MineBalanceGetTitle", nil)];
    
    if (self.buttonArray.count > 0) {
        [self.buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
//    for (int buttonIndex = 0 ; buttonIndex < arr.count; buttonIndex++) {
        NSInteger index = 0 % 2;
        
        UIView *btnBkView = [[UIView alloc] init];
    
        [_backView addSubview:btnBkView];
    [btnBkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FontRegularName(16);
        label.textColor = [UIColor whiteColor];
        label.text = arr[0];
        [btnBkView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(30);
       }];
        
        UILabel *pricel = [[UILabel alloc] init];
//        pricel.frame = CGRectMake(5, 65, Button_Width - 10, 35);
        pricel.textAlignment = NSTextAlignmentCenter;
        pricel.textColor = [UIColor whiteColor];
        pricel.font = FontRegularName(25);
        [btnBkView addSubview:pricel];
        [pricel mas_makeConstraints:^(MASConstraintMaker *make) {
               make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(label.mas_bottom).offset(15);
              }];
    
        NSMutableAttributedString *atString = [[NSMutableAttributedString alloc] initWithString:priceArr[index]];
        [atString addAttributes:@{NSFontAttributeName:FontRegularName(18),
                                  } range:NSMakeRange(0, 1)];
        pricel.attributedText = atString;
        
        UIButton *button = [[UIButton alloc] init];
//        button.frame = CGRectMake(btnBkView.frame.size.width/2 - 50, 120, 100, 35);
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:BlueButtonColor forState:UIControlStateNormal];
        button.titleLabel.font = FontRegularName(14);
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = YES;
        button.tag = 1000 + 1;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:buttonTitles[index] forState:UIControlStateNormal];
        [btnBkView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
                  make.centerX.mas_equalTo(0);
               make.top.mas_equalTo(pricel.mas_bottom).offset(15);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(35);
                 }];
        
        [self.buttonArray addObject:btnBkView];
//    }
    
    
}
//- (void)addSubViews {
//    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 85, screen_width, 75)];
//    _backView.backgroundColor = [UIColor whiteColor];
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_backView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = _backView.bounds;
//    maskLayer.path = maskPath.CGPath;
//    _backView.layer.mask = maskLayer;
//    [self addSubview:_backView];
//
//    if (self.tempButtonArray.count > 0) {
//        [self.tempButtonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    }
//    NSArray *arr = @[@"去获取红包",@"去充值"];
//    NSArray *imageArr = @[@"walletnew_hongbao",@"walletnew_chongzhi"];
//
//    for (int buttonIndex = 0 ; buttonIndex < arr.count; buttonIndex++) {
//
//        UIButton *button = [[UIButton alloc] init];
//        [button setTitle:arr[buttonIndex] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:imageArr[buttonIndex]] forState:UIControlStateNormal];
//        button.tag = 1000+buttonIndex;
//        button.frame = CGRectMake(buttonIndex * (screen_width/2), 0, screen_width/2, 75);
//        [button setTitleColor:BlackTextColor forState:UIControlStateNormal];
//        button.titleLabel.font = FontMediumName(15);
//        button.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [_backView addSubview:button];
//        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.tempButtonArray addObject:button];
//
//        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
//        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
//    }
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(screen_width/2, 20, 1, _backView.frame.size.height - 40)];
//    line.backgroundColor = ZJYColorHex(@"#eeeeee");
//    [_backView addSubview:line];
//

//
//
//}

- (void)buttonClick:(UIButton *)sender {
    if (self.indexTagBlock) {
        self.indexTagBlock(sender.tag);
    }
}

@end
