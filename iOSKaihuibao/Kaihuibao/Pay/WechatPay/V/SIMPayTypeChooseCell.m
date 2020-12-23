//
//  SIMPayTypeChooseCell.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/13.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMPayTypeChooseCell.h"
@interface SIMPayTypeChooseCell()
@property (nonatomic, strong) UIImageView *magV;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *selectImg;
@end
@implementation SIMPayTypeChooseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        _magV = [[UIImageView alloc] init];
        _magV.backgroundColor = [UIColor yellowColor];
        _magV.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_magV];
        
        _label = [[UILabel alloc] init];
        _label.textColor = BlackTextColor;
        _label.font = FontRegularName(16);
        [self.contentView addSubview:_label];
        
        //  选择按钮
        _selectImg = [[UIImageView alloc] init];
        [self.contentView addSubview:_selectImg];
        
        
        [_magV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(20);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(_magV.mas_right).offset(20);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-50);
        }];
        [_selectImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(26);
            make.width.mas_equalTo(26);
        }];
        
        
    }
    return self;
}

- (void)setLabText:(NSString *)labText {
    _labText = labText;
    _label.text = _labText;
//    _magV.image = [UIImage imageNamed:[NSString stringWithFormat:@""]];
}


- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    if (_isSelect) {
        _selectImg.image = [UIImage imageNamed:@"37联系人_06"];
    }else {
        _selectImg.image = [UIImage imageNamed:@"37联系人_03"];
    }
}

@end
