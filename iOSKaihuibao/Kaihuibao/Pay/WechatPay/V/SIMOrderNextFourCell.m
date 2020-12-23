//
//  SIMOrderNextFourCell.m
//  Kaihuibao
//
//  Created by mac126 on 2018/12/26.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMOrderNextFourCell.h"
#import "UILabel+changeAligment.h"
@interface SIMOrderNextFourCell()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *magv;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *content;
@end

@implementation SIMOrderNextFourCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpTitleView];
    }return self;
}
- (void)setUpTitleView {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 40)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topView];
    
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, screen_width-60, 40)];
    _title.text = SIMLocalizedString(@"NPayAllNext_FourPlanTitle", nil);
    _title.textAlignment = NSTextAlignmentLeft;
    _title.font = [UIFont boldSystemFontOfSize:14];
    _title.textColor = NewBlackTextColor;
    [self.topView addSubview:self.title];
    
    // 白色背景 放一堆按钮的背景View
    _line = [[UIView alloc] initWithFrame:CGRectMake(0, 41, screen_width, 1)];
    _line.backgroundColor = ZJYColorHex(@"#eeeeee");
    [self.contentView addSubview:_line];
    
//    _magv = [[UIImageView alloc] init];
////    _magv.backgroundColor = ZJYColorHex(@"#eeeeee");
//    _magv.contentMode = UIViewContentModeScaleAspectFit;
//    [self.contentView addSubview:_magv];
//    [_magv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(56);
//        make.left.mas_equalTo(0);
//        make.height.mas_equalTo(kWidthScale(190));
//        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(-20);
//    }];
    _content = [[UILabel alloc] init];
    _content.font = FontRegularName(16);
    _content.textColor = BlackTextColor;
    _content.textAlignment = NSTextAlignmentCenter;
    _content.numberOfLines = 0;
    [self.contentView addSubview:_content];
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(56);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(kWidthScale(190));
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-20);
    }];
    
    
}
- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    _content.text = _urlStr;
    [UILabel changeLineSpaceForLabel:_content WithSpace:20.0];
//    _magv.image = [UIImage imageNamed:_urlStr];
    
}

@end
