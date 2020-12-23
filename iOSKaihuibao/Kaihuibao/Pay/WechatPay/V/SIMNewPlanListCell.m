//
//  SIMNewPlanListCell.m
//  Kaihuibao
//
//  Created by mac126 on 2019/5/21.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMNewPlanListCell.h"

@interface SIMNewPlanListCell()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *detailLab;


@end
@implementation SIMNewPlanListCell
// 改变单元格的大小
//- (void)setFrame:(CGRect)frame {
//    frame.origin.x += 8;
//    frame.origin.y += 5;
//    frame.size.width -= 16;
//    frame.size.height -= 10;
//    [super setFrame:frame];
//}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.layer.cornerRadius = 6;
//        self.layer.masksToBounds = YES;
//        self.layer.borderColor = [ZJYColorHex(@"#ebebeb") CGColor];
//        self.layer.borderWidth = 1;
        self.backgroundColor = ZJYColorHex(@"#f7f7f7");
        [self setUpTitleView];
        
    }return self;
}
- (void)setUpTitleView {
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.cornerRadius = 5;
    _backView.layer.masksToBounds = YES;
    _backView.layer.borderColor = ZJYColorHex(@"#ebebeb").CGColor;
    _backView.layer.borderWidth = 1;
    [self.contentView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.bottom.mas_equalTo(-2);
    }];
    
    // 计划标题
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = FontMediumName(kWidthS(17));
    _titleLab.textColor = BlackTextColor;
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.centerX.mas_equalTo(0);
    }];
    // 推荐标题
    _typeLab = [[UILabel alloc] init];
    _typeLab.font = FontRegularName(kWidthS(12));
    _typeLab.textColor = BlueButtonColor;
    _typeLab.layer.cornerRadius = 3;
    _typeLab.layer.masksToBounds = YES;
    _typeLab.layer.borderWidth = 0.6;
    _typeLab.layer.borderColor = BlueButtonColor.CGColor;
    _typeLab.text = SIMLocalizedString(@"NPayListRecommendTitle", nil);
    _typeLab.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:_typeLab];
    CGSize size = [_typeLab.text sizeWithAttributes:@{NSFontAttributeName:_typeLab.font}];
    [_typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLab.mas_right).offset(5);
        make.centerY.mas_equalTo(_titleLab);
        make.width.mas_equalTo(size.width + 10);
        make.height.mas_equalTo(size.height);
    }];
    // 计划金额
    _priceLab = [[UILabel alloc] init];
    _priceLab.font = FontMediumName(kWidthS(20));
    _priceLab.textColor = ZJYColorHex(@"#818181");
    _priceLab.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:_priceLab];
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLab.mas_bottom).offset(15);
        make.centerX.mas_equalTo(0);
    }];
    
    // 购买按钮
    _button = [[UIButton alloc] init];
    _button.titleLabel.font = FontRegularName(kWidthS(15));
    _button.layer.cornerRadius = kWidthS(15);
    _button.layer.masksToBounds = YES;
    [_backView addSubview:_button];
    [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_priceLab.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(kWidthS(30));
        make.width.mas_equalTo(kWidthS(90));
    }];
    
    // 解释说明label
    _detailLab = [[UILabel alloc] init];
    _detailLab.font = [UIFont boldSystemFontOfSize:kWidthS(10)];
    _detailLab.numberOfLines = 0;
    _detailLab.textAlignment = NSTextAlignmentCenter;
    _detailLab.textColor = ZJYColorHex(@"#818181");
    [_backView addSubview:_detailLab];
    
    [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_button.mas_bottom).offset(20);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(-20);
    }];
}
- (void)setModel:(SIMNewPlanListModel *)model {
    _model = model;
    _titleLab.text = _model.name;
    if ([_model.name isEqualToString:@"高级计划"]) {
        _typeLab.hidden = NO;
    }else {
        _typeLab.hidden = YES;
    }
    NSString *priceStr = _model.price;
    
    NSString *danweiStr;
//    if ([_model.type isEqualToString:@"plan"]) {
//        danweiStr = _model.unit;
//    }else {
        danweiStr = [NSString stringWithFormat:@"/%@/%@",_model.time_unit,_model.price_unit];
//        if ([_model.plan_type intValue] == 2) {
//            danweiStr = @"/时/参与人";
//        }else {
//            danweiStr = @"/月/参与人";
//        }
//    }

    
    if ([_model.orderType intValue] == 5) {
        _priceLab.text = @"";
    }else {
        NSString *string= [NSString stringWithFormat:@"￥%@%@",priceStr,danweiStr];
        
        NSMutableAttributedString *atString = [[NSMutableAttributedString alloc] initWithString:string];
        CGFloat fontRatio = 0.40;//基线偏移比率
        NSInteger fontSize1 = kWidthS(20);
        NSInteger fontSize2 = kWidthS(13);
        [atString addAttribute:NSFontAttributeName value:FontMediumName(kWidthS(20)) range:NSMakeRange(0, [priceStr length] + 1)];
        [atString addAttribute:NSForegroundColorAttributeName value:ZJYColorHex(@"#f73f43") range:NSMakeRange(0, [priceStr length]+1)];
        [atString addAttribute:NSFontAttributeName value:FontRegularName(kWidthS(13)) range:NSMakeRange([priceStr length]+1, [danweiStr length])];
        [atString addAttribute:NSForegroundColorAttributeName value:ZJYColorHex(@"#818181") range:NSMakeRange([priceStr length]+1, [danweiStr length])];
        //不同大小的文字水平中部对齐(默认是底部对齐)
        [atString addAttribute:NSBaselineOffsetAttributeName value:@(fontRatio * (fontSize1 - fontSize2)) range:NSMakeRange([priceStr length] + 1, danweiStr.length)];
        
        _priceLab.attributedText = atString;
    }
    
//    NSString *buttonTitle;
//    if ([_model.type isEqualToString:@"plan"]) {
        NSString *buttonTitle = _model.buttonText;
//    }else {
//        // 订单类型：0购买，1续费，2升级
//        if ([_model.orderType intValue] == 0) {
//            buttonTitle = @"立即购买";
//        }else if ([_model.orderType intValue] == 1) {
//            buttonTitle = @"立即续费";
//        }else if ([_model.orderType intValue] == 2) {
//            buttonTitle = @"立即升级";
//        }else if ([_model.orderType intValue] == 3) {
//            buttonTitle = @"立即开通";
//        }else if ([_model.orderType intValue] == 4) {
//            buttonTitle = @"立即充值";
//        }
//    }
    
    [_button setTitle:buttonTitle forState:UIControlStateNormal];
    CGSize buttonSize = [_model.buttonText sizeWithAttributes:@{NSFontAttributeName:FontRegularName(kWidthS(15))}];
    CGFloat buttonwidth = buttonSize.width+30;
//    NSLog(@"buttonwidthbuttonwidth %lf",buttonwidth);
    [_button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(buttonwidth);
    }];
    
//    按钮是否可以点击：1可以点击，0不可以
    if ([_model.isClick intValue] == 0) {
        [_button setTitleColor:ZJYColorHex(@"#818181") forState:UIControlStateNormal];
        _button.layer.borderColor = ZJYColorHex(@"#818181").CGColor;
        _button.layer.borderWidth = 0.8;
        _button.enabled = NO;
    }else {
        [_button setTitleColor:ZJYColorHex(@"#f73f43") forState:UIControlStateNormal];
        _button.layer.borderColor = ZJYColorHex(@"#f73f43").CGColor;
        _button.layer.borderWidth = 0.8;
        _button.enabled = YES;
    }
    
    NSMutableString *detailStr = [NSMutableString stringWithString:_model.descriptionStr];
    if ([detailStr rangeOfString:@"&"].location != NSNotFound) {
        NSString *detailRealStr = [NSString stringWithFormat:@"%@",[detailStr stringByReplacingOccurrencesOfString:@"&" withString:@"\n"]];
        _detailLab.text = detailRealStr;
        [self setLabelSpace:_detailLab withValue:detailRealStr.copy withFont:[UIFont boldSystemFontOfSize:kWidthS(10)]];
    }else {
        _detailLab.text = detailStr;
    }
//    NSLog(@"_detailLab.text %@ %@",_model.descriptionStr,_detailLab.text);
}

-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.lineSpacing = 15; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSParagraphStyleAttributeName:paraStyle,
                          };
    NSAttributedString *attributeStr = [[NSAttributedString
                                         alloc] initWithString:str
                                        attributes:dic];
    label.attributedText = attributeStr;
}
- (void)buttonClick {
    if (self.btnClick) {
        self.btnClick();
    }
}
@end
