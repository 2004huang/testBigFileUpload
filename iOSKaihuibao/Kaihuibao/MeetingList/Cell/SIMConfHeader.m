//
//  SIMConfHeader.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/7/13.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMConfHeader.h"

@interface SIMConfHeader()
// 标题 会议号  发送按钮 编辑按钮 背景视图 召开按钮
@property (nonatomic, strong) UILabel *mytitle;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *confNumber;
@property (nonatomic, strong) UILabel *confUrl;

@end

@implementation SIMConfHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubViews];
        
    }return self;
}
- (void)setModel:(ArrangeConfModel *)model {
    _model = model;
    _confUrl.text = _model.roomUrl;
    _confUrl.numberOfLines = 0;
    [_confUrl sizeToFit];
}
// 白色背景上的子视图
- (void)addSubViews {
    // 我的会议室label
    _mytitle = [[UILabel alloc] init];
    _mytitle.textAlignment = NSTextAlignmentCenter;
    _mytitle.font = FontRegularName(13);
    _mytitle.text = SIMLocalizedString(@"MEMineConfID", nil);
    _mytitle.textColor = BlackTextColor;
    [self addSubview:_mytitle];
    
    // 会议号
    _confNumber = [[UILabel alloc] init];
    _confNumber.textColor = BlackTextColor;
    _confNumber.font = FontMediumName(24);
    _confNumber.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.confNumber];
    // 截取会议号 变成带-的形式
    _confNumber.text = [NSString transTheConfIDToTheThreeApart:self.currentUser.self_conf];
    
    // 我的会议室url的label
    _confUrl = [[UILabel alloc] init];
    _confUrl.textAlignment = NSTextAlignmentCenter;
    _confUrl.font = FontRegularName(12);
    _confUrl.textColor = BlackTextColor;
    [self addSubview:_confUrl];
    
    
    // 召开会议按钮
    _convenceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_convenceBtn setTitle:SIMLocalizedString(@"MMainConfStartBtn", nil) forState:UIControlStateNormal];
    _convenceBtn.titleLabel.font = FontRegularName(14);
    [_convenceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_convenceBtn setBackgroundImage:[UIImage imageWithColor:GrayPromptTextColor] forState:UIControlStateHighlighted];
    [_convenceBtn setBackgroundColor:[UIColor whiteColor]];
    [_convenceBtn setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
    _convenceBtn.layer.borderWidth = 1;
    _convenceBtn.layer.borderColor =  GrayPromptTextColor.CGColor;
    _convenceBtn.layer.cornerRadius = 8;
    _convenceBtn.layer.masksToBounds = YES;
    _convenceBtn.enabled = NO;
    [self addSubview:self.convenceBtn];
    [_convenceBtn addTarget:self action:@selector(startBtn) forControlEvents:UIControlEventTouchUpInside];

    // 发送邀请按钮
    _send = [UIButton buttonWithType:UIButtonTypeCustom];
    [_send setTitle:SIMLocalizedString(@"MMainConfSendBtn", nil) forState:UIControlStateNormal];
    _send.titleLabel.font = FontRegularName(14);
    [_send setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_send setBackgroundImage:[UIImage imageWithColor:GrayPromptTextColor] forState:UIControlStateHighlighted];
    [_send setBackgroundColor:[UIColor whiteColor]];
    [_send setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
    _send.layer.borderWidth = 1;
    _send.layer.borderColor = GrayPromptTextColor.CGColor;
    _send.layer.cornerRadius = 8;
    _send.layer.masksToBounds = YES;
    _send.enabled = NO;
    [self addSubview:self.send];
    [_send addTarget:self action:@selector(sendBtn) forControlEvents:UIControlEventTouchUpInside];
    // 编辑按钮
    _edit = [UIButton buttonWithType:UIButtonTypeCustom];
    [_edit setTitle:SIMLocalizedString(@"NavBackEdit", nil) forState:UIControlStateNormal];
    _edit.titleLabel.font = FontRegularName(14);
    [_edit setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_edit setBackgroundImage:[UIImage imageWithColor:GrayPromptTextColor] forState:UIControlStateHighlighted];
    [_edit setBackgroundColor:[UIColor whiteColor]];
    [_edit setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
    _edit.layer.borderWidth = 1;
    _edit.layer.borderColor = GrayPromptTextColor.CGColor;
    _edit.layer.cornerRadius = 8;
    _edit.layer.masksToBounds = YES;
    _edit.enabled = NO;
    [self addSubview:self.edit];
    [_edit addTarget:self action:@selector(editBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [_mytitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    [_confNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_mytitle);
        make.top.mas_equalTo(_mytitle.mas_bottom).offset(10);
    }];
    [_confUrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_mytitle);
        make.top.mas_equalTo(_confNumber.mas_bottom);
        make.height.mas_equalTo(35);
    }];
    [_send mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(_confUrl.mas_bottom).offset(5);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(140);
    }];
    [_convenceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_send.mas_left).offset(-20);
        make.top.height.mas_equalTo(_send);
        make.width.mas_equalTo(60);
    }];
    [_edit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_send.mas_right).offset(20);
        make.top.height.width.mas_equalTo(_convenceBtn);
    }];
//
//
//    _mytitle.sd_layout.centerXEqualToView(self).topSpaceToView(self,15).leftSpaceToView(self, 20).rightSpaceToView(self, 20).heightIs(15);
//    _confNumber.sd_layout.centerXEqualToView(self).leftEqualToView(self.mytitle).rightEqualToView(self.mytitle).topSpaceToView(_mytitle,10).heightIs(40);
//    _confUrl.sd_layout.centerXEqualToView(self).leftEqualToView(self.mytitle).rightEqualToView(self.mytitle).topSpaceToView(_confNumber,5).heightIs(20);
//    _send.sd_layout.heightIs(32).topSpaceToView(_confUrl,10).widthIs(140).centerXEqualToView(self);
//    _convenceBtn.sd_layout.heightIs(32).topEqualToView(_send).widthIs(60).rightSpaceToView(_send,20);
//    _edit.sd_layout.leftSpaceToView(_send,20).topEqualToView(_send).heightIs(32).widthIs(60);
    
}
// 编辑按钮响应方法 block传值
- (void)editBtn {
    if (self.editClick) {
        self.editClick();
    }
}
// 发送邀请按钮响应方法 block传值
- (void)sendBtn {
    if (self.sendClick) {
        self.sendClick();
    }
}

// 召开会议按钮响应方法 block传值
- (void)startBtn {
    if (self.startClick) {
        self.startClick();
    }
}

@end
