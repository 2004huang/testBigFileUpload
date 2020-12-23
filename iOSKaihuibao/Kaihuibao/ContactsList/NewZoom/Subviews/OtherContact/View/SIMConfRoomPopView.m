//
//  SIMConfRoomPopView.m
//  Kaihuibao
//
//  Created by mac126 on 2019/5/14.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMConfRoomPopView.h"
@interface SIMConfRoomPopView()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UILabel *medline;

@end
@implementation SIMConfRoomPopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        [self subviewsUI];
    }return self;
}
- (void)subviewsUI {
    _label = [[UILabel alloc] init];
    _label.text = @"添加序列号";
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = FontRegularName(14);
    _label.textColor = BlackTextColor;
    [self addSubview:self.label];
    
    _textF = [[UITextField alloc] init];
    _textF.layer.borderWidth = 1;
    _textF.layer.borderColor = BlueButtonColor.CGColor;
    _textF.textAlignment = NSTextAlignmentCenter;
    [_textF becomeFirstResponder];
    [self addSubview:self.textF];
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [_addBtn setTitleColor:BlueButtonColor forState:UIControlStateNormal];
    _addBtn.titleLabel.font = FontRegularName(15);
    [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addBtn];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = FontRegularName(15);
    [_cancelBtn setTitleColor:ZJYColorHex(@"#717171") forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelBtn];
    
    _line = [[UILabel alloc] init];
    _line.backgroundColor = ZJYColorHex(@"#dedde0");
    [self addSubview:_line];
    
    _medline = [[UILabel alloc] init];
    _medline.backgroundColor = ZJYColorHex(@"#dedde0");
    [self addSubview:_medline];
    
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(45);
        make.right.mas_equalTo(0);
    }];
    [_textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_label.mas_bottom).offset(5);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(35);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self.frame.size.width/2);
    }];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.height.and.bottom.mas_equalTo(_cancelBtn);
        make.width.mas_equalTo(self.frame.size.width/2);
    }];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_cancelBtn.mas_top);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    [_medline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_line.mas_bottom);
        make.left.mas_equalTo(_cancelBtn.mas_right);
        make.height.mas_equalTo(_cancelBtn);
        make.width.mas_equalTo(1);
    }];
    
}
- (void)addBtnClick {
    if (self.addClickBlock) {
        self.addClickBlock();
    }
}
- (void)cancelBtnClick {
    if (self.cancelClickBlock) {
        self.cancelClickBlock();
    }
}

@end
