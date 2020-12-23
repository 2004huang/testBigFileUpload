//
//  SIMPlanDetailCell.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/11.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMPlanDetailCell.h"
@interface SIMPlanDetailCell()
@property (nonatomic, strong) UIImageView *magv;
@end
@implementation SIMPlanDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _magv = [[UIImageView alloc] init];
        _magv.backgroundColor = ZJYColorHex(@"#eeeeee");
        [self.contentView addSubview:_magv];
        [_magv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
    }return self;
}

- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    
    [_magv sd_setImageWithURL:[NSURL URLWithString:_urlStr] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    
}

@end
