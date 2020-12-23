//
//  SIMMessNotifDetailTableViewCell.m
//  Kaihuibao
//
//  Created by mac126 on 2019/10/29.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMMessNotifDetailTableViewCell.h"
@interface SIMMessNotifDetailTableViewCell()
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *detail;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIButton *joinBtn;
@property (nonatomic, strong) UIButton *shareBtn;

@end
@implementation SIMMessNotifDetailTableViewCell
// 改变单元格的大小
- (void)setFrame:(CGRect)frame {
    frame.origin.x += 13;
    frame.origin.y += 7;
    frame.size.width -= 26;
    frame.size.height -= 14;
    [super setFrame:frame];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = ZJYColorHex(@"#eeeeee").CGColor;
        self.layer.borderWidth = 1;
        
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews {
    
    _iconView = [[UIImageView alloc] init];
    _iconView.backgroundColor = ZJYColorHex(@"#E8E8E8");
    [self addSubview:self.iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-13);
        make.height.mas_equalTo(85);
        make.width.mas_equalTo(150);
    }];
    
    // label
    _title = [[UILabel alloc] init];
    _title.font = FontMediumName(16);
    _title.textColor = ZJYColorHex(@"#010101");
    _title.text = @"fdfsfd";
    _title.numberOfLines = 2;
    _title.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(_iconView.mas_left).offset(-10);
        make.top.mas_equalTo(_iconView.mas_top);
    }];
    
    // label
    _detail = [[UILabel alloc] init];
    _detail.font = FontRegularName(12);
    _detail.text = @"fdfsfdfdffd";
    _detail.textColor = BlackTextColor;
    _detail.numberOfLines = 1;
    _detail.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.detail];
    [_detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(_iconView.mas_left).offset(-10);
        make.top.mas_equalTo(_title.mas_bottom).offset(5);
    }];
    
    _joinBtn = [[UIButton alloc] init];
    [_joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_joinBtn setBackgroundColor:BlueButtonColor];
    [_joinBtn setTitle:SIMLocalizedString(@"WellBeingButtonTitle", nil) forState:UIControlStateNormal];
    _joinBtn.titleLabel.font = FontRegularName(12);
    _joinBtn.layer.cornerRadius = 2;
    _joinBtn.layer.masksToBounds = YES;
    [self.contentView addSubview:_joinBtn];
    [_joinBtn addTarget:self action:@selector(joinBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(23);
        make.bottom.mas_equalTo(-10);
        make.width.mas_equalTo(84);
    }];
    
}

- (void)joinBtnClick {
    if (self.startClick) {
        self.startClick();
    }
}
- (void)setModel:(SIMMessNotiDetailModel *)model {
    _model = model;
    NSString *newFaceValue = [NSString stringWithFormat:@"%@%@",kApiBaseUrl,_model.image];
    NSLog(@"newFaceValuenew %@",newFaceValue);
    [_iconView sd_setImageWithURL:[NSURL URLWithString:newFaceValue] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    
    _title.text = _model.title;
    _detail.text = _model.descriptionStr;
    
}


@end
