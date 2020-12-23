//
//  SIMOrderNextThreeCell.m
//  Kaihuibao
//
//  Created by mac126 on 2018/12/26.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMOrderNextThreeCell.h"
@interface SIMOrderNextThreeCell()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *asscoryImage;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIButton *detail;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *mainMan;
@property (nonatomic, strong) UILabel *detailMain;
@property (nonatomic, strong) UILabel *priceAllLab;
@property (nonatomic, strong) NSString *typse;

@property (nonatomic, strong) UILabel *titleName;
@property (nonatomic, strong) UILabel *liuliang;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *sepline;
@property (nonatomic, strong) UIButton *start;
@property (nonatomic, strong) UIButton *wechatBtn;
@property (nonatomic, strong) UIButton *qqBtn;

@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *dataLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *nameLabdetail;
@property (nonatomic, strong) UILabel *dataLabdetail;
@property (nonatomic, strong) UILabel *prepayLab;
@property (nonatomic, strong) UILabel *prepayLabdetail;
@property (nonatomic, strong) UILabel *explanLab;
@end
@implementation SIMOrderNextThreeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor whiteColor];
        [self setUpTitleView];
        
    }return self;
}
- (void)setUpTitleView {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 40)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topView];
    
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, screen_width-60, 40)];
    _title.text = SIMLocalizedString(@"NPayAllNext_Title", nil);
    _title.textAlignment = NSTextAlignmentLeft;
    _title.font = [UIFont boldSystemFontOfSize:14];
    _title.textColor = NewBlackTextColor;
    [self.topView addSubview:self.title];
    
    // 白色背景 放一堆按钮的背景View
    _line = [[UIView alloc] initWithFrame:CGRectMake(0, 41, screen_width, 1)];
    _line.backgroundColor = ZJYColorHex(@"#eeeeee");
    [self.contentView addSubview:_line];
    
}
- (void)addOnePriceViews {
    
    _dataLab= [[UILabel alloc] init];
    _dataLab.text = SIMLocalizedString(@"NPayAlertViewprice_all", nil);
    _dataLab.font = FontRegularName(16);
    _dataLab.textColor = BlackTextColor;
    _dataLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_dataLab];
    
    _priceLab= [[UILabel alloc] init];
    _priceLab.text = SIMLocalizedString(@"NPayBuyLiuLiang_TypeName", nil);
    _priceLab.font = FontRegularName(16);
    _priceLab.textColor = BlackTextColor;
    _priceLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_priceLab];
    
    _dataLabdetail= [[UILabel alloc] init];
    _dataLabdetail.font = FontRegularName(18);
    _dataLabdetail.textColor = BlackTextColor;
    _dataLabdetail.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_dataLabdetail];

    _wechatBtn = [[UIButton alloc] init];
    [_wechatBtn setImage:[UIImage imageNamed:@"detailPayPage_wechat"] forState:UIControlStateNormal];
    [self.contentView addSubview:_wechatBtn];
    
    [_dataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(56);
        make.left.mas_equalTo(30);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(100);
    }];
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_dataLab.mas_bottom).offset(20);
        make.left.mas_equalTo(30);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(100);
    }];
    [_dataLabdetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_dataLab.mas_top);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(15);
    }];
    [_wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_priceLab.mas_centerY);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-20);
    }];
    
    
}
- (void)addTwoPriceViews {
    
    _dataLab= [[UILabel alloc] init];
    _dataLab.text = SIMLocalizedString(@"NPayAlertViewprice_all", nil);
    _dataLab.font = FontRegularName(16);
    _dataLab.textColor = BlackTextColor;
    _dataLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_dataLab];
    
    _prepayLab= [[UILabel alloc] init];
    _prepayLab.text = SIMLocalizedString(@"NPayAlertViewprice_Prepayments", nil);
    _prepayLab.font = FontRegularName(16);
    _prepayLab.textColor = BlackTextColor;
    _prepayLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_prepayLab];
    
    _priceLab= [[UILabel alloc] init];
    _priceLab.text = SIMLocalizedString(@"NPayBuyLiuLiang_TypeName", nil);
    _priceLab.font = FontRegularName(16);
    _priceLab.textColor = BlackTextColor;
    _priceLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_priceLab];
    
    _dataLabdetail= [[UILabel alloc] init];
    _dataLabdetail.font = FontRegularName(18);
    _dataLabdetail.textColor = BlackTextColor;
    _dataLabdetail.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_dataLabdetail];
    
    _prepayLabdetail= [[UILabel alloc] init];
    _prepayLabdetail.font = FontRegularName(18);
    _prepayLabdetail.textColor = BlackTextColor;
    _prepayLabdetail.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_prepayLabdetail];
    
    _wechatBtn = [[UIButton alloc] init];
    [_wechatBtn setImage:[UIImage imageNamed:@"detailPayPage_wechat"] forState:UIControlStateNormal];
    [self.contentView addSubview:_wechatBtn];
    
    _explanLab = [[UILabel alloc] init];
    _explanLab.font = FontRegularName(12);
    _explanLab.textColor = RedButtonColor;
    _explanLab.numberOfLines = 0;
    _explanLab.text = @"说明：仅需支付预付款，即可立即使用";
    [self.contentView addSubview:_explanLab];
    
    [_dataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(56);
        make.left.mas_equalTo(30);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(100);
    }];
    
    [_prepayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_dataLab.mas_bottom).offset(20);
        make.left.mas_equalTo(30);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(100);
    }];
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_prepayLab.mas_bottom).offset(20);
        make.left.mas_equalTo(30);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(100);
    }];
    [_dataLabdetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_dataLab.mas_top);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(15);
    }];
    [_prepayLabdetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_prepayLab.mas_top);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(15);
    }];
    [_wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_priceLab.mas_centerY);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
    
    [_explanLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_priceLab.mas_bottom).offset(20);
        make.left.mas_equalTo(30);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(screen_width - 60);
        make.bottom.mas_equalTo(-20);
    }];
    
}
- (void)setModel:(SIMPayPlanModel *)model {
    _model = model;
    NSLog(@"freearr_model%@",_model);
    
    SIMPayPlanModel_PricePlan *priceModel = model.PricePlan[0];
    
    //预付款
    if ([priceModel.deposit floatValue] <= 0) {
        //  调用少UI 没有预付款
        [self addOnePriceViews];
        
    }else {
        // 调用全UI
        [self addTwoPriceViews];
    }
    
    
    NSString *yueStr = [NSString stringWithFormat:@"%@",[priceModel.deposit stringValue]];
    NSString *string= [NSString stringWithFormat:@"￥%@",yueStr];
    
    NSMutableAttributedString *atString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [atString addAttribute:NSFontAttributeName value:FontRegularName(14) range:NSMakeRange(0, 1)];
    [atString addAttribute:NSFontAttributeName value:FontRegularName(18) range:NSMakeRange(1, yueStr.length)];
    
    _prepayLabdetail.attributedText = atString;
    
    NSString *yueStr2 = [NSString stringWithFormat:@"%@",[priceModel.total stringValue]];
    NSString *string2= [NSString stringWithFormat:@"￥%@",yueStr2];
    
    NSMutableAttributedString *atString2 = [[NSMutableAttributedString alloc] initWithString:string2];
    
    [atString2 addAttribute:NSFontAttributeName value:FontRegularName(14) range:NSMakeRange(0, 1)];
    [atString2 addAttribute:NSFontAttributeName value:FontRegularName(18) range:NSMakeRange(1, yueStr.length)];
    
    _dataLabdetail.attributedText = atString2;

}


@end
