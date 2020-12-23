//
//  SIMSelectToponTableViewCell.m
//  Kaihuibao
//
//  Created by mac126 on 2019/9/20.
//  Copyright © 2019 Ferris. All rights reserved.
//
#define Button_Height kWidthScale(55)    // 高
#define Button_Width kWidthScale(130)      // 宽
#define Start_X  (screen_width - 30 - Button_Width * 2)/3           // 第一个按钮的X坐标
#define Start_Y kWidthScale(20)          // 第一个按钮的Y坐标
#define Width_Space (screen_width - 30- Button_Width * 2)/3        // 2个按钮之间的横间距
#define Height_Space kWidthScale(10)      // 竖间距

#import "SIMSelectToponTableViewCell.h"

@interface SIMSelectToponTableViewCell()
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *selectImage;
@property (nonatomic, strong) UIButton *nowPlan;
@property (nonatomic, strong) NSMutableArray *tempButtonArray;
@end
@implementation SIMSelectToponTableViewCell
// 改变单元格的大小
//- (void)setFrame:(CGRect)frame {
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
//    frame.origin.x += 5;
////    frame.origin.y += 10;
//    frame.size.width -= 10;
////    frame.size.height -= 20;
//    [super setFrame:frame];
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.layer.borderColor = ZJYColorHex(@"#eeeeee").CGColor;
        self.layer.borderWidth = 1;
        self.layer.shadowOffset = CGSizeMake(5, 5);
        self.layer.shadowOpacity = 0.6f;
        self.layer.shadowColor = ZJYColorHex(@"#eeeeee").CGColor;
        self.buttonArray = [[NSMutableArray alloc] init];
        self.tempButtonArray = [[NSMutableArray alloc] init];
        [self setUpTitleView];
    }return self;
}
- (void)setUpTitleView {
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backView];
}

- (void)setArr:(NSArray *)arr {
    _arr = arr;
    
    NSUInteger rowNum = (_arr.count + 1) / 2;
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(Start_Y + Button_Height* rowNum + Height_Space*(rowNum-1));
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kWidthScale(20));
    }];
    
    if (self.buttonArray.count > 0) {
        [self.buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.buttonArray removeAllObjects];
    }
    
    if (self.tempButtonArray.count > 0) {
        [self.tempButtonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.tempButtonArray removeAllObjects];
    }
    
    for (int buttonIndex = 0 ; buttonIndex < _arr.count; buttonIndex++) {
        
        NSInteger index = buttonIndex % 2;
        NSInteger page = buttonIndex / 2;
        
        UIView *back = [[UIView alloc] init];
        back.tag = 1000+100+buttonIndex;
        back.backgroundColor = [UIColor whiteColor];
        back.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        back.layer.masksToBounds = YES;
        back.layer.cornerRadius = kWidthScale(5);
        back.layer.borderColor = ZJYColorHex(@"#d5d5d5").CGColor;
        back.layer.borderWidth = 1;
        [_backView addSubview:back];
        [self.tempButtonArray addObject:back];
        
        UILabel *label = [[UILabel alloc] init];
        label.tag = 2000+100+buttonIndex;
        label.frame = CGRectMake(kWidthScale(5), 0, Button_Width-kWidthScale(10), Button_Height);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FontRegularName(kWidthScale(15));
        label.textColor = BlackTextColor;
        NSDictionary *dic = _arr[buttonIndex];
        label.text = [NSString stringWithFormat:@"￥%@",dic[@"amount"]];
        [back addSubview:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        btn.enabled = YES;
        btn.backgroundColor = ZJYColorHexWithAlpha(@"#ffffff", 0);
        btn.layer.cornerRadius = kWidthScale(5);
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(subButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + buttonIndex;
        [_backView addSubview:btn];
        [self.buttonArray addObject:btn];
        
        if(buttonIndex == 0) {
            btn.selected = YES;
            self.selectedButton = btn;
            
            UIView *backV = (UIView *)[self.backView viewWithTag:1000 + btn.tag];
            backV.backgroundColor = ZJYColorHexWithAlpha(@"#227bff", 0.12);
            backV.layer.borderColor = ZJYColorHexWithAlpha(@"#227bff", 0.12).CGColor;
            
            UILabel *labV = (UILabel *)[self.backView viewWithTag:2000 + btn.tag];
            labV.textColor = BlueButtonColor;
        };
        
    }
    
}



- (void)subButtonSelected:(UIButton *)button
{
    self.selectedButton.selected = NO;
    
    UIView *backV = (UIView *)[self.backView viewWithTag:1000+ self.selectedButton.tag];
    backV.backgroundColor = [UIColor whiteColor];
    backV.layer.borderColor = ZJYColorHex(@"#d5d5d5").CGColor;
    UILabel *labV = (UILabel *)[self.backView viewWithTag:2000 + self.selectedButton.tag];
    labV.textColor = BlackTextColor;
    
    button.selected = YES;
    self.selectedButton = button;
    
    UIView *backV2 = (UIView *)[self.backView viewWithTag:1000 + button.tag];
    backV2.backgroundColor = ZJYColorHexWithAlpha(@"#227bff", 0.12);
    backV2.layer.borderColor = ZJYColorHexWithAlpha(@"#227bff", 0.12).CGColor;
    UILabel *labV2 = (UILabel *)[self.backView viewWithTag:2000 + button.tag];
    labV2.textColor = BlueButtonColor;
    
    NSInteger btnTag = button.tag - 100;
    
    if (self.didClickAtIndex) {
        self.didClickAtIndex(btnTag);
    }
}

@end
