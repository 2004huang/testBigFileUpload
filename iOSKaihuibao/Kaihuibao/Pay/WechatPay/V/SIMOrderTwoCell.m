//
//  SIMOrderTwoCell.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/12.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMOrderTwoCell.h"
#import "UIButton+RCCImagePosition.h"
@interface SIMOrderTwoCell()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *titleLab2;
@property (nonatomic, strong) UIButton *manCountBtn;
@property (nonatomic, strong) UIButton *roomCountBtn;
@property (nonatomic, strong) UILabel *manLab;
@property (nonatomic, strong) UILabel *roomLab;

@end

@implementation SIMOrderTwoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubViews];
        
    }return self;
}
- (void)addSubViews {
    UIView *backV = [[UIView alloc] init];
    backV.backgroundColor = [UIColor whiteColor];
    backV.layer.borderColor = ZJYColorHex(@"#ebebeb").CGColor;
    backV.layer.borderWidth = 1;
    backV.layer.cornerRadius = 5;
    backV.layer.masksToBounds = YES;
    [self.contentView addSubview:backV];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = FontRegularName(15);
    _titleLab.textColor = BlackTextColor;
    [backV addSubview:_titleLab];
    
    _titleLab2 = [[UILabel alloc] init];
    _titleLab2.font = FontRegularName(15);
    _titleLab2.textColor = BlackTextColor;
    [backV addSubview:_titleLab2];
    
    _roomLab = [[UILabel alloc] init];
    _roomLab.textColor = BlackTextColor;
    _roomLab.font = FontRegularName(15);
    _roomLab.textAlignment = NSTextAlignmentRight;
    [backV addSubview:_roomLab];
    
    _roomCountBtn = [[UIButton alloc] init];
    _roomCountBtn.backgroundColor = ZJYColorHex(@"#f3f3f3");
    _roomCountBtn.layer.cornerRadius = 5;
    _roomCountBtn.layer.masksToBounds = YES;
    _roomCountBtn.layer.borderColor = ZJYColorHex(@"#d5d5d5").CGColor;
    _roomCountBtn.layer.borderWidth = 1;
    _roomCountBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _roomCountBtn.titleLabel.font = FontRegularName(14);
    [_roomCountBtn setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [backV addSubview:_roomCountBtn];
    
    _manLab = [[UILabel alloc] init];
    _manLab.textColor = BlackTextColor;
    _manLab.font = FontRegularName(15);
    _manLab.textAlignment = NSTextAlignmentRight;
    [backV addSubview:_manLab];
    
    _manCountBtn = [[UIButton alloc] init];
    _manCountBtn.backgroundColor = ZJYColorHex(@"#f3f3f3");
    _manCountBtn.layer.cornerRadius = 5;
    _manCountBtn.layer.masksToBounds = YES;
    _manCountBtn.layer.borderColor = ZJYColorHex(@"#d5d5d5").CGColor;
    _manCountBtn.layer.borderWidth = 1;
    _manCountBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _manCountBtn.titleLabel.font = FontRegularName(14);
    [_manCountBtn setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [backV addSubview:_manCountBtn];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = ZJYColorHex(@"#ebebeb");
    [backV addSubview:line];
    
    _titleLab.text = @"基础计划";
    _titleLab2.text = @"基础计划";
    _roomLab.text = @"会议室";
    _manLab.text = @"参会者";
    
    [backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.right.bottom.mas_equalTo(-15);
        make.height.mas_equalTo(105);
    }];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(12);
        make.height.mas_equalTo(25);
        make.width.mas_lessThanOrEqualTo(120);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.centerY.mas_equalTo(backV.mas_centerY);
        make.height.mas_equalTo(1);
    }];
    [_titleLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.width.mas_equalTo(_titleLab);
        make.top.mas_equalTo(line.mas_bottom).offset(12);
    }];
    [_roomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-25);
        make.centerY.mas_equalTo(_titleLab);
        make.width.mas_lessThanOrEqualTo(70);
    }];
    [_manLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.width.mas_equalTo(_roomLab);
        make.centerY.mas_equalTo(_titleLab2);
    }];
    
    
    CGSize size = [@"1" sizeWithAttributes:@{NSFontAttributeName:FontRegularName(14)}];
    CGFloat width = size.width+30;
    
    [_manCountBtn setTitle:@"1" forState:UIControlStateNormal];
    [_manCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_titleLab);
        make.right.mas_equalTo(_roomLab.mas_left).offset(-20);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(width);
    }];
    
    CGSize size2 = [@"100" sizeWithAttributes:@{NSFontAttributeName:FontRegularName(14)}];
    CGFloat width2 = size2.width+30;
    [_roomCountBtn setTitle:@"100" forState:UIControlStateNormal];
    [_roomCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_titleLab2);
        make.right.mas_equalTo(_manLab.mas_left).offset(-20);
        make.height.mas_equalTo(_manCountBtn);
        make.width.mas_equalTo(width2);
    }];
    
}

//- (void)setModel:(SIMPayPlanModel *)model {
//    _model = model;
//
//
//
//}


@end
