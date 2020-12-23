//
//  SIMNewWalletTableViewCell.m
//  Kaihuibao
//
//  Created by mac126 on 2020/2/25.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import "SIMNewWalletTableViewCell.h"
@interface SIMNewWalletTableViewCell()
@property (nonatomic, strong) UIImageView *backPic;
@property (nonatomic, strong) UILabel *label;
@end
@implementation SIMNewWalletTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _backPic = [[UIImageView alloc] init];
//        _backPic.backgroundColor = ZJYColorHex(@"#eeeeee");
        _backPic.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_backPic];
        
        _label = [[UILabel alloc] init];
        _label.textColor = BlackTextColor;
        _label.numberOfLines = 0;
        _label.font = FontRegularName(12);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"注：充值成功后，不能退款、提现或者转赠他人\n如有问题，请拨打：400-080-5766";
        [self.contentView addSubview:_label];
        

    }return self;
}
- (void)setImageHeight:(NSString *)imageHeight {
    _imageHeight = imageHeight;
    CGFloat hei = [_imageHeight floatValue];
    [_backPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(30);
        make.height.mas_equalTo(kWidthScale(hei/2));
    }];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_backPic);
        make.top.mas_equalTo(_backPic.mas_bottom).offset(30);
        make.bottom.mas_equalTo(-20);
    }];
}
- (void)setPicStr:(NSString *)picStr {
    _picStr = picStr;
    
    [_backPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiBaseUrl,picStr]] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    _backPic.contentMode = UIViewContentModeScaleAspectFit;
}

@end
