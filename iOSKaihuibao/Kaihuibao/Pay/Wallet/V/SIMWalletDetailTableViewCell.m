//
//  SIMWalletDetailTableViewCell.m
//  Kaihuibao
//
//  Created by mac126 on 2019/7/5.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMWalletDetailTableViewCell.h"
@interface SIMWalletDetailTableViewCell()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *resultLab;

@end
@implementation SIMWalletDetailTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }return self;
}

- (void)setDic:(NSDictionary *)dic {
    self.titleLab.text = dic[@"description"];
    self.timeLab.text = dic[@"transaction_time"];
    if ([dic[@"order_type"] isEqualToString:@"recharge"]) {
        self.priceLab.text = [NSString stringWithFormat:@"+%@",[dic[@"transaction_amount"] stringValue]];
    }else if ([dic[@"order_type"] isEqualToString:@"expense"]) {
        self.priceLab.text = [NSString stringWithFormat:@"-%@",[dic[@"transaction_amount"] stringValue]];
    }else {
        self.priceLab.text = [NSString stringWithFormat:@"%@",[dic[@"transaction_amount"] stringValue]];
    }
    
//    交易结果："0"=失败,"1"=成功,"2"=未支付,"3"=取消
    self.resultLab.text = dic[@"button_text"];
    if ([dic[@"transaction_result"] intValue] == 0) {
        self.resultLab.textColor = ZJYColorHex(@"#f74447");
    }else if ([dic[@"transaction_result"] intValue] == 1) {
        self.resultLab.textColor = BlueButtonColor;
    }else if ([dic[@"transaction_result"] intValue] == 2) {
        self.resultLab.textColor = ZJYColorHex(@"#7f7f7f");
    }else if ([dic[@"transaction_result"] intValue] == 3) {
        self.resultLab.textColor = ZJYColorHex(@"#7f7f7f");
    }
    
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-20);
    }];
    [self.resultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_priceLab.mas_bottom).offset(5);
        make.right.mas_equalTo(-20);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(_priceLab.mas_left).offset(-10);
        make.top.mas_equalTo(5);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_titleLab);
        make.top.mas_equalTo(_titleLab.mas_bottom).offset(5);
    }];
    
}
- (UILabel *)resultLab {
    if (!_resultLab) {
        _resultLab = [[UILabel alloc] init];
        _resultLab.font = FontRegularName(15);
        [self.contentView addSubview:_resultLab];
    }return _resultLab;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = BlackTextColor;
        _titleLab.font = FontRegularName(15);
        [self.contentView addSubview:_titleLab];
    }return _titleLab;
}
- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = ZJYColorHex(@"#818181");
        _timeLab.font = FontRegularName(13);
        [self.contentView addSubview:_timeLab];
    }return _timeLab;
}
- (UILabel *)priceLab {
    if (!_priceLab) {
        _priceLab = [[UILabel alloc] init];
        _priceLab.textColor = BlueButtonColor;
        _priceLab.font = FontRegularName(15);
        _priceLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_priceLab];
    }return _priceLab;
}


@end
