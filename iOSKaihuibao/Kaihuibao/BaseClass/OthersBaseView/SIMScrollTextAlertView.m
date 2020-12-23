//
//  SIMScrollTextAlertView.m
//  Kaihuibao
//
//  Created by mac126 on 2020/5/11.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import "SIMScrollTextAlertView.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "SIMTempCompanyViewController.h"

@interface SIMScrollTextAlertView()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *lineShort;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation SIMScrollTextAlertView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = kWidthScale(10);
        self.layer.masksToBounds = YES;
        [self addDatas];
    }return self;
}
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = FontRegularName(kWidthScale(15));
        _label.textColor = BlackTextColor;
        [self addSubview:_label];
        _label.text = @"个人信息保护指引";
    }return _label;
}
- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.font = FontRegularName(kWidthScale(13));
        _content.numberOfLines = 0;
        _content.textColor = ZJYColorHex(@"#000000");
    }return _content;
}
- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = ZJYColorHex(@"#eeeeee");
        [self addSubview:_line];
    }return _line;
}

- (UIView *)lineShort {
    if (!_lineShort) {
        _lineShort = [[UIView alloc] init];
        _lineShort.backgroundColor = ZJYColorHex(@"#eeeeee");
        [self addSubview:_lineShort];
    }return _lineShort;
}

- (void)addDatas{
    // 添加title
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kWidthScale(5));
        make.left.mas_equalTo(kWidthScale(10));
        make.right.mas_equalTo(-kWidthScale(10));
        make.height.mas_equalTo(kWidthScale(30));
    }];
    
    //添加滚动视图
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.label.mas_bottom).offset(kWidthScale(5));
        make.left.mas_equalTo(kWidthScale(10));
        make.right.mas_equalTo(-kWidthScale(10));
        make.height.mas_equalTo(250);
    }];
    // 添加空内容view
    UIView *contentView = [[UIView alloc] init];
    [_scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.mas_equalTo(0);
        make.width.mas_equalTo(_scrollView.mas_width);
    }];
    // 添加
    NSString *contentStr = @"1、我们会遵循隐私政策收集、使用信息，但不会仅因同意本隐私政策而采取强制捆绑的方式收集信息。\n\n2、在未登录时，为保障服务所必需，我们会收集设备信息、操作日志信息，用于参加会议的服务提供和信息推送。\n\n3、GPS、摄像头、麦克风、相册权限均不会默认开启，只有经过明示授权才会在为实现功能或服务时使用，不会在功能或服务不需要时而通过您授权的权限收集信息。\n\n您可以查看完整版《隐私协议》\n\n如果您同意请点击“同意”按钮以接受我们的服务";
    NSString *privateStr = @"《隐私协议》";
    NSMutableAttributedString *atstring = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSRange range1 = [contentStr rangeOfString:privateStr];
    [atstring addAttribute:NSForegroundColorAttributeName value:BlueButtonColor range:range1];
    self.content.attributedText = atstring;
    [contentView addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(_scrollView.mas_width);
    }];
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.content.mas_bottom).offset(20);
    }];

    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView.mas_bottom).offset(kWidthScale(10));
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CGFloat btnWidth = self.frame.size.width;
    NSLog(@"btnWidthbtnWidth %lf",btnWidth);
    NSArray *arr = @[@"不同意",@"同意"];
    for (int index = 0 ; index < arr.count; index++) {
        UIButton *aBt = [[UIButton alloc] init];
        [aBt setTitle:arr[index] forState:UIControlStateNormal];
        aBt.tag = index;
        aBt.titleLabel.font = FontRegularName(15);
        aBt.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:aBt];
        [aBt addTarget:self action:@selector(aBtClick:) forControlEvents:UIControlEventTouchUpInside];

        if (index == 0) {
            [aBt setTitleColor:BlackTextColor forState:UIControlStateNormal];
            [aBt mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.line.mas_bottom);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(self.line.mas_centerX);
                make.height.mas_equalTo(45);
            }];
        }else {
            [aBt setTitleColor:BlueButtonColor forState:UIControlStateNormal];
            [aBt mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.line.mas_bottom);
                make.right.mas_equalTo(0);
                make.left.mas_equalTo(self.line.mas_centerX);
                make.height.mas_equalTo(45);
            }];
        } 
    }
    [self.lineShort mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line.mas_bottom);
        make.left.mas_equalTo(self.line.mas_centerX);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(45);
        make.bottom.mas_equalTo(0);
    }];
    
}


// 同意或不同意按钮点击方法
- (void)aBtClick:(UIButton *)sender {
    if (self.buttonSerialBlock) {
        self.buttonSerialBlock(sender.tag);
    }
}
@end
