//
//  SIMFPNextHeader.m
//  Kaihuibao
//
//  Created by mac126 on 2018/11/1.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMFPNextHeader.h"
@interface SIMFPNextHeader()
@property (nonatomic, strong) UIImageView *magv;
@end
@implementation SIMFPNextHeader
- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _magv = [[UIImageView alloc] init];
        _magv.backgroundColor = ZJYColorHex(@"#eeeeee");
        [self addSubview:_magv];
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
