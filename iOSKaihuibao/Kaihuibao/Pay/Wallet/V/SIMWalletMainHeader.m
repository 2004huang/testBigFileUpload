//
//  SIMWalletMainHeader.m
//  Kaihuibao
//
//  Created by mac126 on 2019/7/5.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMWalletMainHeader.h"
@interface SIMWalletMainHeader()
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *littleBackImg;
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *detailLab;
@property (nonatomic, strong) UILabel *explainLab;
@property (nonatomic, strong) UILabel *typeLab;

@end
@implementation SIMWalletMainHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = ZJYColorHex(@"#0d0d0d");
        [self addDatas];
    }return self;
}
- (void)setBalanceCount:(NSString *)balanceCount {
    _balanceCount = balanceCount;
    NSString *priceStr = [NSString stringWithFormat:@"充值金额：%@ 元",_balanceCount];
    NSMutableAttributedString *patString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [patString addAttributes:@{NSFontAttributeName:FontRegularName(kWidthScale(16))
                                } range:NSMakeRange(0, 5)];
    [patString addAttributes:@{NSFontAttributeName:FontRegularName(kWidthScale(16))
    } range:NSMakeRange(priceStr.length - 1, 1)];
//    [patString addAttributes:@{NSFontAttributeName:FontRegularName(kWidthScale(26))
//                               } range:NSMakeRange(0, 1)];
    self.priceLab.attributedText = patString;
}
- (void)addDatas {
    [self addSubview:self.priceLab];
//    [self addSubview:self.title];
    
//    NSString *priceStr = [NSString stringWithFormat:@"￥%@",@"0.00"];
//    NSMutableAttributedString *patString = [[NSMutableAttributedString alloc] initWithString:priceStr];
//    [patString addAttributes:@{NSFontAttributeName:FontRegularName(kWidthScale(26))
//                              } range:NSMakeRange(0, 1)];
    
//    self.title.text = SIMLocalizedString(@"TopUpwallet_nowCount", nil);
    
//    [self.backImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(kWidthScale(257));
//    }];
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.centerY.mas_equalTo(0);
    }];
//    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(_priceLab);
//        make.top.mas_equalTo(_priceLab.mas_bottom).offset(kWidthScale(15));
//    }];
}
#pragma mark -- lazyload
- (UILabel *)priceLab {
    if (!_priceLab) {
        _priceLab = [[UILabel alloc] init];
        _priceLab.textColor = [UIColor whiteColor];
        _priceLab.font = FontRegularName(kWidthScale(30));
        _priceLab.textAlignment = NSTextAlignmentCenter;
    }return _priceLab;
}
- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor whiteColor];
        _title.font = FontRegularName(kWidthScale(15));
        _title.textAlignment = NSTextAlignmentCenter;
    }return _title;
}

- (UIImageView *)littleBackImg {
    if (!_littleBackImg) {
        _littleBackImg = [[UIImageView alloc] init];
        _littleBackImg.image = [UIImage imageNamed:@"wallet_littleBack"];
    }
    return _littleBackImg;
}
- (UIImageView *)iconImg {
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.image = [UIImage imageNamed:@"wallet_littleIcon"];
    }
    return _iconImg;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = ZJYColorHex(@"#85571f");
        _titleLab.font = FontRegularName(kWidthScale(16));
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }return _titleLab;
}

- (UILabel *)detailLab {
    if (!_detailLab) {
        _detailLab = [[UILabel alloc] init];
        _detailLab.textColor = ZJYColorHex(@"#85571f");
        _detailLab.font = FontRegularName(kWidthScale(13));
        _detailLab.textAlignment = NSTextAlignmentCenter;
    }return _detailLab;
}

- (UILabel *)explainLab {
    if (!_explainLab) {
        _explainLab = [[UILabel alloc] init];
        _explainLab.textColor = ZJYColorHex(@"#85571f");
        _explainLab.font = FontRegularName(kWidthScale(13));
        _explainLab.textAlignment = NSTextAlignmentCenter;
    }return _explainLab;
}
- (UILabel *)typeLab {
    if (!_typeLab) {
        _typeLab = [[UILabel alloc] init];
        _typeLab.textColor = ZJYColorHex(@"#f73f43");
        _typeLab.font = FontRegularName(kWidthScale(12));
        _typeLab.textAlignment = NSTextAlignmentCenter;
        _typeLab.layer.borderColor = ZJYColorHex(@"#f73f43").CGColor;
        _typeLab.layer.borderWidth = 1;
        _typeLab.backgroundColor = ZJYColorHex(@"#fce1e2");
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_typeLab.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(8,8)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _typeLab.bounds;
        maskLayer.path = maskPath.CGPath;
        _typeLab.layer.mask = maskLayer;
        _typeLab.adjustsFontSizeToFitWidth = YES;
    }return _typeLab;
}


@end
