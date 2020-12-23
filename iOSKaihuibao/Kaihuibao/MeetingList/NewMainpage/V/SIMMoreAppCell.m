//
//  SIMMoreAppCell.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/20.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMMoreAppCell.h"
//#import "SIMMeetBtn.h"
@interface SIMMoreAppCell()
//@property (nonatomic, strong) SIMMeetBtn *aBt;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UILabel *label;
@end
@implementation SIMMoreAppCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _image = [[UIImageView alloc] init];
        _image.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_image];
        
        _label = [[UILabel alloc] init];
        _label.font = FontRegularName(13);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = BlackTextColor;
        [self.contentView addSubview:_label];
        
//        return CGRectMake(5, 0, self.frame.size.width-10, self.frame.size.width-10);
//        return CGRectMake(0, self.frame.size.height-15, self.frame.size.width, 15);
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.left.mas_equalTo(10);
            make.height.mas_equalTo(_image.mas_width);
            make.top.mas_equalTo(0);
        }];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(15);
            make.bottom.mas_equalTo(0);
        }];
//        _aBt = [[SIMMeetBtn alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
//        _aBt.titleLabel.font = FontRegularName(13);
//        _aBt.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [_aBt setTitleColor:ZJYColorHex(@"#333333") forState:UIControlStateNormal];
//        [self.contentView addSubview:_aBt];
        
    }
    return self;
}
- (void)setImageStr:(NSString *)imageStr {
    _label.text = imageStr;
    _image.image = [UIImage imageNamed:imageStr];
//    [_aBt setTitle:imageStr forState:UIControlStateNormal];
//    [_aBt setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
}
@end
