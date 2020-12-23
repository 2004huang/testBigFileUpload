//
//  SIMAddNewFriendCell.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/19.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMAddNewFriendCell.h"


@implementation SIMAddNewFriendCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        
        //        colorArr = @[@"#4faaf0",@"f7b55e",@"f4735e",@"17c295"];
        
        CGFloat iconHeight = 40;
        _iconBtn = [[UIButton alloc] init];
        _iconBtn.layer.cornerRadius = iconHeight/2;
        _iconBtn.layer.masksToBounds = YES;
        [_iconBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _iconBtn.titleLabel.font = FontRegularName(13);
        _iconBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_iconBtn];
        
        _label = [[UILabel alloc] init];
        _label.textColor = BlackTextColor;
        _label.font = FontRegularName(17);
        [self.contentView addSubview:_label];
        
        _ownerLab = [[UILabel alloc] init];
        _ownerLab.textColor = GrayPromptTextColor;
        _ownerLab.font = FontRegularName(12);
        _ownerLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_ownerLab];
        
        [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(iconHeight);
            make.width.mas_equalTo(iconHeight);
        }];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(_iconBtn.mas_right).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-80);
        }];
        [_ownerLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(80);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        }];
    }
    return self;
}
- (void)setTheNewDic:(NSDictionary *)theNewDic {
    _theNewDic = theNewDic;
    _label.text = _theNewDic[@"nickname"];
    
    UIImage *defaultImg = [UIImage imageNamed:_theNewDic[@"face"]];
//    [_iconBtn sd_setImageWithURL:nil forState:UIControlStateNormal placeholderImage:defaultImg];
    [_iconBtn setImage:defaultImg forState:UIControlStateNormal];
    //    _iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

@end
