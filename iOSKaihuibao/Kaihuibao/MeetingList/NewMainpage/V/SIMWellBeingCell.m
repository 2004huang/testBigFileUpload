//
//  SIMWellBeingCell.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/21.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMWellBeingCell.h"
@interface SIMWellBeingCell()
@property (nonatomic, strong) UIImageView *image;

@end

@implementation SIMWellBeingCell
//// 改变单元格的大小
//- (void)setFrame:(CGRect)frame {
////    frame.origin.x += 15;
//    frame.origin.y += 7;
////    frame.size.width -= 30;
//    frame.size.height -= 14;
//    [super setFrame:frame];
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.layer.cornerRadius = 2;
//        self.layer.masksToBounds = YES;
//        self.layer.shadowOffset =CGSizeMake(0, 3);
//        self.layer.shadowColor = [UIColor grayColor].CGColor;
//        self.layer.shadowRadius = 2;
//        self.layer.shadowOpacity = .2f;
        _image = [[UIImageView alloc] init];
        _image.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_image];
    }
    return self;
}
- (void)setModel:(SIMFootImageModel *)model {
    _model = model;
    CGFloat hei = [_model.height floatValue]/2;
//    NSLog(@"heiheiheihei %lf",hei);
    [_image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiBaseUrl,_model.image]] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
//    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(0);
//        make.left.mas_equalTo(0);
//        make.height.mas_equalTo(hei);
//        make.top.mas_equalTo(5);
//        make.bottom.mas_equalTo(-5);
//    }];
    
    _image.sd_layout.leftEqualToView(self.contentView).rightEqualToView(self.contentView).topSpaceToView(self.contentView,12).heightIs(kWidthScale(hei));

    // sdautolayout的自动适应单元格
    [self setupAutoHeightWithBottomView:_image bottomMargin:12];
}


@end
