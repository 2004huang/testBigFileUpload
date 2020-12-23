//
//  SIMMainContactTableViewCell.m
//  Kaihuibao
//
//  Created by mac126 on 2019/5/13.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMMainContactTableViewCell.h"
@interface SIMMainContactTableViewCell()
@end
@implementation SIMMainContactTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        
//        CGFloat iconHeight = 15;
//        _addBtn = [[UIButton alloc] init];
//        [_addBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        _addBtn.backgroundColor = [UIColor yellowColor];
//        _addBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [self.contentView addSubview:_addBtn];
        
        _mainTitle = [[UILabel alloc] init];
        _mainTitle.textColor = BlackTextColor;
        _mainTitle.font = FontMediumName(16);
        [self.contentView addSubview:_mainTitle];
        
        _detailLab = [[UILabel alloc] init];
        _detailLab.textColor = BlackTextColor;
        _detailLab.font = FontRegularName(14);
        _detailLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_detailLab];
        
//        [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(15);
//            make.centerY.mas_equalTo(0);
//            make.height.mas_equalTo(iconHeight);
//            make.width.mas_equalTo(iconHeight);
//        }];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = ZJYColorHex(@"#e3e3e4");
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return self;
}
- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
    _mainTitle.text = _dic[@"name"];
    _detailLab.text = _dic[@"count"];
    [_mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-80);
    }];
    [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-20);
    }];
}

@end
