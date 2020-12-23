//
//  SIMContentHeadTableViewCell.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/9/2.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMContentHeadTableViewCell.h"

@implementation SIMContentHeadTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        
        CGFloat iconHeight = 36;
        _iconBtn = [[UIButton alloc] init];
        _iconBtn.layer.cornerRadius = 3;
        _iconBtn.layer.masksToBounds = YES;
        _iconBtn.backgroundColor = ZJYColorHex(@"#E8E8E8");
        [_iconBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _iconBtn.titleLabel.font = FontRegularName(18);
        _iconBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_iconBtn];
        
        [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(iconHeight);
            make.width.mas_equalTo(iconHeight);
        }];
        
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = FontRegularName(17);
        _titleLab.textColor = BlackTextColor;
        _titleLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLab];
        
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(_iconBtn.mas_right).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-40);
        }];

        
//        _arrow= [UIButton buttonWithType:UIButtonTypeCustom];
//        _arrow.frame=CGRectMake(screen_width-40, 10, 30, 30);
//        [_arrow setImage:[UIImage imageNamed:@"gd_left"] forState:UIControlStateNormal];
//        [self addSubview:_arrow];
        
    }
    return self;
}

@end
