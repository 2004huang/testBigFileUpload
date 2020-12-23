//
//  SIMListTableViewCell.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/7/17.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMListTableViewCell.h"
#import "UIImage+Compression.h"

@interface SIMListTableViewCell()


@end

@implementation SIMListTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        
        CGFloat iconHeight = 32;
        _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iconBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _iconBtn.titleLabel.font = FontRegularName(13);
        _iconBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _iconBtn.layer.cornerRadius = 10;
        _iconBtn.layer.masksToBounds = YES;
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
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = ZJYColorHex(@"#e3e3e4");
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}


- (void)setContants:(SIMContants *)contants {
    _contants = contants;
    _iconBtn.contentMode = UIViewContentModeScaleAspectFit;
    if (_contants.avatar.length > 0 && ![_contants.avatar isEqualToString:@"/assets/img/avatar.png"]) {

        _iconBtn.backgroundColor = [UIColor whiteColor];
        [_iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiBaseUrl,_contants.avatar]] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            NSLog(@"imageerrorerrore %@",[NSString stringWithFormat:@"%@%@",kApiBaseUrl,_contants.avatar]);
            //            UIImage *newimage = [UIImage imageWithOriginImage:image scaleToWidth:200];
            //            NSLog(@"imagefdfsdfdsuiierrorerrore %@",newimage);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    if ([_iconBtn sd_currentBackgroundImageURL]) {
                        [_iconBtn setBackgroundImage:nil forState:UIControlStateNormal];
//                        [_iconBtn setImage:nil forState:UIControlStateNormal];
                    }
                    
                    NSString *name = _contants.nickname;
                    [_iconBtn setTitle:[NSString firstCharactorWithString:name] forState:UIControlStateNormal];
                }else {
                    //                    [_iconBtn setImage:newimage forState:UIControlStateNormal];
                    
                    [_iconBtn setTitle:@"" forState:UIControlStateNormal];
                }
            });
        }];
        
//        [_iconBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiBaseUrl,_contants.avatar]] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//
//
//        }];
    }else {
        _iconBtn.backgroundColor = BlueButtonColor;
        // 取人名首字母
        if ([_iconBtn sd_currentBackgroundImageURL]) {
            [_iconBtn setBackgroundImage:nil forState:UIControlStateNormal];
        }
        NSString *name = _contants.nickname;
        [_iconBtn setTitle:[NSString firstCharactorWithString:name] forState:UIControlStateNormal];
    }
//    _iconBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//    _iconBtn.layer.borderWidth = 4;
   
    
    _label.text = _contants.nickname;
//    if (_contants.isOwner == YES) {
//    if ([_contants.role isEqualToString:@"拥有者"]) {
//        _ownerLab.text = SIMLocalizedString(@"CCContantLeader", nil);
//    }else {
//        _ownerLab.text = @"";
//    }
    
//    }else {
//        _ownerLab.text = @"";
//    }
}

//- (void)setMembers:(SIMGroupMember *)members {
//    _members = members;
//    if (_members.face != nil) {
//        if (![_members.face isEqualToString:@"/assets/img/avatar.png"]) {
//            [_iconBtn setTitle:@"" forState:UIControlStateNormal];
//            NSString *urlString = kApiBaseUrl;
//
//            [_iconBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlString,_members.face]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar"]];
//            _iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
//        }else {
//            // 取人名首字母
//            NSString *name = _members.username;
//            if ([_iconBtn sd_currentImageURL]) {
//                [_iconBtn setImage:nil forState:UIControlStateNormal];
//            }
//            _iconBtn.backgroundColor = BlueButtonColor;
//            [_iconBtn setTitle:[NSString firstCharactorWithString:name] forState:UIControlStateNormal];
//
//        }
//    }else {
//        // 取人名首字母
//        NSString *name = _members.username;
//        if ([_iconBtn sd_currentImageURL]) {
//            [_iconBtn setImage:nil forState:UIControlStateNormal];
//        }
//        _iconBtn.backgroundColor = BlueButtonColor;
//        [_iconBtn setTitle:[NSString firstCharactorWithString:name] forState:UIControlStateNormal];
//
//    }
//    _label.text = _members.username;
//}
//
//- (void)setGroups:(SIMGroup *)groups {
//    _groups = groups;
//
//    [_iconBtn setImage:[UIImage imageNamed:@"groupNew_addIcon"] forState:UIControlStateNormal];
//    _iconBtn.backgroundColor = BlueButtonColor;
//    _label.text = _groups.name;
//
//}
//- (void)setUserContants:(SIMUserContants *)userContants {
//    _userContants = userContants;
//    [_iconBtn setTitle:[self firstCharactorWithString:_userContants.nickname] forState:UIControlStateNormal];
//    _iconBtn.backgroundColor = ZJYColorHex(colorArr[arc4random()%4]);
//    _label.text = _userContants.nickname;
//    if ([_iconBtn sd_currentImageURL]) {
//        [_iconBtn setImage:nil forState:UIControlStateNormal];
//    }
//}
//- (void)setDepartment:(SIMDepartment_member *)department {
//    _department = department;
//    if (_department.face != nil) {
//        if (![_department.face isEqualToString:@"/assets/img/avatar.png"]) {
//            [_iconBtn setTitle:@"" forState:UIControlStateNormal];
//            NSString *urlString = kApiBaseUrl;
//
//            [_iconBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlString,_department.face]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar"]];
//            _iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
//        }else {
//            // 取人名首字母
//            NSString *name = _department.nickname;
//            if ([_iconBtn sd_currentImageURL]) {
//                [_iconBtn setImage:nil forState:UIControlStateNormal];
//            }
//            _iconBtn.backgroundColor = BlueButtonColor;
//            [_iconBtn setTitle:[NSString firstCharactorWithString:name] forState:UIControlStateNormal];
//
//
//        }
//    }else {
//        // 取人名首字母
//        NSString *name = _department.nickname;
//        if ([_iconBtn sd_currentImageURL]) {
//            [_iconBtn setImage:nil forState:UIControlStateNormal];
//        }
//        _iconBtn.backgroundColor = BlueButtonColor;
//        [_iconBtn setTitle:[NSString firstCharactorWithString:name] forState:UIControlStateNormal];
//
//
//    }
//    _label.text = _department.nickname;
//}


@end
