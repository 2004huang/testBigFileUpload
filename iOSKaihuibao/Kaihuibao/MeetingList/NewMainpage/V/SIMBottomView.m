//
//  SIMBottomView.m
//  Kaihuibao
//
//  Created by mac126 on 2019/5/16.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMBottomView.h"
#import "UILabel+YBAttributeTextTapAction.h"
@interface SIMBottomView()<YBAttributeTapActionDelegate>
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *detail;
@property (nonatomic, strong) UIButton *lookBtn;
@property (nonatomic, strong) UIButton *redEnvelopeBtn;
@property (nonatomic, strong) UIButton *wellbeingBtn;
@end

@implementation SIMBottomView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubViews];
        
    }return self;
}
- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
    
//    _redEnvelopeBtn = [[UIButton alloc] init];
////    [_redEnvelopeBtn setImage:[UIImage imageNamed:@"main_红包"] forState:UIControlStateNormal];
//    [_redEnvelopeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_redEnvelopeBtn setBackgroundImage:[UIImage imageWithColor:GrayPromptTextColor] forState:UIControlStateHighlighted];
//    [_redEnvelopeBtn addTarget:self action:@selector(lookBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    _redEnvelopeBtn.titleLabel.font = FontRegularName(kWidthS(13));
//    _redEnvelopeBtn.backgroundColor = BlueButtonColor;
////    ZJYColorHex(@"#f74d50");
//    _redEnvelopeBtn.layer.masksToBounds = YES;
//    _redEnvelopeBtn.layer.cornerRadius = kWidthS(17);
//    [self addSubview:_redEnvelopeBtn];
//    [_redEnvelopeBtn setTitle:SIMLocalizedString(@"MainPageBottomButtonOne", nil) forState:UIControlStateNormal];
    
     _wellbeingBtn = [[UIButton alloc] init];
//     [_wellbeingBtn setImage:[UIImage imageNamed:@"main_计划定价"] forState:UIControlStateNormal];
     [_wellbeingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [_wellbeingBtn setBackgroundImage:[UIImage imageWithColor:GrayPromptTextColor] forState:UIControlStateHighlighted];
     [_wellbeingBtn addTarget:self action:@selector(wellbeingBtnClick) forControlEvents:UIControlEventTouchUpInside];
     _wellbeingBtn.titleLabel.font = FontRegularName(kWidthS(13));
     _wellbeingBtn.backgroundColor = BlueButtonColor;
     _wellbeingBtn.layer.masksToBounds = YES;
     _wellbeingBtn.layer.cornerRadius = kWidthS(17);
     [self addSubview:_wellbeingBtn];
    [_wellbeingBtn setTitle:@"升级到专业版" forState:UIControlStateNormal];
    
    _title.font = FontRegularName(kWidthS(12));
    _title.textColor = GrayPromptTextColor;
    NSString *contentStr = self.cloudVersion.specialnote_content;
    NSString *linkStr = self.cloudVersion.specialnote_link;
    NSString *allStr = [NSString stringWithFormat:@"%@ %@",contentStr,linkStr];
    NSMutableAttributedString *atstring = [[NSMutableAttributedString alloc] initWithString:allStr];
    if (linkStr.length > 0) {
        NSRange range1 = [allStr rangeOfString:linkStr];
        [atstring addAttribute:NSForegroundColorAttributeName value:BlueButtonColor range:range1];
    }
    _title.attributedText = atstring;
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-kWidthS(15));
    }];
    if (linkStr.length > 0) {
       [_title yb_addAttributeTapActionWithStrings:@[linkStr] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
            // 联系客服 跳转官网
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
        }];
    }
    
//    BOOL oneSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"] && [self.cloudVersion.find boolValue];
    BOOL twoSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"] && [self.cloudVersion.plan boolValue];
//    if (oneSwitch && twoSwitch) {
//        [_redEnvelopeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(self.mas_centerX).offset(-kWidthS(10));
//            make.height.mas_equalTo(kWidthS(34));
//            make.width.mas_equalTo(kWidthS(90));
//            make.bottom.mas_equalTo(_title.mas_top).offset(-kWidthS(15));
//        }];
//        [_wellbeingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.mas_centerX).offset(kWidthS(10));
//            make.height.mas_equalTo(kWidthS(34));
//            make.width.mas_equalTo(kWidthS(90));
//            make.bottom.mas_equalTo(_title.mas_top).offset(-kWidthS(15));
//        }];
//    }else if (!oneSwitch && twoSwitch) {
        [_wellbeingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(kWidthS(35));
            make.width.mas_equalTo(kWidthS(130));
            make.bottom.mas_equalTo(_title.mas_top).offset(-kWidthS(15));
        }];
//    }else if (oneSwitch && !twoSwitch) {
//        [_redEnvelopeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(0);
//            make.height.mas_equalTo(kWidthS(34));
//            make.width.mas_equalTo(kWidthS(90));
//            make.bottom.mas_equalTo(_title.mas_top).offset(-kWidthS(15));
//        }];
//    }
    
    
//    [_redEnvelopeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, kWidthS(5), 0, -kWidthS(5))];
//    [_redEnvelopeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -kWidthS(5), 0, kWidthS(5))];
//    [_wellbeingBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, kWidthS(5), 0, -kWidthS(5))];
//    [_wellbeingBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -kWidthS(5), 0, kWidthS(5))];

}
- (void)setModel:(SIMNewPlanCurrentModel *)model {
    _model = model;
    NSLog(@"delta1delta1delta1 %@",_model.planName);
    _title.text = SIMLocalizedString(@"NewMainLoginTitle", nil);
    _title.textColor = BlackTextColor;
    _title.font = FontRegularName(kWidthS(16));
    
    _detail.font = FontRegularName(kWidthS(12));
    _detail.textColor = GrayPromptTextColor;
    
    _lookBtn = [[UIButton alloc] init];
    [_lookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_lookBtn setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [_lookBtn setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    [_lookBtn addTarget:self action:@selector(lookBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _lookBtn.titleLabel.font = FontRegularName(kWidthS(13));
    _lookBtn.backgroundColor = BlueButtonColor;
    _lookBtn.layer.masksToBounds = YES;
    _lookBtn.layer.cornerRadius = kWidthS(8);
    [self addSubview:_lookBtn];
    
    
    if (_model.endTime.length == 0) { // 后台数据是根绝结束时间判断的 如果是“”那么就是计时计划和免费计划 如果有结束日期则为普通计划
        if (_model.plan_type != nil && [_model.plan_type intValue] == 2) {
            // 计时计划 2为计时计划
            _detail.text = [NSString stringWithFormat:SIMLocalizedString(@"NPayMineTimingPlanText", nil),_model.planName,[_model.participant stringValue]];
            if ([_model.type isEqualToString:@"mainPage"]) {
                // 如果是首页进来 那么就是查看计划 如果是在当前计划页面 就是关闭计划
                [_lookBtn setTitle:SIMLocalizedString(@"NPayMineBtnLookText", nil) forState:UIControlStateNormal];
            }else {
                [_lookBtn setTitle:SIMLocalizedString(@"NPayMineBtnCloseText", nil) forState:UIControlStateNormal];
            }
        }else {
            // 免费计划 1为免费计划
            _detail.text = [NSString stringWithFormat:SIMLocalizedString(@"NPayMineFreePlanText", nil),_model.planName];
            
            [_lookBtn setTitle:SIMLocalizedString(@"NPayMineBtnLookText", nil) forState:UIControlStateNormal];
        }
        
    }else {
        // 普通计划
        NSDate *dateS = [NSDate date];
        NSDate *dateE = [NSString dateTranformDateFromTimeStr:_model.endTime withformat:@"yyyy-MM-dd"];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit unit1 = NSCalendarUnitDay;//同时比较天数、月份差异
        //比较的结果是NSDateComponents类对象
        NSDateComponents *delta1 = [calendar components:unit1 fromDate:dateS toDate:dateE options:0];
        //打印
        NSLog(@"delta1delta1delta1 %@",delta1);

        _detail.text = [NSString stringWithFormat:SIMLocalizedString(@"NPayMinePaymentPlanText", nil),_model.planName,[_model.participant stringValue],delta1.day];
        if ([_model.type isEqualToString:@"mainPage"]) {
            [_lookBtn setTitle:SIMLocalizedString(@"NPayMineBtnLookText", nil) forState:UIControlStateNormal];
        }else {
            [_lookBtn setTitle:SIMLocalizedString(@"NPayMineBtnUpdateText", nil) forState:UIControlStateNormal];
        }

    }
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(kWidthS(5));
    }];
    
    [_detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_title);
        make.top.mas_equalTo(_title.mas_bottom).offset(kWidthS(10));
    }];
    [_lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(kWidthS(32));
        make.top.mas_equalTo(_detail.mas_bottom).offset(kWidthS(20));
        make.width.mas_equalTo(kWidthS(86));
    }];
}
- (void)addSubViews {
    _title = [[UILabel alloc] init];
    _title.numberOfLines = 0;
    _title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_title];
    
    _detail = [[UILabel alloc] init];
    _detail.textAlignment = NSTextAlignmentCenter;
    _detail.numberOfLines = 0;
    [self addSubview:_detail];

}
- (void)lookBtnClick {
    if (self.btnClick) {
        self.btnClick();
    }
}
- (void)wellbeingBtnClick {
    if (self.wellBeingBtnClick) {
        self.wellBeingBtnClick();
    }
}


@end
