//
//  SIMEnterConfPayAlertView.m
//  Kaihuibao
//
//  Created by mac126 on 2019/12/19.
//  Copyright © 2019 Ferris. All rights reserved.
//

#define Start_X  kWidthScale(30)        // 第一个按钮的X坐标
#define Start_Y kWidthScale(5)          // 第一个按钮的Y坐标
#define Button_Height 44    // 高
#define Button_Width (self.frame.size.width - Start_X * 2)      // 宽
#define Width_Space Start_X        // 2个按钮之间的横间距
#define Height_Space kWidthScale(10)      // 竖间距

#import "SIMEnterConfPayAlertView.h"

@interface SIMEnterConfPayAlertView()
@property (nonatomic, strong) UIButton *close;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) UIScrollView *scrollView;

@end
@implementation SIMEnterConfPayAlertView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = kWidthScale(10);
        self.layer.masksToBounds = YES;
        
    }return self;
}
- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = ZJYColorHex(@"#eeeeee");
        [self addSubview:_line];
    }return _line;
}
- (UIButton *)close {
    if (!_close) {
        _close = [[UIButton alloc] init];
        _close.titleLabel.font = FontRegularName(kWidthScale(15));
        [_close setTitleColor:ZJYColorHex(@"#959595") forState:UIControlStateNormal];
        [_close setTitle:SIMLocalizedString(@"NavBackCancelTitle", nil) forState:UIControlStateNormal];
        [_close addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.close];
    }return _close;
}
- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textAlignment = NSTextAlignmentCenter;
        _content.font = FontRegularName(kWidthScale(14));
        _content.numberOfLines = 0;
        _content.textColor = ZJYColorHex(@"#000000");
//        [self addSubview:self.content];
    }return _content;
}
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = FontRegularName(kWidthScale(16));
        _label.textColor = ZJYColorHex(@"#000000");
        [self addSubview:self.label];
    }return _label;
}
- (UIImageView *)img {
    if (!_img) {
        _img = [[UIImageView alloc] init];
//        _img.backgroundColor = GrayPromptTextColor;
        
    }return _img;
}
-(UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        [self addSubview:self.backView];
    }return _backView;
}

- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}
- (void)setDicM:(NSDictionary *)dicM {
    _dicM = dicM;
    self.label.text = _dicM[@"prompt_title"];
    [self.close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kWidthScale(5));
        make.left.mas_equalTo(kWidthScale(10));
        make.height.mas_equalTo(kWidthScale(30));
        make.width.mas_equalTo(kWidthScale(40));
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kWidthScale(5));
        make.left.mas_equalTo(self.close.mas_right).offset(kWidthScale(10));
        make.right.mas_equalTo(-kWidthScale(60));
        make.height.mas_equalTo(kWidthScale(30));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.close.mas_bottom).offset(kWidthScale(5));
        make.left.mas_equalTo(kWidthScale(15));
        make.right.mas_equalTo(-kWidthScale(15));
        make.height.mas_equalTo(1);
    }];
    //添加滚动视图
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line.mas_bottom).offset(kWidthScale(5));
        make.left.mas_equalTo(kWidthScale(15));
        make.right.mas_equalTo(-kWidthScale(15));
        make.height.mas_equalTo(250);
    }];
    // 添加空内容view
    UIView *contentView = [[UIView alloc] init];
    [_scrollView addSubview:contentView];
    
    self.content.text = _dicM[@"prompt_text"];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.mas_equalTo(0);
        make.width.mas_equalTo(_scrollView.mas_width);
    }];
    [contentView addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(_scrollView.mas_width);
    }];
    [contentView addSubview:self.img];
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.content.mas_bottom).offset(kWidthScale(10));
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(kWidthScale(15));
        make.right.mas_equalTo(-kWidthScale(15));
//        make.width.mas_equalTo(kWidthScale(270));
    }];
    if (_dicM[@"illustration"] != nil && [_dicM[@"illustration"] length] > 0) {
        [self.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kApiBaseUrl,_dicM[@"illustration"]]]];
        [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(kWidthScale(140));
            make.height.mas_equalTo(_img.mas_width).multipliedBy(0.52);
        }];
        _img.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.img.mas_bottom).offset(5);
    }];
    
    NSArray *arr = _dicM[@"buttons"];
    _array = arr;
    NSUInteger rowNum = arr.count; // 行数
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_scrollView.mas_bottom).offset(kWidthScale(5));
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(Start_Y + Button_Height* rowNum + Height_Space* (rowNum-1));
        make.bottom.mas_equalTo(-kWidthScale(15));
    }];
    
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
    
    if (self.buttonArray.count > 0) {
        [self.buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    for (int index = 0 ; index < arr.count; index++) {
        NSDictionary *dic = arr[index];
        UIButton *aBt = [[UIButton alloc] init];
        [aBt setTitle:dic[@"button_text"] forState:UIControlStateNormal];
        aBt.tag = index;
        aBt.titleLabel.font = FontRegularName(15);
        aBt.layer.cornerRadius = kWidthScale(3);
        aBt.layer.masksToBounds = YES;
        aBt.titleLabel.textAlignment = NSTextAlignmentCenter;
        aBt.layer.borderColor = BlueButtonColor.CGColor;
        aBt.layer.borderWidth = 1;
        [self.backView addSubview:aBt];
        [aBt addTarget:self action:@selector(aBtClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArray addObject:aBt];
        if (index == 0) {
            aBt.backgroundColor = BlueButtonColor;
            [aBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else {
            aBt.backgroundColor = [UIColor whiteColor];
            [aBt setTitleColor:BlueButtonColor forState:UIControlStateNormal];
            
        }
        [aBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(index  * (Button_Height + Height_Space)+Start_Y);
            make.left.mas_equalTo(Start_X);
            make.right.mas_equalTo(-Start_X);
            make.height.mas_equalTo(Button_Height);
        }];
    }
    
}


- (void)closeBtn {
    if (self.cancelClick) {
        self.cancelClick();
    }
}
// 图标按钮点击方法
- (void)aBtClick:(UIButton *)sender {
    NSDictionary *dic = self.array[sender.tag];
    NSString *string = dic[@"button_type"];
    if (self.buttonSerialBlock) {
        self.buttonSerialBlock(string);
    }
}

@end
