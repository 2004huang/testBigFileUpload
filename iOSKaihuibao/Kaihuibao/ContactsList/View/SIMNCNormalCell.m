//
//  SIMNCNormalCell.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/8.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMNCNormalCell.h"
@interface SIMNCNormalCell()
@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *detailLab;

@end

@implementation SIMNCNormalCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        
        CGFloat iconHeight = 40;
        _iconBtn = [[UIButton alloc] init];
//        _iconBtn.layer.cornerRadius = iconHeight/2;
//        _iconBtn.layer.masksToBounds = YES;
//        _iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_iconBtn];
        
        _label = [[UILabel alloc] init];
        _label.textColor = NewBlackTextColor;
        [self.contentView addSubview:_label];
        
        [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(iconHeight);
            make.width.mas_equalTo(iconHeight);
        }];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(_iconBtn.mas_right).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-100);
        }];
        
    }
    return self;
}

- (void)setTheNewDic:(NSDictionary *)theNewDic {
    _theNewDic = theNewDic;
    _label.text = _theNewDic[@"nickname"];
    [_iconBtn setImage:[UIImage imageNamed:_theNewDic[@"face"]] forState:UIControlStateNormal];
    if (_theNewDic[@"title"] == nil) {
        _label.font = FontRegularName(17);
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        self.accessoryType = UITableViewCellAccessoryNone;
        _label.font = [UIFont boldSystemFontOfSize:17];
        
        // 添加成员的按钮
        _detailLab = [[UIButton alloc] init];
        [_detailLab setTitleColor:ZJYColorHex(@"3478f6") forState:UIControlStateNormal];
        _detailLab.titleLabel.font = FontRegularName(14);
        _detailLab.titleLabel.textAlignment = NSTextAlignmentRight;
        [_detailLab setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
        [_detailLab addTarget:self action:@selector(detailBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_detailLab];
        
        [_detailLab setTitle:_theNewDic[@"title"] forState:UIControlStateNormal];
        [_detailLab setImage:[UIImage imageNamed:_theNewDic[@"picture"]] forState:UIControlStateNormal];
        
        [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-kWidthScale(15));
        }];
    }
}
- (void)detailBtnClick {
    if (self.btnClick) {
        self.btnClick();
    }
}
@end
