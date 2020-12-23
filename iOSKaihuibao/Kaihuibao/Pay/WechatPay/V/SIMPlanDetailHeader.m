//
//  SIMPlanDetailHeader.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/11.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMPlanDetailHeader.h"
@interface SIMPlanDetailHeader()
@property (nonatomic, strong) UIImageView *magv;
@end
@implementation SIMPlanDetailHeader
- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _magv = [[UIImageView alloc] init];
        _magv.backgroundColor = ZJYColorHex(@"#eeeeee");
        [self addSubview:_magv];
        [_magv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kWidthScale(10));
            make.left.mas_equalTo(kWidthScale(8));
            make.right.mas_equalTo(-kWidthScale(8));
            make.bottom.mas_equalTo(-kWidthScale(10));
        }];
        
    }return self;
}
- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    [_magv sd_setImageWithURL:[NSURL URLWithString:_urlStr] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    
}

@end
