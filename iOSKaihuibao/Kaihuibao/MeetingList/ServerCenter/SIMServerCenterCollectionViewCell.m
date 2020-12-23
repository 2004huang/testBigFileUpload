//
//  SIMServerCenterCollectionViewCell.m
//  Kaihuibao
//
//  Created by mac126 on 2020/6/29.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import "SIMServerCenterCollectionViewCell.h"
@interface SIMServerCenterCollectionViewCell()
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UILabel *title;

@end

@implementation SIMServerCenterCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubViews];
    }
    return self;
}
- (void)addSubViews {
    _img = [[UIImageView alloc] init];
//    _img.backgroundColor = ZJYColorHex(@"#eeeeee");
    _img.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_img];
    
    // 主标题label
    _title = [[UILabel alloc] init];
    _title.font =FontRegularName(15);
    _title.textColor = BlackTextColor;
    _title.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.title];
    
    // 适配
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(25);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(85);
    }];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_img.mas_bottom).offset(35);
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(15);
    }];
    
}
- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
    [_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiBaseUrl,dic[@"thumbnail"]]] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    _title.text = dic[@"title"];
    
}
@end
