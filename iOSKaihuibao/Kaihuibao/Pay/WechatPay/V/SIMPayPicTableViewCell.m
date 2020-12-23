//
//  SIMPayPicTableViewCell.m
//  Kaihuibao
//
//  Created by mac126 on 2020/2/22.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import "SIMPayPicTableViewCell.h"
@interface SIMPayPicTableViewCell ()
@property (nonatomic, strong) UIImageView *backPic;
@end

@implementation SIMPayPicTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _backPic = [[UIImageView alloc] init];
        
//        self.backgroundColor = ZJYColorHex(@"#eeeeee");
//        _backPic.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_backPic];
        
    }return self;
}

- (void)setPicStr:(NSString *)picStr {
    _picStr = picStr;
    
    [_backPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiBaseUrl,_picStr]] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    
//    [_backPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiBaseUrl,_picStr]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        NSLog(@"图片高度%f==%f",image.size.height,image.size.width);
//
//    }];
    
    _backPic.contentMode = UIViewContentModeScaleAspectFit;
    
}
- (void)setImageHeight:(NSString *)imageHeight {
    _imageHeight = imageHeight;

    CGFloat hei = [_imageHeight floatValue];
    [_backPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(kWidthScale(hei/2));
        make.bottom.mas_equalTo(-15);
    }];
    
}


@end
