//
//  SIMPayResultAlertView.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/11.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMPayResultAlertView.h"

@interface SIMPayResultAlertView()
@property (nonatomic, strong) UIButton *cancel;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *save;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UILabel *medline;

@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *dataLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *nameLabdetail;
@property (nonatomic, strong) UILabel *dataLabdetail;
@property (nonatomic, strong) UILabel *priceLabdetail;


@property (nonatomic, strong) UILabel *faillab;

@end

@implementation SIMPayResultAlertView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;

    }return self;
}
- (void)subviewsUI {
    _label = [[UILabel alloc] init];
    _label.text = SIMLocalizedString(@"NPayAlertViewsucess", nil);
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = FontRegularName(18);
    _label.textColor = BlackTextColor;
    [self addSubview:self.label];
    
    _save = [UIButton buttonWithType:UIButtonTypeCustom];
    [_save setTitle:SIMLocalizedString(@"AlertCOk", nil) forState:UIControlStateNormal];
    [_save setTitleColor:BlackTextColor forState:UIControlStateNormal];
    _save.titleLabel.font = FontRegularName(14);
    [_save addTarget:self action:@selector(saveBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.save];
    
    _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancel setTitle:SIMLocalizedString(@"AlertCBack", nil) forState:UIControlStateNormal];
    _cancel.titleLabel.font = FontRegularName(14);
    [_cancel setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [_cancel addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancel];
    
    _line = [[UILabel alloc] init];
    _line.backgroundColor = ZJYColorHex(@"#eeeeee");
    [self addSubview:_line];
    
    _medline = [[UILabel alloc] init];
    _medline.backgroundColor = ZJYColorHex(@"#eeeeee");
    [self addSubview:_medline];
    
    _nameLab = [[UILabel alloc] init];
    _nameLab.text = SIMLocalizedString(@"NPayAlertViewname", nil);
    _nameLab.font = FontRegularName(14);
    _nameLab.textColor = BlackTextColor;
    _nameLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_nameLab];
//    _dataLab= [[UILabel alloc] init];
//    _dataLab.text = SIMLocalizedString(@"NPayAlertViewdate", nil);
//    _dataLab.font = FontRegularName(14);
//    _dataLab.textColor = BlackTextColor;
//    _dataLab.textAlignment = NSTextAlignmentLeft;
//    [self addSubview:_dataLab];
    _priceLab= [[UILabel alloc] init];
    _priceLab.text = SIMLocalizedString(@"NPayAlertViewprice", nil);
    _priceLab.font = FontRegularName(14);
    _priceLab.textColor = BlackTextColor;
    _priceLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_priceLab];
    
    _nameLabdetail= [[UILabel alloc] init];
    
    _nameLabdetail.font = FontRegularName(14);
    _nameLabdetail.textColor = TableViewHeaderColor;
    _nameLabdetail.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_nameLabdetail];
    
//    _dataLabdetail= [[UILabel alloc] init];
//    _dataLabdetail.font = FontRegularName(14];
//    _dataLabdetail.textColor = TableViewHeaderColor;
//    _dataLabdetail.textAlignment = NSTextAlignmentLeft;
//    [self addSubview:_dataLabdetail];
    
    _priceLabdetail= [[UILabel alloc] init];
    _priceLabdetail.font = FontRegularName(14);
    _priceLabdetail.textColor = RedButtonColor;
    _priceLabdetail.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_priceLabdetail];
    
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(45);
        make.right.mas_equalTo(0);
    }];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_label.mas_bottom).offset(5);
        make.left.mas_equalTo(25);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(15);
    }];
//    [_dataLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_nameLab.mas_bottom).offset(10);
//        make.left.mas_equalTo(25);
//        make.height.mas_equalTo(15);
//        make.width.mas_equalTo(_nameLab.mas_width);
//    }];
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLab.mas_bottom).offset(10);
        make.left.mas_equalTo(25);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(_nameLab.mas_width);
    }];
    
    [_nameLabdetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_label.mas_bottom).offset(5);
        make.left.mas_equalTo(_nameLab.mas_right).offset(15);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
//    [_dataLabdetail mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_nameLab.mas_bottom).offset(10);
//        make.left.mas_equalTo(_dataLab.mas_right).offset(15);
//        make.height.mas_equalTo(15);
//        make.right.mas_equalTo(-15);
//    }];
    [_priceLabdetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabdetail.mas_bottom).offset(10);
        make.left.mas_equalTo(_priceLab.mas_right).offset(15);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_priceLab.mas_bottom).offset(15);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(0);
    }];
    [_save mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_line.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(self.frame.size.width/2);
    }];
    [_medline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_line.mas_bottom).offset(0);
        make.left.mas_equalTo(_save.mas_right).offset(0);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(1);
    }];
    [_cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_line.mas_bottom).offset(0);
        make.left.mas_equalTo(_medline.mas_right).offset(0);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(self.frame.size.width/2);
    }];
}

- (void)subviewsUIfail {
    _label = [[UILabel alloc] init];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = FontMediumName(17);
    _label.textColor = BlackTextColor;
    [self addSubview:self.label];
    
    _faillab= [[UILabel alloc] init];
    _faillab.font = FontRegularName(15);
    _faillab.textColor = BlackTextColor;
    _faillab.numberOfLines = 0;
    _faillab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_faillab];
    
    _save = [UIButton buttonWithType:UIButtonTypeCustom];
    [_save setTitle:@"确定" forState:UIControlStateNormal];
    [_save setTitleColor:BlueButtonColor forState:UIControlStateNormal];
    _save.titleLabel.font = FontRegularName(15);
    [_save addTarget:self action:@selector(saveBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.save];
    
//    _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_cancel setTitle:SIMLocalizedString(@"AlertCBack", nil) forState:UIControlStateNormal];
//    _cancel.titleLabel.font = FontRegularName(14);
//    [_cancel setTitleColor:BlackTextColor forState:UIControlStateNormal];
//    [_cancel addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.cancel];
    
    _line = [[UILabel alloc] init];
    _line.backgroundColor = ZJYColorHex(@"#eeeeee");
    [self addSubview:_line];
    
    _medline = [[UILabel alloc] init];
    _medline.backgroundColor = ZJYColorHex(@"#eeeeee");
    [self addSubview:_medline];
    
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(45);
        make.right.mas_equalTo(0);
    }];
    [_faillab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_label.mas_bottom).offset(5);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(45);
        make.right.mas_equalTo(0);
    }];
    
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_faillab.mas_bottom).offset(15);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(0);
    }];
    [_save mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_line.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(self.frame.size.width);
    }];
    [_medline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_line.mas_bottom).offset(0);
        make.left.mas_equalTo(_save.mas_right).offset(0);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(1);
    }];
//    [_cancel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_line.mas_bottom).offset(0);
//        make.left.mas_equalTo(_medline.mas_right).offset(0);
//        make.height.mas_equalTo(45);
//        make.width.mas_equalTo(self.frame.size.width/2);
//    }];
}
//- (void)setType:(NSString *)type {
//    _type = type;
//    if ([_type isEqualToString:@"success"]) {
//        // 支付成功
//    }else {
//        
//    }
//    
//}
//- (void)setDicWalletM:(NSDictionary *)dicWalletM {
//    _dicWalletM = dicWalletM;
//    if ([[_dicWalletM objectForKey:@"msg"] isEqualToString:@"支付成功"]) {
//
//        [self subviewsUI];
//        _priceLab.text = @"钱包余额";
//        _nameLab.text = @"交易价格";
//
//        _nameLabdetail.text = [NSString stringWithFormat:@"￥%@",[_dicWalletM objectForKey:@"transaction_amount"]];
//        //        _dataLabdetail.text = [_dicM objectForKey:@"ExpirationTime"];
//        _priceLabdetail.text = [NSString stringWithFormat:@"￥%@",[_dicWalletM objectForKey:@"balance"]];
//
//
//    }else {
//        [self subviewsUIfail];
////        _faillab.text = [_dicM objectForKey:@"msg"];
//    }
//}
- (void)setDicFreeM:(NSDictionary *)dicFreeM {
    _dicFreeM = dicFreeM;
    [self subviewsUIfail];
    _label.text = [_dicFreeM objectForKey:@"msg"];
    _faillab.text = [_dicFreeM objectForKey:@"detail"];
}
- (void)setDicM:(NSDictionary *)dicM {
    _dicM = dicM;
    [self subviewsUIfail];
    if ([_dicM[@"code"] integerValue] == successCodeOK) {
//        [self subviewsUI];
//        _priceLab.text = SIMLocalizedString(@"NPayAlertViewprice", nil);
//        _nameLab.text = SIMLocalizedString(@"NPayAlertViewname", nil);
//        _nameLabdetail.text = [_dicM objectForKey:@"PlanName"];
        //        _dataLabdetail.text = [_dicM objectForKey:@"ExpirationTime"];
//        _priceLabdetail.text = [NSString stringWithFormat:@"￥%@",_dicM[@"data"][@"price"]];
        
        _label.text = [_dicM objectForKey:@"msg"];
        if ([_dicM[@"data"] isEqual:[NSNull null]] || _dicM[@"data"] == nil) {
            _faillab.text = SIMLocalizedString(@"NPayAllNext_HelpText", nil);
        }else {
            _faillab.text = [NSString stringWithFormat:@"%@：￥%@",SIMLocalizedString(@"NPayAlertViewprice_pay", nil),_dicM[@"data"][@"money"]];
            
        }
//        _faillab.text = @"可联系我们的官方客服\n400-080-5766";
    }else {
        _label.text = [_dicM objectForKey:@"msg"];
        _faillab.text = SIMLocalizedString(@"NPayAllNext_HelpText", nil);
    }
    
}
- (void)cancelBtn {
    if (self.cancelClick) {
        self.cancelClick();
    }
}
- (void)saveBtn {
    if (self.saveClick) {
        self.saveClick();
    }
}



@end
