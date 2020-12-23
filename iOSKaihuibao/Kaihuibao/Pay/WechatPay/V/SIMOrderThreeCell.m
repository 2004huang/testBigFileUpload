//
//  SIMOrderThreeCell.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/12.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMOrderThreeCell.h"

@interface SIMOrderThreeCell()

@property (nonatomic, strong) UIView *topView; // “订单总览”标题view
@property (nonatomic, strong) UILabel *title;  // “订单总览”label
@property (nonatomic, strong) UIView *line;    // 分割线
@property (nonatomic, strong) NSString *typse; // 区分是视频会议的月 还是客服的分钟 不知道还用不用这个参数了

@property (nonatomic, strong) UILabel *titleName;      // 计划类型标题
@property (nonatomic, strong) UILabel *roomLab;        // 会议室数量
@property (nonatomic, strong) UILabel *manLab;         // 参会者数量
@property (nonatomic, strong) UILabel *dataLab;        // “总金额”titlelab
@property (nonatomic, strong) UILabel *dataLabdetail;  // “总金额具体价格”detaillab
@property (nonatomic, strong) UILabel *priceLab;       // “支付方式”titlelab
@property (nonatomic, strong) UIButton *wechatBtn;     // 微信支付图标样式
@property (nonatomic, strong) UILabel *prepayLab;      // “预付款”titlelab
@property (nonatomic, strong) UILabel *prepayLabdetail;// “预付款具体价格”detaillab
@property (nonatomic, strong) UILabel *explanLab;      // 对预付款的解释说明 有预付款才有的label
@property (nonatomic, strong) UILabel *expairDateLab;  // 有效期label
@property (nonatomic, strong) UILabel *payDetailLab; // 支付细则label

@end

@implementation SIMOrderThreeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor whiteColor];
        [self setUpTitleView];
        
        
    }return self;
}

#pragma mark -- 布局视图
// 总标题栏
- (void)setUpTitleView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = ZJYColorHex(@"#f7f7f7");
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(5);
        make.top.mas_equalTo(0);
    }];
    
    _topView = [[UIView alloc] init];
    _topView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.topView];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(kWidthS(36));
        make.top.mas_equalTo(view.mas_bottom);
    }];
    
    _title = [[UILabel alloc] init];
    _title.text = SIMLocalizedString(@"NPayAllNext_OrderTitle", nil);
    _title.textAlignment = NSTextAlignmentLeft;
    _title.font = FontMediumName(15);
    _title.textColor = BlackTextColor;
    [self.topView addSubview:self.title];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(kWidthS(35));
    }];
    
    _line = [[UIView alloc] init];
    _line.backgroundColor = ZJYColorHex(@"#ebebeb");
    [self.topView addSubview:_line];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    [self addBackViews];
    
}
// 订单详情的控件init
- (void)addBackViews {
    _titleName = [[UILabel alloc] init];
    _titleName.font = FontRegularName(kWidthS(14));
    _titleName.textColor = BlackTextColor;
    [self.contentView addSubview:_titleName];
    
    [_titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topView.mas_bottom).offset(kWidthS(10));
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(kWidthS(30));
        make.right.mas_equalTo(-30);
    }];
    
//    _roomLab = [[UILabel alloc] init];
//    _roomLab.font = FontRegularName(14];
//    _roomLab.textColor = BlackTextColor;
//    [self.contentView addSubview:_roomLab];
//
//    [_roomLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_titleName.mas_bottom);
//        make.left.height.right.mas_equalTo(_titleName);
//    }];
//
//    _manLab = [[UILabel alloc] init];
//    _manLab.font = FontRegularName(14];
//    _manLab.textColor = BlackTextColor;
//    [self.contentView addSubview:_manLab];
//
//    [_manLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_roomLab.mas_bottom);
//        make.left.height.right.mas_equalTo(_titleName);
//    }];
    
    // 总金额
    _dataLab= [[UILabel alloc] init];
    _dataLab.text = SIMLocalizedString(@"NPayAlertViewprice_all", nil);
    _dataLab.font = FontRegularName(kWidthS(14));
    _dataLab.textColor = BlackTextColor;
    _dataLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_dataLab];
    
    [_dataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleName.mas_bottom);
        make.left.height.mas_equalTo(_titleName);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    // 具体总金额
    _dataLabdetail= [[UILabel alloc] init];
    _dataLabdetail.font = FontRegularName(kWidthS(18));
    _dataLabdetail.textColor = BlackTextColor;
    _dataLabdetail.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_dataLabdetail];
    
    [_dataLabdetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_dataLab.mas_centerY);
        make.right.mas_equalTo(-20);
    }];
    // 支付金额label 减掉
    _prepayLab= [[UILabel alloc] init];
    _prepayLab.font = FontRegularName(kWidthS(14));
    _prepayLab.textColor = BlackTextColor;
    _prepayLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_prepayLab];
    // 预付款金额label
    _prepayLabdetail= [[UILabel alloc] init];
    _prepayLabdetail.font = FontRegularName(kWidthS(18));
    _prepayLabdetail.textColor = BlackTextColor;
    _prepayLabdetail.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_prepayLabdetail];
//     // 支付方式label
//    _priceLab= [[UILabel alloc] init];
//    _priceLab.text = SIMLocalizedString(@"NPayBuyLiuLiang_TypeName", nil);
//    _priceLab.font = FontRegularName(kWidthS(14));
//    _priceLab.textColor = BlackTextColor;
//    _priceLab.textAlignment = NSTextAlignmentLeft;
//    [self.contentView addSubview:_priceLab];
//    // 支付方式图标
//    _wechatBtn = [[UIButton alloc] init];
//    [_wechatBtn setImage:[UIImage imageNamed:@"detailPayPage_wechat"] forState:UIControlStateNormal];
//    _wechatBtn.contentMode = UIViewContentModeCenter;
//    [self.contentView addSubview:_wechatBtn];
    // 有效日期label
    _expairDateLab = [[UILabel alloc] init];
    _expairDateLab.font = FontRegularName(kWidthS(14));
    _expairDateLab.textColor = BlackTextColor;
    _expairDateLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_expairDateLab];
    
//    // 支付细则label
//    _payDetailLab = [[UILabel alloc] init];
//    _payDetailLab.font = FontRegularName(kWidthS(12));
//    _payDetailLab.textColor = ZJYColorHex(@"#f73f43");
//    _payDetailLab.numberOfLines = 0;
//    [self.contentView addSubview:_payDetailLab];
    
//    // 解释说明label
//    _explanLab = [[UILabel alloc] init];
//    _explanLab.font = FontRegularName(kWidthS(12));
//    _explanLab.numberOfLines = 0;
//    _explanLab.text = SIMLocalizedString(@"NPayAllNext_HelpText", nil);
//    _explanLab.textColor = ZJYColorHex(@"#b6b6b6");
//    [self.contentView addSubview:_explanLab];
    
    [_prepayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_dataLab.mas_bottom);
        make.left.height.mas_equalTo(_titleName);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    [_prepayLabdetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_prepayLab.mas_centerY);
        make.right.mas_equalTo(-20);
    }];
//    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_prepayLab.mas_bottom);
//        make.left.height.mas_equalTo(_titleName);
//        make.width.mas_lessThanOrEqualTo(100);
//    }];
//    [_wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(_priceLab.mas_centerY);
//        make.size.mas_equalTo(kWidthS(25));
//        make.right.mas_equalTo(-20);
//    }];
    [_expairDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_prepayLab.mas_bottom);
        make.left.height.mas_equalTo(_titleName);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-kWidthS(15));
    }];
//    [_payDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_expairDateLab.mas_bottom).offset(5);
//        make.left.mas_equalTo(_titleName);
//        make.right.mas_equalTo(-15);
//    }];
//    [_explanLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_expairDateLab.mas_bottom).offset(kWidthS(5));
//        make.left.mas_equalTo(_titleName);
//        make.right.mas_equalTo(-20);
//        make.bottom.mas_equalTo(-kWidthS(20));
//    }];
}
//- (void)setIsUpPlan:(BOOL)isUpPlan {
//    _isUpPlan = isUpPlan;
//    if (_isUpPlan == YES) {
//        _explanLab.textColor = ZJYColorHex(@"#f73f43");
//        _explanLab.text = @"说明：当您选择升级会议计划或服务时，原购买套餐将失效；如果您的原套餐剩余天数的核算总金额大于升级时所需金额，可直接抵扣升级费用。需要帮助？请联系我们：400-080-5766";
//    }else {
//        _explanLab.text = @"需要帮助？请联系我们：400-080-5766";
//        _explanLab.textColor = ZJYColorHex(@"#b6b6b6");
//    }
//
//
//}

- (void)setTypes:(NSString *)types {
    _types = types;
    _typse = _types;
}
- (void)setNameStr:(NSString *)nameStr {
    _nameStr = nameStr;
    _titleName.text = [NSString stringWithFormat:@"%@",_nameStr];
}
- (void)setListmodel:(SIMOptionList *)listmodel {
    _listmodel = listmodel;
    
    SIMNewPlanDetailInfo *info = _listmodel.info[[self.typse intValue] - 1];
    _expairDateLab.text = [NSString stringWithFormat:@"%@：%@-%@",SIMLocalizedString(@"NPayHistoryDate", nil),[NSString dateTranformTimeStrFromTimeStr:info.startTime withFromformat:@"yyyy-MM-dd HH:mm:ss" withToformat:@"yyyy.MM.dd"],[NSString dateTranformTimeStrFromTimeStr:info.endTime withFromformat:@"yyyy-MM-dd HH:mm:ss" withToformat:@"yyyy.MM.dd"]];
    
    int mainCount;
    CGFloat priceAllCount;
    CGFloat pricePreCount;
    CGFloat sumAllCount;
    CGFloat sumPreCount;
//    if ([self.typse intValue] == 1) {
        // 月
        mainCount = [_listmodel.countStr intValue];
        priceAllCount = [info.totalMoney floatValue];
        pricePreCount = [info.payMoney floatValue];
        sumAllCount = mainCount * (priceAllCount / [_listmodel.main intValue]);
        sumPreCount = mainCount * (priceAllCount / [_listmodel.main intValue]);
//    }
    
    NSString *priceStr = [NSString stringWithFormat:@"%.2f",sumAllCount];
    NSString *preStr = [NSString stringWithFormat:@"%.2f",sumPreCount];
    
    NSString *string= [NSString stringWithFormat:@"￥%@",priceStr];
    NSMutableAttributedString *atString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [atString addAttribute:NSFontAttributeName value:FontRegularName(kWidthS(14)) range:NSMakeRange(0, 1)];
    [atString addAttribute:NSFontAttributeName value:FontRegularName(kWidthS(18)) range:NSMakeRange(1, priceStr.length)];
    
    _dataLabdetail.attributedText = atString;
    
    
    _prepayLab.text = SIMLocalizedString(@"NPayAlertViewprice_pay", nil);
    
    NSString *preAllStr= [NSString stringWithFormat:@"￥%@",preStr];
    
    NSMutableAttributedString *preAtrString = [[NSMutableAttributedString alloc] initWithString:preAllStr];
    
    [preAtrString addAttribute:NSFontAttributeName value:FontRegularName(kWidthS(14)) range:NSMakeRange(0, 1)];
    [preAtrString addAttribute:NSFontAttributeName value:FontRegularName(kWidthS(18)) range:NSMakeRange(1, preStr.length)];
    
    _prepayLabdetail.attributedText = preAtrString;
}

- (void)setDetailModel:(SIMNewPlanDetailModel *)detailModel {
    _detailModel = detailModel;
    
    _titleName.text = [NSString stringWithFormat:@"%@",_detailModel.name];
    NSArray *arr;
    NSArray *infoarray = _detailModel.info_array;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"] && [self.cloudVersion.plan boolValue]) {
        if (infoarray.count == 0) {
            arr = _detailModel.info;
        }else {
            arr = _detailModel.info_array;
        }
    }else {
        arr = _detailModel.info;
    }
    
    
    SIMNewPlanDetailInfo *info = arr[[self.typse intValue] - 1];
//    if ([self.typse isEqualToString:@"1"]) {
//
//        _expairDateLab.text = [NSString stringWithFormat:@"有效日期：%@-%@",info.MstartTime,info.MendTime];
//
//        NSString *priceStr = info.monthTotal;
//        NSString *preStr = info.monthPay;
//
//        NSString *string= [NSString stringWithFormat:@"￥%@",priceStr];
//        NSMutableAttributedString *atString = [[NSMutableAttributedString alloc] initWithString:string];
//
//        [atString addAttribute:NSFontAttributeName value:FontRegularName(14) range:NSMakeRange(0, 1)];
//        [atString addAttribute:NSFontAttributeName value:FontRegularName(18) range:NSMakeRange(1, priceStr.length)];
//
//        _dataLabdetail.attributedText = atString;
//
//
//        _prepayLab.text = @"支付金额";
//
//        NSString *preAllStr= [NSString stringWithFormat:@"￥%@",preStr];
//
//        NSMutableAttributedString *preAtrString = [[NSMutableAttributedString alloc] initWithString:preAllStr];
//
//        [preAtrString addAttribute:NSFontAttributeName value:FontRegularName(14) range:NSMakeRange(0, 1)];
//        [preAtrString addAttribute:NSFontAttributeName value:FontRegularName(18) range:NSMakeRange(1, preStr.length)];
//
//        _prepayLabdetail.attributedText = preAtrString;
//    }else {
    if (_detailModel.valuationType != nil) {
        _expairDateLab.text = [NSString stringWithFormat:@"%@：%@-%@",SIMLocalizedString(@"NPayHistoryDate", nil),[NSString dateTranformTimeStrFromTimeStr:info.startTime withFromformat:@"yyyy-MM-dd  HH:mm:ss" withToformat:@"yyyy.MM.dd"],[NSString dateTranformTimeStrFromTimeStr:info.endTime withFromformat:@"yyyy-MM-dd  HH:mm:ss" withToformat:@"yyyy.MM.dd"]];
    }else {
        _expairDateLab.text = [NSString stringWithFormat:@"%@：%@-%@",SIMLocalizedString(@"NPayHistoryDate", nil),[NSString dateTranformTimeStrFromTimeStr:info.startTime withFromformat:@"yyyy-MM-dd" withToformat:@"yyyy.MM.dd"],[NSString dateTranformTimeStrFromTimeStr:info.endTime withFromformat:@"yyyy-MM-dd" withToformat:@"yyyy.MM.dd"]];
    }
    
    
    NSString *priceStr;
    NSString *preStr;
    if ([_detailModel.type isEqualToString:@"plan"]) {
        priceStr = info.totalMoney;
        preStr = info.payMoney;
    }else {
        if (_detailModel.countStr == nil) {
            priceStr = info.totalMoney;
            preStr = info.payMoney;
        }else {
            int mainCount;
            CGFloat priceAllCount;
            CGFloat pricePreCount;
            CGFloat sumAllCount;
            CGFloat sumPreCount;
            mainCount = [_detailModel.countStr intValue];
            priceAllCount = [info.totalMoney floatValue];
            pricePreCount = [info.payMoney floatValue];
            sumAllCount = mainCount * (priceAllCount / [_detailModel.main intValue]);
            sumPreCount = mainCount * (priceAllCount / [_detailModel.main intValue]);
            
//            if ([self.typse intValue] == 1) {
//                mainCount = [_detailModel.countStr intValue];
//                priceCount = [info.price floatValue];
//                sumCount = mainCount * priceCount;
//            }else {
//                mainCount = [_detailModel.countStr intValue];
//                priceCount = [info.price floatValue];
//                sumCount = mainCount * priceCount * 12;
//            }
            priceStr = [NSString stringWithFormat:@"%.2f",sumAllCount];
            preStr = [NSString stringWithFormat:@"%.2f",sumPreCount];
        }
    }
        NSString *string= [NSString stringWithFormat:@"￥%@",priceStr];
        NSMutableAttributedString *atString = [[NSMutableAttributedString alloc] initWithString:string];
        
        [atString addAttribute:NSFontAttributeName value:FontRegularName(kWidthS(14)) range:NSMakeRange(0, 1)];
        [atString addAttribute:NSFontAttributeName value:FontRegularName(kWidthS(18)) range:NSMakeRange(1, priceStr.length)];
        
        _dataLabdetail.attributedText = atString;
        
        
        _prepayLab.text = SIMLocalizedString(@"NPayAlertViewprice_pay", nil);
        
        NSString *preAllStr= [NSString stringWithFormat:@"￥%@",preStr];
        
        NSMutableAttributedString *preAtrString = [[NSMutableAttributedString alloc] initWithString:preAllStr];
        
        [preAtrString addAttribute:NSFontAttributeName value:FontRegularName(kWidthS(14)) range:NSMakeRange(0, 1)];
        [preAtrString addAttribute:NSFontAttributeName value:FontRegularName(kWidthS(18)) range:NSMakeRange(1, preStr.length)];
        
        _prepayLabdetail.attributedText = preAtrString;
//    }
}


@end
