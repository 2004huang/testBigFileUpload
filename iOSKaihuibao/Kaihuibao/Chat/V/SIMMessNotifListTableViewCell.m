//
//  SIMMessNotifListTableViewCell.m
//  Kaihuibao
//
//  Created by mac126 on 2019/10/29.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMMessNotifListTableViewCell.h"
@interface SIMMessNotifListTableViewCell()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *detailLab;
@end
@implementation SIMMessNotifListTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        
        _icon = [[UIImageView alloc] init];
        _icon.layer.cornerRadius = 10;
        _icon.layer.masksToBounds = YES;
        _icon.backgroundColor = ZJYColorHex(@"#eeeeee");
        [self.contentView addSubview:_icon];
        
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.font = FontRegularName(16);
        [self.contentView addSubview:_titleLab];
        
        _detailLab = [[UILabel alloc] init];
        _detailLab.textColor = [UIColor lightGrayColor];
        _detailLab.font = FontRegularName(14);
        [self.contentView addSubview:_detailLab];
        
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(50);
        }];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_icon.mas_top).offset(3);
            make.left.mas_equalTo(_icon.mas_right).offset(10);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-80);
        }];
        [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_icon.mas_bottom).offset(-3);
            make.left.mas_equalTo(_icon.mas_right).offset(10);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-80);
        }];
    }
    return self;
}
- (void)setModel:(SIMMessNotiModel *)model {
    _model = model;
    NSString *newFaceValue = [NSString stringWithFormat:@"%@%@",kApiBaseUrl,_model.image];
    NSLog(@"newFaceValuenew %@",newFaceValue);
    [_icon sd_setImageWithURL:[NSURL URLWithString:newFaceValue] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    _titleLab.text = model.classification_name;
    _detailLab.text = model.descriptionStr;
}

@end
