
//
//  SIMChoosePayPlanCell.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/11.
//  Copyright © 2018年 Ferris. All rights reserved.
//
//#define Button_Height kWidthScale(90)    // 高
#define Button_Width kWidthScale(170)      // 宽
#define Start_X  (screen_width - Button_Width * 2)/5 * 2           // 第一个按钮的X坐标
#define Start_Y 0.0f          // 第一个按钮的Y坐标
#define Width_Space (screen_width - Button_Width * 2)/5        // 2个按钮之间的横间距
#define Height_Space (screen_width - Button_Width * 2)/5     // 竖间距


#import "SIMChoosePayPlanCell.h"
#import "SIMPayPlanModel.h"
#import "SIMLabel.h"
@interface SIMChoosePayPlanCell()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *asscoryImage;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIButton *detail;
@property (nonatomic, assign) CGFloat bttonH;

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *selectImage;
@property (nonatomic, strong) UIButton *nowPlan;
@property (nonatomic, strong) NSMutableArray *tempButtonArray;
@end

@implementation SIMChoosePayPlanCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _bttonH = kWidthScale(90);
        self.buttonArray = [[NSMutableArray alloc] init];
        self.tempButtonArray = [[NSMutableArray alloc] init];
        [self setUpTitleView];
        
    }return self;
}
- (void)setUpTitleView {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 45)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topView];
    
    _asscoryImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 15, 5, 15)];
    _asscoryImage.backgroundColor = BlueButtonColor;
    _asscoryImage.image = [UIImage imageNamed:@"paymain_squareBlue"];
    [self.topView addSubview:_asscoryImage];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(25 + 10, 10, 100, 25)];
    _title.text = SIMLocalizedString(@"NPayMainS_selectPlanText", nil) ;
    _title.textAlignment = NSTextAlignmentLeft;
    _title.font = FontRegularName(14);
    _title.textColor = NewBlackTextColor;
    [self.topView addSubview:self.title];
    
    _detail = [[UIButton alloc] initWithFrame:CGRectMake(screen_width - 125, 10, 100, 25)];
    [_detail setTitle:SIMLocalizedString(@"NPayMainS_lookThePlanText", nil)  forState:UIControlStateNormal];
    _detail.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _detail.titleLabel.font = FontRegularName(14);
    [_detail addTarget:self action:@selector(detailMoreClick) forControlEvents:UIControlEventTouchUpInside];
    [_detail setTitleColor:BlueButtonColor forState:UIControlStateNormal];
    [self.topView addSubview:self.detail];
    
    // 白色背景 放一堆按钮的背景View
    _backView = [[UIView alloc] init];
    [self.contentView addSubview:self.backView];
    
}
//- (NSMutableArray *)tempButtonArray{
//    if (!_tempButtonArray) {
//        _tempButtonArray = [NSMutableArray array];
//    }
//    return _tempButtonArray;
//}


- (void)setArr:(NSArray *)arr {
    _arr = arr;
    
    
    
    
//    NSLog(@"_arrarrrrrrr %@ %@ %@",_arr,self.buttonArray,self.tempButtonArray);
    NSMutableArray *aaM= [NSMutableArray array];
    for (int buttonIndex = 0 ; buttonIndex < _arr.count; buttonIndex++) {
        SIMPayPlanModel *model = _arr[buttonIndex];
        NSString *strdd = model.PlanDescribe;
        
        CGSize size = [strdd sizeWithFont:FontRegularName(kWidthScale(10)) constrainedToSize:CGSizeMake(Button_Width-kWidthScale(20), MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        
        //宽度不变，根据字的多少计算label的高度
        CGFloat buttonHei = kWidthScale(70) + size.height + kWidthScale(15);
        [aaM addObject:@(buttonHei)];
    }
    _bttonH = [[aaM valueForKeyPath:@"@max.floatValue"] floatValue];
    NSLog(@"maxPricemaxPrice %lf",_bttonH);
    
    
    if (self.buttonArray.count > 0) {
        [self.buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.buttonArray removeAllObjects];
    }
    
    if (self.tempButtonArray.count > 0) {
        [self.tempButtonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.tempButtonArray removeAllObjects];
    }
    
    
    for (int buttonIndex = 0 ; buttonIndex < _arr.count; buttonIndex++) {
        
        SIMPayPlanModel *model = _arr[buttonIndex];
        SIMPayPlanModel_PricePlan *pm;
        NSNumber *billingStr;
        NSString *dateTypestr;
        if ([model.sign intValue] == 1) {
            // 视频会议 视频会议是月
            dateTypestr = SIMLocalizedString(@"NPayMain_MonthOrMin_YUE", nil);
            pm = [model.PricePlan objectAtIndex:1];
            billingStr = pm.MonthBilling;
        
        }else {
            // 其他都是分钟
            dateTypestr = SIMLocalizedString(@"NPayMain_MonthOrMin_FEN", nil);
            pm = [model.PricePlan objectAtIndex:0];
            billingStr = pm.MinuteBilling;
            
        }
        
        NSLog(@"pm.MonthBilling %@",billingStr);
        
        NSInteger index = buttonIndex % 2;
        NSInteger page = buttonIndex / 2;
        
        UIView *back = [[UIView alloc] init];
        back.tag = 1000+100+buttonIndex;
        back.backgroundColor = [UIColor whiteColor];
        back.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (_bttonH + Height_Space)+Start_Y, Button_Width, _bttonH);
//        back.layer.masksToBounds = YES;
        back.layer.cornerRadius = kWidthScale(5);
        back.layer.borderColor = ZJYColorHex(@"#d5d5d5").CGColor;
        back.layer.borderWidth = 1;
        [_backView addSubview:back];
        [self.tempButtonArray addObject:back];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(kWidthScale(20), kWidthScale(15), Button_Width-kWidthScale(40), kWidthScale(15));
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FontRegularName(kWidthScale(11));
        label.textColor = BlackTextColor;
        label.text = model.PlanName;
        [back addSubview:label];
//        [self.tempButtonArray addObject:label];
        
        UILabel *pricel = [[UILabel alloc] init];
        pricel.frame = CGRectMake(kWidthScale(20), kWidthScale(40), Button_Width - kWidthScale(40), kWidthScale(20));
        pricel.textAlignment = NSTextAlignmentCenter;
        pricel.textColor = BlueButtonColor;
        pricel.font = FontRegularName(kWidthScale(17));
//        [self.tempButtonArray addObject:pricel];
        
        if ([billingStr floatValue] <= 0) {
            pricel.text = @"免费";
        }else {
            
            NSString *string= [NSString stringWithFormat:@"￥%@/%@",[billingStr stringValue],dateTypestr];
            
            NSMutableAttributedString *atString = [[NSMutableAttributedString alloc] initWithString:string];
            [atString addAttributes:@{NSFontAttributeName:FontRegularName(kWidthScale(12)),
                                      NSForegroundColorAttributeName:GrayPromptTextColor
                                      
                                      } range:NSMakeRange(0, 1)];
            [atString addAttributes:@{NSFontAttributeName:FontRegularName(kWidthScale(25)),
                                      NSForegroundColorAttributeName:BlueButtonColor
                                      
                                      } range:NSMakeRange(1, [NSString stringWithFormat:@"%@",[billingStr stringValue]].length)];
            [atString addAttributes:@{NSFontAttributeName:FontRegularName(kWidthScale(12)),
                                      NSForegroundColorAttributeName:GrayPromptTextColor
                                      
                                      } range:NSMakeRange([NSString stringWithFormat:@"%@",[billingStr stringValue]].length+1, dateTypestr.length + 1)];
            
            pricel.attributedText = atString;
        }
        
        [back addSubview:pricel];
        
        SIMLabel *detaillab = [[SIMLabel alloc] init];
        detaillab.frame = CGRectMake(kWidthScale(10), kWidthScale(70), Button_Width-kWidthScale(20), _bttonH-kWidthScale(70)- 10);
        
        detaillab.numberOfLines = 0;
        detaillab.textColor = GrayPromptTextColor;
        detaillab.font = FontRegularName(kWidthScale(10));
        NSString *strdd = model.PlanDescribe;
//        CGSize size = [strdd sizeWithFont:detaillab.font constrainedToSize:CGSizeMake(detaillab.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        CGSize size = [strdd sizeWithFont:FontRegularName(kWidthScale(10)) constrainedToSize:CGSizeMake(Button_Width-kWidthScale(20), MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        detaillab.text = strdd;
        [back addSubview:detaillab];
       NSInteger count = size.height / detaillab.font.lineHeight;
        NSLog(@"detaillabcount%ld",count);
        if (count<2) {
            //二行以内
            detaillab.textAlignment = NSTextAlignmentCenter;
            detaillab.verticalAlignment = VerticalAlignmentTop;
        }else {
            //二行以外 顶部对齐
            detaillab.textAlignment = NSTextAlignmentLeft;
            detaillab.verticalAlignment = VerticalAlignmentTop;
        }
//        [self.tempButtonArray addObject:detaillab];

//        [detaillab setFrame:CGRectMake(kWidthScale(5), kWidthScale(70), Button_Width-kWidthScale(10), size.height)];
        
//        //宽度不变，根据字的多少计算label的高度
//        _bttonH = kWidthScale(70) + size.height + 15;
//
//        //根据计算结果重新设置UILabel的尺寸
//        if (buttonIndex == 0) {
//            [back setFrame:CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (_bttonH + Height_Space)+Start_Y, Button_Width, _bttonH)];
//        }
        
//        label.text = str;
//
//        [self.view addSubview:label];
        
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (_bttonH + Height_Space)+Start_Y, Button_Width, _bttonH);
        btn.enabled = YES;
        btn.backgroundColor = ZJYColorHexWithAlpha(@"#ffffff", 0);
        btn.layer.cornerRadius = kWidthScale(5);
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(subButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + buttonIndex;
        [_backView addSubview:btn];
        [self.buttonArray addObject:btn];
        
//        _nowPlan =[[UIButton alloc] init];
//        [_nowPlan setTitle:SIMLocalizedString(@"NPayMainS_NowPlanText", nil) forState:UIControlStateNormal];
//        [_nowPlan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _nowPlan.titleLabel.font = FontRegularName(kWidthScale(10)];
//        [btn addSubview:_nowPlan];//一定要先添加到视图上
//        _nowPlan.frame = CGRectMake(kWidthScale(110), 0, kWidthScale(50), kWidthScale(20));
//
//        _nowPlan.backgroundColor=RedButtonColor;
////        [self.tempButtonArray addObject:_nowPlan];
//
//        UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:_nowPlan.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(kWidthScale(10), kWidthScale(10))];
//        CAShapeLayer *maskLayer=[[CAShapeLayer alloc]init];
//        maskLayer.frame=_nowPlan.bounds;
//        maskLayer.path=maskPath.CGPath;
//        _nowPlan.layer.mask=maskLayer;
//        if ([model.isnow integerValue] == 0) {
//            _nowPlan.hidden = YES;
//        }else if ([model.isnow integerValue] == 1) {
//            _nowPlan.hidden = NO;
//        }
        

        if(buttonIndex == 1) {
//            btn.enabled = NO;
//            btn.backgroundColor = ZJYColorHexWithAlpha(@"#c3c3c3", 0.5);
            btn.selected = YES;
            self.selectedButton = btn;
//
            UIView *backV = (UIView *)[self.backView viewWithTag:1000 + btn.tag];
            backV.backgroundColor = ZJYColorHex(@"#ddecfe");
            
            backV.layer.borderColor = BlueButtonColor.CGColor;
//            backV.layer.shadowOffset =CGSizeMake(0, kWidthScale(2));
//            backV.layer.shadowColor = ZJYColorHex(@"#d5d5d5").CGColor;
//            backV.layer.shadowRadius = kWidthScale(4);
//            backV.layer.shadowOpacity = kWidthScale(1);
        };
        
    }
    NSUInteger rowNum = (_arr.count + 1) / 2;
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(45);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(Start_Y + _bttonH* rowNum + Height_Space*(rowNum-1));
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-15);
    }];
    
    
}



- (void)subButtonSelected:(UIButton *)button
{
    self.selectedButton.selected = NO;
    NSLog(@"444");
    UIView *backV = (UIView *)[self.backView viewWithTag:1000+ self.selectedButton.tag];
    backV.backgroundColor = [UIColor whiteColor];
    backV.layer.borderColor = ZJYColorHex(@"#d5d5d5").CGColor;
//    backV.layer.shadowOffset =CGSizeMake(0, 0);
//    backV.layer.shadowColor = [UIColor whiteColor].CGColor;
//    backV.layer.shadowRadius = 0;
//    backV.layer.shadowOpacity = .0f;
    
    
    button.selected = YES;
    self.selectedButton = button;
    
    UIView *backV2 = (UIView *)[self.backView viewWithTag:1000 + button.tag];
    backV2.backgroundColor = ZJYColorHex(@"#ddecfe");
    backV2.layer.borderColor = BlueButtonColor.CGColor;
//    backV2.layer.shadowOffset =CGSizeMake(0, kWidthScale(2));
//    backV2.layer.shadowColor = ZJYColorHex(@"#d5d5d5").CGColor;
//    backV2.layer.shadowRadius = kWidthScale(4);
//    backV2.layer.shadowOpacity = kWidthScale(1);
    
    NSInteger btnTag = button.tag - 100;
    
    if (self.didClickAtIndex) {
        self.didClickAtIndex(btnTag);
    }
}
- (void)detailMoreClick {
    if (self.btnClick) {
        self.btnClick();
    }
    
}



@end
