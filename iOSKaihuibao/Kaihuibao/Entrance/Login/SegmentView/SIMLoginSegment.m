//
//  SIMLoginSegment.m
//  Kaihuibao
//
//  Created by mac126 on 2019/4/26.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMLoginSegment.h"
@interface SIMLoginSegment ()

//@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat fontSizeNum;

//@property(nonatomic,strong)UIColor *sliderBackgroundColor;
@property(nonatomic,strong)UIColor *buttonNormalTitleColor;
@property(nonatomic,strong)UIColor *buttonSelectedTileColor;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation SIMLoginSegment
- (instancetype)initWithTitles:(NSArray *)titles frame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _fontSizeNum = 15;
        self.buttonNormalTitleColor = BlackTextColor;
        self.buttonSelectedTileColor = BlackTextColor;
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
        };
        
        [btn addTarget:self action:@selector(subButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + buttonIndex;
        [self addSubview:btn];
        [self.buttonArray addObject:btn];
        
    }
    
    
    self.sliderView = [[UIView alloc] init];
    self.sliderView.backgroundColor = BlueButtonColor;
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
    self.buttonArray[indexT].selected = YES;
    self.selectedButton = self.buttonArray[indexT];
    
    [self sliderViewAnimationWithButtonIndex:index];
    
}
//滚动完成改变按钮的选中状态
- (void)canSelectedWidthIndex:(CGFloat)index{
    NSInteger indexT = index/screen_width;
    self.selectedButton.selected = NO;
    self.buttonArray[indexT].selected = YES;
    self.selectedButton = self.buttonArray[indexT];
    
    [self sliderViewAnimationWithButtonIndex:index];
}

-(void)sliderViewAnimationWithButtonIndex:(CGFloat)offsetX {
    // 条的宽度
    NSInteger indexT = offsetX/screen_width;

    CGFloat buttonX = self.buttonArray[indexT].center.x - 22 / 2;
    
    self.sliderView.frame = CGRectMake(buttonX, self.frame.size.height - 1.0f, 22, 1);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat lineWidth = 22;
    CGFloat buttonWidth = self.frame.size.width / self.buttonArray.count;
    for (int buttonIndex = 0; buttonIndex < self.buttonArray.count; buttonIndex ++) {
        self.buttonArray[buttonIndex].frame = CGRectMake(buttonIndex * buttonWidth, 0, buttonWidth, 44);
    }
    
    CGFloat buttonX = self.buttonArray[_selectIndex].center.x - lineWidth / 2;
    
    self.sliderView.frame = CGRectMake(buttonX, self.frame.size.height - 1.0f, lineWidth, 1);
    
}


@end
