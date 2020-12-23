//
//  SIMServerCenterListCell.m
//  Kaihuibao
//
//  Created by mac126 on 2020/5/28.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import "SIMServerCenterListCell.h"

@interface SIMServerCenterListCell()
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UILabel *title;

@end

@implementation SIMServerCenterListCell

// 会议列表cell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
    _title.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.title];
    
    // 适配
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(85);
    }];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_img.mas_right).offset(25);
        make.right.mas_equalTo(-25);
        make.centerY.mas_equalTo(0);
    }];
    
}
- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
    [_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiBaseUrl,dic[@"thumbnail"]]] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    _title.text = dic[@"title"];
    
}

@end
