//
//  SIMAddFromAdressCell.m
//  Kaihuibao
//
//  Created by mac126 on 2019/7/9.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMAddFromAdressCell.h"
@interface SIMAddFromAdressCell()

@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *detail;
@property (nonatomic, strong) UIButton *addBtn;
@end
@implementation SIMAddFromAdressCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _addBtn = [[UIButton alloc] init];
        _addBtn.userInteractionEnabled = NO;
//        [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addBtn];
        
        [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(20);
            make.left.mas_equalTo(15);
        }];
        
        
        
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
        
    }
    return self;
}
//// 开始按钮block
//- (void)addBtnClick {
//    if (self.addBnClick) {
//        self.addBnClick();
//    }
//}

- (void)setContants:(SIMContants *)contants {
    _contants = contants;
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
    if (_contants.isContant) {
        _label.text = _contants.nickname;
        CGFloat iconHeight = 32;
        [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_addBtn.mas_right).offset(25);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(iconHeight);
            make.width.mas_equalTo(iconHeight);
        }];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_iconBtn.mas_centerY);
            make.left.mas_equalTo(_iconBtn.mas_right).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-100);
        }];
    }else {
        _label.text = _contants.nickname;
        _detail.text = _contants.mobile;
        CGFloat iconHeight = 32;
        [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_addBtn.mas_right).offset(25);
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
    }
    
    
    if (_contants.isSelectt) {
        [_addBtn setImage:[UIImage imageNamed:@"adduser_normalSquare"] forState:UIControlStateNormal];
    }else {
        [_addBtn setImage:[UIImage imageNamed:@"adduser_selectSquare"] forState:UIControlStateNormal];
    }
    if (_contants.isNotClick) {
        self.userInteractionEnabled = NO;
        _label.textColor = GrayPromptTextColor;
        _iconBtn.enabled = NO;
    }else {
        self.userInteractionEnabled = YES;
        _label.textColor = BlackTextColor;
        _iconBtn.enabled = YES;
    }
    
    
    
    
    
}

@end
