//
//  SIMHistoryPayCell.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/11.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMHistoryPayCell.h"
@interface SIMHistoryPayCell()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *buyLong;
@property (nonatomic, strong) UILabel *titleName;
@property (nonatomic, strong) UILabel *deadline;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *payResultLab;
@property (nonatomic, strong) UILabel *priceAllLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UIView *bottomline;

@end
@implementation SIMHistoryPayCell
// 改变单元格的大小
//- (void)setFrame:(CGRect)frame {
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
//    frame.origin.x += 8;
//    frame.origin.y += 10;
//    frame.size.width -= 16;
//    frame.size.height -= 20;
//    [super setFrame:frame];
//}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    // 计划标题
    _titleName = [[UILabel alloc] init];
    _titleName.font = FontRegularName(kWidthS(15));
    _titleName.textColor = BlackTextColor;
    [_backView addSubview:_titleName];
    
    // 支付结果
    _payResultLab = [[UILabel alloc] init];
    _payResultLab.textAlignment = NSTextAlignmentRight;
    _payResultLab.font = FontRegularName(kWidthS(15));
    [_backView addSubview:_payResultLab];
    
    // 分割线line
    _line = [[UIView alloc] init];
    _line.backgroundColor = ZJYColorHex(@"#ebebeb");
    [_backView addSubview:_line];
    
    // 商品头像
    _icon = [[UIImageView alloc] init];
//    _icon.image = [UIImage imageNamed:@"订单图片"];
    _icon.layer.cornerRadius = 5;
    _icon.layer.masksToBounds = YES;
    [_backView addSubview:_icon];
    
    // 购买时长
    _buyLong = [[UILabel alloc] init];
    _buyLong.font = FontRegularName(kWidthS(13));
    _buyLong.textColor = BlackTextColor;
    [_backView addSubview:_buyLong];
    
    // 有效期
    _deadline = [[UILabel alloc] init];
    _deadline.font = FontRegularName(kWidthS(13));
    _deadline.textColor = BlackTextColor;
    [_backView addSubview:_deadline];
    
    // 账单号
    _title = [[UILabel alloc] init];
    _title.font = FontRegularName(kWidthS(13));
    _title.textColor = BlackTextColor;
    [_backView addSubview:_title];
    
    // 分割线line
    _bottomline = [[UIView alloc] init];
    _bottomline.backgroundColor = ZJYColorHex(@"#ebebeb");
    [_backView addSubview:_bottomline];
    
    // 总金额
    _priceAllLab = [[UILabel alloc] init];
    _priceAllLab.font = FontRegularName(kWidthS(15));
    _priceAllLab.textColor = BlackTextColor;
    [_backView addSubview:_priceAllLab];
    
    // 支付金额
    _priceLab = [[UILabel alloc] init];
    _priceLab.font = FontRegularName(kWidthS(15));
    _priceLab.textColor = BlackTextColor;
    [_backView addSubview:_priceLab];
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.bottom.mas_equalTo(-10);
    }];
    [_titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kWidthS(5));
        make.left.mas_equalTo(kWidthS(10));
        make.height.mas_equalTo(kWidthS(35));
        make.width.mas_lessThanOrEqualTo(120);
    }];
    [_payResultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_titleName);
        make.right.mas_equalTo(-kWidthS(10));
    }];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleName.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_line.mas_bottom).offset(kWidthS(15));
        make.size.mas_equalTo(kWidthS(65));
        make.left.mas_equalTo(kWidthS(15));
    }];
    [_buyLong mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_icon.mas_top);
        make.left.mas_equalTo(_icon.mas_right).offset(kWidthS(15));
        make.right.mas_equalTo(-kWidthS(30));
    }];
    [_deadline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_icon.mas_centerY);
        make.left.right.mas_equalTo(_buyLong);
    }];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_icon.mas_bottom);
        make.left.right.mas_equalTo(_buyLong);
    }];
    [_bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_title.mas_bottom).offset(kWidthS(30));
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kWidthS(10));
        make.top.mas_equalTo(_bottomline.mas_bottom).offset(kWidthS(15));
        make.bottom.mas_equalTo(-kWidthS(15));
    }];
    [_priceAllLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_priceLab.mas_left).offset(-kWidthS(20));
        make.top.mas_equalTo(_priceLab);
    }];
    
}
- (void)setCurrentModel:(SIMNewPlanCurrentModel *)currentModel {
    _currentModel = currentModel;
    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiBaseUrl,_currentModel.payImg]] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    _titleName.text = _currentModel.planName;
//    支付状态：0=失败,1=成功,2=未支付,3=取消
    if ([_currentModel.payStatus intValue] == 0) {
        _payResultLab.text = SIMLocalizedString(@"NPayAlertViewfail", nil);
        _payResultLab.textColor = ZJYColorHex(@"#f74447");
    }else if ([_currentModel.payStatus intValue] == 1) {
        _payResultLab.text = SIMLocalizedString(@"NPayAlertViewsucess", nil);
        _payResultLab.textColor = BlueButtonColor;
    }else if ([_currentModel.payStatus intValue] == 2) {
        _payResultLab.text = SIMLocalizedString(@"NPayAlertViewNoPayed", nil);
        _payResultLab.textColor = ZJYColorHex(@"#7f7f7f");
    }else if ([_currentModel.payStatus intValue] == 3){
        _payResultLab.text = SIMLocalizedString(@"NPayAlertViewCancel", nil);
        _payResultLab.textColor = ZJYColorHex(@"#7f7f7f");
    }
    if ([_currentModel.payType isEqualToString:@"m"]) {
        _buyLong.text = [NSString stringWithFormat:@"%@：%@",SIMLocalizedString(@"NPayHistoryTimeLong", nil),SIMLocalizedString(@"NPayMain_Month", nil)];
    }else if ([_currentModel.payType isEqualToString:@"q"]) {
        _buyLong.text = [NSString stringWithFormat:@"%@：%@",SIMLocalizedString(@"NPayHistoryTimeLong", nil),@"1季"];
    }else {
        _buyLong.text = [NSString stringWithFormat:@"%@：%@",SIMLocalizedString(@"NPayHistoryTimeLong", nil),SIMLocalizedString(@"NPayMain_Year", nil)];
    }
    
    _title.text = [NSString stringWithFormat:@"%@：%@",SIMLocalizedString(@"NPayHistoryCount", nil),_currentModel.orderNum];
    _deadline.text = [NSString stringWithFormat:@"%@：%@ - %@",SIMLocalizedString(@"NPayHistoryDate", nil),[NSString dateTranformTimeStrFromTimeStr:_currentModel.startTime withFromformat:@"yyyy-MM-dd" withToformat:@"yyyy.MM.dd"],[NSString dateTranformTimeStrFromTimeStr:_currentModel.endTime withFromformat:@"yyyy-MM-dd" withToformat:@"yyyy.MM.dd"]];
    _priceAllLab.text = [NSString stringWithFormat:@"%@：￥%@",SIMLocalizedString(@"NPayAlertViewprice_all", nil),_currentModel.orderAmount];
    _priceLab.text = [NSString stringWithFormat:@"%@：￥%@",SIMLocalizedString(@"NPayAlertViewprice_pay", nil),_currentModel.amount];
    
}


@end
