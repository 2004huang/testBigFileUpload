//
//  SIMNewPlanChossen.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/31.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMNewPlanChossen.h"
@interface SIMNewPlanChossen ()

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat fontSizeNum;
@property (nonatomic, assign) CGFloat fontSizeSelect;
@property (nonatomic, strong) NSArray * arrs;
//@property(nonatomic,strong)UIColor *sliderBackgroundColor;
@property(nonatomic,strong)UIColor *buttonNormalTitleColor;
@property(nonatomic,strong)UIColor *buttonSelectedTileColor;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIView *down;
@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) BOOL isHasLine;
@property (nonatomic, assign) BOOL isslider;
@property (nonatomic, assign) CGFloat buttonWidths;
@property (nonatomic, assign) CGFloat buttonWidthsum;


@end
@implementation SIMNewPlanChossen
- (instancetype)initWithTitles:(NSArray *)titles frame:(CGRect)frame selectIndex:(NSInteger)index hasLine:(BOOL)ishas hasSlider:(BOOL)isslider{
    if (self = [super initWithFrame:frame]) {
        _arrs =titles;
        self.backgroundColor = ZJYColorHex(@"#f7f7f7");
        _fontSizeNum = 15;
        _fontSizeSelect = 15;
        _selectIndex = index;
        _isHasLine = ishas;
        _isslider = isslider;
        self.buttonNormalTitleColor = BlackTextColor;
        self.buttonSelectedTileColor = BlueButtonColor;
        [self setSubViewWithTitles:titles];
        if (_isslider == YES) {
            [self sliderViewAnimationWithButtonIndex:index];
        }
        
    }
    return self;
}
-(void)setSubViewWithTitles:(NSArray *)titles
{
    CGFloat buttonf = 0.0;
    self.buttonArray = [[NSMutableArray alloc] init];
    for (int buttonIndex = 0 ; buttonIndex < titles.count; buttonIndex++) {
        NSString *titleString = titles[buttonIndex];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:self.buttonNormalTitleColor forState:UIControlStateNormal];
        [btn setTitleColor:self.buttonSelectedTileColor forState:UIControlStateSelected];
        [btn setTitleColor:self.buttonSelectedTileColor forState:UIControlStateHighlighted | UIControlStateSelected];
        [btn setTitle:titleString forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = FontRegularName(_fontSizeNum);
        
        NSString *ss = _arrs[buttonIndex];
        CGSize size = [ss sizeWithAttributes:@{NSFontAttributeName:FontRegularName(kWidthScale(14))}];
        CGFloat buttonWidth = size.width+30;
        
        btn.frame = CGRectMake(buttonf, 0, buttonWidth, self.frame.size.height);
        
        buttonf += buttonWidth;
        
        if(buttonIndex == _selectIndex) {
            btn.selected = YES;
            self.selectedButton = btn;
            btn.titleLabel.font = FontRegularName(_fontSizeSelect);
            
        };
        
        [btn addTarget:self action:@selector(subButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + buttonIndex;
        [self addSubview:btn];
        [self.buttonArray addObject:btn];
        
    }
    
    if (_isHasLine == YES) {
        self.down=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
        self.down.backgroundColor = ZJYColorHex(@"#eeeeee");
        [self addSubview:self.down];
    
    }
    
    
    self.sliderView = [[UIView alloc] init];
    self.sliderView.layer.cornerRadius = 2;
    self.sliderView.layer.masksToBounds = YES;
    self.sliderView.backgroundColor = self.buttonSelectedTileColor;
    [self addSubview:self.sliderView];

}
- (void)subButtonSelected:(UIButton *)button
{
    NSInteger btnTag = button.tag - 100;
    if (self.didClickAtIndex) {
        self.didClickAtIndex(btnTag);
    }
}
-(void)scrollToIndex:(CGFloat)index
{
    NSInteger indexT = index/screen_width;
    self.selectedButton.selected = NO;
    self.selectedButton.titleLabel.font = FontRegularName(_fontSizeNum);
    self.buttonArray[indexT].selected = YES;
    self.buttonArray[indexT].titleLabel.font = FontRegularName(_fontSizeSelect);
    self.selectedButton = self.buttonArray[indexT];
    if (_isslider == YES) {
        [self sliderViewAnimationWithButtonIndex:indexT];
    }
}
//滚动完成改变按钮的选中状态
- (void)canSelectedWidthIndex:(CGFloat)index{
    NSInteger indexT = index/screen_width;
    self.selectedButton.selected = NO;
    self.selectedButton.titleLabel.font = FontRegularName(_fontSizeNum);
    self.buttonArray[indexT].selected = YES;
    self.buttonArray[indexT].titleLabel.font = FontRegularName(_fontSizeSelect);
    self.selectedButton = self.buttonArray[indexT];
    if (_isslider == YES) {
        [self sliderViewAnimationWithButtonIndex:indexT];
    }
    
}
-(void)sliderViewAnimationWithButtonIndex:(NSInteger)indexT {
    // 条的宽度
    //    NSInteger indexT = offsetX/screen_width;
    //    CGFloat lineWidth = [_titleStr boundingRectWithSize:CGSizeMake(100, 21) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FontRegularName(16)} context:nil].size.width;
    
    CGFloat buttonX = self.buttonArray[indexT].center.x - 25 / 2;
    
    //    CGFloat tmp = (self.buttonArray[indexT].frame.size.width+20)/screen_width;
    //    buttonX += tmp*offsetX;
    if (_isslider == YES) {
        self.sliderView.frame = CGRectMake(buttonX, self.frame.size.height - 5.0f, 25, 4);
    }
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat lineWidth = 25;
    CGFloat buttonWidth = self.frame.size.width / self.buttonArray.count;
    for (int buttonIndex = 0; buttonIndex < self.buttonArray.count; buttonIndex ++) {
        self.buttonArray[buttonIndex].frame = CGRectMake(buttonIndex * buttonWidth, 0, buttonWidth, 44);
    }

    CGFloat buttonX = self.buttonArray[_selectIndex].center.x - lineWidth / 2;

    if (_isslider == YES) {
        self.sliderView.frame = CGRectMake(buttonX, self.frame.size.height - 5.0f, lineWidth, 4);
    }
    

}

@end
