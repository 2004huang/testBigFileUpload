//
//  SIMOtherContactTableViewCell.m
//  Kaihuibao
//
//  Created by mac126 on 2019/5/14.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMOtherContactTableViewCell.h"

@interface SIMOtherContactTableViewCell()
@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation SIMOtherContactTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        
        CGFloat iconHeight = 32;
        _iconBtn = [[UIButton alloc] init];
        _iconBtn.layer.cornerRadius = 10;
        _iconBtn.layer.masksToBounds = YES;
        [_iconBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _iconBtn.titleLabel.font = FontRegularName(13);
        _iconBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _iconBtn.contentMode = UIViewContentModeScaleAspectFill;
        _iconBtn.backgroundColor = BlueButtonColor;
        [self.contentView addSubview:_iconBtn];
        
        _label = [[UILabel alloc] init];
        _label.textColor = BlackTextColor;
        _label.font = FontMediumName(16);
        [self.contentView addSubview:_label];
        
        
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
        
    }
    return self;
}


- (void)setContants:(SIMContants *)contants {
    _contants = contants;
    NSString *name = _contants.nickname;
    [_iconBtn setTitle:[NSString firstCharactorWithString:name] forState:UIControlStateNormal];
    if (_contants.avatar.length > 0 && ![_contants.avatar isEqualToString:@"/assets/img/avatar.png"]) {
//        [_iconBtn setTitle:@"" forState:UIControlStateNormal];
        
        [_iconBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiBaseUrl,_contants.avatar]] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
        
    }else {
        // 取人名首字母
        if ([_iconBtn sd_currentImageURL]) {
            [_iconBtn setImage:nil forState:UIControlStateNormal];
        }
        
    }
    
    _label.text = _contants.nickname;
    
}
- (void)setIshaveBtn:(BOOL)ishaveBtn {
    _ishaveBtn = ishaveBtn;
    if (_ishaveBtn) {
        _addBtn = [[UIButton alloc] init];
        _addBtn.layer.masksToBounds = YES;
        _addBtn.layer.cornerRadius = 25/4;
        _addBtn.layer.borderColor = BlueButtonColor.CGColor;
        _addBtn.layer.borderWidth = 1;
        [_addBtn setTitle:SIMLocalizedString(@"CGAddMember", nil) forState:UIControlStateNormal];
        _addBtn.titleLabel.font = FontRegularName(14);
        [_addBtn setTitleColor:BlueButtonColor forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addBtn];
        
        [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(60);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        }];
    }
    
}
// 开始按钮block
- (void)addBtnClick {
    if (self.addBnClick) {
        self.addBnClick();
    }
}
@end
