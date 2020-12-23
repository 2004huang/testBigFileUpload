//
//  SIMBaseAssecoryTableViewCell.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/22.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMBaseAssecoryTableViewCell.h"

@implementation SIMBaseAssecoryTableViewCell
-(instancetype)init
{
    if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[SIMBaseAssecoryTableViewCell reuseIdentifier]])
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
        
        self.preservesSuperviewLayoutMargins = NO;
        self.separatorInset = UIEdgeInsetsZero;
        if ([self respondsToSelector:@selector(layoutMargins)]) {
            self.layoutMargins = UIEdgeInsetsZero;
        }

    }
    return self;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
