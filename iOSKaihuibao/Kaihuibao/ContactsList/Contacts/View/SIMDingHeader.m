//
//  SIMDingHeader.m
//  Kaihuibao
//
//  Created by 王小琪 on 2018/1/31.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMDingHeader.h"


@interface SIMDingHeader()
@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *company;

@end

@implementation SIMDingHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        [self addViews];
    }return self;
}

- (void)addViews {
    CGFloat iconHeight = 48;
    _iconBtn = [[UIButton alloc] init];
    _iconBtn.layer.cornerRadius = iconHeight/2.0;
    _iconBtn.layer.masksToBounds = YES;
    [_iconBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _iconBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _iconBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _iconBtn.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_iconBtn];
    
    _name = [[UILabel alloc] init];
    _name.textColor = ZJYColorHex(@"#0d0d0d");
    _name.font = [UIFont boldSystemFontOfSize:20];
    [self addSubview:_name];
    
    _company = [[UILabel alloc] init];
    _company.textColor = ZJYColorHex(@"#010101");
    _company.font = FontRegularName(16);
    //    _company.text = @"星澜科技";
    [self addSubview:_company];
    
    // 适配
    [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(iconHeight, iconHeight));
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(15);
    }];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(_iconBtn.mas_left).offset(-20);
        make.top.mas_equalTo(15);
    }];
    
    [_company mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-20);
    }];
    
}


// setModel 联系人列表模型
- (void)setContant:(SIMContants *)contant {
    _contant = contant;
    _name.text = _contant.nickname;
    if (_contant.company_name.length>0) {
        _company.text = _contant.company_name;
    }
    
    if (self.contant.avatar != nil) {
        if (![self.contant.avatar isEqualToString:@"/assets/img/avatar.png"]) {
            [_iconBtn setTitle:@"" forState:UIControlStateNormal];
            
            NSString *urlString = kApiBaseUrl;
            
            [_iconBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlString,self.contant.avatar]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar"] options:SDWebImageAllowInvalidSSLCertificates];
            
            _iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        }else {
            [_iconBtn setBackgroundColor:ZJYColorHex(@"#3296fa")];
            
            // 取人名首字母
            NSString *name = self.contant.nickname;
            if (name.length >0) {
                NSString *firstName = [name substringToIndex:1];
                [_iconBtn setTitle:firstName forState:UIControlStateNormal];
            }
        }
    }else {
        [_iconBtn setBackgroundColor:ZJYColorHex(@"#3296fa")];
        // 取人名首字母
        NSString *name = self.contant.nickname;
        if (name.length >0) {
            NSString *firstName = [name substringToIndex:1];
            [_iconBtn setTitle:firstName forState:UIControlStateNormal];
        }
    }
    
}


- (void)setAdress:(SIMAdress *)adress {
    _adress = adress;
    _name.text = _adress.nickname;
    
    [_iconBtn setBackgroundColor:ZJYColorHex(@"#3296fa")];
    // 取人名首字母
    NSString *name = self.adress.nickname;
    if (name.length >0) {
        NSString *firstName = [name substringToIndex:1];
        [_iconBtn setTitle:firstName forState:UIControlStateNormal];
    }
    
    
    
}

//- (void)setUserCont:(SIMUserContants *)userCont {
//    _userCont = userCont;
//    _name.text = _userCont.nickname;
//
//    [_iconBtn setBackgroundColor:ZJYColorHex(@"#3296fa")];
//    // 取人名首字母
//    NSString *name = _userCont.nickname;
//    NSString *firstName = [name substringToIndex:1];
//    [_iconBtn setTitle:firstName forState:UIControlStateNormal];
//
//}
- (void)setDepart:(SIMDepartment_member *)depart {
    _depart = depart;
    _name.text = _depart.nickname;
    
    if (self.depart.face != nil) {
        if (![self.depart.face isEqualToString:@"/assets/img/avatar.png"]) {
            [_iconBtn setTitle:@"" forState:UIControlStateNormal];
            
            NSString *urlString = kApiBaseUrl;
            [_iconBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlString,self.depart.face]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar"] options:SDWebImageAllowInvalidSSLCertificates];
            
            _iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        }else {
            [_iconBtn setBackgroundColor:ZJYColorHex(@"#3296fa")];
            
            // 取人名首字母
            NSString *name = self.depart.nickname;
            if (name.length >0) {
                NSString *firstName = [name substringToIndex:1];
                [_iconBtn setTitle:firstName forState:UIControlStateNormal];
            }
        }
    }
    
    
    
}

@end
