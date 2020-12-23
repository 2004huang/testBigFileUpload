//
//  SIMTeacherCollectionCell.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/15.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMTeacherCollectionCell.h"

@interface SIMTeacherCollectionCell()
@property (nonatomic, strong) UIImageView *magV;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UIImageView *changeImg;
@property (nonatomic, strong) UILabel *transLab;
@property (nonatomic, strong) UILabel *sourceLab;

@end
@implementation SIMTeacherCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
       
        _magV = [[UIImageView alloc] init];
        _magV.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_magV];
        _magV.layer.cornerRadius = 70/2;
        _magV.layer.masksToBounds = YES;
        
        _name = [[UILabel alloc] init];
        _name.textColor = ZJYColorHex(@"#000000");
        _name.font = FontRegularName(15);
        _name.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_name];
        
        _changeImg = [[UIImageView alloc] init];
        _changeImg.image = [UIImage imageNamed:@"interpreterchange"];
        [self.contentView addSubview:_changeImg];
        
        _transLab = [[UILabel alloc] init];
        _transLab.textColor = ZJYColorHex(@"#808080");
        _transLab.font = FontRegularName(12);
        _transLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_transLab];
        
        _sourceLab = [[UILabel alloc] init];
        _sourceLab.textColor = ZJYColorHex(@"#808080");
        _sourceLab.font = FontRegularName(12);
        _sourceLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_sourceLab];
        
        [_magV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(70);
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(20);
            make.height.mas_equalTo(70);
        }];
        
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_magV.mas_bottom).offset(8);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        
//        [_changeImg mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(11);
//            make.centerX.mas_equalTo(0);
//            make.top.mas_equalTo(_name.mas_bottom).offset(8);
//            make.height.mas_equalTo(10);
//        }];
//        [_sourceLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(_changeImg);
//            make.right.mas_equalTo(_changeImg.mas_left).offset(-8);
//        }];
//        [_transLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(_changeImg);
//            make.left.mas_equalTo(_changeImg.mas_right).offset(8);
//        }];
        [_transLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_name.mas_bottom);
            make.left.right.mas_equalTo(0);
        }];
        
        
    }
    return self;
}

- (void)setContants:(SIMInterpreter *)contants {
    _contants = contants;
    [_magV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiBaseUrl,_contants.avatar]] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    _magV.contentMode = UIViewContentModeScaleAspectFill;
       
    _name.text = _contants.nickname;
    
//    _transLab.text = _contants.translate_language;
//    _sourceLab.text = _contants.source_language;
    NSMutableAttributedString *sourceStr = [[NSMutableAttributedString alloc] initWithString:_contants.source_language];
    NSMutableAttributedString *transStr = [[NSMutableAttributedString alloc] initWithString:_contants.translate_language];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] init];
    
    NSTextAttachment *nameAttach = [[NSTextAttachment alloc] init];
    UIImage *img = [UIImage imageNamed:@"interpreterchange"];
    nameAttach.image = img;
    nameAttach.bounds = CGRectMake(0, 0, 11, 10);
    NSAttributedString *strA = [NSAttributedString attributedStringWithAttachment:nameAttach];
    
    
    [attStr appendAttributedString:sourceStr];
    [attStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" "]]];
    [attStr appendAttributedString:strA];
    [attStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" "]]];
    [attStr appendAttributedString:transStr];
    
    _transLab.attributedText = attStr;
    
}


@end
