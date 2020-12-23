//
//  SIMConfShorthandCell.m
//  Kaihuibao
//
//  Created by mac126 on 2019/12/3.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMConfShorthandCell.h"

@interface SIMConfShorthandCell()
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UILabel *detail;
@end
@implementation SIMConfShorthandCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _dateLab = [[UILabel alloc] init];
        _dateLab.textAlignment = NSTextAlignmentRight;
        _dateLab.font = FontRegularName(13);
        _dateLab.textColor = TableViewHeaderColor;
        [self.contentView addSubview:self.dateLab];

        [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(10);
        }];
        
        _name = [[UILabel alloc] init];
        _name.textAlignment = NSTextAlignmentLeft;
        _name.font = FontRegularName(16);
        _name.textColor = BlackTextColor;
        [self.contentView addSubview:_name];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(_dateLab.mas_left).offset(10);
        }];
        
        _title = [[UILabel alloc] init];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.font = FontRegularName(14);
        _title.textColor = BlackTextColor;
        _title.numberOfLines = 0;
        [self.contentView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(_name.mas_bottom).offset(5);
            make.right.mas_equalTo(-10);
        }];
        _detail = [[UILabel alloc] init];
        _detail.textAlignment = NSTextAlignmentLeft;
        _detail.font = FontRegularName(14);
        _detail.numberOfLines = 0;
        _detail.textColor = BlackTextColor;
        [self.contentView addSubview:_detail];
        [_detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(_title.mas_bottom).offset(5);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-15);
            
        }];
        
        
    }return self;
}
- (void)setModel:(SIMCofShorthandModel *)model {
    _model = model;
    _dateLab.text = _model.time;
    _name.text = _model.record_user_name;
    _title.text = [NSString stringWithFormat:@"源文本：%@",_model.src_text];
    if (_model.tar_text != nil && _model.tar_text.length > 0) {
        _detail.text = [NSString stringWithFormat:@"目标文本：%@",_model.tar_text];
    }
    
}


@end
