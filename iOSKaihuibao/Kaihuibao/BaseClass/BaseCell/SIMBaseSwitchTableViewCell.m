//
//  SIMBaseSwitchTableViewCell.m
//  Kaihuibao
//
//  Created by Ferris on 2017/4/1.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMBaseSwitchTableViewCell.h"

@implementation SIMBaseSwitchTableViewCell
{
    UISwitch* _switchButton;
}
-(instancetype)init
{
    if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[SIMBaseSwitchTableViewCell reuseIdentifier]])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.preservesSuperviewLayoutMargins = NO;
        self.separatorInset = UIEdgeInsetsZero;
        if ([self respondsToSelector:@selector(layoutMargins)]) {
            self.layoutMargins = UIEdgeInsetsZero;
        }
//        self.textLabel.textColor = BlackTextColor;
//        self.textLabel.font = FontRegularName(16);
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = FontRegularName(16);
        _titleLab.textColor = BlackTextColor;
        [self.contentView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(kWidthScale(15));
            make.height.mas_equalTo(30);
        }];
        
        
        _switchButton = [[UISwitch alloc] init];
        [_switchButton addTarget:self action:@selector(switchActive:) forControlEvents:UIControlEventValueChanged];
//        [self.contentView addSubview:_switchButton];
        self.accessoryView = _switchButton;
//        [_switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(0);
//            make.right.mas_equalTo(-15);
//        }];
        
    }
    return self;
}
- (void)switchActive:(UISwitch *)sender {
    if (self.switClick) {
        self.switClick();
    }
}
-(UISwitch *)switchButton
{
    return _switchButton;
}
@end
