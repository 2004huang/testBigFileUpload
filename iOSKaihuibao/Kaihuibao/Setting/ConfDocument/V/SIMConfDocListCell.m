//
//  SIMConfDocListCell.m
//  Kaihuibao
//
//  Created by mac126 on 2019/9/5.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMConfDocListCell.h"

@interface SIMConfDocListCell()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *dateLab;
@end
@implementation SIMConfDocListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _icon = [[UIImageView alloc] init];
//        _icon.backgroundColor = ZJYColorHex(@"#eeeeee");
        _icon.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_icon];
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(40);
        }];
        
        _title = [[UILabel alloc] init];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.font = FontRegularName(16);
        _title.textColor = BlackTextColor;
        [self.contentView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_icon.mas_right).offset(20);
            make.top.mas_equalTo(_icon);
            make.height.mas_equalTo(20);
            make.right.mas_equalTo(-kWidthScale(90));
        }];
        
        _dateLab = [[UILabel alloc] init];
        _dateLab.textAlignment = NSTextAlignmentLeft;
        _dateLab.font = FontRegularName(13);
        _dateLab.textColor = TableViewHeaderColor;
        [self.contentView addSubview:self.dateLab];

        [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_title);
            make.top.mas_equalTo(_title.mas_bottom).offset(6);
            make.height.mas_equalTo(15);
        }];
        
        
        
    }return self;
}
- (void)setModel:(SIMConfDocModel *)model {
    _model = model;
    _icon.image = [UIImage imageNamed:@"confDocTitleicon"];
    _title.text = _model.name;
    _dateLab.text = _model.time;
}

- (void)setShortmodel:(SIMCofShorthandModel *)shortmodel {
    _shortmodel = shortmodel;
    _icon.image = [UIImage imageNamed:@"confDocTitleicon"];
    _title.text = _shortmodel.conf_name;
    _dateLab.text = _shortmodel.time;
}
@end
