//
//  SIMDingTableViewCell.m
//  Kaihuibao
//
//  Created by 王小琪 on 2018/1/31.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMDingTableViewCell.h"
@interface SIMDingTableViewCell()

@end

@implementation SIMDingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = ZJYColorHex(@"#a3a5a8");
        _titleLabel.font = FontRegularName(13);
        [self.contentView addSubview:_titleLabel];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = ZJYColorHex(@"191f25");
        _detailLabel.font = FontRegularName(17);
        [self.contentView addSubview:_detailLabel];
        
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            //            make.height.mas_equalTo(20);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-40);
        }];
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_titleLabel.mas_bottom);
            make.left.mas_equalTo(20);
            //            make.height.mas_equalTo(25);
            make.right.mas_equalTo(-40);
        }];
    }
    return self;
}

@end
