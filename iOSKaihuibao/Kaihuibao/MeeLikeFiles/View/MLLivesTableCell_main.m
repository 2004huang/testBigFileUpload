//
//  MLLivesTableCell_main.m
//  MeeLike
//
//  Created by mac126 on 2020/9/16.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import "MLLivesTableCell_main.h"
#import "UIButton+RCCImagePosition.h"


@interface MLLivesTableCell_main ()

@property (nonatomic, strong)UIView * backgView;
@property (nonatomic, strong)UIImageView * mImageV;
@property (nonatomic, strong)UIImageView * sfkIcon;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel * descLabel;
@property (nonatomic, strong)UIButton * itemBtn;
@property (nonatomic, strong)UILabel * timeLabel;
@property (nonatomic, strong)UIButton * interBtn;

@end


@implementation MLLivesTableCell_main

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.backgView];
        [self.backgView addSubview:self.mImageV];
        [self.backgView addSubview:self.sfkIcon];
        [self.backgView addSubview:self.titleLabel];
        [self.backgView addSubview:self.descLabel];
        [self.backgView addSubview:self.itemBtn];
        [self.backgView addSubview:self.timeLabel];
        [self.backgView addSubview:self.interBtn];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
        __weak typeof(self) weakself = self;
        [self.backgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kWidthScale(15.0));
            make.right.mas_equalTo(kWidthScale(-15));
            make.top.mas_equalTo(kWidthScale(10.0));
            make.bottom.mas_equalTo(weakself.mas_bottom).offset(kWidthScale(-5));
        }];
        
        [self.mImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kWidthScale(15.0));
            make.top.mas_equalTo(kWidthScale(15.0));
            make.bottom.mas_equalTo(kWidthScale(-15.0));
            make.width.mas_equalTo(weakself.mImageV.mas_height).multipliedBy(175.0/210.0);
        }];
        
        [self.sfkIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakself.backgView.mas_right);
            make.top.mas_equalTo(weakself.backgView.mas_top);
            make.width.mas_equalTo(kWidthScale(45.0));
            make.height.mas_equalTo(kWidthScale(20.0));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakself.mImageV.mas_right).offset(kWidthScale(15.0));
            make.top.mas_equalTo(kWidthScale(15.0));
        }];
        
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakself.mImageV.mas_right).offset(kWidthScale(15.0));
            make.top.mas_equalTo(weakself.titleLabel.mas_bottom).offset(kWidthScale(10.0));
        }];
        
        [self.itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakself.descLabel.mas_bottom).offset(kWidthScale(10.0));
            make.left.mas_equalTo(weakself.mImageV.mas_right).offset(kWidthScale(15.0));
            make.width.mas_equalTo(weakself.itemBtn.width).offset(kWidthScale(10));
            make.height.mas_equalTo(kWidthScale(20));
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakself.mImageV.mas_right).offset(kWidthScale(15.0));
            make.bottom.mas_equalTo(weakself.mImageV.mas_bottom);
        }];
        
        [self.interBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kWidthScale(70.0));
            make.height.mas_equalTo(kWidthScale(28.0));
            make.right.mas_equalTo(weakself.backgView.mas_right).offset(kWidthScale(-20.0));
            make.bottom.mas_equalTo(weakself.mImageV.mas_bottom);
        }];

}

#pragma mark - public methods

#pragma mark - private methods

#pragma mark - delegate

#pragma mark - selector
-(void)btClick{
    if (self.didClickAtIndex) {
        self.didClickAtIndex(self.model);
    }
}

#pragma mark - getters and setters

-(void)setModel:(MLLivesModel_main *)model{
    _model = model;
    
    [self.mImageV sd_setImageWithURL:[NSURL URLWithString:_model.cover] placeholderImage:[UIImage imageNamed:@"share_meeting"]];
    [self.itemBtn setImage:[UIImage imageNamed:@"舞蹈"] forState:UIControlStateNormal];
    [self.itemBtn setTitle:@"舞蹈" forState:UIControlStateNormal];

    [self.titleLabel setText:@"高效燃脂训练"];
    [self.descLabel setText:@"全身.燃脂.力量"];
    [self.timeLabel setText:@"15:00"];

#warning 加判断条件
//    [self.mImageV sd_setImageWithURL:[NSURL URLWithString:_model.cover] placeholderImage:[UIImage imageNamed:@"share_meeting"]];
//    [self.sfkIcon setImage:[UIImage imageNamed:@"sfk_ml_ic"]];
//    [self.itemBtn setImage:[UIImage imageNamed:@"舞蹈"] forState:UIControlStateNormal];
//    [self.itemBtn setTitle:@"舞蹈" forState:UIControlStateNormal];
//
//    [self.titleLabel setText:_model.name];
//    [self.descLabel setText:_model.detail];
//    [self.timeLabel setText:@"15:00"];
}

-(UIView *)backgView{
    if (!_backgView) {
        _backgView = [[UIView alloc]initWithFrame:self.contentView.bounds];
        _backgView.backgroundColor = [UIColor whiteColor];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, screen_width-(30), kWidthScale(140))  byRoundingCorners:(UIRectCornerAllCorners) cornerRadii:CGSizeMake(kWidthScale(5), kWidthScale(5))];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = _backgView.bounds;
        maskLayer.path = maskPath.CGPath;
        _backgView.layer.mask = maskLayer;
    }
    return _backgView;
}

- (UIImageView *)mImageV{
    if (!_mImageV) {
        _mImageV = [[UIImageView alloc]init];
        _mImageV.userInteractionEnabled = NO;
        _mImageV.contentMode = UIViewContentModeScaleToFill;
    }
    return _mImageV;
}

-(UIImageView *)sfkIcon{
    if (!_sfkIcon) {
        _sfkIcon = [[UIImageView alloc]init];
        _sfkIcon.userInteractionEnabled = NO;
        [_sfkIcon setImage:[UIImage imageNamed:@"示范课"]];
        _sfkIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _sfkIcon;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = FontMediumName(13);
    }
    return _titleLabel;
}

-(UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc]init];
        _descLabel.textColor = [UIColor blackColor];
        _descLabel.font = FontRegularName(12);
    }
    return _descLabel;
}

-(UIButton *)itemBtn{
    if (!_itemBtn) {
        _itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _itemBtn.frame =CGRectMake(0, 0, kWidthScale(50), kWidthScale(20));
        _itemBtn.imageView.contentMode = UIViewContentModeCenter;
        _itemBtn.titleLabel.font = FontRegularName(10);
        _itemBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_itemBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_itemBtn setImagePosition:RCCImagePositionLeft spacing:5.0];
        _itemBtn.layer.cornerRadius = (_itemBtn.frame.size.height / 2);
        _itemBtn.layer.borderWidth = 0.5;
        _itemBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _itemBtn.clipsToBounds = YES;
    }
    return _itemBtn;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor blackColor];
        _timeLabel.font = FontMediumName(15);
    }
    return _timeLabel;
}

-(UIButton *)interBtn{
    if (!_interBtn) {
        _interBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _interBtn.titleLabel.textColor = [UIColor blackColor];
        [_interBtn setImage:[UIImage imageNamed:@"进入课程"] forState:UIControlStateNormal];
        [_interBtn addTarget:self action:@selector(btClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _interBtn;
}


@end
