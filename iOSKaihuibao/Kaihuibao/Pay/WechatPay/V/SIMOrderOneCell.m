//
//  SIMOrderOneCell.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/12.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#define Button_Width (screen_width - Start_X * self.arrCount - Width_Space)/self.arrCount     // 宽170
#define Button_Height 120    // 高
#define Start_X  15           // 第一个按钮的X坐标
#define Start_Y 20.0f          // 第一个按钮的Y坐标
#define Width_Space 15        // 2个按钮之间的横间距(screen_width - Button_Width * 2)/3
#define Height_Space 10     // 竖间距


#import "SIMOrderOneCell.h"
@interface SIMOrderOneCell()
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;
@property (nonatomic, strong) NSMutableArray<UILabel *> *nowBtnArray;
@property (nonatomic, strong) NSMutableArray *tempButtonArray;
@property (nonatomic, strong) NSMutableArray *butArray;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *selectImage;
//@property (nonatomic, strong) UILabel *nowPlan;
@property (nonatomic, assign) NSInteger arrCount;

@end
@implementation SIMOrderOneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.buttonArray = [[NSMutableArray alloc] init];
        self.nowBtnArray = [[NSMutableArray alloc] init];
        self.butArray = [[NSMutableArray alloc] init];
        
        [self setUpChooseView];
    }return self;
}
- (NSMutableArray *)tempButtonArray{
    if (!_tempButtonArray) {
        _tempButtonArray = [NSMutableArray array];
    }
    return _tempButtonArray;
}
- (void)setUpChooseView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = ZJYColorHex(@"#f7f7f7");
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(5);
        make.top.mas_equalTo(0);
    }];
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 1)];
//    line.backgroundColor = ZJYColorHex(@"#ebebeb");
//    [self.contentView addSubview:line];
    
    _backView = [[UIView alloc] init];
    [self.contentView addSubview:self.backView];
}

- (void)subButtonSelected:(UIButton *)button
{
    self.selectedButton.selected = NO;
    
    UIView *backV = (UIView *)[self.backView viewWithTag:1000+ self.selectedButton.tag];
    backV.backgroundColor = [UIColor whiteColor];
    backV.layer.borderColor = ZJYColorHex(@"#ebebeb").CGColor;
    
    button.selected = YES;
    self.selectedButton = button;
    
    UIView *backV2 = (UIView *)[self.backView viewWithTag:1000 + button.tag];
    backV2.backgroundColor = ZJYColorHex(@"#e0edff");
    backV2.layer.borderColor = BlueButtonColor.CGColor;
    
    
    NSInteger btnTag = button.tag - 100;
    
    if (self.didClickAtIndex) {
        self.didClickAtIndex(btnTag);
    }
}


- (void)setListmodel:(SIMOptionList *)listmodel {
    _listmodel = listmodel;
    NSArray *arr = _listmodel.info;
    _arrCount = arr.count;
    NSUInteger rowNum = (arr.count + (_arrCount - 1)) / _arrCount;
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(Start_Y + Button_Height* rowNum + Height_Space*(rowNum-1));
        make.bottom.mas_equalTo(-20);
    }];
    
    if (self.tempButtonArray.count > 0) {
        [self.tempButtonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    if (self.buttonArray.count > 0) {
        [self.buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    if (self.nowBtnArray.count > 0) {
        [self.nowBtnArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    for (int buttonIndex = 0 ; buttonIndex < arr.count; buttonIndex++) {
        SIMNewPlanDetailInfo *dic = arr[buttonIndex];
        
        NSInteger index = buttonIndex % _arrCount;
        NSInteger page = buttonIndex / _arrCount;
    
        UIView *back = [[UIView alloc] init];
        back.tag = 1000+100+buttonIndex;
        back.backgroundColor = [UIColor whiteColor];
        back.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        back.layer.masksToBounds = YES;
        back.layer.cornerRadius = 5;
        back.layer.borderColor = ZJYColorHex(@"#ebebeb").CGColor;
        back.layer.borderWidth = 1;
        [_backView addSubview:back];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(20, 0, Button_Width - 40, 40);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FontRegularName(kWidthS(20));
        label.textColor = BlackTextColor;
        label.text = dic.name;
        [back addSubview:label];
        
        UILabel *pricel = [[UILabel alloc] init];
        pricel.frame = CGRectMake(5, 45, Button_Width - 10, 35);
        pricel.textAlignment = NSTextAlignmentCenter;
        pricel.textColor = BlueButtonColor;
        NSString *string= [NSString stringWithFormat:@"￥%@",dic.price];
        
        NSMutableAttributedString *atString = [[NSMutableAttributedString alloc] initWithString:string];
        
        [atString addAttribute:NSFontAttributeName value:FontRegularName(kWidthS(14)) range:NSMakeRange(0, 1)];
        [atString addAttribute:NSFontAttributeName value:FontRegularName(kWidthS(22)) range:NSMakeRange(1, [dic.price length])];
        
        pricel.attributedText = atString;
        [back addSubview:pricel];
        
        UILabel *detaillab = [[UILabel alloc] init];
        detaillab.frame = CGRectMake(20, 90, Button_Width - 40, 20);
        detaillab.textAlignment = NSTextAlignmentCenter;
        detaillab.textColor = GrayPromptTextColor;
        detaillab.font = FontRegularName(kWidthS(12));
        [back addSubview:detaillab];
        
        detaillab.text = [NSString stringWithFormat:@"/%@/%@",_listmodel.time_unit,_listmodel.price_unit];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        btn.backgroundColor = ZJYColorHexWithAlpha(@"#ffffff", 0);
        
        [btn addTarget:self action:@selector(subButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + buttonIndex;
        [_backView addSubview:btn];
        [self.buttonArray addObject:btn];
        [self.tempButtonArray addObject:back];
        if(buttonIndex == [_listmodel.selectBtn intValue]) {
            btn.selected = YES;
            self.selectedButton = btn;
            
            UIView *backV = (UIView *)[self.backView viewWithTag:1000 + btn.tag];
            backV.backgroundColor = ZJYColorHex(@"#e0edff");
            backV.layer.borderColor = BlueButtonColor.CGColor;
            
        }
        // 优惠价格UI
        UILabel *nowPlan =[[UILabel alloc] init];
        nowPlan.numberOfLines = 1;
        nowPlan.textColor = [UIColor whiteColor];
        nowPlan.backgroundColor = ZJYColorHex(@"#f73f43");
        nowPlan.textAlignment = NSTextAlignmentCenter;
        nowPlan.font = FontRegularName(11);
        [self.backView addSubview:nowPlan];//一定要先添加到视图上
        [self.nowBtnArray addObject:nowPlan];
        if ([dic.time_type isEqualToString:@"q"] || [dic.name isEqualToString:@"季"]) {
            if ([_listmodel.quarterdiscountsPrice floatValue] > 0) {
                if (_listmodel.countStr == nil) {
                    _listmodel.countStr = @"1";
                }
                CGFloat sumDiscount = [_listmodel.quarterdiscountsPrice floatValue] * [_listmodel.countStr intValue];
                nowPlan.text = [NSString stringWithFormat:@"%@￥%.2f",SIMLocalizedString(@"NPayAllNext_OfferTitle", nil),sumDiscount];
                NSDictionary *attributes = @{NSFontAttributeName:FontRegularName(11)};
                CGSize textSize = [nowPlan.text boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
                nowPlan.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X + (Button_Width - textSize.width - 10), page  * (Button_Height + Height_Space)+Start_Y - 8 , textSize.width + 10, 16);
            }
        }else if ([dic.time_type isEqualToString:@"y"] || [dic.name isEqualToString:@"年"]) {
            if ([_listmodel.discountsPrice floatValue] > 0) {
                // 这里应该是判断是否有优惠
                if (_listmodel.countStr == nil) {
                    _listmodel.countStr = @"1";
                }
                CGFloat sumDiscount = [_listmodel.discountsPrice floatValue] * [_listmodel.countStr intValue];
                nowPlan.text = [NSString stringWithFormat:@"%@￥%.2f",SIMLocalizedString(@"NPayAllNext_OfferTitle", nil),sumDiscount];
                NSDictionary *attributes = @{NSFontAttributeName:FontRegularName(11)};
                CGSize textSize = [nowPlan.text boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
                nowPlan.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X + (Button_Width - textSize.width - 10), page  * (Button_Height + Height_Space)+Start_Y - 8 , textSize.width + 10, 16);
            }
        }
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:nowPlan.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = nowPlan.bounds;
        maskLayer.path = maskPath.CGPath;
        nowPlan.layer.mask = maskLayer;
    }
}
- (void)setDetailModel:(SIMNewPlanDetailModel *)detailModel {
    _detailModel = detailModel;
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
    
    _arrCount = arr.count;
    NSUInteger rowNum = (arr.count + (_arrCount - 1)) / _arrCount;
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(Start_Y + Button_Height* rowNum + Height_Space*(rowNum-1));
        make.bottom.mas_equalTo(-20);
    }];

    if (self.tempButtonArray.count > 0) {
        [self.tempButtonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    if (self.buttonArray.count > 0) {
        [self.buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    if (self.nowBtnArray.count > 0) {
        [self.nowBtnArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    for (int buttonIndex = 0 ; buttonIndex < arr.count; buttonIndex++) {
        SIMNewPlanDetailInfo *dic = arr[buttonIndex];

        NSInteger index = buttonIndex % _arrCount;
        NSInteger page = buttonIndex / _arrCount;


        UIView *back = [[UIView alloc] init];
        back.tag = 1000+100+buttonIndex;
        back.backgroundColor = [UIColor whiteColor];
        back.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        back.layer.masksToBounds = YES;
        back.layer.cornerRadius = 5;
        back.layer.borderColor = ZJYColorHex(@"#ebebeb").CGColor;
        back.layer.borderWidth = 1;
        [_backView addSubview:back];

        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(20, 0, Button_Width - 40, 40);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FontRegularName(kWidthS(20));
        label.textColor = BlackTextColor;
        label.text = dic.name;
        [back addSubview:label];

        UILabel *pricel = [[UILabel alloc] init];
        pricel.frame = CGRectMake(5, 45, Button_Width - 10, 35);
        pricel.textAlignment = NSTextAlignmentCenter;
        pricel.textColor = BlueButtonColor;
//        pricel.font = FontRegularName(kWidthS(22));
        NSString *string;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"] == YES && [self.cloudVersion.plan boolValue]) {
            string= [NSString stringWithFormat:@"￥%@",dic.price];
            NSMutableAttributedString *atString = [[NSMutableAttributedString alloc] initWithString:string];

            [atString addAttribute:NSFontAttributeName value:FontRegularName(kWidthS(14)) range:NSMakeRange(0, 1)];
            [atString addAttribute:NSFontAttributeName value:FontRegularName(kWidthS(22)) range:NSMakeRange(1, [dic.price length])];

            pricel.attributedText = atString;
        }else {
            #if TypeClassBao || TypeXviewPrivate
                
            #else
                string= [NSString stringWithFormat:@"￥%@",dic.totalMoney];
                NSMutableAttributedString *atString = [[NSMutableAttributedString alloc] initWithString:string];

                [atString addAttribute:NSFontAttributeName value:FontMediumName(kWidthS(16)) range:NSMakeRange(0, 1)];
                [atString addAttribute:NSFontAttributeName value:FontMediumName(kWidthS(26)) range:NSMakeRange(1, [dic.totalMoney length])];
                pricel.attributedText = atString;
            #endif
            
        }
        [back addSubview:pricel];

        UILabel *detaillab = [[UILabel alloc] init];
        detaillab.frame = CGRectMake(20, 90, Button_Width - 40, 20);
        detaillab.textAlignment = NSTextAlignmentCenter;
        detaillab.textColor = GrayPromptTextColor;
        detaillab.font = FontRegularName(kWidthS(12));
        [back addSubview:detaillab];
//        if ([_detailModel.type isEqualToString:@"plan"]) {
//            detaillab.text = _detailModel.unit;
//        }else {
//            detaillab.text = @"/月/参与人";
//        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"] == YES && [self.cloudVersion.plan boolValue]) {
            detaillab.text = [NSString stringWithFormat:@"/%@/%@",_detailModel.time_unit,_detailModel.price_unit];
        }else {
            #if TypeClassBao || TypeXviewPrivate
                
            #else
               detaillab.text = [NSString stringWithFormat:@"/%@",_detailModel.price_unit];
            #endif
            
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        btn.backgroundColor = ZJYColorHexWithAlpha(@"#ffffff", 0);

        [btn addTarget:self action:@selector(subButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + buttonIndex;
        [_backView addSubview:btn];
        [self.buttonArray addObject:btn];
        [self.tempButtonArray addObject:back];
        if(buttonIndex == [_detailModel.selectBtn intValue]) {
            btn.selected = YES;
            self.selectedButton = btn;

            UIView *backV = (UIView *)[self.backView viewWithTag:1000 + btn.tag];
            backV.backgroundColor = ZJYColorHex(@"#e0edff");
            backV.layer.borderColor = BlueButtonColor.CGColor;
        }
        UILabel *nowPlan =[[UILabel alloc] init];
        nowPlan.numberOfLines = 1;
        nowPlan.textColor = [UIColor whiteColor];
        nowPlan.backgroundColor = ZJYColorHex(@"#f73f43");
        nowPlan.textAlignment = NSTextAlignmentCenter;
        nowPlan.font = FontRegularName(11);
        [self.backView addSubview:nowPlan];//一定要先添加到视图上
        [self.nowBtnArray addObject:nowPlan];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"] == YES && [self.cloudVersion.plan boolValue]) {
            if ([dic.time_type isEqualToString:@"q"] || [dic.name isEqualToString:@"季"]) {
                if ([_detailModel.quarterdiscountsPrice floatValue] > 0) {
                    if (_detailModel.countStr == nil) {
                        _detailModel.countStr = @"1";
                    }
                    CGFloat sumDiscount = [_detailModel.quarterdiscountsPrice floatValue] * [_detailModel.countStr intValue];
                    nowPlan.text = [NSString stringWithFormat:@"%@￥%.2f",SIMLocalizedString(@"NPayAllNext_OfferTitle", nil),sumDiscount];
                    NSDictionary *attributes = @{NSFontAttributeName:FontRegularName(11)};
                    CGSize textSize = [nowPlan.text boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
                    nowPlan.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X + (Button_Width - textSize.width - 10), page  * (Button_Height + Height_Space)+Start_Y - 8 , textSize.width + 10, 16);
                }
            }else if ([dic.time_type isEqualToString:@"y"] || [dic.name isEqualToString:@"年"]) {
                if ([_detailModel.discountsPrice floatValue] > 0) {
                    if (_detailModel.countStr == nil) {
                        _detailModel.countStr = @"1";
                    }
                    CGFloat sumDiscount = [_detailModel.discountsPrice floatValue] * [_detailModel.countStr intValue];
                    nowPlan.text = [NSString stringWithFormat:@"%@￥%.2f",SIMLocalizedString(@"NPayAllNext_OfferTitle", nil),sumDiscount];
                    NSDictionary *attributes = @{NSFontAttributeName:FontRegularName(11)};
                    CGSize textSize = [nowPlan.text boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
                    nowPlan.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X + (Button_Width - textSize.width - 10), page  * (Button_Height + Height_Space)+Start_Y - 8 , textSize.width + 10, 16);
                }
            }
        }
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:nowPlan.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = nowPlan.bounds;
        maskLayer.path = maskPath.CGPath;
        nowPlan.layer.mask = maskLayer;
    }
}

@end
