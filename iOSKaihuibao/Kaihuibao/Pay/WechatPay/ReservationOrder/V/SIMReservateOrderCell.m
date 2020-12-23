//
//  SIMReservateOrderCell.m
//  Kaihuibao
//
//  Created by mac126 on 2019/10/31.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMReservateOrderCell.h"
@interface SIMReservateOrderCell()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIImageView *imageAss;
@property (nonatomic, strong) UILabel *titleName;
@property (nonatomic, strong) UILabel *deadline;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *payResultLab;
@property (nonatomic, strong) UILabel *priceAllLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UIView *bottomline;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *buyBtn;

@end

@implementation SIMReservateOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = ZJYColorHex(@"#f7f7f7");
        
        [self setUpTitleView];
        
    }return self;
}
- (void)setUpTitleView {
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.cornerRadius = 5;
    _backView.layer.masksToBounds = YES;
    _backView.layer.borderColor = ZJYColorHex(@"#ebebeb").CGColor;
    _backView.layer.borderWidth = 1;
    [self.contentView addSubview:_backView];
    
    // 有效期
    _deadline = [[UILabel alloc] init];
    _deadline.font = FontRegularName(kWidthS(13));
    _deadline.textColor = BlackTextColor;
    [_backView addSubview:_deadline];
    
    // 支付结果
    _payResultLab = [[UILabel alloc] init];
    _payResultLab.textAlignment = NSTextAlignmentRight;
    _payResultLab.font = FontRegularName(kWidthS(13));
    [_backView addSubview:_payResultLab];
    
    // 分割线line
    _line = [[UIView alloc] init];
    _line.backgroundColor = ZJYColorHex(@"#ebebeb");
    [_backView addSubview:_line];
    
    // 商品头像
    _icon = [[UIImageView alloc] init];
    _icon.image = [UIImage imageNamed:@"订单图片"];
    [_backView addSubview:_icon];
    
    // 计划标题
    _titleName = [[UILabel alloc] init];
    _titleName.font = FontRegularName(kWidthS(15));
    _titleName.textColor = BlackTextColor;
    [_backView addSubview:_titleName];
    
    // 右侧箭头
    _imageAss = [[UIImageView alloc] init];
    _imageAss.image = [UIImage imageNamed:@"通讯录页-箭头"];
    [_backView addSubview:_imageAss];
    
    // 分割线line
    _bottomline = [[UIView alloc] init];
    _bottomline.backgroundColor = ZJYColorHex(@"#ebebeb");
    [_backView addSubview:_bottomline];
    
    // 商品一共几件
    _priceAllLab = [[UILabel alloc] init];
    _priceAllLab.font = FontRegularName(kWidthS(14));
    _priceAllLab.textColor = BlackTextColor;
    [_backView addSubview:_priceAllLab];
    
    // 支付金额
    _priceLab = [[UILabel alloc] init];
    _priceLab.font = FontRegularName(kWidthS(14));
    _priceLab.textColor = BlackTextColor;
    [_backView addSubview:_priceLab];
    
    // 取消按钮
    _cancelBtn = [[UIButton alloc] init];
    _cancelBtn.titleLabel.font = FontRegularName(kWidthS(14));
    _cancelBtn.layer.cornerRadius = kWidthS(14);
    _cancelBtn.layer.masksToBounds = YES;
    [_backView addSubview:_cancelBtn];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 购买按钮
    _buyBtn = [[UIButton alloc] init];
    _buyBtn.titleLabel.font = FontRegularName(kWidthS(14));
    _buyBtn.layer.cornerRadius = kWidthS(14);
    _buyBtn.layer.masksToBounds = YES;
    [_backView addSubview:_buyBtn];
    [_buyBtn addTarget:self action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.bottom.mas_equalTo(-10);
    }];
    [_payResultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_deadline);
        make.right.mas_equalTo(-kWidthS(20));
    }];
    [_deadline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kWidthS(5));
        make.left.mas_equalTo(kWidthS(10));
        make.height.mas_equalTo(kWidthS(35));
        make.right.mas_equalTo(_payResultLab.mas_left).offset(-kWidthS(15));
    }];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_deadline.mas_bottom);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(0.5);
    }];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_line.mas_bottom).offset(kWidthS(10));
        make.size.mas_equalTo(kWidthS(70));
        make.left.mas_equalTo(kWidthS(20));
    }];
    [_imageAss mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_icon);
        make.right.mas_equalTo(-kWidthS(25));
        make.width.mas_equalTo(kWidthS(7));
        make.height.mas_equalTo(kWidthS(14));
    }];
    [_titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_icon);
        make.left.mas_equalTo(_icon.mas_right).offset(kWidthS(20));
        make.right.mas_equalTo(_imageAss.mas_left).offset(-kWidthS(10));
    }];
    [_bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_icon.mas_bottom).offset(kWidthS(10));
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(0.5);
    }];
    
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kWidthS(20));
        make.top.mas_equalTo(_bottomline.mas_bottom).offset(kWidthS(15));
    }];
    [_priceAllLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_priceLab.mas_left).offset(-kWidthS(15));
        make.top.mas_equalTo(_priceLab);
    }];
    [_buyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_priceLab.mas_bottom).offset(20);
        make.right.mas_equalTo(-kWidthS(15));
        make.height.mas_equalTo(kWidthS(28));
        make.width.mas_equalTo(kWidthS(78));
    }];
    [_cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_priceLab.mas_bottom).offset(20);
        make.right.mas_equalTo(_buyBtn.mas_left).offset(-kWidthS(10));
        make.height.mas_equalTo(kWidthS(28));
        make.width.mas_equalTo(kWidthS(78));
        make.bottom.mas_equalTo(-kWidthS(15));
    }];
    
    [self addDatas];
}
- (void)addDatas {
    
    _deadline.text = @"2019-10-12 11:01:09";
//    支付状态：0=失败,1=成功,2=未支付,3=取消
//    if ([_currentModel.payStatus intValue] == 0) {
//        _payResultLab.text = SIMLocalizedString(@"NPayAlertViewfail", nil);
//        _payResultLab.textColor = ZJYColorHex(@"#f74447");
//    }else if ([_currentModel.payStatus intValue] == 1) {
//        _payResultLab.text = SIMLocalizedString(@"NPayAlertViewsucess", nil);
//        _payResultLab.textColor = BlueButtonColor;
//    }else if ([_currentModel.payStatus intValue] == 2) {
//        _payResultLab.text = SIMLocalizedString(@"NPayAlertViewNoPayed", nil);
//        _payResultLab.textColor = ZJYColorHex(@"#7f7f7f");
//    }else if ([_currentModel.payStatus intValue] == 3){
        _payResultLab.text = SIMLocalizedString(@"NPayResOrdPaymentTitle", nil);
        _payResultLab.textColor = ZJYColorHex(@"#7f7f7f");
//    }
    
    _titleName.text = @"KHB90会议终端一体机";
    _priceLab.text = [NSString stringWithFormat:@"总价：￥%@",@"1988.00"];
    _priceAllLab.text = [NSString stringWithFormat:@"共%@件商品",@"1"];
    [_buyBtn setTitle:@"去支付" forState:UIControlStateNormal];
    [_buyBtn setTitleColor:ZJYColorHex(@"#f73f43") forState:UIControlStateNormal];
    _buyBtn.layer.borderColor = ZJYColorHex(@"#f73f43").CGColor;
    _buyBtn.layer.borderWidth = 1;
    [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:BlackTextColor forState:UIControlStateNormal];
    _cancelBtn.layer.borderColor = ZJYColorHex(@"#969696").CGColor;
    _cancelBtn.layer.borderWidth = 1;
    
}
@end
