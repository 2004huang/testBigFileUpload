//
//  SIMOrderNextOtherCell.m
//  Kaihuibao
//
//  Created by mac126 on 2018/12/26.
//  Copyright © 2018年 Ferris. All rights reserved.
//
#define Button_Height kWidthScale(115)    // 高
#define Button_Width screen_width - kWidthScale(30)      // 宽
#define Start_X  kWidthScale(15)           // 第一个按钮的X坐标
#define Start_Y 10.0f          // 第一个按钮的Y坐标


#import "SIMOrderNextOtherCell.h"
#import "SIMPayPlanModel.h"
#import "SIMLabel.h"

@interface SIMOrderNextOtherCell()
@property (nonatomic, strong) UIView *back;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) SIMLabel *detaillab;
@property (nonatomic, assign) CGFloat bttonH;
@end
@implementation SIMOrderNextOtherCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = ZJYColorHex(@"#f4f3f3");
    
    }return self;
}
- (void)setModel:(SIMPayPlanModel *)model {
    _model = model;
    NSArray *arr = model.PricePlan;
    NSLog(@"arrnew22arr33%@",arr);
    
    NSString *dateTypestr = @"分钟";
    SIMPayPlanModel_PricePlan *priceModel = arr[0];
    
    NSString *strdd = model.PlanDescribe;
    NSNumber *billingStr = priceModel.MinuteBilling;
    
    CGSize size = [strdd sizeWithFont:FontRegularName(kWidthScale(12)) constrainedToSize:CGSizeMake(Button_Width-kWidthScale(20), MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    //宽度不变，根据字的多少计算label的高度
    CGFloat buttonHei = kWidthScale(100) + size.height;
    
    
    _back = [[UIView alloc] init];
    _back.backgroundColor = [UIColor whiteColor];
//    _back.frame = CGRectMake( Start_X, Start_Y, Button_Width, Button_Height);
    _back.layer.masksToBounds = YES;
    _back.layer.cornerRadius = kWidthScale(5);
    _back.layer.borderColor = ZJYColorHex(@"#d5d5d5").CGColor;
    _back.layer.borderWidth = 1;
    [self.contentView addSubview:_back];
    
    
    [_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Start_Y);
        make.left.mas_equalTo(Start_X);
        make.height.mas_equalTo(buttonHei);
        make.right.mas_equalTo(-Start_X);
        make.bottom.mas_equalTo(-Start_Y);
    }];
    
    
    UILabel *pricel = [[UILabel alloc] init];
//    pricel.frame = CGRectMake(kWidthScale(20), kWidthScale(30), Button_Width - kWidthScale(40), kWidthScale(30));
    pricel.textAlignment = NSTextAlignmentCenter;
    pricel.textColor = BlueButtonColor;
    pricel.font = FontRegularName(kWidthScale(18));
    
    if ([billingStr floatValue] <= 0) {
        pricel.text = @"免费";
    }else {
        
        NSString *string= [NSString stringWithFormat:@"￥%@/%@",[billingStr stringValue],dateTypestr];
        
        NSMutableAttributedString *atString = [[NSMutableAttributedString alloc] initWithString:string];
        [atString addAttributes:@{NSFontAttributeName:FontRegularName(kWidthScale(18)),
                                  NSForegroundColorAttributeName:GrayPromptTextColor
                                  
                                  } range:NSMakeRange(0, 1)];
        [atString addAttributes:@{NSFontAttributeName:FontRegularName(kWidthScale(36)),
                                  NSForegroundColorAttributeName:BlueButtonColor
                                  
                                  } range:NSMakeRange(1, [NSString stringWithFormat:@"%@",[billingStr stringValue]].length)];
        [atString addAttributes:@{NSFontAttributeName:FontRegularName(kWidthScale(18)),
                                  NSForegroundColorAttributeName:GrayPromptTextColor
                                  
                                  } range:NSMakeRange([NSString stringWithFormat:@"%@",[billingStr stringValue]].length+1, dateTypestr.length + 1)];
        
        pricel.attributedText = atString;
    }
    
    [_back addSubview:pricel];
    
    [pricel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kWidthScale(30));
        make.left.mas_equalTo(kWidthScale(20));
        make.height.mas_equalTo(kWidthScale(30));
        make.right.mas_equalTo(-kWidthScale(20));
    }];
    

    SIMLabel *detaillab = [[SIMLabel alloc] init];
//    detaillab.frame = CGRectMake(kWidthScale(10), kWidthScale(70), Button_Width-kWidthScale(20), buttonHei-kWidthScale(70)- 10);
    detaillab.numberOfLines = 0;
    detaillab.textColor = GrayPromptTextColor;
    detaillab.font = FontRegularName(kWidthScale(12));
//    NSString *strdd = model.PlanDescribe;
//    CGSize size = [strdd sizeWithFont:FontRegularName(kWidthScale(12)) constrainedToSize:CGSizeMake(Button_Width-kWidthScale(20), MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    detaillab.text = model.PlanIntroduce;
    [_back addSubview:detaillab];
    
    [detaillab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pricel.mas_bottom).offset(kWidthScale(20));
        make.left.mas_equalTo(kWidthScale(10));
        make.height.mas_equalTo(size.height);
        make.right.mas_equalTo(-kWidthScale(10));
    }];
    
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
    
}

@end
