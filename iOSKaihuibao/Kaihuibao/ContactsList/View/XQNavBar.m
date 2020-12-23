//
//  XQNavBar.m
//  ZAKER
//
//  Created by 王小琪 on 17/1/26.
//  Copyright © 2017年 王小琪. All rights reserved.
//

#import "XQNavBar.h"

@interface XQNavBar ()

//@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat fontSizeNum;

//@property(nonatomic,strong)UIColor *sliderBackgroundColor;
@property(nonatomic,strong)UIColor *buttonNormalTitleColor;
@property(nonatomic,strong)UIColor *buttonSelectedTileColor;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation XQNavBar

- (instancetype)initWithTitles:(NSArray *)titles frame:(CGRect)frame titleColor:(UIColor *)titleColor isDev:(BOOL)isDev{
    if (self = [super initWithFrame:frame]) {
        _fontSizeNum = 15;
        _selectIndex = 0;
        if (titles.count == 1) {
            self.buttonNormalTitleColor = BlackTextColor;
            self.buttonSelectedTileColor = BlackTextColor;
        }else {
            self.buttonNormalTitleColor = BlackTextColor;
            self.buttonSelectedTileColor = titleColor;
        }
        
        [self setSubViewWithTitles:titles];
    }
    return self;
}
-(void)setSubViewWithTitles:(NSArray *)titles
{
    self.buttonArray = [[NSMutableArray alloc] init];
    for (int buttonIndex = 0 ; buttonIndex < titles.count; buttonIndex++) {
        NSString *titleString = titles[buttonIndex];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:self.buttonNormalTitleColor forState:UIControlStateNormal];
        [btn setTitleColor:self.buttonSelectedTileColor forState:UIControlStateSelected];
        [btn setTitleColor:self.buttonSelectedTileColor forState:UIControlStateHighlighted | UIControlStateSelected];
//        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
        [btn setTitle:titleString forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = FontRegularName(_fontSizeNum);
        
        if(buttonIndex == _selectIndex) {
            btn.selected = YES;
            self.selectedButton = btn;
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:_fontSizeNum];
        };
        
        [btn addTarget:self action:@selector(subButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + buttonIndex;
        [self addSubview:btn];
        [self.buttonArray addObject:btn];
    }
    
//    self.sliderView = [[UIView alloc] init];
//    self.sliderView.backgroundColor = self.buttonSelectedTileColor;
//    [self addSubview:self.sliderView];
    
}
- (void)subButtonSelected:(UIButton *)button
{
    /*
    self.selectedButton.selected = NO;
    self.selectedButton.titleLabel.font = FontRegularName(_fontSizeNum];
    
    button.selected = YES;
    self.selectedButton = button;
     
    button.titleLabel.font = [UIFont boldSystemFontOfSize:_fontSizeNum];
     */
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
    self.buttonArray[indexT].titleLabel.font = [UIFont boldSystemFontOfSize:_fontSizeNum];
    self.selectedButton = self.buttonArray[indexT];
    
//    [self sliderViewAnimationWithButtonIndex:index];
    
}
//滚动完成改变按钮的选中状态
- (void)canSelectedWidthIndex:(CGFloat)index{
    NSInteger indexT = index/screen_width;
    self.selectedButton.selected = NO;
    self.selectedButton.titleLabel.font = FontRegularName(_fontSizeNum);
    self.buttonArray[indexT].selected = YES;
    self.buttonArray[indexT].titleLabel.font = [UIFont boldSystemFontOfSize:_fontSizeNum];
    self.selectedButton = self.buttonArray[indexT];
}
//-(void)sliderViewAnimationWithButtonIndex:(CGFloat)offsetX {
//    // 条的宽度
//    CGFloat lineWidth = [_titleStr boundingRectWithSize:CGSizeMake(100, 21) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FontRegularName(15]} context:nil].size.width;
//    CGFloat buttonX = self.buttonArray[0].center.x - lineWidth / 2;
//    CGFloat tmp = (self.buttonArray[0].frame.size.width+20)/screen_width;
//    buttonX += tmp*offsetX;
//    self.sliderView.frame = CGRectMake(buttonX, self.frame.size.height - 2.0f, lineWidth, 2);
//}

-(void)layoutSubviews
{
    [super layoutSubviews];
    // 条的宽度
//    CGFloat lineWidth = [_titleStr boundingRectWithSize:CGSizeMake(100, 21) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FontRegularName(15]} context:nil].size.width;
    CGFloat buttonWidth = (self.frame.size.width - 15*(self.buttonArray.count-1)) / self.buttonArray.count;
    for (int buttonIndex = 0; buttonIndex < self.buttonArray.count; buttonIndex ++) {
        self.buttonArray[buttonIndex].frame = CGRectMake(buttonIndex * (buttonWidth+15), 0, buttonWidth, 44);
    }
//    CGFloat buttonX = self.buttonArray[_selectIndex].center.x - lineWidth / 2;
//    self.sliderView.frame = CGRectMake(buttonX, self.frame.size.height - 2.0f, lineWidth, 2);
}





@end
