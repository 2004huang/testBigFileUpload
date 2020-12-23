//
//  SIMAdressTableViewCell.m
//  Kaihuibao
//
//  Created by mac126 on 2017/12/26.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMAdressTableViewCell.h"
@interface SIMAdressTableViewCell()

@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *detail;
@property (nonatomic, strong) UIButton *addBtn;
@end
@implementation SIMAdressTableViewCell
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
//        _iconBtn.backgroundColor = BlueButtonColor;
        [self.contentView addSubview:_iconBtn];
        
        _label = [[UILabel alloc] init];
        _label.textColor = BlackTextColor;
        _label.font = FontRegularName(16);
        [self.contentView addSubview:_label];
        
        _detail = [[UILabel alloc] init];
        _detail.textColor = ZJYColorHex(@"#818181");
        _detail.font = FontRegularName(13);
        [self.contentView addSubview:_detail];
        
        [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(iconHeight);
            make.width.mas_equalTo(iconHeight);
        }];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_iconBtn.mas_centerY);
            make.left.mas_equalTo(_iconBtn.mas_right).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-100);
        }];
        [_detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_iconBtn.mas_centerY);
            make.bottom.mas_equalTo(_iconBtn.mas_bottom);
            make.left.mas_equalTo(_label.mas_left);
            make.right.mas_equalTo(_label.mas_right);
        }];
        _addBtn = [[UIButton alloc] init];
        _addBtn.layer.masksToBounds = YES;
        _addBtn.layer.cornerRadius = 25/4;
        _addBtn.titleLabel.font = FontRegularName(14);
        [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addBtn];
        
        [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(60);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        }];
        
    }
    return self;
}
// 开始按钮block
- (void)addBtnClick {
    if (self.addBnClick) {
        self.addBnClick();
    }
}
- (void)setContants:(SIMContants *)contants {
    _contants = contants;
    // 取人名首字母
//    NSString *name = _contants.nickname;
//    [_iconBtn setTitle:[NSString firstCharactorWithString:name] forState:UIControlStateNormal];
//    if (_contants.avatar.length > 0 && ![_contants.avatar isEqualToString:@"/assets/img/avatar.png"]) {
////        [_iconBtn setTitle:@"" forState:UIControlStateNormal];
//
//        [_iconBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiBaseUrl,_contants.avatar]] forState:UIControlStateNormal placeholderImage:nil];
//
//    }else {
//        if ([_iconBtn sd_currentImageURL]) {
//            [_iconBtn setImage:nil forState:UIControlStateNormal];
//        }
//    }
    _iconBtn.contentMode = UIViewContentModeScaleAspectFit;
    if (_contants.avatar.length > 0 && ![_contants.avatar isEqualToString:@"/assets/img/avatar.png"]) {
        _iconBtn.backgroundColor = [UIColor whiteColor];
        
        [_iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiBaseUrl,_contants.avatar]] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            NSLog(@"imageerrorerrore %@",image);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    if ([_iconBtn sd_currentBackgroundImageURL]) {
                        [_iconBtn setBackgroundImage:nil forState:UIControlStateNormal];
                    }
                    
                    NSString *name = _contants.nickname;
                    [_iconBtn setTitle:[NSString firstCharactorWithString:name] forState:UIControlStateNormal];
                }else {
                    [_iconBtn setTitle:@"" forState:UIControlStateNormal];
                }
            });
        }];
    }else {
        _iconBtn.backgroundColor = BlueButtonColor;
        // 取人名首字母
        if ([_iconBtn sd_currentBackgroundImageURL]) {
            [_iconBtn setBackgroundImage:nil forState:UIControlStateNormal];
        }
        NSString *name = _contants.nickname;
        [_iconBtn setTitle:[NSString firstCharactorWithString:name] forState:UIControlStateNormal];
    }
    
    _label.text = _contants.nickname;
    _detail.text = _contants.mobile;
    
    if (_contants.isNeedChange) {
        // 好友或者注册
//        if (_contants.is_user) {
            // 已经注册
            // 未注册 发短信让他注册
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        if (_contants.isFriend) {
            // 是好友
            _addBtn.enabled = NO;
            [_addBtn setTitle:SIMLocalizedString(@"CCFriend_Relation_Added", nil) forState:UIControlStateNormal];
            _addBtn.layer.borderColor = [UIColor clearColor].CGColor;
            _addBtn.layer.borderWidth = 1;
            [_addBtn setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
        }else {
            // 不是好友
            [_addBtn setTitle:SIMLocalizedString(@"NavBackADD", nil) forState:UIControlStateNormal];
            _addBtn.enabled = YES;
            _addBtn.layer.borderColor = BlueButtonColor.CGColor;
            _addBtn.layer.borderWidth = 1;
            [_addBtn setTitleColor:BlueButtonColor forState:UIControlStateNormal];
        }
//        }
    }else {
        // 统一都为邀请按钮
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [_addBtn setTitle:SIMLocalizedString(@"NavBackInvite", nil) forState:UIControlStateNormal];
        _addBtn.enabled = YES;
        _addBtn.layer.borderColor = BlueButtonColor.CGColor;
        _addBtn.layer.borderWidth = 1;
        [_addBtn setTitleColor:BlueButtonColor forState:UIControlStateNormal];
    }
//    if (_contants.isUserContant) {
//        // 从添加用户的地方进来
//        if (_contants.is_user) {
//            // 已经注册
//            [_addBtn setTitle:SIMLocalizedString(@"CCFriend_Relation_Registed", nil) forState:UIControlStateNormal];
//            _addBtn.enabled = NO;
//            _addBtn.layer.borderColor = [UIColor clearColor].CGColor;
//            _addBtn.layer.borderWidth = 1;
//            [_addBtn setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
//        }else {
//            // 未注册
//            if (_contants.isSelectSend) {
//                [_addBtn setTitle:SIMLocalizedString(@"CCFriend_Relation_sended", nil) forState:UIControlStateNormal];
//                _addBtn.enabled = NO;
//                _addBtn.layer.borderColor = [UIColor clearColor].CGColor;
//                _addBtn.layer.borderWidth = 1;
//                [_addBtn setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
//            }else {
//                [_addBtn setTitle:SIMLocalizedString(@"NavBackADD", nil) forState:UIControlStateNormal];
//                _addBtn.enabled = YES;
//                _addBtn.layer.borderColor = BlueButtonColor.CGColor;
//                _addBtn.layer.borderWidth = 1;
//                [_addBtn setTitleColor:BlueButtonColor forState:UIControlStateNormal];
//            }
//
//
//        }
//    }else {
//        // 从外部联系人地方进来
//        if (_contants.is_user) {
//            // 已经注册
//            if (_contants.is_friend) {
//                // 是好友
//                _addBtn.enabled = NO;
//                [_addBtn setTitle:SIMLocalizedString(@"CCFriend_Relation_Added", nil) forState:UIControlStateNormal];
//                _addBtn.layer.borderColor = [UIColor clearColor].CGColor;
//                _addBtn.layer.borderWidth = 1;
//                [_addBtn setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
//            }else {
//                // 不是好友
//                if (_contants.isSelectSend) {
//                    [_addBtn setTitle:SIMLocalizedString(@"CCFriend_Relation_sended", nil) forState:UIControlStateNormal];
//                    _addBtn.enabled = NO;
//                    _addBtn.layer.borderColor = [UIColor clearColor].CGColor;
//                    _addBtn.layer.borderWidth = 1;
//                    [_addBtn setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
//                }else {
//                    [_addBtn setTitle:SIMLocalizedString(@"NavBackADD", nil) forState:UIControlStateNormal];
//                    _addBtn.enabled = YES;
//                    _addBtn.layer.borderColor = BlueButtonColor.CGColor;
//                    _addBtn.layer.borderWidth = 1;
//                    [_addBtn setTitleColor:BlueButtonColor forState:UIControlStateNormal];
//                }
//
//            }
//        }else {
//            // 未注册
//            if (_contants.isSelectSend) {
//                [_addBtn setTitle:SIMLocalizedString(@"CCFriend_Relation_sended", nil) forState:UIControlStateNormal];
//                _addBtn.enabled = NO;
//                _addBtn.layer.borderColor = [UIColor clearColor].CGColor;
//                _addBtn.layer.borderWidth = 1;
//                [_addBtn setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
//
//            }else {
//                [_addBtn setTitle:SIMLocalizedString(@"NavBackADD", nil) forState:UIControlStateNormal];
//                _addBtn.enabled = YES;
//                _addBtn.layer.borderColor = BlueButtonColor.CGColor;
//                _addBtn.layer.borderWidth = 1;
//                [_addBtn setTitleColor:BlueButtonColor forState:UIControlStateNormal];
//
//            }
//
//        }
//
//    }
    
}

//- (void)setSont:(SIMAdress *)sont {
//    _sont = sont;
//    [_iconBtn setTitle:[NSString firstCharactorWithString:_sont.nickname] forState:UIControlStateNormal];
//    _label.text = _sont.nickname;
//    _detail.text = _sont.mobile;
//
//    if (_sont.isUserContant) {
//        // 从添加用户的地方进来
//        if (_sont.is_user) {
//            // 已经注册
//            [_addBtn setTitle:SIMLocalizedString(@"CCFriend_Relation_Registed", nil) forState:UIControlStateNormal];
//            _addBtn.enabled = NO;
//            _addBtn.layer.borderColor = [UIColor clearColor].CGColor;
//            _addBtn.layer.borderWidth = 1;
//            [_addBtn setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
//        }else {
//            // 未注册
//            if (_sont.isSelectSend) {
//                [_addBtn setTitle:SIMLocalizedString(@"CCFriend_Relation_sended", nil) forState:UIControlStateNormal];
//                _addBtn.enabled = NO;
//                _addBtn.layer.borderColor = [UIColor clearColor].CGColor;
//                _addBtn.layer.borderWidth = 1;
//                [_addBtn setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
//            }else {
//                [_addBtn setTitle:SIMLocalizedString(@"NavBackADD", nil) forState:UIControlStateNormal];
//                _addBtn.enabled = YES;
//                _addBtn.layer.borderColor = BlueButtonColor.CGColor;
//                _addBtn.layer.borderWidth = 1;
//                [_addBtn setTitleColor:BlueButtonColor forState:UIControlStateNormal];
//            }
//
//
//        }
//    }else {
//        // 从外部联系人地方进来
//        if (_sont.is_user) {
//            // 已经注册
//            if (_sont.is_friend) {
//                // 是好友
//                _addBtn.enabled = NO;
//                [_addBtn setTitle:SIMLocalizedString(@"CCFriend_Relation_Added", nil) forState:UIControlStateNormal];
//                _addBtn.layer.borderColor = [UIColor clearColor].CGColor;
//                _addBtn.layer.borderWidth = 1;
//                [_addBtn setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
//            }else {
//                // 不是好友
//                if (_sont.isSelectSend) {
//                    [_addBtn setTitle:SIMLocalizedString(@"CCFriend_Relation_sended", nil) forState:UIControlStateNormal];
//                    _addBtn.enabled = NO;
//                    _addBtn.layer.borderColor = [UIColor clearColor].CGColor;
//                    _addBtn.layer.borderWidth = 1;
//                    [_addBtn setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
//                }else {
//                    [_addBtn setTitle:SIMLocalizedString(@"NavBackADD", nil) forState:UIControlStateNormal];
//                    _addBtn.enabled = YES;
//                    _addBtn.layer.borderColor = BlueButtonColor.CGColor;
//                    _addBtn.layer.borderWidth = 1;
//                    [_addBtn setTitleColor:BlueButtonColor forState:UIControlStateNormal];
//                }
//
//            }
//        }else {
//            // 未注册
//            if (_sont.isSelectSend) {
//                [_addBtn setTitle:SIMLocalizedString(@"CCFriend_Relation_sended", nil) forState:UIControlStateNormal];
//                _addBtn.enabled = NO;
//                _addBtn.layer.borderColor = [UIColor clearColor].CGColor;
//                _addBtn.layer.borderWidth = 1;
//                [_addBtn setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
//
//            }else {
//                [_addBtn setTitle:SIMLocalizedString(@"NavBackADD", nil) forState:UIControlStateNormal];
//                _addBtn.enabled = YES;
//                _addBtn.layer.borderColor = BlueButtonColor.CGColor;
//                _addBtn.layer.borderWidth = 1;
//                [_addBtn setTitleColor:BlueButtonColor forState:UIControlStateNormal];
//
//            }
//
//        }
//
//    }
//
//}


@end
