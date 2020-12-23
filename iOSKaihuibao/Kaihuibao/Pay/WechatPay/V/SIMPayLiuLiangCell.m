//
//  SIMPayLiuLiangCell.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/13.
//  Copyright © 2018年 Ferris. All rights reserved.
//
#define Button_Height kWidthScale(62)    // 高
#define Button_Width kWidthScale(110)      // 宽
#define Start_X  (screen_width - Button_Width * 3)/6 * 2           // 第一个按钮的X坐标
#define Start_Y 18.0f          // 第一个按钮的Y坐标
#define Width_Space (screen_width - Button_Width * 3)/6        // 2个按钮之间的横间距
#define Height_Space 15.0f     // 竖间距


#import "SIMPayLiuLiangCell.h"
@interface SIMPayLiuLiangCell()
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;

@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIView *backView;
@end
@implementation SIMPayLiuLiangCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setUpChooseView];
        
    }return self;
}

- (void)setUpChooseView {
    
    // 白色背景 放一堆按钮的背景View
    _backView = [[UIView alloc] init];
    [self.contentView addSubview:self.backView];
    
    NSUInteger rowNum = 3;
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(Start_Y + Button_Height* rowNum + Height_Space*(rowNum-1));
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-5);
    }];
    self.buttonArray = [[NSMutableArray alloc] init];
    for (int buttonIndex = 0 ; buttonIndex < 9; buttonIndex++) {
        
        NSInteger index = buttonIndex % 3;
        NSInteger page = buttonIndex / 3;
        
        UIView *back = [[UIView alloc] init];
        back.tag = 3000+100+buttonIndex;
        back.backgroundColor = [UIColor whiteColor];
        back.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        back.layer.masksToBounds = YES;
        back.layer.cornerRadius = kWidthScale(5);
        back.layer.borderColor = ZJYColorHex(@"#dbdbdb").CGColor;
        back.layer.borderWidth = 1;
        [_backView addSubview:back];
        
        UILabel *label = [[UILabel alloc] init];
        label.tag = 1000+100+buttonIndex; // tag正好是1000加上button的tag
        label.frame = CGRectMake(0, kWidthScale(15), Button_Width, kWidthScale(15));
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FontRegularName(kWidthScale(18));
        label.textColor = BlackTextColor;
        label.text = @"10G";
        [back addSubview:label];
        
        
        UILabel *pricel = [[UILabel alloc] init];
        pricel.tag = 2000+100+buttonIndex; // tag正好是2000加上button的tag
        pricel.frame = CGRectMake(0, kWidthScale(35), Button_Width, kWidthScale(15));
        pricel.textAlignment = NSTextAlignmentCenter;
        pricel.textColor = TableViewHeaderColor;
        pricel.font = FontRegularName(kWidthScale(14));
        pricel.text = @"￥60.00";
        [back addSubview:pricel];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        btn.backgroundColor = ZJYColorHexWithAlpha(@"#ffffff", 0);
        [btn addTarget:self action:@selector(subButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + buttonIndex;
        [_backView addSubview:btn];
        [self.buttonArray addObject:btn];

        
        if(buttonIndex == 0) {
            btn.selected = YES;
            self.selectedButton = btn;
            
            UIView *backV = (UIView *)[self.backView viewWithTag:3000 + 100];
            backV.backgroundColor = LowOrangeButtonColor;
            backV.layer.borderColor = OrangeButtonColor.CGColor;
            
            UILabel *titleLab = (UILabel *)[self.backView viewWithTag:1000 + 100];
            titleLab.textColor = TextOrangeColor;
            
            UILabel *priceLab = (UILabel *)[self.backView viewWithTag:2000 + 100];
            priceLab.textColor = TextOrangeColor;

        };
        
        
    }
}

- (void)subButtonSelected:(UIButton *)button
{
    self.selectedButton.selected = NO;
    
    UIView *backV = (UIView *)[self.backView viewWithTag:3000+ self.selectedButton.tag];
    backV.backgroundColor = [UIColor whiteColor];
    backV.layer.borderColor = ZJYColorHex(@"#dbdbdb").CGColor;
    
    UILabel *titleLab = (UILabel *)[self.backView viewWithTag:1000+ self.selectedButton.tag];
    titleLab.textColor = BlackTextColor;
    
    UILabel *priceLab = (UILabel *)[self.backView viewWithTag:2000+ self.selectedButton.tag];
    priceLab.textColor = TableViewHeaderColor;
    
    button.selected = YES;
    self.selectedButton = button;
    
    UIView *backV2 = (UIView *)[self.backView viewWithTag:3000 + button.tag];
    backV2.backgroundColor = LowOrangeButtonColor;
    backV2.layer.borderColor = OrangeButtonColor.CGColor;
    
    UILabel *titleLab2 = (UILabel *)[self.backView viewWithTag:1000 + button.tag];
    titleLab2.textColor = TextOrangeColor;
    
    UILabel *priceLab2 = (UILabel *)[self.backView viewWithTag:2000 + button.tag];
    priceLab2.textColor = TextOrangeColor;
    
    NSInteger btnTag = button.tag - 100;
    
    if (self.didClickAtIndex) {
        self.didClickAtIndex(btnTag);
    }
}

@end
