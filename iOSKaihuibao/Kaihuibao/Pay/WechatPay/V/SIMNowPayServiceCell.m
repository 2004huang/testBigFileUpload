//
//  SIMNowPayServiceCell.m
//  Kaihuibao
//
//  Created by mac126 on 2019/9/18.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMNowPayServiceCell.h"
@interface SIMNowPayServiceCell()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UILabel *dayLab;
@property (nonatomic, strong) UIButton *closeBtn;

@end
@implementation SIMNowPayServiceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }return self;
}
- (void)setModel:(SIMNowServiceModel *)model {
    _model = model;
    self.titleLab.text = _model.service_name;
    if ([_model.service_type intValue] == 5) {
        // 计时计划
        self.timeLab.text = [NSString stringWithFormat:@"%@：%@",SIMLocalizedString(@"NPayNowSOpenDate", nil),_model.start_time];
        self.dayLab.text = @"";
    }else {
        self.timeLab.text = [NSString stringWithFormat:@"%@：%@至%@",SIMLocalizedString(@"NPayAlertViewdate", nil),_model.start_time,_model.end_time];
        self.dayLab.text = [NSString stringWithFormat:@"%@：%@天",SIMLocalizedString(@"NPayNowSCountDown", nil),_model.count_down];
    }
    
    self.typeLab.text = [NSString stringWithFormat:@"%@：%@",SIMLocalizedString(@"NPayNowSPaymethod", nil),_model.pay_type];
    [self.closeBtn setTitle:_model.button_text forState:UIControlStateNormal];
    self.closeBtn.tag = [_model.service_type integerValue];

    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(0);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(_closeBtn.mas_left).offset(-10);
        make.top.mas_equalTo(15);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_titleLab);
        make.top.mas_equalTo(_titleLab.mas_bottom).offset(5);
    }];
    if ([_model.service_type intValue] == 5) {
        [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_timeLab.mas_bottom).offset(5);
            make.left.right.mas_equalTo(_titleLab);
            make.bottom.mas_equalTo(-10);
        }];
    }else {
        [self.dayLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_timeLab.mas_bottom).offset(5);
            make.left.right.mas_equalTo(_titleLab);
        }];
        [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_dayLab.mas_bottom).offset(5);
            make.left.right.mas_equalTo(_titleLab);
            make.bottom.mas_equalTo(-10);
        }];
    }
    
    
}
- (void)closeBtnClick:(UIButton *)sender {
    if (self.buttonCilckBlock) {
        self.buttonCilckBlock(sender.tag);
    }
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setBackgroundColor:BlueButtonColor];
        _closeBtn.layer.cornerRadius = 5;
        _closeBtn.layer.masksToBounds = YES;
        [_closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeBtn setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
        [_closeBtn setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
        _closeBtn.titleLabel.font = FontRegularName(15);
        [self.contentView addSubview:_closeBtn];
        [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }return _closeBtn;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = BlackTextColor;
        _titleLab.font = FontRegularName(17);
        [self.contentView addSubview:_titleLab];
    }return _titleLab;
}
- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = TableViewHeaderColor;
        _timeLab.font = FontRegularName(15);
        [self.contentView addSubview:_timeLab];
    }return _timeLab;
}
- (UILabel *)dayLab {
    if (!_dayLab) {
        _dayLab = [[UILabel alloc] init];
        _dayLab.font = FontRegularName(15);
        _dayLab.textColor = RedButtonColor;
        [self.contentView addSubview:_dayLab];
    }return _dayLab;
}
- (UILabel *)typeLab {
    if (!_typeLab) {
        _typeLab = [[UILabel alloc] init];
        _typeLab.textColor = TableViewHeaderColor;
        _typeLab.font = FontRegularName(15);
        [self.contentView addSubview:_typeLab];
    }return _typeLab;
}

@end
