//
//  SIMWalletPayAlertView.m
//  Kaihuibao
//
//  Created by mac126 on 2019/7/29.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMWalletPayAlertView.h"
@interface SIMWalletPayAlertView()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *save;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UIView *backV;

@end
@implementation SIMWalletPayAlertView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        [self subviewsUI];
    }return self;
}
- (void)subviewsUI {
    _backV = [[UIView alloc] init];
    _backV.backgroundColor = [UIColor whiteColor];
    _backV.layer.cornerRadius = 5;
    _backV.layer.masksToBounds = YES;
    [self addSubview:_backV];
    
    _imageV = [[UIImageView alloc] init];
    _imageV.image = [UIImage imageNamed:@"wallet支付成功"];
    [self addSubview:self.imageV];
    
    _label = [[UILabel alloc] init];
    _label.text = @"已开通";
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = FontRegularName(24);
    _label.textColor = ZJYColorHex(@"#282a35");
    [_backV addSubview:self.label];
    
    _save = [UIButton buttonWithType:UIButtonTypeCustom];
    [_save setTitle:@"关闭" forState:UIControlStateNormal];
    _save.titleLabel.font = FontRegularName(17);
    [_save setTitleColor:ZJYColorHex(@"#282a35") forState:UIControlStateNormal];
    [_save addTarget:self action:@selector(saveBtn) forControlEvents:UIControlEventTouchUpInside];
    [_backV addSubview:self.save];
    
    _line = [[UILabel alloc] init];
    _line.backgroundColor = ZJYColorHex(@"#e4e4e4");
    [_backV addSubview:_line];
    
    [_backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(40);
    }];
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_backV.mas_top);
        make.centerX.mas_equalTo(0);
        make.height.width.mas_equalTo(66);
    }];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(55);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    [_save mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_save.mas_top);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
}
- (void)saveBtn {
    if (self.saveClick) {
        self.saveClick();
    }
}



@end
