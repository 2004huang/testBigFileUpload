//
//  SIMChoseCompany.m
//  Kaihuibao
//
//  Created by mac126 on 2019/4/9.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMChoseCompany.h"

@interface SIMChoseCompany()
@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *company;

@end

@implementation SIMChoseCompany

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        [self addViews];
    }return self;
}

- (void)addViews {
    CGFloat iconHeight = 56;
    _iconBtn = [[UIButton alloc] init];
    _iconBtn.layer.cornerRadius = iconHeight/2.0;
    _iconBtn.layer.masksToBounds = YES;
    [_iconBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _iconBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _iconBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_iconBtn];
    
    _name = [[UILabel alloc] init];
    _name.textColor = ZJYColorHex(@"#000000");
    _name.font = [UIFont boldSystemFontOfSize:19];
    [self addSubview:_name];
    
    _company = [[UILabel alloc] init];
    _company.textColor = ZJYColorHex(@"#898989");
    _company.font = FontRegularName(17);
    //    _company.text = @"星澜科技";
    [self addSubview:_company];
    
    // 适配
    [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(iconHeight, iconHeight));
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(20);
    }];
    
    [_company mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(_iconBtn.mas_left).offset(-20);
        make.top.mas_equalTo(15);
    }];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-20);
    }];
    
}
- (void)setCompanyModel:(SIMCompany *)companyModel {
    _companyModel = companyModel;
    _company.text = _companyModel.company_name;
    _name.text = self.currentUser.nickname;
    if (self.currentUser.avatar != nil) {
        [_iconBtn setTitle:@"" forState:UIControlStateNormal];
        
        [_iconBtn sd_setImageWithURL:[NSURL URLWithString:self.currentUser.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar"] options:SDWebImageAllowInvalidSSLCertificates];
        
        _iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    }else {
        [_iconBtn setBackgroundColor:ZJYColorHex(@"#3296fa")];
        // 取人名首字母
        NSString *name = self.currentUser.nickname;
        if (name.length >0) {
            NSString *firstName = [name substringToIndex:1];
            [_iconBtn setTitle:firstName forState:UIControlStateNormal];
        }
    }
}

@end
