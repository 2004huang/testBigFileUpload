//
//  SIMConverManView.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/26.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMConverManView.h"

@interface SIMConverManView()

/**
 联系人详情界面上方视图
 */
@property (nonatomic, strong) UILabel *phonelab;
@property (nonatomic, strong) UILabel *maillab;
@property (nonatomic, strong) UILabel *myConfLabel;
@property (nonatomic, strong) UILabel *confID;
@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) UILabel *grouplab;

@property (nonatomic, strong) UILabel *mailtitle;
@property (nonatomic, strong) UILabel *phonetitle;
@end
@implementation SIMConverManView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        self.backgroundColor = ZJYColorHex(@"#2da5ff");
        [self addViews];
    }return self;
}
// setModel 联系人列表模型
- (void)setContant:(SIMContants *)contant {
    _contant = contant;
//    _maillab.text = _contant.mail;
    _phonelab.text = _contant.mobile;

    
    if ([_contant.conf isEmptyString]) {
        _myConfLabel.text = @"";
    }else {
        _myConfLabel.text = @"个人会议ID";
        _confID.text = [NSString transTheConfIDToTheThreeApart:_contant.conf];
    }
    
    
    if (self.contant.avatar != nil) {
        if (![self.contant.avatar isEqualToString:@"/assets/img/avatar.png"]) {
            [_iconBtn setTitle:@"" forState:UIControlStateNormal];
            
            [_iconBtn sd_setImageWithURL:[NSURL URLWithString:[NSString iconGetString:self.contant.avatar]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar"] options:SDWebImageAllowInvalidSSLCertificates];
            
            _iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        }else {
            [_iconBtn setBackgroundColor:ZJYColorHex(@"#b3d465")];
            _iconBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            _iconBtn.layer.borderWidth = 1.5;
            // 取人名首字母
            NSString *name = self.contant.nickname;
            if (name.length >0) {
                NSString *firstName = [name substringToIndex:1];
                [_iconBtn setTitle:firstName forState:UIControlStateNormal];
            }
        }
    }else {
        [_iconBtn setBackgroundColor:ZJYColorHex(@"#b3d465")];
        _iconBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconBtn.layer.borderWidth = 1.5;
        // 取人名首字母
        NSString *name = self.contant.nickname;
        if (name.length >0) {
            NSString *firstName = [name substringToIndex:1];
            [_iconBtn setTitle:firstName forState:UIControlStateNormal];
        }
    }
    
//        __weak typeof(self)weakSelf  = self;
//        [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(kWidthScale(108), kWidthScale(108)));
//            make.centerX.mas_equalTo(weakSelf.mas_centerX);
//            make.top.mas_equalTo(weakSelf.mas_top).offset(kWidthScale(40));
//        }];

    __weak typeof(self)weakSelf  = self;
    [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(108, 108));
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.top.mas_equalTo(weakSelf.mas_top).offset(kWidthScale(108));
    }];
    
//    [_mailtitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.top.mas_equalTo(_iconBtn.mas_bottom).offset(kWidthScale(40));
////        make.height.mas_equalTo(10);
//    }];
//    
//    [_maillab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.top.mas_equalTo(_mailtitle.mas_bottom).offset(kWidthScale(3));
////        make.height.mas_equalTo(30);
//    }];
    
    [_phonetitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(_iconBtn.mas_bottom).offset(kWidthScale(50));
        make.height.mas_equalTo(10);
    }];
    
    [_phonelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(_phonetitle.mas_bottom).offset(kWidthScale(3));
        make.height.mas_equalTo(30);
    }];
    
    [_myConfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(_phonelab.mas_bottom).offset(kWidthScale(15));
        make.height.mas_equalTo(10);
    }];
    
    [_confID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(_myConfLabel.mas_bottom).offset(kWidthScale(3));
        make.height.mas_equalTo(25);
    }];
}

- (void)setAdress:(SIMAdress *)adress {
    _adress = adress;
    
    [_iconBtn setBackgroundColor:ZJYColorHex(@"#b3d465")];
    _iconBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconBtn.layer.borderWidth = 1.5;
    // 取人名首字母
    NSString *name = self.adress.nickname;
    if (name.length >0) {
        NSString *firstName = [name substringToIndex:1];
        [_iconBtn setTitle:firstName forState:UIControlStateNormal];
    }
    
    _phonelab.text = _adress.mobile;
    
    
    __weak typeof(self)weakSelf  = self;
    [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(108, 108));
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.top.mas_equalTo(weakSelf.mas_top).offset(kWidthScale(108));
    }];
    
    [_phonetitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(_iconBtn.mas_bottom).offset(kWidthScale(50));
        make.height.mas_equalTo(10);
    }];
    
    [_phonelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(_phonetitle.mas_bottom).offset(kWidthScale(3));
        make.height.mas_equalTo(30);
    }];
    
}

//- (void)setUserCont:(SIMUserContants *)userCont {
//    _userCont = userCont;
//    if (_userCont.email.length>0) {
//        _mailtitle.text = @"个人邮箱";
//        _maillab.text = _userCont.email;
//        _phonelab.text = _userCont.mobile;
//        [_iconBtn setBackgroundColor:ZJYColorHex(@"#b3d465")];
//        _iconBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//        _iconBtn.layer.borderWidth = 1.5;
//        // 取人名首字母
//        NSString *name = _userCont.nickname;
//        NSString *firstName = [name substringToIndex:1];
//        [_iconBtn setTitle:firstName forState:UIControlStateNormal];
//        __weak typeof(self)weakSelf  = self;
//        [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(108, 108));
//            make.centerX.mas_equalTo(weakSelf.mas_centerX);
//            make.top.mas_equalTo(weakSelf.mas_top).offset(kWidthScale(108));
//        }];
//        [_mailtitle mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(0);
//            make.right.mas_equalTo(0);
//            make.top.mas_equalTo(_iconBtn.mas_bottom).offset(kWidthScale(50));
//            make.height.mas_equalTo(10);
//        }];
//        
//        [_maillab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(0);
//            make.right.mas_equalTo(0);
//            make.top.mas_equalTo(_mailtitle.mas_bottom).offset(kWidthScale(3));
//            make.height.mas_equalTo(30);
//        }];
//        [_phonetitle mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(0);
//            make.right.mas_equalTo(0);
//            make.top.mas_equalTo(_maillab.mas_bottom).offset(kWidthScale(50));
//            make.height.mas_equalTo(10);
//        }];
//        
//        [_phonelab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(0);
//            make.right.mas_equalTo(0);
//            make.top.mas_equalTo(_phonetitle.mas_bottom).offset(kWidthScale(3));
//            make.height.mas_equalTo(30);
//        }];
//    }else {
//        _phonelab.text = _userCont.mobile;
//    
//        [_iconBtn setBackgroundColor:ZJYColorHex(@"#b3d465")];
//        _iconBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//        _iconBtn.layer.borderWidth = 1.5;
//        // 取人名首字母
//        NSString *name = _userCont.nickname;
//        NSString *firstName = [name substringToIndex:1];
//        [_iconBtn setTitle:firstName forState:UIControlStateNormal];
//        
//        __weak typeof(self)weakSelf  = self;
//        [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(108, 108));
//            make.centerX.mas_equalTo(weakSelf.mas_centerX);
//            make.top.mas_equalTo(weakSelf.mas_top).offset(kWidthScale(108));
//        }];
//        [_phonetitle mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(0);
//            make.right.mas_equalTo(0);
//            make.top.mas_equalTo(_iconBtn.mas_bottom).offset(kWidthScale(50));
//            make.height.mas_equalTo(10);
//        }];
//        
//        [_phonelab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(0);
//            make.right.mas_equalTo(0);
//            make.top.mas_equalTo(_phonetitle.mas_bottom).offset(kWidthScale(3));
//            make.height.mas_equalTo(30);
//        }];
//    }
//}
- (void)setDepart:(SIMDepartment_member *)depart {
    _depart = depart;
    if (_depart.email.length>0) {
        _mailtitle.text = @"个人邮箱";
        _maillab.text = _depart.email;
        _phonelab.text = _depart.mobile;
        if (self.depart.face != nil) {
            if (![self.depart.face isEqualToString:@"/assets/img/avatar.png"]) {
                [_iconBtn setTitle:@"" forState:UIControlStateNormal];
                
                NSString *urlString = kApiBaseUrl;
                
//                [_iconBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://video.kaihuibao.net/customer/img/",self.depart.face]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar"]];
                [_iconBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlString,self.depart.face]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar"] options:SDWebImageAllowInvalidSSLCertificates];
                
                _iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            }else {
                [_iconBtn setBackgroundColor:ZJYColorHex(@"#b3d465")];
                _iconBtn.layer.borderColor = [UIColor whiteColor].CGColor;
                _iconBtn.layer.borderWidth = 1.5;
                // 取人名首字母
                NSString *name = self.depart.nickname;
                if (name.length >0) {
                    NSString *firstName = [name substringToIndex:1];
                    [_iconBtn setTitle:firstName forState:UIControlStateNormal];
                }
            }
        }
        __weak typeof(self)weakSelf  = self;
        [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(108, 108));
            make.centerX.mas_equalTo(weakSelf.mas_centerX);
            make.top.mas_equalTo(weakSelf.mas_top).offset(kWidthScale(108));
        }];
        [_mailtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(_iconBtn.mas_bottom).offset(kWidthScale(50));
            make.height.mas_equalTo(10);
        }];
        
        [_maillab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(_mailtitle.mas_bottom).offset(kWidthScale(3));
            make.height.mas_equalTo(30);
        }];
        [_phonetitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(_maillab.mas_bottom).offset(kWidthScale(20));
            make.height.mas_equalTo(10);
        }];
        
        [_phonelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(_phonetitle.mas_bottom).offset(kWidthScale(3));
            make.height.mas_equalTo(30);
        }];
    }else {
        _phonelab.text = _depart.mobile;
        if (self.depart.face != nil) {
            if (![self.depart.face isEqualToString:@"/assets/img/avatar.png"]) {
                [_iconBtn setTitle:@"" forState:UIControlStateNormal];
//                [_iconBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://video.kaihuibao.net/customer/img/",self.depart.face]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar"]];
                NSString *urlString = kApiBaseUrl;
                
                [_iconBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlString,self.depart.face]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar"] options:SDWebImageAllowInvalidSSLCertificates];
                _iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            }else {
                [_iconBtn setBackgroundColor:ZJYColorHex(@"#b3d465")];
                _iconBtn.layer.borderColor = [UIColor whiteColor].CGColor;
                _iconBtn.layer.borderWidth = 1.5;
                // 取人名首字母
                NSString *name = self.depart.nickname;
                if (name.length >0) {
                    NSString *firstName = [name substringToIndex:1];
                    [_iconBtn setTitle:firstName forState:UIControlStateNormal];
                }
                
            }
        }
        __weak typeof(self)weakSelf  = self;
        [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(108, 108));
            make.centerX.mas_equalTo(weakSelf.mas_centerX);
            make.top.mas_equalTo(weakSelf.mas_top).offset(kWidthScale(108));
        }];
        [_phonetitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(_iconBtn.mas_bottom).offset(kWidthScale(50));
            make.height.mas_equalTo(10);
        }];
        
        [_phonelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(_phonetitle.mas_bottom).offset(kWidthScale(3));
            make.height.mas_equalTo(30);
        }];
    }
    
}

- (void)addViews {
    _iconBtn = [[UIButton alloc] init];
    _iconBtn.layer.cornerRadius = 54;
    _iconBtn.layer.masksToBounds = YES;
    _iconBtn.titleLabel.font = FontRegularName(30);
    _iconBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_iconBtn];
    
    // 添加阴影父视图
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(_iconBtn.frame.origin.x, _iconBtn.frame.origin.y, _iconBtn.frame.size.width+50, _iconBtn.frame.size.height + 50)];
    [self addSubview:shadowView];
    shadowView.layer.shadowColor = [UIColor whiteColor].CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(1, 1);
    shadowView.layer.shadowOpacity = 1;
    shadowView.layer.shadowRadius = 35;
    shadowView.layer.cornerRadius = 40;
    shadowView.clipsToBounds = NO;
    [shadowView addSubview:_iconBtn];
    
    _maillab = [[UILabel alloc] init];
    _maillab.textAlignment = NSTextAlignmentCenter;
    _maillab.font = FontRegularName(16);
    _maillab.numberOfLines = 0;
    _maillab.textColor = [UIColor whiteColor];
    [self addSubview:_maillab];
    
    _phonelab = [[UILabel alloc] init];
    _phonelab.textAlignment = NSTextAlignmentCenter;
    _phonelab.font = FontRegularName(16);
    _phonelab.numberOfLines = 0;
    _phonelab.textColor = [UIColor whiteColor];
    [self addSubview:_phonelab];
    
    _myConfLabel = [[UILabel alloc] init];
    _myConfLabel.textAlignment = NSTextAlignmentCenter;
    _myConfLabel.font = FontRegularName(13);
    _myConfLabel.textColor = ZJYColorHex(@"#b6d8ff");
    [self addSubview:_myConfLabel];
    
    _confID = [[UILabel alloc] init];
    _confID.textAlignment = NSTextAlignmentCenter;
    _confID.font = FontRegularName(16);
    _confID.textColor = [UIColor whiteColor];
    [self addSubview:_confID];
    
    _mailtitle = [[UILabel alloc] init];
    _mailtitle.textAlignment = NSTextAlignmentCenter;
    _mailtitle.font = FontRegularName(13);
    _mailtitle.textColor = ZJYColorHex(@"#b6d8ff");
    [self addSubview:_mailtitle];
    
    _phonetitle = [[UILabel alloc] init];
    _phonetitle.textAlignment = NSTextAlignmentCenter;
    _phonetitle.font = FontRegularName(13);
    _phonetitle.text = @"手机号";
    _phonetitle.textColor = ZJYColorHex(@"#b6d8ff");
    [self addSubview:_phonetitle];
    
}

@end
