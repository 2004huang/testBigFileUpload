//
//  SIMSettingNewCell.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/18.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMSettingNewCell.h"
@interface SIMSettingNewCell()
@property (nonatomic, strong) UIImageView *icon;


@end
@implementation SIMSettingNewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }return self;
}
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_icon];
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(25);
        }];
    }return _icon;
}
-(UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.font = FontRegularName(16);
        _title.textColor = BlackTextColor;
        [self.contentView addSubview:self.title];
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_icon.mas_right).offset(20);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
    }return _title;
}

- (void)setDatas:(NSDictionary *)datas {
    _datas = datas;
    self.icon.image = [UIImage imageNamed:_datas[@"icon"]];
    self.title.text = _datas[@"title"];
}

@end
